#!/bin/bash

[[ "$JOBS_ID" == "1" ]] && exit 0

# Max retries
max_retries=10
# Interval between checks (10 retries in 10 minutes -> 60s each)
interval=60

for ((i=1; i<=max_retries; i++)); do
  echo "Check $i of $max_retries..."

  HEADER="Accept: application/vnd.github+json"
  RESPONSE=$(gh api -H "${HEADER}" repos/$REPO_NAME/actions/runners)
  TOTAL_COUNT=$(echo "$RESPONSE" | jq '.total_count')
  STATUS=$(echo "$RESPONSE" | jq -r --arg NAME "$RUNNER_TITLE" '.runners[] | select(.name == $NAME).status')

  if [[ "$TOTAL_COUNT" -gt 0 && "$STATUS" != "offline" ]]; then

    secrets=$(curl -s -H "Authorization: token $GH_TOKEN" \
      -H "Accept: application/vnd.github.v3+json" \
      "https://api.github.com/repos/$REPO_NAME/actions/secrets" | jq -r '.secrets[].name')

    errors=0

    for secret in $secrets; do
      echo "${!secret}" | sed -n '/./p' > .validated_secret_temp

      if [ ! -s .validated_secret_temp ]; then
        echo "❌ Error: Secret '$secret' is empty or contains only whitespace" >&2
        ((errors++))
      else
        gh secret set "$secret" --repo $TARGET_REPOSITORY --body "${!secret}"
        echo "✅ Secret '$secret' successfully set"
      fi
    done

    rm -f .validated_secret_temp

    if [ $errors -gt 0 ]; then
      echo "❌ $errors secrets failed validation"
      gh run cancel $GITHUB_RUN_ID --repo "$REPO_NAME"
    fi

    exit 0
  fi

  if [ $i -lt $max_retries ]; then
    wait=$((i * interval))
    sleep $wait
  fi
done

echo "Condition not fulfilled after $max_retries checks ❌"
SOURCE_REPOSITORY=$(gh variable get SOURCE_REPOSITORY --repo "$REPO_NAME")
gh workflow run "main.yml" --repo "$SOURCE_REPOSITORY" --raw-field "RUN_MODE=MEC30" --raw-field "REMOVE_RUNNER=true"

echo "Canceling the current workflow..."
gh run cancel $GITHUB_RUN_ID --repo "$REPO_NAME"

# Sleep briefly to ensure the cancellation goes through before the step finishes
sleep 10 
exit 0

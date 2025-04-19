#!/bin/bash

cd /home/runner/_site

if [[ -z $RUNNER_TOKEN && -z $GITHUB_ACCESS_TOKEN ]]; then
    echo "Error : You need to set RUNNER_TOKEN (or GITHUB_ACCESS_TOKEN) environment variable."
    exit 1
fi

if [[ -z $RUNNER_REPLACE_EXISTING ]]; then
    export RUNNER_REPLACE_EXISTING="true"
fi

CONFIG_OPTS=""
if [ "$(echo $RUNNER_REPLACE_EXISTING | tr '[:upper:]' '[:lower:]')" == "true" ]; then
	CONFIG_OPTS="--replace"
fi

if [[ -n $RUNNER_LABELS ]]; then
    CONFIG_OPTS="${CONFIG_OPTS} --labels ${RUNNER_LABELS}"
fi

if [[ -f $GITHUB_WORKSPACE/_config.yml ]]; then
    FOLDER=$(yq '.span' $GITHUB_WORKSPACE/_config.yml)
    export RUNNER_NAME=$(eval echo $FOLDER)
    export RUNNER_WORK_DIRECTORY=$(eval echo $FOLDER)

    TARGET_REPOSITORY=$(yq '.repository' $GITHUB_WORKSPACE/_config.yml)
    if [[ "$TARGET_REPOSITORY" != *"eq19/"* ]]; then
        SCOPE="orgs"
        RUNNER_URL="https://github.com/${TARGET_REPOSITORY%%/*}"
    else
        SCOPE="repos"
        RUNNER_URL="https://github.com/${TARGET_REPOSITORY}"
    fi

    if [[ -n $GITHUB_ACCESS_TOKEN ]]; then

        echo "Exchanging the GitHub Access Token with a Runner Token (scope: ${SCOPE})..."

        _PROTO="$(echo "${RUNNER_URL}" | grep :// | sed -e's,^\(.*://\).*,\1,g')"
        _URL="$(echo "${RUNNER_URL/${_PROTO}/}")"
        _PATH="$(echo "${_URL}" | grep / | cut -d/ -f2-)"

        RUNNER_TOKEN="$(curl -XPOST -fsSL \
            -H "Authorization: token ${GITHUB_ACCESS_TOKEN}" \
            -H "Accept: application/vnd.github.v3+json" \
            "https://api.github.com/${SCOPE}/${_PATH}/actions/runners/registration-token" \
            | jq -r '.token')"
    fi

    # Register new URL
    ../config.sh \
        --url $RUNNER_URL \
        --token $RUNNER_TOKEN \
        --name $RUNNER_NAME \
        --work $RUNNER_WORK_DIRECTORY \
        $CONFIG_OPTS \
        --unattended
    ../svc.sh install
    ../svc.sh start

fi

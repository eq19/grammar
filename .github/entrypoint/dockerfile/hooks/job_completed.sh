#!/usr/bin/env bash
# Structure: Cell Types – Modulo 6

hr='----------------------------------------------------------------------------------'
CONTAINER="mydb"
APP="freqtrade_live"
DOCKER="/mnt/disks/deeplearning/usr/bin/docker"

echo -e "\n$hr\nFinal Space\n$hr"
df -h

if [ -d /mnt/disks/deeplearning/usr/local/sbin ]; then

  echo -e "\n$hr\nDocker images\n$hr"
  $DOCKER image ls

  echo -e "\n$hr\nNetwork images\n$hr"
  $DOCKER network inspect bridge

  RERUN_RUNNER=$(curl -s \
    -H "Authorization: token $GH_TOKEN" \
    -H "Accept: application/vnd.github.v3+json" \
    "https://api.github.com/repos/${GITHUB_REPOSITORY}/actions/variables/RERUN_RUNNER" | jq -r '.value')

  REMOVE_REPOSITORY=$(curl -s \
    -H "Authorization: token $GH_TOKEN" \
    -H "Accept: application/vnd.github.v3+json" \
    "https://api.github.com/repos/${GITHUB_REPOSITORY}/actions/variables/REMOVE_REPOSITORY" | jq -r '.value')

  TARGET_REPOSITORY=$(curl -s \
    -H "Authorization: token $GH_TOKEN" \
    -H "Accept: application/vnd.github.v3+json" \
    "https://api.github.com/repos/${GITHUB_REPOSITORY}/actions/variables/TARGET_REPOSITORY" | jq -r '.value')

  echo -e "\n$hr\nStart Network\n$hr"
  $DOCKER exec mydb supervisorctl reload
  if [[ "$RERUN_RUNNER" == "true" ]]; then
    #$DOCKER exec mydb supervisorctl start freqtrade_dry
    $DOCKER exec mydb supervisorctl start freqtrade_live
    $DOCKER exec mydb service cron start

  #Check if ✅ $APP is running inside $CONTAINER
  elif $DOCKER ps --format '{{.Names}}' | grep -q "^${CONTAINER}$" && \
    $DOCKER exec "$CONTAINER" supervisorctl status "$APP" | grep -q "RUNNING"; then

    if [[ "$CONTAINER_NAME" == "runner1" ]]; then
      $DOCKER exec runner2 /home/runner/scripts/exitpoint.sh $REMOVE_REPOSITORY $TARGET_REPOSITORY
    elif [[ "$CONTAINER_NAME" == "runner2" ]]; then
      $DOCKER exec runner1 /home/runner/scripts/exitpoint.sh $REMOVE_REPOSITORY $TARGET_REPOSITORY
    fi

  else
    # Optionally restart:
    # docker start "$CONTAINER" && docker exec "$CONTAINER" supervisorctl start "$APP"
    #$DOCKER exec mydb supervisorctl start freqtrade_dry
    $DOCKER exec mydb supervisorctl start freqtrade_live
    $DOCKER exec mydb service cron start
    #echo "❌ $APP is NOT running (either container is down or process crashed)."
    
  fi
fi

echo -e "\njob completed"

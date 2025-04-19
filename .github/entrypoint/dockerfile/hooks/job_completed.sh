#!/usr/bin/env bash
# Structure: Cell Types – Modulo 6

hr='------------------------------------------------------------------------------------'

echo -e "\n$hr\nFinal Space\n$hr"
df -h

if [ -d /mnt/disks/deeplearning/usr/local/sbin ]; then

  echo -e "\n$hr\nDocker images\n$hr"
  /mnt/disks/deeplearning/usr/bin/docker image ls

  echo -e "\n$hr\nNetwork images\n$hr"
  /mnt/disks/deeplearning/usr/bin/docker network inspect bridge

  echo -e "\n$hr\nStart Network\n$hr"
  /mnt/disks/deeplearning/usr/bin/docker exec mydb supervisorctl start freqtrade
  /mnt/disks/deeplearning/usr/bin/docker exec mydb service cron start

fi

echo -e "\njob completed"

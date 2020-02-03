#!/bin/bash

launch_librespot () {
  screen -dmS librespot `which librespot` \

  # SPECIFY LIBRESPOT ATTRIBUTES WITH TRAILING BACKSLASH
  # --START OF CUSTOM ATTRIBUTES

  --name osmc \
  --bitrate 320 \
  --initial-volume 50 \
  --enable-volume-normalisation \
  --disable-audio-cache \
  --backend alsa \
  #--username [username] \
  #--password [password] \
  #--device plughw:0 \
  #--onevent /var/local/www/commandw/spotevent.sh \

  # --END OF CUSTOM ATTRIBUTES
  # DO NOT REMOVE verbose
  --verbose

  echo "librespot started"
}

if [[ "$1" == "start" ]]; then

  if [[ -z `screen -ls | grep librespot` ]]; then
    launch_librespot
  else
    echo "librespot is already running"
  fi
  exit 1

elif [[ "$1" == "restart" ]]; then

  if [[ -z `screen -ls | grep librespot` ]]; then
    echo "librespot not running"
  else
    echo "restarting librespot"
    kill -9 `screen -ls librespot | grep librespot | cut -d "." -f 1`
    screen -wipe | 1>/dev/null
  fi

  launch_librespot
  exit 1

elif [[ "$1" == "stop" ]]; then

  if [[ -z `screen -ls | grep librespot` ]]; then
    echo "librespot not running"
  else
    echo "stopping librespot"
    kill -9 `screen -ls librespot | grep librespot | cut -d "." -f 1`
    screen -wipe | 1>/dev/null
  fi
  exit 1

elif [[ "$1" == "status" ]]; then

  if [[ -z `screen -ls | grep librespot` ]]; then
    echo "librespot not running"
  else
    screen -S librespot -X hardcopy /run/user/1000/librespot
    tail /run/user/1000/librespot
  fi
  exit 1

elif [[ "$1" == "cron" ]]; then

  if [[ -z `screen -ls | grep librespot` ]]; then
    echo "librespot not running"
  else
    screen -S librespot -X hardcopy /run/user/1000/librespot
    if [[ `tail /run/user/1000/librespot | grep -c ConnectionReset` != 0 ]]; then
      echo "ConnectionReset detected"
      "$0" restart
    fi

  fi
  exit 1

elif [[ "$1" == "ping" ]]; then

  echo ping

else

  echo "function: ./librespot [start|restart|stop|status|cron]"

fi

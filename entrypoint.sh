#!/usr/bin/env bash

exit_handler() {
  echo "in exit handler"
  /usr/lib/unifi/bin/unifi.init stop
  echo "done exit handler"
  exit ${?}
}

trap "exit_handler" SIGHUP SIGINT SIGQUIT SIGTERM

echo "About to call start"
/usr/lib/unifi/bin/unifi.init start

sleep infinity &
wait ${!}
echo "dropped out of sleep"

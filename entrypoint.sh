#!/usr/bin/env bash

exit_handler() {
  echo "in exit handler"
  /usr/lib/unifi/bin/unifi.init stop
  echo "done exit handler"
  exit ${?}
}

trap 'kill ${!}; exit_handler' SIGHUP SIGINT SIGQUIT SIGTERM

echo "About to call start"
/usr/lib/unifi/bin/unifi.init start
echo "Done start - about to sleep"
sleep infinity
echo "dropped out of sleep"

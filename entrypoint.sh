#!/usr/bin/env bash

exit_handler() {
  /usr/lib/unifi/bin/unifi.init stop
  exit ${?}
}

trap 'kill ${!}; exit_handler' SIGHUP SIGINT SIGQUIT SIGTERM

/usr/lib/unifi/bin/unifi.init start
wait

exit 1

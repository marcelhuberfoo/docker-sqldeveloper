#!/bin/sh
set -e
umask 002

if [ "$1" = 'oracle-sqldeveloper' ]; then
  exec gosu $UNAME "$@"
fi
exec "$@"

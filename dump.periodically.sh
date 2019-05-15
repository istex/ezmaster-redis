#!/bin/bash
# script looping indefinitly and doing each X hours
# a redisdump into /ezdata/dump folder

while true
do
  # loop until the database is ready to accept connections
  echo -n "Waiting until redis is ready to run redisdump."
  until nc -z 127.0.0.1 6379
  do
    echo -n "."
    sleep 1
  done  

  DUMP_FILE=/ezdata/dump/dump.$(date '+%Y-%m-%d_%Hh%M').archive
  echo "Creating a dump with BGSAVE in $DUMP_FILE"
  # Use BGSAVE instead of SAVE. Because SAVE is synchronous and may cause some troubles if you are working with redis 
  # while this save happened. For more informations https://redis.io/commands/bgsave https://redis.io/commands/save
  redis-cli BGSAVE > $DUMP_FILE

  
  echo "Cleaning old dump."
  tmpreaper --verbose ${DUMP_CLEANUP_MORE_THAN_NBDAYS}d /ezdata/dump/

  echo "Waiting $DUMP_EACH_NBHOURS hours before next dump."
  sleep ${DUMP_EACH_NBHOURS}h
done

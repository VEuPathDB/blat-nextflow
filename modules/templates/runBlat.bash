#!/usr/bin/env bash

set -euo pipefail
RANGE=13000
FLOOR=8000
MAX_TRIES=4
for (( i=0; i<= MAX_TRIES; i++)); do
  randomNumber=0
  while [ \$randomNumber -le \$FLOOR ]; do
    randomNumber=\$RANDOM
    let "randomNumber %= \$RANGE"
  done
  PORT=\$randomNumber;
  if $params.trans ; then
    TRANS="-trans"
  else 
    TRANS=""
  fi
  gfServer start localhost \$PORT $databasePath \
    -canStop \
    -maxAaSize=15000 \$TRANS > /dev/null 2>&1 & 
  sleep 10
  gfServer status localhost \$PORT > temp
  if grep "version" temp; then
    echo Port \$PORT is active
    break
  else 
    echo Attempt \$i to start server
  fi 
done
sleep 10
gfClient localhost \$PORT . $subsetFasta out.psl \
  -t=$params.dbType \
  -q=$params.queryType \
  -dots=10 $params.blatParams \
  -maxIntron=$params.maxIntron
gfServer stop localhost \$PORT

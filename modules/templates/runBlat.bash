#!/usr/bin/env bash

set -euo pipefail

blat $genomeSubsetFasta $queryFasta out.psl $params.blatParams \
  -t=$params.dbType \
  -q=$params.queryType \
  -dots=10 \
  -noHead \
  -maxIntron=$params.maxIntron

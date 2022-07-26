nextflow.enable.dsl=2

process blat {
  input:
  path 'subset.fa'
  path 'data.2bit'
  output:
  path "out.psl"
  """
  RANGE=13000
  FLOOR=8000
  MAX_TRIES=4
  randomNumber=0
  for (( i=0; i<= 10; i++)); do
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
  gfServer start localhost \$PORT data.2bit -canStop -maxAaSize=15000 \$TRANS > /dev/null 2>&1 &
  done
  sleep 10 
  for (( i=1; i<=\$MAX_TRIES; i++ )); do
    echo Try \$i    
    gfClient localhost \$PORT . subset.fa out.psl -t=$params.dbType -q=$params.queryType -dots=10 $params.blatParams -maxIntron=$params.maxIntron
    break
  done
  gfServer stop localhost \$PORT
  """
}

workflow {
  seqs = Channel.fromPath(params.seqFile).splitFasta(by:params.fastaSubsetSize, file:true)
  blat(seqs, params.databasePath) | collectFile(storeDir: params.outputDir) 
}
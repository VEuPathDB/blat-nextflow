nextflow.enable.dsl=2

process blat {
  publishDir params.outputDir, mode: "copy"
  input:
  path 'subset.fa'
  output:
  path "out.psl"
  """
  RANGE=13000
  FLOOR=8000
  MAX_TRIES=12
  for (( i=0; i<= 10; i++)); do
      randomNumber=0
    while [ \$randomNumber -le \$FLOOR ]; do
	randomNumber=\$RANDOM
        let "randomNumber %= \$RANGE"
    done
    SERVER_PORT=\$randomNumber;
    if $params.trans ; then
        TRANS="-trans"
    else 
        TRANS=""
    fi
    gfServer -canStop -maxAaSize=15000 \$TRANS start localhost \$SERVER_PORT "$params.databasePath/" & pid=\$!
    ps -p \$pid >/dev/null && break 1;
  done
  for (( i=1; i<=\$MAX_TRIES; i++ )); do
     sleep 10
     echo Try \$i of \$MAX_TRIES to connect
   
     if echo version >/dev/tcp/localhost/\$SERVER_PORT; then
         echo blat server running on port \$SERVER_PORT 
        
         gfClient -nohead -maxIntron=$params.maxIntron -t=$params.dbType -q=$params.queryType -dots=10 $params.blatParams localhost \$SERVER_PORT $params.databasePath subset.fa out.psl
         gfServer stop localhost \$SERVER_PORT 
         exit 0
     
     else
         echo Connection Failure \$i of \$MAX_TRIES
     fi   
       
  done
  kill \$pid;
  exit 1
  
  """
}

workflow {
  Channel.fromPath(params.seqFile).splitFasta(by:params.fastaSubsetSize, file:true) | blat
}
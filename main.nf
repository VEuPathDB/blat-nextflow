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
    for (( i = 0 ; i <= 1000 ; i++ )); do
        randomNumber=0
	while [ "\$randomNumber" -le \$FLOOR ]
	do
	  randomNumber=\$RANDOM
	  let "randomNumber %= \$RANGE"
        done
        SERVER_PORT=\$randomNumber;
        if [$params.trans = true] ; then
          TRANS = "-trans"
        else 
          TRANS = ""
        fi
        gfServer -canStop -maxAaSize=15000 \$TRANS start localhost \$SERVER_PORT "$params.databasePath/*.2bit" 
    done
    
    gfClient -nohead -maxIntron=$maxIntron -t=$dbType -q=$queryType -dots=10 $blatParams localhost $port $targetPath subset.fa out.psl 
    
    gfServer stop localhost \$SERVER_PORT
  """
}
workflow {
  Channel.fromPath(params.seqFile).splitFasta(by:params.fastaSubsetSize, file:true) | blat
}
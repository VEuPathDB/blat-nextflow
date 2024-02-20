#!/usr/bin/env nextflow
nextflow.enable.dsl=2


process runBlat {

  input:
    path genomeSubsetFasta
    path queryFasta

  output:
    path "out.psl"

  script:
    template 'runBlat.bash'
}


workflow blat {
  take:
    seqs

  main:
    runBlat(seqs, params.queryFasta) | collectFile( storeDir: params.outputDir )
}

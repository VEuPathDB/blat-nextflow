#!/usr/bin/env nextflow
nextflow.enable.dsl=2


process runBlat {

  input:
    path 'subset.fa'
    path 'data.2bit'

  output:
    path "out.psl"

  script:
    template 'runBlat.bash'
}


workflow blat {
  take:
    seqs

  main:
    runBlat( seqs, params.databasePath ) \
      | collectFile( storeDir: params.outputDir )   
}
#!/usr/bin/env nextflow
nextflow.enable.dsl=2


process runBlat {
  container = 'veupathdb/blat:1.0.0'

  input:
    path genomeSubsetFasta
    path queryFasta

  output:
    path "out.psl"

  script:
  """
  blat $genomeSubsetFasta $queryFasta out.psl  \
  -t=$params.dbType \
  -noHead \
  -q=$params.queryType ${task.ext.args}
  """
}


workflow blat {
  take:
    seqs

  main:
  runBlat(seqs, params.queryFasta) | collectFile( name: params.outputFileName, storeDir: params.outputDir )
}

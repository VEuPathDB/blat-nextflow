#!/usr/bin/env nextflow
nextflow.enable.dsl=2

//---------------------------------------------------------------
// Param Checking 
//---------------------------------------------------------------

if(params.genomeFasta) {
  genomicSeqs = Channel.fromPath( params.genomeFasta )
    .splitFasta( by:params.fastaSubsetSize, file:true )
}
else {
  throw new Exception("Missing params.genomeFasta")
}

if(!params.queryFasta) {
  throw new Exception("Missing params.queryFasta")
}

//---------------------------------------------------------------
// Includes 
//---------------------------------------------------------------

include { blat } from './modules/blat.nf'

//---------------------------------------------------------------
// Main Workflow
//---------------------------------------------------------------

workflow {
  blat(genomicSeqs)
}

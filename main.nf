#!/usr/bin/env nextflow
nextflow.enable.dsl=2

//---------------------------------------------------------------
// Param Checking 
//---------------------------------------------------------------

//---------------------------------------------------------------
// Includes 
//---------------------------------------------------------------

include { blat } from './modules/blat.nf'

//---------------------------------------------------------------
// Main Workflow
//---------------------------------------------------------------

workflow {
  if(params.genomeFasta) {
    genomicSeqs = channel.fromPath( params.genomeFasta )
      .splitFasta( by:params.fastaSubsetSize, file:true )
  }
  else {
    error "Missing params.genomeFasta"
  }

  if(!params.queryFasta) {
    error "Missing params.queryFasta"
  }

  blat(genomicSeqs)
}

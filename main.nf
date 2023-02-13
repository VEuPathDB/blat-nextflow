#!/usr/bin/env nextflow
nextflow.enable.dsl=2

//---------------------------------------------------------------
// Param Checking 
//---------------------------------------------------------------

if(params.seqFile) {
  seqs = Channel.fromPath( params.seqFile )
           .splitFasta( by:params.fastaSubsetSize, file:true )
}
else {
  throw new Exception("Missing params.seqFile")
}

if(!params.databasePath) {
  throw new Exception("Missing params.databasePath")
}

//---------------------------------------------------------------
// Includes 
//---------------------------------------------------------------

include { blat } from './modules/blat.nf'

//---------------------------------------------------------------
// Main Workflow
//---------------------------------------------------------------

workflow {
  blat(seqs)
}
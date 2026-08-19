# blat-nextflow

A Nextflow pipeline that aligns query sequences against a genome using [BLAT](https://genome.ucsc.edu/FAQ/FAQblat.html) (BLAST-Like Alignment Tool).

## Overview

This pipeline is a Nextflow implementation of a BLAT-based sequence alignment step used in VEuPathDB's genomic data workflows. It splits an input genome FASTA into subsets, runs the UCSC `blat` aligner against a query FASTA for each subset, and merges the resulting PSL alignment records into a single output file. It is used within VEuPathDB's ReFlow-orchestrated pipelines wherever genomic sequences (or contigs) need to be aligned against a reference genome — for example, mapping assembled or query sequences onto a genome assembly.

## Requirements

- [Nextflow](https://www.nextflow.io/) (DSL2)
- A container engine: [Docker](https://www.docker.com/) or [Singularity](https://sylabs.io/singularity/)/[Apptainer](https://apptainer.org/)

The pipeline runs the `veupathdb/blat:1.1.0` container, which is built from the included `Dockerfile` and installs the UCSC `blat` binary via rsync from `hgdownload.soe.ucsc.edu`.

Execution profiles are provided under `conf/`:
- `conf/docker.config` — run with Docker (default, included via `nextflow.config`)
- `conf/singularity.config` — run with Singularity
- `conf/lsf.config` — run with Singularity on an LSF cluster

## Usage

```bash
nextflow run VEuPathDB/blat-nextflow -r main -resume \
  --genomeFasta /path/to/genome.fa \
  --queryFasta  /path/to/query.fa \
  --outputDir   /path/to/results \
  -C conf/docker.config
```

The pipeline has a single, unnamed entry point (no `-entry` flag is needed). It:

1. Splits `genomeFasta` into subsets of `fastaSubsetSize` sequences each.
2. Runs `blat` for each subset against `queryFasta`.
3. Concatenates all resulting PSL records into one output file written to `outputDir`.

## Key Parameters

| Parameter          | Default                    | Description |
| ------------------ | --------------------------- | ------------ |
| `genomeFasta`       | `data/genome.fa`             | Genome FASTA to split and search against (required). |
| `queryFasta`        | `data/nuc.fa`                 | Query FASTA aligned against each genome subset (required). |
| `fastaSubsetSize`   | `1`                          | Number of sequences per split of `genomeFasta`, controlling parallelism. |
| `dbType`            | `dna`                        | BLAT database (target) sequence type: `dna`, `prot`, or `dnax`. |
| `queryType`         | `dna`                        | BLAT query sequence type: `dna`, `prot`, `dnax`, or `rnax`. |
| `outputDir`         | `results`                    | Directory the merged PSL output is published to. |
| `outputFileName`    | `output.psl`                 | Name of the merged PSL output file. |

Additional BLAT command-line options (e.g. `-dots=10 -maxIntron=50`) are set via `process.withName:runBlat.ext.args` in `nextflow.config` and can be overridden per deployment.

## Output

A single PSL-format alignment file (`outputDir/outputFileName`, default `results/output.psl`) containing the concatenated BLAT alignment records for every genome subset searched against the query FASTA.

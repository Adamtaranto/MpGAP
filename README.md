# MpGAP (General multi-platform genome assembly pipeline)

![](https://travis-ci.com/fmalmeida/MpGAP.svg?branch=master)

MpGAP is a nextflow docker-based pipeline that wraps up [Canu](https://github.com/marbl/canu), [Flye](https://github.com/fenderglass/Flye), [Unicycler](https://github.com/rrwick/Unicycler), [Spades](https://github.com/ablab/spades), [Nanopolish](https://github.com/jts/nanopolish), [QUAST](https://github.com/ablab/quast) and [Pilon](https://github.com/broadinstitute/pilon).

This is an easy to use pipeline that adopts well known software for genome assembly of Illumina, Pacbio and Oxford Nanopore sequencing data through illumina only, long reads only or hybrid modes.

This pipeline has only two dependencies: [Docker](https://www.docker.com) and [Nextflow](https://github.com/nextflow-io/nextflow).

## Table of contents

* [Requirements](https://github.com/fmalmeida/MpGAP#requirements)
* [Quickstart](https://github.com/fmalmeida/MpGAP#quickstart)
* [Documentation](https://github.com/fmalmeida/MpGAP#documentation)
  * [Full usage](https://github.com/fmalmeida/MpGAP#usage)
  * [Usage Examples](https://github.com/fmalmeida/MpGAP#usage-examples)
  * [Configuration File](https://github.com/fmalmeida/MpGAP#using-the-configuration-file)

## Requirements

* Unix-like operating system (Linux, macOS, etc)
* Java 8
* Docker
  * `fmalmeida/compgen:{ASSEMBLERS, QUAST, Unicycler_Polish}`

## Quickstart

1. If you don't have it already install Docker in your computer. Read more [here](https://docs.docker.com/).
    * You can give this [in-house script](https://github.com/fmalmeida/bioinfo/blob/master/dockerfiles/docker_install.sh) a try.
    * After installed, you need to download the required Docker image

          docker pull fmalmeida/compgen:ASSEMBLERS
          docker pull fmalmeida/compgen:QUAST
          docker pull fmalmeida/compgen:Unicycler_Polish

2. Install Nextflow (version 0.24.x or higher):

       curl -s https://get.nextflow.io | bash

3. Give it a try:

       nextflow fmalmeida/MpGAP --help

## Documentation

### Usage

    Usage:
    nextflow run fmalmeida/MpGAP [--help] [ -c nextflow.config ] [OPTIONS] [-with-report] [-with-trace] [-with-timeline]

    Comments:
    This pipeline contains a massive amount of configuration variables and its usage as CLI parameters would
    cause the command to be huge. Therefore, it is extremely recommended to use the nextflow.config configuration file in order to make
    parameterization easier and more readable.

    Creating a configuration file:
    nextflow run fmalmeida/MpGAP [--get_hybrid_config] [--get_lreads_config] [--get_sreads_config] [--get_yaml]

    Show command line examples:
    nextflow run fmalmeida/MpGAP --show

    Execution Reports:
    nextflow run fmalmeida/MpGAP [ -c nextflow.config ] -with-report
    nextflow run fmalmeida/MpGAP [ -c nextflow.config ] -with-trace
    nextflow run fmalmeida/MpGAP [ -c nextflow.config ] -with-timeline

    OBS: These reports can also be enabled through the configuration file.

    OPTIONS:
             General Parameters - Mandatory

     --outDir <string>                      Output directory name
     --prefix <string>                      Set prefix for output files
     --threads <int>                        Number of threads to use
     --yaml <string>                        Sets path to yaml file containing additional parameters to assemblers.
     --assembly_type <string>               Selects assembly mode: hybrid, illumina-only or longreads-only
     --try_canu                             Execute assembly with Canu. Multiple assemblers can be chosen.
     --try_unicycler                        Execute assembly with Unicycler. Multiple assemblers can be chosen.
     --try_flye                             Execute assembly with Flye. Multiple assemblers can be chosen.
     --try_spades                           Execute assembly with Spades. Multiple assemblers can be chosen.


             Parameters for illumina-only mode. Can be executed by SPAdes and Unicycler assemblers.
             Users can use paired or single end reads. If both types are given at once, assemblers
             will be executed with a mix of both.

     --shortreads_paired <string>           Path to Illumina paired end reads.
     --shortreads_single <string>           Path to Illumina single end reads.
     --ref_genome <string>                  Path to reference genome for guided assembly. Used only by SPAdes.

             Parameters for hybrid mode. Can be executed by spades and unicycler assemblers.

     --shortreads_paired <string>           Path to Illumina paired end reads.
     --shortreads_single <string>           Path to Illumina single end reads.
     --ref_genome <string>                  Path to reference genome for guided assembly. Used only by SPAdes.
     --longreads <string>                   Path to longreads in FASTA or FASTQ formats.
     --lr_type <string>                     Sets wich type of long reads are being used: pacbio or nanopore

             Parameters for longreads-only mode. Can be executed by canu, flye and unicycler assemblers.
             In the end, long reads only assemblies can be polished with illumina reads through pilon.

     --longreads <string>                   Path to longreads in FASTA or FASTQ formats.
     --fast5Path <string>                   Path to directory containing FAST5 files for given reads.
                                            Whenever set, the pipeline will execute a polishing step
                                            with Nanopolish. This makes the pipeline extremely SLOW!!
     --pacbio_all_baxh5_path <string>       Path to all bax.h5 files for given reads. Whenever set, the pipeline
                                            will execute a polishing step with VarianCaller.
     --pacbio_all_bam_path <string>         Path to all subreads bam files for given reads. Whenever set, the pipeline
                                            will execute a polishing step with VarianCaller.
     --genomeSize                           Canu and Flye require an estimative of genome size in order
                                            to be executed. Examples: 5.6m; 1.2g
     --lr_type <string>                     Sets wich type of long reads are being used: pacbio or nanopore
     --illumina_polish_longreads_contigs    This tells the pipeline to polish long reads only assemblies
                                            with Illumina reads through Pilon. This is another hybrid methodology.
                                            For that, users have to set path to Illumina reads through
                                            --shortreads_paired or --shortreads_single.

### Usage examples:

> Illumina-only assembly with paired end reads, using SPAdes and Unicycler assemblers. Since it will always be a pattern match, example "illumina/SRR9847694_{1,2}.fastq.gz", it MUST ALWAYS be double quoted as the example below.

    ./nextflow run fmalmeida/MpGAP --threads 3 --outDir outputs/illumina_paired --prefix test --yaml path-to-additional_parameters.yaml --assembly_type
    illumina-only --try_unicycler --try_spades --shortreads_paired "../illumina/SRR9847694_{1,2}.fastq.gz"

> Illumina-only assembly with single end reads, using SPAdes and Unicycler assemblers. If multiple unpaired reads are given as input at once, pattern MUST be double quoted: "SRR9696*.fastq.gz"

    ./nextflow run fmalmeida/MpGAP --threads 3 --outDir outputs/illumina_single --prefix test --yaml path-to-additional_parameters.yaml --assembly_type
    illumina-only --try_unicycler --try_spades --shortreads_single "../illumina/SRR9696*.fastq.gz"

> Long reads only with ONT reads, using Canu, Flye and Unicycler assemblers.

    ./nextflow run fmalmeida/MpGAP --threads 3 --outDir sample_dataset/outputs/ont --run_longreads_pipeline --lreads_type nanopore --longReads sample_dataset/ont/kpneumoniae_25X.fastq --nanopore_prefix kpneumoniae_25X

> Pacbio basecalled (.fastq) reads with nextflow general report

    ./nextflow run fmalmeida/MpGAP --threads 3 --outDir sample_dataset/outputs/pacbio_from_fastq --run_longreads_pipeline --lreads_type pacbio --longReads sample_dataset/pacbio/m140905_042212_sidney_c100564852550000001823085912221377_s1_X0.subreads.fastq -with-report

> Pacbio raw (subreads.bam) reads

    ./nextflow run fmalmeida/MpGAP --threads 3 --outDir sample_dataset/outputs/pacbio --run_longreads_pipeline --lreads_type pacbio --pacbio_bamPath sample_dataset/pacbio/m140905_042212_sidney_c100564852550000001823085912221377_s1_X0.subreads.bam

> Pacbio raw (legacy .bas.h5 to subreads.bam) reads

    ./nextflow run fmalmeida/MpGAP --threads 3 --outDir sample_dataset/outputs/pacbio --run_longreads_pipeline --lreads_type pacbio --pacbio_h5Path sample_dataset/pacbio/m140912_020930_00114_c100702482550000001823141103261590_s1_p0.1.bax.h5

## Using the configuration file

All the parameters showed above can be, and are advised to be, set through the configuration file. When a configuration file is set the pipeline is run by simply executing `nextflow run fmalmeida/MpGAP -c ./configuration-file`

Your configuration file is what will tell to the pipeline the type of data you have, and which processes to execute. Therefore, it needs to be correctly set up.

Create a configuration file in your working directory:

* For Illumina data:

      nextflow run fmalmeida/MpGAP --get_illumina_config

* For Pacbio data:

      nextflow run fmalmeida/MpGAP --get_pacbio_config

* For ONT data:

      nextflow run fmalmeida/MpGAP --get_ont_config

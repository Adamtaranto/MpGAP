.. _config:

******************
Configuration File
******************

To download a configuration file template users just need to run ``nextflow run fmalmeida/MpGAP [--get_hybrid_config] [--get_lreads_config] [--get_sreads_config]``

Using a config file your code is a lot more clean and concise: ``nextflow run fmalmeida/MpGAP -c [path-to-config]``

Check out some `templates <https://github.com/fmalmeida/MpGAP/tree/master/configuration_example>`_.

Example of Hybrid assembly config file:
=======================================

.. code-block:: groovy

    /*
     * Configuration File to run fmalmeida/MpGAP pipeline.
     */

    /*
     * Customizable parameters
     */
    params {

                    /*
                     * General parameters
                     */

    //Output folder name
          outdir = 'output'

    //Number of threads to be used by each software.
          threads = 3

    /*
     * Here we chose the assembly type wanted. This is required.
     * It must be set as one of these posibilities: longreads-only ; hybrid ; illumina-only
     */
          assembly_type = ''

    /*
     * Here it is set the software wanted to perform the assembly with.
     * It must be set as true to use the software and false to skip it.
     */
          try_canu      = false
          canu_additional_parameters = '' // Must be given as shown in Canu manual. E.g. 'correctedErrorRate=0.075 corOutCoverage=200'
          try_unicycler = false
          unicycler_additional_parameters = '' // Must be given as shown in Unicycler manual. E.g. '--mode conservative --no_correct'
          try_flye      = false
          flye_additional_parameters = '' // Must be given as shown in Flye manual. E.g. '--meta --iterations 4'
          try_spades    = false
          spades_additional_parameters = '' // Must be given as shown in Spades manual. E.g. '--meta --plasmids'

    /*
     * This parameter only needs to be set if the software chosen is Canu or Flye.
     * It is an estimate of the size of the genome. Common suffices are allowed, for example, 3.7m or 2.8g
     */
          genomeSize = ''

                    /*
                     * Long reads parameters
                     */

    /*
     * Long reads input files. Just needed to be specified in case of hybrid or longreads-only assembly.
     * If none of these are wanted it may be left in blank.
     */
          longreads = '' // Already extracted in fasta or fastq

    /*
     * This parameter is used to specify the long read sequencing technology used.
     * It might be set as one of both: nanopore ; pacbio
     */
          lr_type = ''


    /*
     * Tells Medaka polisher which model to use according to the basecaller used.
     * For example the model named r941_min_fast_g303 should be used with data from
     * MinION (or GridION) R9.4.1 flowcells using the fast Guppy basecaller version 3.0.3.
     *
     * Where a version of Guppy has been used without an exactly corresponding medaka model,
     * the medaka model with the highest version equal to or less than the guppy version
     * should be selected. Models available: r941_min_fast_g303, r941_min_high_g303,
     * r941_min_high_g330, r941_min_high_g344, r941_prom_fast_g303, r941_prom_high_g303,
     * r941_prom_high_g344, r941_prom_high_g330, r10_min_high_g303, r10_min_high_g340,
     * r103_min_high_g345, r941_prom_snp_g303, r941_prom_variant_g303, r941_min_high_g340_rle.
     *
     * If left in blank, medaka will not be executed.
     */
          medaka_sequencing_model = 'r941_min_fast_g303'

    /*
     * The polishing step is performed (and advised) with Medaka (--sequencing_model parameter).
     * This parameter tells the pipeline to also try Nanopolish.
     *
     * This parameter loads the directory where all the nanopore FAST5 files are stored.
     * If this parameter is set, the pipeline is able to execute the polishing step with nanopolish.
     */
          nanopolish_fast5Path = ''

    /*
     * This parameter sets to nanopolish the max number of haplotypes to be considered.
     * Sometimes the pipeline may crash because to much variation was found exceeding the
     * limit. Try augmenting this value (Default: 1000)
     */
          nanopolish_max_haplotypes = 1000

    //Number of cores to run nanopolish in parallel
    //Beware of your system limits
          cpus = 2

    /*
     * This parameter loads all the subreads *.bam pacbio raw files for polishing with VariantCaller.
     * In order to nextflow properly use it, one needs to store all the data, from all the cells
     * in one single directory and set the filepath as "some/data/*bam".
     */
          pacbio_all_bam_path = ''


                    /*
                     * Short reads parameters
                     */
    /*
     * Short reads input files. They need to be specified in case of hybrid or shortreads-only assembly.
     * If none of these are wanted it may be left in blank. The files might be single or paired ended. They just
     * need to be properly identified as the examples below.
     * Examples for illumina reads:
     * Paired: shortreads_paired = 'SRR6307304_{1,2}.fastq' // For reads SRR6307304_1.fastq and SRR6307304_2.fastq
     * Single: shortreads_single = 'SRR7128258*'
     */
          shortreads_paired = ''
          shortreads_single = ''

    /*
     * This parameter below is to define wheter one wants or not to execute the alternative hybrid assembly method.
     * It first creates a long reads only assembly with canu, flye or unicycler and then polishes it using the provided
     * shortreads. It executes an alternative workflow and DOES NOT RUN unicycler/spades default hybrid modes.
     * Must be used with: assembly_type = 'hybrid'
     *
     * Whenever using this parameter, it is also possible to polish the longreads-only assemblies with Nanopolish,
     * Medaka or VarianCaller (Arrow) before the polishing with shortreads (using Pilon). For that it is necessary to set
     * the right parameters: pacbio_all_bam_path, nanopolish_fast5Path or medaka_sequencing_model.
     */
          illumina_polish_longreads_contigs = false

    /*
     * Whenever polishing long reads only assemblies with unpaired short reads (single end), the pipeline
     * will directly execute one round of pilon polishing instead of using Unicycler's polish pipeline.
     * Therefore we need to allocate the amount of memory allocated by Pilon. Default 50G.
     * This step is crucial because with not enough memory will crash and not correct your assembly.
     * When that happens you will not have the pilon output nor the QUAST assessment.
     */
          pilon_memory_limit = 50

    }

    /*
     * Configuring Nextflow reports
     */

    //Trace Report
    trace {
        enabled = false
        file = "${params.outdir}" + "/annotation_pipeline_trace.txt"
        fields = 'task_id,name,status,exit,realtime,cpus,%cpu,memory,%mem,rss'
    }

    //Timeline Report
    timeline {
        enabled = false
        file = "${params.outdir}" + "/annotation_pipeline_timeline.html"
    }

    //Complete Report
    report {
        enabled = false
        file = "${params.outdir}" + "/annotation_pipeline_nextflow_report.html"
    }

    /*
     * Configuring Nextflow Scopes.
     * Do NOT change any of the following
     */

    //Queue limit
    executor.$local.queueSize = 1

    //Docker usage
    docker.enabled = true
    //docker.runOptions = '-u $(id -u):root'
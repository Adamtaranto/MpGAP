.. _examples:

******************
CLI usage Examples
******************

Illumina-only assembly with paired end reads
============================================

::

   ./nextflow run fmalmeida/MpGAP --outdir output --threads 5 --assembly_type illumina-only --try_spades
   --try_unicycler --shortreads_paired "dataset_1/sampled/illumina_R{1,2}.fastq"

.. note::

  This command will perform an illumina-only assembly using paired end reads with Unicycler and SPAdes assemblers.
  Since fastq files will be found by a pattern match users MUST ALWAYS double quote as: Example "illumina/SRR9847694_{1,2}.fastq.gz"

Illumina-only assembly with single end reads
============================================

::

  ./nextflow run fmalmeida/MpGAP --outdir output --threads 5 --assembly_type illumina-only --try_spades
  --try_unicycler --shortreads_single "dataset_1/sampled/illumina_single.fastq"

.. note::

  This command will perform an illumina-only assembly using unpaired reads with Unicycler and SPAdes assemblers.
  Since fastq files will be found by a pattern match users MUST ALWAYS double quote as: Example "SRR9696*.fastq.gz"

Illumina-only assembly with both paired and single end reads
============================================================

::

  ./nextflow run fmalmeida/MpGAP --outdir output --threads 5 --assembly_type illumina-only --try_spades
  --try_unicycler --shortreads_paired "dataset_1/sampled/illumina_R{1,2}.fastq" --shortreads_single "dataset_1/sampled/illumina_single.fastq"

.. note::

  This command will perform an illumina-only assembly using both paired and unpaired reads with Unicycler and SPAdes assemblers.
  Since fastq files will be found by a pattern match users MUST ALWAYS double quote it.

Long reads only with ONT reads
==============================

::

  ./nextflow run fmalmeida/MpGAP --outdir output --threads 5 --assembly_type longreads-only --try_canu --try_flye --try_unicycler --medaka_sequencing_model r941_min_fast_g303
  --nanopolish_fast5Path "dataset_1/ont/fast5_pass" --nanopolish_max_haplotypes 2000 --genomeSize 2m --lr_type nanopore --longreads "dataset_1/ont/ont_reads.fastq"

.. note::

  This will perform a long reads only assembly using nanopore data with Canu, Flye and Unicycler assemblers. This specific command will also execute a polishing step with
  nanopolish (see ``--nanopolish_fast5Path``) and medaka (see ``--medaka_sequencing_model``).

.. tip::

  If neither ``--nanopolish_fast5Path`` nor ``--medaka_sequencing_model`` is set, the pipeline will not try to polish the assemblies using Nanopolish or Medaka, respectively.

Long reads only with ONT reads. With polishing using both FAST5 and Illumina data (paired end).
===============================================================================================

::

  ./nextflow run fmalmeida/MpGAP --threads 3 --outDir sample_dataset/outputs/ont --assembly_type "longreads-only" --lr_type nanopore
  --longreads sample_dataset/ont/kpneumoniae_25X.fastq  --fast5Path ./fast5_pass --try_canu --try_flye --try_unicycler --genomeSize "5.6m"
  --shortreads_paired "../illumina/SRR9847694_{1,2}.fastq.gz" --illumina_polish_longreads_contigs

.. note::

  This will perform a long reads only assembly using nanopore data with Canu, Flye and Unicycler assemblers. In the end, it will polish the
  assembly first with FAST5 data then with Illumina data.

Assembly in Hybrid mode with Unicycler. Using Pacbio reads.
===========================================================

::

  ./nextflow run fmalmeida/MpGAP --threads 3 --outDir sample_dataset/output --assembly_type "hybrid" --lr_type pacbio
  --longreads sample_dataset/ont/ecoli_25X.fastq --shortreads_paired "../illumina/SRR9847694_{1,2}.fastq.gz" --try_unicycler

.. note::

  This command will execute a hybrid assembly directly through Unicycler's hybrid assembly mode.

Running with a configuration file
=================================

::

      ./nextflow run fmalmeida/MpGAP -c nextflow.config

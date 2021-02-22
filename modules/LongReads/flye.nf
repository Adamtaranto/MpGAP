process flye_assembly {
  publishDir "${params.outdir}/${lrID}/${type}", mode: 'copy'
  container 'fmalmeida/mpgap'
  cpus params.threads
  tag "Performing a longreads only assembly with Flye"

  input:
  file lreads

  output:
  file "flye" // Saves all files
  tuple file("flye/flye_assembly.fasta"), val(lrID), val('flye') // Gets contigs file

  script:
  lr    = (params.lr_type == 'nanopore') ? '--nano-raw' : '--pacbio-raw'
  lrID  = lreads.getSimpleName()
  gsize = (params.genomeSize) ? "--genome-size ${params.genomeSize}" : ""

  // Check available reads
  if (!params.shortreads_paired && !params.shortreads_single && params.longreads && params.lr_type) {
    type = 'longreads_only'
  } else if ((params.shortreads_paired || params.shortreads_single) && params.longreads && params.lr_type) {
    type = 'hybrid/strategy_2'
  }
  """
  source activate flye ;
  flye ${lr} $lreads ${gsize} --out-dir flye \
  --threads ${params.threads} ${params.flye_additional_parameters} &> flye.log ;
  mv flye/assembly.fasta flye/flye_assembly.fasta
  """
}

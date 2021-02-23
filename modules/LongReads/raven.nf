process raven_assembly {
  publishDir "${params.outdir}/${lrID}/${type}/raven", mode: 'copy'
  container 'fmalmeida/mpgap'
  cpus params.threads
  tag "Performing a longreads only assembly with raven"

  input:
  file lreads

  output:
  file "raven_contigs.fa" // Saves all files
  tuple file("raven_contigs.fa"), val(lrID), val('raven') // Gets contigs file

  script:
  lrID = lreads.getSimpleName()

  // Check available reads
  if (!params.shortreads_paired && !params.shortreads_single && params.longreads && params.lr_type) {
    type = 'longreads_only'
  } else if ((params.shortreads_paired || params.shortreads_single) && params.longreads && params.lr_type) {
    type = 'hybrid/strategy_2/longreads_only'
  }
  """
  raven $lreads --threads ${params.threads} ${params.raven_additional_parameters} > raven_contigs.fa ;
  """
}

process shovill_sreads_assembly {
  publishDir "${params.outdir}/${id}/shortreads_only", mode: 'copy', overwrite: true
  container 'fmalmeida/mpgap'
  tag "Performing a illumina-only assembly with shovill, using paired end reads"
  cpus params.threads

  input:
  tuple val(id), file(sread1), file(sread2)

  output:
  file "*" // Save all output
  tuple file("shovill/contigs.fa"), val(id), val('shovill') // Gets contigs file

  when:
  ((params.shortreads_paired) && (!params.shortreads_single))

  script:
  """
  # Activate env
  source activate shovill ;

  # Run
  shovill --outdir shovill --R1 $sread1 --R2 $sread2 \
  --cpus ${params.threads} --trim ${params.shovill_additional_parameters}
  """
}

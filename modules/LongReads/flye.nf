process flye_assembly {
  publishDir "${params.outdir}/longreads-only", mode: 'copy', overwrite: true
  container 'fmalmeida/mpgap'
  cpus params.threads
  tag "Performing a longreads only assembly with Flye"

  input:
  file lreads

  output:
  file "flye_${lrID}" // Saves all files
  tuple file("flye_${lrID}/assembly_flye.fasta"), val(lrID), val('flye') // Gets contigs file

  script:
  lr = (params.lr_type == 'nanopore') ? '--nano-raw' : '--pacbio-raw'
  lrID = lreads.getSimpleName()
  """
  source activate flye ;
  flye ${lr} $lreads --genome-size ${params.genomeSize} --out-dir flye_${lrID} \
  --threads ${params.threads} ${params.flye_additional_parameters} &> flye.log ;
  mv flye_${lrID}/assembly.fasta flye_${lrID}/assembly_flye.fasta
  """
}

/*
 * DEFINITION OF MULTI-SAMPLE (BATCH) MODE
 */

/*
 * Include modules
 */

// SPAdes sreads
include { spades } from '../modules/ShortReads/spades_sreads.nf'

// Unicycler sreads
include { unicycler } from '../modules/ShortReads/unicycler_sreads.nf'

// Shovill sreads
include { shovill } from '../modules/ShortReads/shovill_sreads.nf'

workflow SHORTREADS_ONLY {

  take:
      input_tuple
  
  main:

  // Channels for quast
  spades_ch    = Channel.empty()
  unicycler_ch = Channel.empty()
  shovill_ch   = Channel.empty()

  // SPAdes
  if (!params.skip_spades) {
    spades(input_tuple)
    spades_ch = spades.out[1]
  }
  // Unicycler
  if (!params.skip_unicycler) {
    unicycler(input_tuple)
    unicycler_ch = unicycler.out[1]
  }
  // Shovill
  if (!params.skip_shovill) {
    shovill(input_tuple.combine(Channel.from('spades', 'skesa', 'megahit')))
    shovill_ch = shovill.out[1]
  }

  // Get assemblies
  assemblies_ch = spades_ch.mix(unicycler_ch, shovill_ch)

  // Gather assemblies for qc
  final_assemblies = assemblies_ch.combine(input_tuple, by: 0)

  emit:
  final_assemblies

}
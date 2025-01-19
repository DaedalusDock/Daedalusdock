/*
 * Injects a number of chemicals from the plant when you throw it at someone or they slip on it.
 * At 0 potency it can inject 1 unit of its chemicals, while at 100 potency it can inject 20 units.
 */
/datum/plant_gene/product_trait/stinging
	name = "Hypodermic Prickles"
	examine_line = "<span class='info'>It's quite prickley.</span>"
	trait_ids = REAGENT_TRANSFER_ID
	gene_flags = PLANT_GENE_MUTATABLE

/datum/plant_gene/product_trait/stinging/on_new_product(obj/item/product, newloc, datum/plant/plant_datum)
	. = ..()
	if(!.)
		return

	RegisterSignal(product, COMSIG_PLANT_ON_SLIP, PROC_REF(prickles_inject))
	RegisterSignal(product, COMSIG_MOVABLE_IMPACT, PROC_REF(prickles_inject))

/*
 * Injects a target with a number of reagents from our plant.
 *
 * product - our plant that's injecting someone
 * target - the atom being hit on thrown or slipping on our plant
 */
/datum/plant_gene/product_trait/stinging/proc/prickles_inject(obj/item/product, atom/target)
	SIGNAL_HANDLER

	if(!isliving(target) || !product.reagents?.total_volume)
		return

	var/mob/living/living_target = target
	var/datum/plant/our_plant = product.get_plant_datum()
	var/potency = our_plant.get_effective_stat(PLANT_STAT_POTENCY)

	if(living_target.reagents && living_target.can_inject())
		var/injecting_amount = max(1, potency * 0.2) // Minimum of 1, max of 20
		product.reagents.trans_to(living_target, injecting_amount, methods = INJECT)
		to_chat(target, span_danger("You are pricked by [product]!"))
		log_combat(product, living_target, "pricked and attempted to inject reagents from [product] to [living_target]. Last touched by: [product.fingerprintslast].")
		product.investigate_log("pricked and injected [key_name(living_target)] and injected [injecting_amount] reagents at [AREACOORD(living_target)]. Last touched by: [product.fingerprintslast].", INVESTIGATE_BOTANY)

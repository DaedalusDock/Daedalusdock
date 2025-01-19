/// Explodes into reagent-filled smoke when squashed.
/datum/plant_gene/product_trait/smoke
	name = "Gaseous Decomposition"
	gene_flags = PLANT_GENE_MUTATABLE

/datum/plant_gene/product_trait/smoke/on_new_product(obj/item/product, newloc, datum/plant/plant_datum)
	. = ..()
	if(!.)
		return

	RegisterSignal(product, COMSIG_PLANT_ON_SQUASH, PROC_REF(make_smoke))

/*
 * Makes a cloud of reagent smoke.
 *
 * our_plant - our plant being squashed and smoked
 * target - the atom the plant was squashed on
 */
/datum/plant_gene/product_trait/smoke/proc/make_smoke(obj/item/product, atom/target)
	SIGNAL_HANDLER

	product.investigate_log("made smoke at [AREACOORD(target)]. Last touched by: [product.fingerprintslast].", INVESTIGATE_BOTANY)

	var/datum/effect_system/fluid_spread/smoke/chem/smoke = new()
	var/datum/plant/our_plant = product.get_plant_datum()
	var/splat_location = get_turf(target)
	var/smoke_amount = round(sqrt(our_plant.get_effective_stat(PLANT_STAT_POTENCY) * 0.1), 1)

	smoke.attach(splat_location)
	smoke.set_up(smoke_amount, location = splat_location, carry = product.reagents, silent = FALSE)
	smoke.start()
	product.reagents.clear_reagents()

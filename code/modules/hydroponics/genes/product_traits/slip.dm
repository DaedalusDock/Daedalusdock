/*
 * Makes plant slippery, unless it has a grown-type trash. Then the trash gets slippery.
 * Applies other trait effects (teleporting, etc) to the target by signal.
 */
/datum/plant_gene/product_trait/slip
	name = "Slippery Skin"
	rate = 1.6
	examine_line = "<span class='info'>It has a very slippery skin.</span>"
	gene_flags = PLANT_GENE_MUTATABLE

/datum/plant_gene/product_trait/slip/on_new_product(obj/item/product, newloc, datum/plant/plant_datum)
	. = ..()
	if(!.)
		return

	var/obj/item/food/grown/grown_plant = product
	if(istype(grown_plant) && ispath(grown_plant.trash_type, /obj/item/grown))
		return

	var/stun_len = grown_plant.cached_potency * rate

	if(!istype(grown_plant, /obj/item/grown/bananapeel) && (!grown_plant.reagents || !grown_plant.reagents.has_reagent(/datum/reagent/lube)))
		stun_len /= 3

	grown_plant.AddComponent(/datum/component/slippery, min(stun_len, 140), NONE, CALLBACK(src, PROC_REF(handle_slip), grown_plant))

/// On slip, sends a signal that our plant was slipped on out.
/datum/plant_gene/product_trait/slip/proc/handle_slip(obj/item/food/grown/our_plant, mob/slipped_target)
	SEND_SIGNAL(our_plant, COMSIG_PLANT_ON_SLIP, slipped_target)

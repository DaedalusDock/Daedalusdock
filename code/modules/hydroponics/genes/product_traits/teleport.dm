/*
 * Makes plant teleport people when squashed or slipped on.
 * Teleport radius is roughly potency / 10.
 */
/datum/plant_gene/product_trait/teleport
	name = "Bluespace Activity"
	rate = 0.1
	gene_flags = PLANT_GENE_UNSPLICABLE

/datum/plant_gene/product_trait/teleport/on_new_product(obj/item/product, newloc, datum/plant/plant_datum)
	. = ..()
	if(!.)
		return

	var/datum/plant/our_plant = product.get_plant_datum()
	if(our_plant.gene_holder.has_active_gene_of_type(/datum/plant_gene/product_trait/squash))
		// If we have the squash gene, let that handle slipping
		RegisterSignal(product, COMSIG_PLANT_ON_SQUASH, PROC_REF(squash_teleport))
	else
		RegisterSignal(product, COMSIG_PLANT_ON_SLIP, PROC_REF(slip_teleport))

/*
 * When squashed, makes the target teleport.
 *
 * product - our plant, being squashed, and teleporting the target
 * target - the atom targeted by the squash
 */
/datum/plant_gene/product_trait/teleport/proc/squash_teleport(obj/item/product, atom/target)
	SIGNAL_HANDLER

	if(!isliving(target))
		return

	product.investigate_log("squash-teleported [key_name(target)] at [AREACOORD(target)]. Last touched by: [product.fingerprintslast].", INVESTIGATE_BOTANY)
	var/datum/plant/our_plant = product.get_plant_datum()
	var/teleport_radius = max(round(our_plant.get_effective_stat(PLANT_STAT_POTENCY) / 10), 1)
	var/turf/T = get_turf(target)

	new /obj/effect/decal/cleanable/molten_object(T) //Leave a pile of goo behind for dramatic effect...
	do_teleport(target, T, teleport_radius, channel = TELEPORT_CHANNEL_BLUESPACE)

/*
 * When slipped on, makes the target teleport and either teleport the source again or delete it.
 *
 * product - our plant being slipped on
 * target - the carbon targeted that was slipped and was teleported
 */
/datum/plant_gene/product_trait/teleport/proc/slip_teleport(obj/item/product, mob/living/carbon/target)
	SIGNAL_HANDLER

	product.investigate_log("slip-teleported [key_name(target)] at [AREACOORD(target)]. Last touched by: [product.fingerprintslast].", INVESTIGATE_BOTANY)
	var/datum/plant/our_plant = product.get_plant_datum()
	var/teleport_radius = max(round(our_plant.get_effective_stat(PLANT_STAT_POTENCY) / 10), 1)
	var/turf/T = get_turf(target)

	to_chat(target, span_warning("You slip through spacetime!"))
	do_teleport(target, T, teleport_radius, channel = TELEPORT_CHANNEL_BLUESPACE)

	if(prob(50))
		do_teleport(product, T, teleport_radius, channel = TELEPORT_CHANNEL_BLUESPACE)
	else
		new /obj/effect/decal/cleanable/molten_object(T) //Leave a pile of goo behind for dramatic effect...
		qdel(product)

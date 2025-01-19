/// Allows the plant to be squashed when thrown or slipped on, leaving a colored mess and trash type item behind.
/datum/plant_gene/product_trait/squash
	name = "Liquid Contents"
	examine_line = "<span class='info'>It has a lot of liquid contents inside.</span>"
	trait_ids = THROW_IMPACT_ID | REAGENT_TRANSFER_ID | ATTACK_SELF_ID
	gene_flags = PLANT_GENE_MUTATABLE

// Register a signal that our plant can be squashed on add.
/datum/plant_gene/product_trait/squash/on_new_product(obj/item/food/grown/product, newloc)
	. = ..()
	if(!.)
		return

	RegisterSignal(product, COMSIG_PLANT_ON_SLIP, PROC_REF(squash_plant))
	RegisterSignal(product, COMSIG_MOVABLE_IMPACT, PROC_REF(squash_plant))
	RegisterSignal(product, COMSIG_ITEM_ATTACK_SELF, PROC_REF(squash_plant))

/*
 * Signal proc to squash the plant this trait belongs to, causing a smudge, exposing the target to reagents, and deleting it,
 *
 * Arguments
 * our_plant - the plant this trait belongs to.
 * target - the atom being hit by this squashed plant.
 */
/datum/plant_gene/product_trait/squash/proc/squash_plant(obj/item/food/grown/our_plant, atom/target)
	SIGNAL_HANDLER

	var/turf/our_turf = get_turf(target)
	our_plant.forceMove(our_turf)
	if(istype(our_plant))
		if(ispath(our_plant.splat_type, /obj/effect/decal/cleanable/food/plant_smudge))
			var/obj/plant_smudge = new our_plant.splat_type(our_turf)
			plant_smudge.name = "[our_plant.name] smudge"
			if(our_plant.filling_color)
				plant_smudge.color = our_plant.filling_color
		else if(our_plant.splat_type)
			new our_plant.splat_type(our_turf)
	else
		var/obj/effect/decal/cleanable/food/plant_smudge/misc_smudge = new(our_turf)
		misc_smudge.name = "[our_plant.name] smudge"
		misc_smudge.color = "#82b900"

	our_plant.visible_message(span_warning("[our_plant] is squashed."),span_hear("You hear a smack."))
	SEND_SIGNAL(our_plant, COMSIG_PLANT_ON_SQUASH, target)

	our_plant.reagents?.expose(our_turf)
	for(var/things in our_turf)
		our_plant.reagents?.expose(things)

	qdel(our_plant)

/// Plants that explode when used (based on their reagent contents)
/datum/plant_gene/product_trait/bomb_plant
	name = "Explosive Contents"
	trait_ids = ATTACK_SELF_ID

/datum/plant_gene/product_trait/bomb_plant/on_new_product(obj/item/product, newloc, datum/plant/plant_datum)
	. = ..()
	if(!.)
		return

	product.max_integrity = 40 // Max_integrity is lowered so they explode better, or something like that.
	RegisterSignal(product, COMSIG_ITEM_ATTACK_SELF, PROC_REF(trigger_detonation))
	RegisterSignal(product, COMSIG_ATOM_EX_ACT, PROC_REF(explosion_reaction))
	RegisterSignal(product, COMSIG_OBJ_DECONSTRUCT, PROC_REF(deconstruct_reaction))

/*
 * Trigger our plant's detonation.
 *
 * product - the plant that's exploding
 * user - the mob detonating the plant
 */
/datum/plant_gene/product_trait/bomb_plant/proc/trigger_detonation(obj/item/product, mob/living/user)
	SIGNAL_HANDLER

	var/obj/item/food/grown/grown_plant = product

	// If we have an alt icon, use that to show our plant is exploding.
	if(istype(grown_plant) && grown_plant.alt_icon)
		grown_plant.icon_state = grown_plant.alt_icon
	else
		grown_plant.color = COLOR_RED

	playsound(grown_plant, 'sound/effects/fuse.ogg', grown_plant.cached_potency, FALSE)
	user.visible_message(
		span_warning("[user] plucks the stem from [grown_plant]!"),
		span_userdanger("You pluck the stem from [grown_plant], which begins to hiss loudly!"),
	)
	log_bomber(user, "primed a", grown_plant, "for detonation")
	detonate(grown_plant)

/*
 * Reacting to when the plant is deconstructed.
 * When is a plant ever deconstructed? Apparently, when it burns.
 *
 * our_plant - the plant that's 'deconstructed'
 * disassembled - if it was disassembled when it was deconstructed.
 */
/datum/plant_gene/product_trait/bomb_plant/proc/deconstruct_reaction(obj/item/our_plant, disassembled)
	SIGNAL_HANDLER

	if(!disassembled)
		detonate(our_plant)
	if(!QDELETED(our_plant))
		qdel(our_plant)

/*
 * React to explosions that hit the plant.
 * Ensures that the plant id deleted by its own explosion.
 * Also prevents mass chain reaction with piles plants.
 *
 * our_plant - the plant that's exploded on
 * severity - severity of the explosion
 */
/datum/plant_gene/product_trait/bomb_plant/proc/explosion_reaction(obj/item/our_plant, severity)
	SIGNAL_HANDLER

	qdel(our_plant)

/*
 * RActually blow up the plant.
 *
 * our_plant - the plant that's exploding for real
 */
/datum/plant_gene/product_trait/bomb_plant/proc/detonate(obj/item/our_plant)
	our_plant.reagents.chem_temp = 1000 //Sets off the gunpowder
	our_plant.reagents.handle_reactions()

/// A subtype of bomb plants that have their boom sized based on potency instead of reagent contents.
/datum/plant_gene/product_trait/bomb_plant/potency_based
	name = "Explosive Nature"

/datum/plant_gene/product_trait/bomb_plant/potency_based/trigger_detonation(obj/item/our_plant, mob/living/user)
	user.visible_message(
		span_warning("[user] primes [our_plant]!"),
		span_userdanger("You prime [our_plant]!"),
	)
	log_bomber(user, "primed a", our_plant, "for detonation")

	var/obj/item/food/grown/grown_plant = our_plant
	if(istype(our_plant) && grown_plant.alt_icon)
		our_plant.icon_state = grown_plant.alt_icon
	else
		our_plant.color = COLOR_RED

	playsound(our_plant.drop_location(), 'sound/weapons/armbomb.ogg', 75, TRUE, -3)
	addtimer(CALLBACK(src, PROC_REF(detonate), our_plant), rand(1 SECONDS, 6 SECONDS))

/datum/plant_gene/product_trait/bomb_plant/potency_based/detonate(obj/item/product)
	var/datum/plant/our_plant = product.get_plant_datum()
	var/flame_reach = clamp(round(our_plant.gene_holder.get_effective_stat(PLANT_STAT_POTENCY) / 20), 1, 5) //Like IEDs - their flame range can get up to 5, but their real boom is small

	product.forceMove(product.drop_location())
	explosion(product, devastation_range = -1, heavy_impact_range = -1, light_impact_range = 2, flame_range = flame_reach)
	qdel(product)

// ********************************************************
// Here's all the seeds (plants) that can be used in hydro
// ********************************************************

/obj/item/seeds
	icon = 'icons/obj/hydroponics/seeds.dmi'
	icon_state = "seed" // Unknown plant seed - these shouldn't exist in-game.
	worn_icon_state = "seed"
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE

	/// Typepath of plant_datum to spawn on init.
	var/plant_type

	///Determines if the plant should be allowed to mutate early at 30+ instability.
	var/seed_flags = MUTATE_EARLY

	/// The plant within.
	var/tmp/datum/plant/plant_datum

	/// How much damage the seed has sustained. Destroyed at 100%.
	var/tmp/seed_damage = 0
	#warn impl correctly

/obj/item/seeds/Initialize(mapload, datum/plant/copy_from)
	. = ..()
	pixel_x = base_pixel_x + rand(-8, 8)
	pixel_y = base_pixel_y + rand(-8, 8)

	plant_datum = copy_from ? copy_from.Copy() : new plant_type()
	plant_datum.in_seed = src

/obj/item/seeds/Destroy()
	QDEL_NULL(plant_datum)
	return ..()

/obj/item/seeds/examine(mob/user)
	. = ..()
	. += span_notice("Use a pen on it to rename it or change its description.")

/**
 * Override for seeds with unique text for their analyzer. (No newlines at the start or end of unique text!)
 * Returns null if no unique text, or a string of text if there is.
 */
/obj/item/seeds/proc/get_unique_analyzer_text()
	return null

/// Damages the seed, deleting it at 100 damage.
/obj/item/seeds/proc/damage_seed(amt)
	seed_damage = clamp(seed_damage + amt, 0, 100)
	if(seed_damage == 100)
		qdel(src)

/*
 * Both `/item/food/grown` and `/item/grown` implement a seed variable which tracks
 * plant statistics, genes, traits, etc. This proc gets the seed for either grown food or
 * grown inedibles and returns it, or returns null if it's not a plant.
 *
 * Returns an `/obj/item/seeds` ref for grown foods or grown inedibles.
 *  - returned seed CAN be null in weird cases but in all applications it SHOULD NOT be.
 * Returns null if it is not a plant.
 */
/obj/item/proc/get_plant_datum()
	return null

/obj/item/seeds/get_plant_datum()
	return plant_datum

/obj/item/food/grown/get_plant_datum()
	return plant_datum

/obj/item/grown/get_plant_datum()
	return plant_datum

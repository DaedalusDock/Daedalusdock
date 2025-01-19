/datum/plant/shrub
	species = "shrub"
	name = "Shrubbery"

	seed_path = /obj/item/seeds/shrub
	product_path = /obj/item/grown/shrub

	growthstages = 3
	base_harvest_yield = 2

/obj/item/seeds/shrub
	name = "pack of shrub seeds"
	desc = "These seeds grow into hedge shrubs."
	icon_state = "seed-shrub"

	plant_type = /datum/plant/shrub


// Structure Stuff.

/obj/item/grown/shrub
	plant_datum = /datum/plant/shrub
	name = "shrub"
	desc = "A shrubbery, it looks nice and it was only a few credits too. Plant it on the ground to grow a hedge, shrubbing skills not required."
	icon_state = "shrub"

/obj/item/grown/shrub/attack_self(mob/user)
	var/turf/player_turf = get_turf(user)
	if(player_turf?.is_blocked_turf(TRUE))
		return FALSE
	user.visible_message(span_danger("[user] begins to plant \the [src]..."))
	if(do_after(user, user.drop_location(), 8 SECONDS, progress = TRUE))
		new /obj/structure/hedge/opaque(user.drop_location())
		to_chat(user, span_notice("You plant \the [src]."))
		qdel(src)

///the structure placed by the shrubs
/obj/structure/hedge
	name = "hedge"
	desc = "A large bushy hedge."
	icon = 'icons/obj/smooth_structures/hedge.dmi'
	icon_state = "hedge-0"
	base_icon_state = "hedge"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_HEDGE_FLUFF
	canSmoothWith = SMOOTH_GROUP_HEDGE_FLUFF
	density = TRUE
	anchored = TRUE
	opacity = FALSE
	max_integrity = 80

/obj/structure/hedge/attacked_by(obj/item/I, mob/living/user)
	if(opacity && HAS_TRAIT(user, TRAIT_BONSAI) && (I.sharpness & SHARP_EDGED))
		to_chat(user,span_notice("You start trimming \the [src]."))
		if(do_after(user, src, 3 SECONDS))
			to_chat(user,span_notice("You finish trimming \the [src]."))
			opacity = FALSE
	else
		return ..()
/**
 * useful for mazes and such
 */
/obj/structure/hedge/opaque
	opacity = TRUE

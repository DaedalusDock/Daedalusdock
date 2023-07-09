/obj/item/bodypart/proc/create_stump(mob/living/carbon/human/H, disintegrated, clean)
	var/path
	switch(body_zone)
		if(BODY_ZONE_HEAD)
			path = /obj/item/bodypart/head
		if(BODY_ZONE_R_LEG)
			path = /obj/item/bodypart/leg/right
		if(BODY_ZONE_L_LEG)
			path = /obj/item/bodypart/leg/left
		if(BODY_ZONE_R_ARM)
			path = /obj/item/bodypart/arm/right
		if(BODY_ZONE_L_ARM)
			path = /obj/item/bodypart/arm/left
		else
			CRASH("Insane stump!")


	var/obj/item/bodypart/stump = new path()
	stump.can_be_disabled = TRUE
	ADD_TRAIT(stump, TRAIT_PARALYSIS, STUMP_TRAIT)
	stump.update_disabled()
	stump.bodypart_flags = NONE
	stump.is_stump = TRUE

	stump.bleed_overlay_icon = null
	stump.max_damage = max_damage
	stump.icon = null
	stump.icon_static = null
	stump.icon_greyscale = null
	stump.icon_state = null
	stump.body_zone = body_zone
	stump.bodytype = bodytype
	stump.body_part = body_part
	stump.dismemberable = FALSE
	stump.amputation_point = amputation_point


	stump.name = "stump of \a [name]"
	stump.artery_name = "mangled [artery_name]"
	return stump


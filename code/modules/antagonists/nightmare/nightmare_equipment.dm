/**
 * An armblade that instantly snuffs out lights
 */
/obj/item/light_eater
	name = "light eater" //as opposed to heavy eater
	icon = 'icons/obj/changeling_items.dmi'
	icon_state = "arm_blade"
	inhand_icon_state = "arm_blade"
	force = 25
	armor_penetration = 35
	lefthand_file = 'icons/mob/inhands/antag/changeling_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/antag/changeling_righthand.dmi'
	item_flags = ABSTRACT | DROPDEL | ACID_PROOF
	w_class = WEIGHT_CLASS_HUGE
	sharpness = SHARP_EDGED
	tool_behaviour = TOOL_MINING
	hitsound = 'sound/weapons/bladeslice.ogg'

/obj/item/light_eater/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, HAND_REPLACEMENT_TRAIT)
	AddComponent(/datum/component/butchering, 80, 70)
	AddComponent(/datum/component/light_eater)

/datum/augment_item/organ
	category = AUGMENT_CATEGORY_ORGANS

/datum/augment_item/organ/apply_to_human(mob/living/carbon/human/H)
	if(istype(H, /mob/living/carbon/human/dummy))
		return
	var/obj/item/organ/new_organ = new path()
	new_organ.Insert(H,TRUE,FALSE)

//HEARTS
/datum/augment_item/organ/heart
	slot = AUGMENT_SLOT_HEART

/datum/augment_item/organ/heart/cybernetic
	name = "Cybernetic heart"
	path = /obj/item/organ/heart/cybernetic

/datum/augment_item/organ/heart/can_apply_to_species(datum/species/S)
	return !(NOBLOOD in S.species_traits)

//LUNGS
/datum/augment_item/organ/lungs
	slot = AUGMENT_SLOT_LUNGS

/datum/augment_item/organ/lungs/cybernetic
	name = "Cybernetic lungs"
	path = /obj/item/organ/lungs/cybernetic

/datum/augment_item/organ/lungs/can_apply_to_species(datum/species/S)
	return !(TRAIT_NOBREATH in S.inherent_traits)

//LIVERS
/datum/augment_item/organ/liver
	slot = AUGMENT_SLOT_LIVER

/datum/augment_item/organ/liver/cybernetic
	name = "Cybernetic liver"
	path = /obj/item/organ/liver/cybernetic

/datum/augment_item/organ/liver/can_apply_to_species(datum/species/S)
	return !(TRAIT_NOMETABOLISM in S.inherent_traits)

//STOMACHES
/datum/augment_item/organ/stomach
	slot = AUGMENT_SLOT_STOMACH

/datum/augment_item/organ/stomach/cybernetic
	name = "Cybernetic stomach"
	path = /obj/item/organ/stomach/cybernetic

/datum/augment_item/organ/stomach/can_apply_to_species(datum/species/S)
	return !(TRAIT_NOHUNGER in S.inherent_traits)

//EYES
/datum/augment_item/organ/eyes
	slot = AUGMENT_SLOT_EYES

/datum/augment_item/organ/eyes/cybernetic
	name = "Cybernetic eyes"
	path = /obj/item/organ/eyes/robotic

//TONGUES
/datum/augment_item/organ/tongue
	slot = AUGMENT_SLOT_TONGUE

/datum/augment_item/organ/tongue/normal
	name = "Organic tongue"
	path = /obj/item/organ/tongue

/datum/augment_item/organ/tongue/robo
	name = "Robotic voicebox"
	path = /obj/item/organ/tongue/robot

/datum/augment_item/organ/tongue/forked
	name = "Forked tongue"
	path = /obj/item/organ/tongue/lizard

/datum/reagent/ichor
	name = "Ichor"
	description = "The blood of gods."
	color = "#ffe346"
	taste_description = "vomit"
	taste_mult = 2
	harmful = TRUE

/datum/reagent/ichor/affect_blood(mob/living/carbon/C, removed)
	C.adjustToxLoss(2 * removed, updating_health = FALSE)
	return TRUE

/datum/reagent/tincture
	abstract_type = /datum/reagent/tincture
	name = "Tincture"
	ingest_met = 1

/datum/reagent/tincture/proc/get_effectiveness_mod()
	var/potency = data?["potency"]
	if(isnull(potency))
		return 0.2

	return round(potency / POTENCY_SCALE_AT_100, 0.1)

/datum/reagent/tincture/woundseal
	name = "Woundseal"
	description = "An herbal tincture for mending wounds."
	color = "#310505"
	taste_description = "sickly sweetness"
	taste_mult = 2

/datum/reagent/tincture/woundseal/affect_ingest(mob/living/carbon/C, removed)
	var/effectiveness = get_effectiveness_mod()
	C.adjustBloodVolume(-0.5 * effectiveness * removed)
	. = C.adjustBruteLoss(-2 * effectiveness * removed, updating_health = FALSE)
	return ..() || .


/datum/reagent/medicine/antihol
	name = "Antihol"
	description = "Purges alcoholic substance from the patient's body and eliminates its side effects."
	color = "#00B4C8"
	taste_description = "raw egg"

/datum/reagent/medicine/antihol/affect_blood(mob/living/carbon/C, removed)
	C.remove_status_effect(/datum/status_effect/dizziness)
	C.set_drowsyness(0)
	C.remove_status_effect(/datum/status_effect/speech/slurring/drunk)
	C.remove_status_effect(/datum/status_effect/confusion)
	holder.remove_reagent(/datum/reagent/consumable/ethanol, 3 * removed, include_subtypes = TRUE)
	var/obj/item/organ/stomach = C.getorganslot(ORGAN_SLOT_STOMACH)
	if(stomach)
		stomach.reagents.remove_reagent(/datum/reagent/consumable/ethanol, 3 * removed, include_subtypes = TRUE)
	C.adjustToxLoss(-0.2 * removed, 0)
	C.adjust_drunk_effect(-10 * removed)
	. = TRUE

/datum/reagent/medicine/strange_reagent
	name = "Strange Reagent"
	description = "A miracle drug capable of bringing the dead back to life. Works topically unless anotamically complex, in which case works orally. Only works if the target has less than 200 total brute and burn damage and hasn't been husked and requires more reagent depending on damage inflicted. Causes damage to the living."
	reagent_state = LIQUID
	color = "#A0E85E"
	metabolization_rate = 0.25
	taste_description = "magnets"
	harmful = TRUE

// FEED ME SEYMOUR
/datum/reagent/medicine/strange_reagent/on_hydroponics_apply(datum/plant_tick/plant_tick, datum/reagents/chems, volume, obj/machinery/hydroponics/mytray, mob/user)
	. = ..()
	if(chems.has_reagent(type, 1))
		mytray.spawnplant()

/datum/reagent/medicine/strange_reagent/expose_mob(mob/living/exposed_mob, reac_volume, exposed_temperature = T20C, datum/reagents/source, methods=TOUCH, show_message = TRUE, touch_protection = 0)
	if(exposed_mob.stat != DEAD)
		return ..()
	if(exposed_mob.suiciding) //they are never coming back
		exposed_mob.visible_message(span_warning("[exposed_mob]'s body does not react..."))
		return
	if(iscarbon(exposed_mob) && !(methods & INGEST)) //simplemobs can still be splashed
		return ..()
	var/amount_to_revive = round((exposed_mob.getBruteLoss()+exposed_mob.getFireLoss())/20)
	if(exposed_mob.getBruteLoss()+exposed_mob.getFireLoss() >= 200 || HAS_TRAIT(exposed_mob, TRAIT_HUSK) || reac_volume < amount_to_revive) //body will die from brute+burn on revive or you haven't provided enough to revive.
		exposed_mob.visible_message(span_warning("[exposed_mob]'s body convulses a bit, and then falls still once more."))
		exposed_mob.do_jitter_animation(10)
		return
	exposed_mob.visible_message(span_warning("[exposed_mob]'s body starts convulsing!"))
	exposed_mob.notify_ghost_revival("Your body is being revived with Strange Reagent!")
	exposed_mob.do_jitter_animation(10)
	var/excess_healing = 5*(reac_volume-amount_to_revive) //excess reagent will heal blood and organs across the board
	addtimer(CALLBACK(exposed_mob, TYPE_PROC_REF(/mob/living/carbon, do_jitter_animation), 10), 40) //jitter immediately, then again after 4 and 8 seconds
	addtimer(CALLBACK(exposed_mob, TYPE_PROC_REF(/mob/living/carbon, do_jitter_animation), 10), 80)
	addtimer(CALLBACK(exposed_mob, TYPE_PROC_REF(/mob/living, revive), FALSE, FALSE, excess_healing), 79)
	return ..()

/datum/reagent/medicine/strange_reagent/affect_blood(mob/living/carbon/C, removed)
	var/damage_at_random = rand(0, 250)/100 //0 to 2.5
	C.adjustBruteLoss(damage_at_random * removed, FALSE)
	C.adjustFireLoss(damage_at_random * removed, FALSE)
	. = TRUE

/datum/reagent/medicine/strange_reagent/affect_touch(mob/living/carbon/C, removed)
	holder.del_reagent(type)

/datum/reagent/medicine/silver_sulfadiazine
	name = "Silver Sulfadiazine"
	description = "This antibacterial compound is used to treat burn victims."
	reagent_state = LIQUID
	color = "#F0DC00"
	touch_met = 1
	harmful = TRUE
	taste_description = "burn cream"

	var/heal_per_unit = 1.2

/datum/reagent/medicine/silver_sulfadiazine/expose_mob(mob/living/exposed_mob, reac_volume, exposed_temperature, datum/reagents/source, methods, show_message, touch_protection)
	. = ..()

	if(!(methods & TOUCH))
		return

	exposed_mob.heal_overall_damage(burn = heal_per_unit * reac_volume, required_status = BODYTYPE_ORGANIC)

/datum/reagent/medicine/silver_sulfadiazine/affect_blood(mob/living/carbon/C, removed)
	C.adjustToxLoss(0.5 * removed, FALSE)
	return TRUE

/datum/reagent/medicine/silver_sulfadiazine/affect_touch(mob/living/carbon/C, removed)
	C.heal_overall_damage(burn = heal_per_unit * removed, required_status = BODYTYPE_ORGANIC)
	return TRUE

/datum/reagent/medicine/styptic_powder
	name = "Styptic Powder"
	description = "Styptic (aluminum sulfate) powder helps control bleeding and heal physical wounds."
	reagent_state = LIQUID
	color = "#FF9696"
	touch_met = 1
	harmful = TRUE
	taste_description = "wound cream"

	var/heal_per_unit = 1.2

/datum/reagent/medicine/styptic_powder/expose_mob(mob/living/exposed_mob, reac_volume, exposed_temperature, datum/reagents/source, methods, show_message, touch_protection)
	. = ..()

	if(!(methods & TOUCH))
		return

	exposed_mob.heal_overall_damage(heal_per_unit * reac_volume, required_status = BODYTYPE_ORGANIC)

	if(ishuman(exposed_mob))
		var/mob/living/carbon/human/H = exposed_mob
		H.notify_pain(1, "Your flesh burns.", TRUE)

/datum/reagent/medicine/styptic_powder/affect_blood(mob/living/carbon/C, removed)
	C.adjustToxLoss(0.5 * removed, FALSE)
	return TRUE

/datum/reagent/medicine/styptic_powder/affect_touch(mob/living/carbon/C, removed)
	C.heal_overall_damage(heal_per_unit * removed, required_status = BODYTYPE_ORGANIC)
	APPLY_CHEM_EFFECT(C, CE_ANTICOAGULANT, -1)
	return TRUE

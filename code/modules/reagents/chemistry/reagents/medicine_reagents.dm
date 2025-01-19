

//////////////////////////////////////////////////////////////////////////////////////////
					// MEDICINE REAGENTS
//////////////////////////////////////////////////////////////////////////////////////

// where all the reagents related to medicine go.

/datum/reagent/medicine
	taste_description = "bitterness"
	chemical_flags = REAGENT_IGNORE_MOB_SIZE
	abstract_type = /datum/reagent/medicine

/datum/reagent/medicine/adminordrazine //An OP chemical for admins
	name = "Adminordrazine"
	description = "It's magic. We don't have to explain it."
	color = "#E0BB00" //golden for the gods
	taste_description = "badmins"
	chemical_flags = REAGENT_IGNORE_MOB_SIZE | REAGENT_SPECIAL | REAGENT_DEAD_PROCESS
	metabolization_rate = 1

// The best stuff there is. For testing/debugging.
/datum/reagent/medicine/adminordrazine/on_hydroponics_apply(datum/plant_tick/plant_tick, datum/reagents/chems, volume, obj/machinery/hydroponics/mytray, mob/user)
	if(volume >= 1)
		plant_tick.plant_health_delta += 2
		plant_tick.plant_growth_delta += 2

/datum/reagent/medicine/adminordrazine/affect_blood(mob/living/carbon/C, removed)
	C.heal_bodypart_damage(2 * removed, 2 * removed, FALSE)
	C.adjustToxLoss(-2 * removed, FALSE, TRUE)
	C.setOxyLoss(0, 0)
	C.setCloneLoss(0, 0)

	C.set_blurriness(0)
	C.set_blindness(0)
	C.SetKnockdown(0)
	C.SetStun(0)
	C.SetUnconscious(0)
	C.SetParalyzed(0)
	C.SetImmobilized(0)
	C.remove_status_effect(/datum/status_effect/confusion)
	C.SetSleeping(0)

	C.silent = FALSE
	C.remove_status_effect(/datum/status_effect/dizziness)
	C.disgust = 0
	C.set_drowsyness(0)

	// Remove all speech related status effects
	for(var/effect in typesof(/datum/status_effect/speech))
		C.remove_status_effect(effect)
	C.remove_status_effect(/datum/status_effect/jitter)
	C.hallucination = 0
	REMOVE_TRAITS_NOT_IN(C, list(SPECIES_TRAIT, ROUNDSTART_TRAIT, ORGAN_TRAIT))
	C.reagents.remove_reagent(/datum/reagent/toxin, 2 * removed, include_subtypes = TRUE)
	if(C.blood_volume < BLOOD_VOLUME_NORMAL)
		C.setBloodVolume(BLOOD_VOLUME_NORMAL)

	C.cure_all_traumas(TRAUMA_RESILIENCE_MAGIC)
	for(var/obj/item/organ/organ as anything in C.processing_organs)
		organ.setOrganDamage(0)
	for(var/thing in C.diseases)
		var/datum/pathogen/D = thing
		if(D.severity == PATHOGEN_SEVERITY_POSITIVE)
			continue
		D.force_cure()
	. = TRUE

/datum/reagent/medicine/adminordrazine/quantum_heal
	name = "Quantum Medicine"
	description = "Rare and experimental particles, that apparently swap the user's body with one from an alternate dimension where it's completely healthy."
	taste_description = "science"

/* General medicine */

/datum/reagent/medicine/inaprovaline
	name = "Inaprovaline"
	description = "Inaprovaline is a multipurpose neurostimulant and cardioregulator. Commonly used to stabilize patients."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#00bfff"
	overdose_threshold = 60
	metabolization_rate = 0.1
	value = 3.5

/datum/reagent/medicine/inaprovaline/on_mob_metabolize(mob/living/carbon/C, class)
	if(class == CHEM_BLOOD)
		ADD_TRAIT(C, TRAIT_NOCRITDAMAGE, type)
		ADD_TRAIT(C, TRAIT_STABLEHEART, type)

/datum/reagent/medicine/inaprovaline/on_mob_end_metabolize(mob/living/carbon/C, class)
	if(class == CHEM_BLOOD)
		REMOVE_TRAIT(C, TRAIT_NOCRITDAMAGE, type)
		REMOVE_TRAIT(C, TRAIT_STABLEHEART, type)

/datum/reagent/medicine/inaprovaline/affect_blood(mob/living/carbon/C, removed)
	APPLY_CHEM_EFFECT(C, CE_STABLE, 1)
	APPLY_CHEM_EFFECT(C, CE_PAINKILLER, 30)

/datum/reagent/medicine/inaprovaline/overdose_start(mob/living/carbon/C)
	C.add_movespeed_modifier(/datum/movespeed_modifier/inaprovaline)

/datum/reagent/medicine/inaprovaline/overdose_end(mob/living/carbon/C)
	C.remove_movespeed_modifier(/datum/movespeed_modifier/inaprovaline)

/datum/reagent/medicine/inaprovaline/overdose_process(mob/living/carbon/C)
	. = ..()
	if(prob(5))
		C.set_slurring_if_lower(10 SECONDS)
	if(prob(2))
		C.drowsyness = max(C.drowsyness, 5)

/datum/reagent/medicine/bicaridine
	name = "Bicaridine"
	description = "Bicaridine is a slow-acting medication to treat physical trauma."
	taste_description = "bitterness"
	taste_mult = 3
	metabolization_rate = 0.1
	reagent_state = LIQUID
	color = "#bf0000"
	overdose_threshold = 30
	value = 4.9

/datum/reagent/medicine/bicaridine/affect_blood(mob/living/carbon/C, removed)
	APPLY_CHEM_EFFECT(C, CE_PAINKILLER, 20)
	C.adjustBruteLoss(-6 * removed, updating_health = FALSE)
	return TRUE

/datum/reagent/medicine/bicaridine/overdose_process(mob/living/M)
	. = ..()
	APPLY_CHEM_EFFECT(M, CE_BLOCKAGE, (15 + volume - overdose_threshold)/100)
	var/mob/living/carbon/human/H = M
	for(var/obj/item/bodypart/E as anything in H.bodyparts)
		if((E.bodypart_flags & BP_ARTERY_CUT) && prob(2))
			E.set_sever_artery(FALSE)

/datum/reagent/medicine/meralyne
	name = "Meralyne"
	description = "Meralyne is a concentrated form of bicaridine and can be used to treat extensive physical trauma."
	color = "#FD5964"
	taste_mult = 12
	metabolization_rate = 0.4
	overdose_threshold = 20

/datum/reagent/medicine/meralyne/affect_blood(mob/living/carbon/C, removed)
	C.adjustBruteLoss(-12 * removed, updating_health = FALSE)
	return TRUE

/datum/reagent/medicine/meralyne/overdose_process(mob/living/carbon/C)
	. = ..()
	APPLY_CHEM_EFFECT(C, CE_BLOCKAGE, (15 + volume - overdose_threshold)/100)
	for(var/obj/item/bodypart/E as anything in C.bodyparts)
		if((E.bodypart_flags & BP_ARTERY_CUT) && prob(2))
			E.set_sever_artery(FALSE)
	C.losebreath++

/datum/reagent/medicine/kelotane
	name = "Kelotane"
	description = "Kelotane is a drug used to treat burns."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#ffa800"
	overdose_threshold = 30
	metabolization_rate = 0.1
	value = 2.9

/datum/reagent/medicine/kelotane/affect_blood(mob/living/carbon/C, removed)
	C.adjustFireLoss(-6 * removed, updating_health = FALSE)
	return TRUE

/datum/reagent/medicine/dermaline
	name = "Dermaline"
	description = "Dermaline is the next step in burn medication. Works twice as good as kelotane and enables the body to restore even the direst heat-damaged tissue."
	taste_description = "bitterness"
	taste_mult = 1.5
	reagent_state = LIQUID
	color = "#ff8000"
	metabolization_rate = 0.4
	overdose_threshold = 20
	value = 3.9

/datum/reagent/medicine/dermaline/affect_blood(mob/living/carbon/C, removed)
	C.adjustFireLoss(-12 * removed, updating_health = FALSE)
	return TRUE

/datum/reagent/medicine/dexalin
	name = "Dexalin"
	description = "Dexalin is used in the treatment of oxygen deprivation."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#0080ff"
	metabolization_rate = 0.5
	overdose_threshold = 30
	value = 2.4

/datum/reagent/medicine/dexalin/affect_blood(mob/living/carbon/C, removed)
	APPLY_CHEM_EFFECT(C, CE_OXYGENATED, 1)
	C.adjustOxyLoss(-10 * removed, FALSE)
	holder.remove_reagent(/datum/reagent/toxin/lexorin, 10 * removed)
	return TRUE

/datum/reagent/medicine/tricordrazine
	name = "Tricordrazine"
	description = "Tricordrazine is an extended release medicine, originally derived from cordrazine. Can be used to treat a wide range of injuries."
	taste_description = "grossness"
	reagent_state = LIQUID
	color = "#8040ff"
	value = 6

/datum/reagent/medicine/tricordrazine/affect_blood(mob/living/carbon/C, removed)
	var/heal = (1 + clamp(floor(current_cycle / 25), 0, 5)) * removed
	C.heal_overall_damage(heal, heal, updating_health = FALSE)
	C.adjustToxLoss(-heal, FALSE)
	return TRUE

/datum/reagent/medicine/tricordrazine/godblood
	name = "God's Blood"
	description = "Slowly heals all wounds, while being almost impossible to overdose on."
	overdose_threshold = 0

/datum/reagent/medicine/tricordrazine/godblood/affect_blood(mob/living/carbon/C, removed)
	C.heal_overall_damage(0.5 * removed, 0.5 * removed, updating_health = FALSE)
	C.adjustToxLoss(-0.5 * removed, FALSE)
	return TRUE

/datum/reagent/medicine/omnizine
	name = "Omnizine"
	description = "A quickly metabolizing miracle drug that mends all wounds at a rapid pace."
	reagent_state = LIQUID
	color = "#DCDCDC"
	metabolization_rate = 1
	overdose_threshold = 30

/datum/reagent/medicine/omnizine/affect_blood(mob/living/carbon/C, removed)
	C.heal_overall_damage(12 * removed, 12 * removed, updating_health = FALSE)
	C.adjustToxLoss(-12 * removed, FALSE)
	return TRUE

/datum/reagent/medicine/cryoxadone
	name = "Cryoxadone"
	description = "A chemical mixture with almost magical healing powers. Its main limitation is that the targets body temperature must be under 170K for it to metabolise correctly."
	taste_description = "sludge"
	reagent_state = LIQUID
	color = "#8080ff"
	metabolization_rate = 0.1
	value = 3.9

/datum/reagent/medicine/cryoxadone/affect_blood(mob/living/carbon/C, removed)
	APPLY_CHEM_EFFECT(C, CE_CRYO, 1)
	if(!(C.bodytemperature < TCRYO))
		return

	C.adjustCloneLoss(-100 * removed, FALSE)
	APPLY_CHEM_EFFECT(C, CE_OXYGENATED, 1)
	C.heal_overall_damage(30 * removed, 30 * removed, updating_health = FALSE)
	APPLY_CHEM_EFFECT(C, CE_PULSE, -2)
	for(var/obj/item/organ/I as anything in C.processing_organs)
		if(!(I.organ_flags & ORGAN_SYNTHETIC))
			I.applyOrganDamage(-20*removed)
	return TRUE


/datum/reagent/medicine/clonexadone
	name = "Clonexadone"
	description = "A liquid compound similar to that used in the cloning process. Can be used to 'finish' the cloning process when used in conjunction with a cryo tube."
	taste_description = "slime"
	reagent_state = LIQUID
	color = "#80bfff"
	metabolization_rate = 0.1
	value = 5.5

/datum/reagent/medicine/clonexadone/affect_blood(mob/living/carbon/C, removed)
	APPLY_CHEM_EFFECT(C, CE_CRYO, 1)
	if(C.bodytemperature < 170)
		C.adjustCloneLoss(-300 * removed, FALSE)
		APPLY_CHEM_EFFECT(C, CE_OXYGENATED, 2)
		C.heal_overall_damage(50 * removed, 50 * removed, updating_health = FALSE)
		APPLY_CHEM_EFFECT(C, CE_PULSE, -2)
		for(var/obj/item/organ/I as anything in C.processing_organs)
			if(!(I.organ_flags & ORGAN_SYNTHETIC))
				I.applyOrganDamage(-30*removed)
		return TRUE

/* Painkillers */

/datum/reagent/medicine/tramadol
	name = "Tramadol"
	description = "A simple, yet effective painkiller. Don't mix with alcohol."
	taste_description = "sourness"
	reagent_state = LIQUID
	color = "#cb68fc"
	overdose_threshold = 30
	metabolization_rate = 0.05
	ingest_met = 0.02
	value = 3.1
	var/pain_power = 40 //magnitide of painkilling effect
	var/effective_cycle = 10 //how many cycles it need to process to reach max power

/datum/reagent/medicine/tramadol/affect_blood(mob/living/carbon/C, removed)
	var/effectiveness = volume

	if(current_cycle < effective_cycle)
		effectiveness = volume * current_cycle/effective_cycle

	APPLY_CHEM_EFFECT(C, CE_PAINKILLER, pain_power * effectiveness)

	if(volume > overdose_threshold)
		C.add_movespeed_modifier(/datum/movespeed_modifier/tramadol)
		C.set_slurring_if_lower(60 SECONDS)
		if(prob(1))
			C.Knockdown(2 SECONDS)
			C.drowsyness = max(C.drowsyness, 5)

	else if(volume > 0.75 * overdose_threshold)
		C.add_movespeed_modifier(/datum/movespeed_modifier/tramadol)
		if(prob(5))
			C.set_slurring_if_lower(40 SECONDS)

	else if(volume > 0.5 * overdose_threshold)
		C.add_movespeed_modifier(/datum/movespeed_modifier/tramadol)
		if(prob(1))
			C.set_slurring_if_lower(20 SECONDS)

	else
		C.remove_movespeed_modifier(/datum/movespeed_modifier/tramadol)

	var/boozed = how_boozed(C)
	if(boozed)
		APPLY_CHEM_EFFECT(C, CE_ALCOHOL_TOXIC, 1)
		APPLY_CHEM_EFFECT(C, CE_BREATHLOSS, 0.1 * boozed) //drinking and opiating makes breathing kinda hard

/datum/reagent/medicine/tramadol/on_mob_end_metabolize(mob/living/carbon/C, class)
	if(class != CHEM_BLOOD)
		return
	C.remove_movespeed_modifier(/datum/movespeed_modifier/tramadol)

/datum/reagent/medicine/tramadol/overdose_process(mob/living/carbon/C)
	C.set_timed_status_effect(20 SECONDS, /datum/status_effect/drugginess, only_if_higher = TRUE)
	APPLY_CHEM_EFFECT(C, CE_PAINKILLER, pain_power*0.5) //extra painkilling for extra trouble
	APPLY_CHEM_EFFECT(C, CE_BREATHLOSS, 0.6) //Have trouble breathing, need more air
	if(how_boozed(C))
		APPLY_CHEM_EFFECT(C, CE_BREATHLOSS, 0.2) //Don't drink and OD on opiates folks

/datum/reagent/medicine/tramadol/proc/how_boozed(mob/living/carbon/C)
	. = 0
	var/datum/reagents/ingested = C.get_ingested_reagents()
	if(!ingested)
		return
	var/list/pool = C.reagents.reagent_list | ingested.reagent_list
	for(var/datum/reagent/consumable/ethanol/booze in pool)
		if(booze.volume < 2) //let them experience false security at first
			continue
		. = 1
		if(booze.boozepwr >= 65) //liquor stuff hits harder
			return 2

/datum/reagent/medicine/tramadol/oxycodone
	name = "Oxycodone"
	description = "An effective and very addictive painkiller. Don't mix with alcohol."
	taste_description = "bitterness"
	color = "#800080"
	overdose_threshold = 20
	pain_power = 200
	effective_cycle = 2
	addiction_types = list(/datum/addiction/opiods = 10)

/datum/reagent/medicine/morphine
	name = "Morphine"
	description = "A painkiller that allows the patient to move at full speed even when injured. Causes drowsiness and eventually unconsciousness in high doses. Overdose will cause a variety of effects, ranging from minor to lethal."
	reagent_state = LIQUID
	color = "#A9FBFB"
	metabolization_rate = 0.1
	overdose_threshold = 30
	addiction_types = list(/datum/addiction/opiods = 10)

/datum/reagent/medicine/morphine/on_mob_metabolize(mob/living/carbon/C, class)
	if(class != CHEM_BLOOD)
		return
	C.add_movespeed_modifier(/datum/movespeed_modifier/morphine)

/datum/reagent/medicine/morphine/on_mob_end_metabolize(mob/living/carbon/C, class)
	if(class != CHEM_BLOOD)
		return
	C.remove_movespeed_modifier(/datum/movespeed_modifier/morphine)

/datum/reagent/medicine/morphine/affect_blood(mob/living/carbon/C, removed)
	APPLY_CHEM_EFFECT(C, CE_PAINKILLER, 120)
	C.set_timed_status_effect(4 SECONDS, /datum/status_effect/dizziness, only_if_higher = TRUE)
	if(prob(75))
		C.drowsyness++
	if(prob(25))
		C.adjust_confusion(2 SECONDS)

/datum/reagent/medicine/morphine/overdose_process(mob/living/carbon/C)
	C.set_timed_status_effect(4 SECONDS, /datum/status_effect/drugginess, only_if_higher = TRUE)
	APPLY_CHEM_EFFECT(C, CE_PAINKILLER, 50)

/datum/reagent/medicine/tramadol/oxycodone
	name = "Oxycodone"
	description = "An extremely effective and very addictive painkiller. Don't mix with alcohol."
	taste_description = "bitterness"
	color = "#800080"
	overdose_threshold = 20
	pain_power = 200
	effective_cycle = 2
	addiction_types = list(/datum/addiction/opiods = 20)

/datum/reagent/medicine/tramadol/oxycodone/on_mob_end_metabolize(mob/living/carbon/C, class)
	if(class != CHEM_BLOOD)
		return
	C.stamina.adjust(-INFINITY)
	to_chat(C, span_userdanger("Stinging pain shoots through your body!"))

/* Other medicine */
/datum/reagent/medicine/synaptizine
	name = "Synaptizine"
	description = "Synaptizine is used to treat various diseases."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#99ccff"
	metabolization_rate = 0.01
	overdose_threshold = 5
	value = 4.6

/datum/reagent/medicine/synaptizine/affect_blood(mob/living/carbon/C, removed)
	C.drowsyness = max(C.drowsyness - 5, 0)
	C.AdjustAllImmobility(-2 SECONDS * removed)

	holder.remove_reagent(/datum/reagent/toxin/mindbreaker, 5)

	C.adjustToxLoss(3 * removed, updating_health = FALSE, cause_of_death = "Synaptizine") // It used to be incredibly deadly due to an oversight. Not anymore!
	APPLY_CHEM_EFFECT(C, CE_PAINKILLER, 70)
	APPLY_CHEM_EFFECT(C, CE_STIMULANT, 10)
	return TRUE

/datum/reagent/medicine/dylovene
	name = "Dylovene"
	description = "Dylovene is a broad-spectrum antitoxin used to neutralize poisons before they can do significant harm."
	taste_description = "a roll of gauze"
	color = "#dadd98"
	metabolization_rate = 0.2

/datum/reagent/medicine/dylovene/affect_blood(mob/living/carbon/C, removed)
	C.adjust_drowsyness(-6 * removed)
	SET_CHEM_EFFECT_IF_LOWER(C, CE_ANTITOX, 1)

	var/removing = (4 * removed)
	var/datum/reagents/ingested = C.get_ingested_reagents()

	for(var/datum/reagent/R in ingested.reagent_list)
		if(istype(R, /datum/reagent/toxin))
			ingested.remove_reagent(R.type, removing)
			return

	for(var/datum/reagent/R in C.reagents.reagent_list)
		if(istype(R, /datum/reagent/toxin))
			C.reagents.remove_reagent(R.type, removing)
			return

/datum/reagent/medicine/alkysine
	name = "Alkysine"
	description = "Alkysine is a drug used to lessen the damage to neurological tissue after a injury. Can aid in healing brain tissue."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#ffff66"
	metabolization_rate = 0.05
	overdose_threshold = 30
	value = 5.9

/datum/reagent/medicine/alkysine/affect_blood(mob/living/carbon/C, removed)
	APPLY_CHEM_EFFECT(C, CE_PAINKILLER, 30)
	APPLY_CHEM_EFFECT(C, CE_BRAIN_REGEN, 1)
	C.adjustOrganLoss(ORGAN_SLOT_BRAIN, -10 * removed, updating_health = FALSE)
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		H.adjust_confusion(2 SECONDS)
		H.drowsyness++

	if(prob(10))
		C.cure_trauma_type(resilience = TRAUMA_RESILIENCE_BASIC)
	return TRUE

/datum/reagent/medicine/imidazoline
	name = "Imidazoline"
	description = "Heals eye damage"
	taste_description = "dull toxin"
	reagent_state = LIQUID
	color = "#c8a5dc"
	overdose_threshold = 30
	metabolization_rate = 0.4
	value = 4.2

/datum/reagent/medicine/imidazoline/affect_blood(mob/living/carbon/C, removed)
	C.eye_blurry = max(C.eye_blurry - 5, 0)
	C.eye_blind = max(C.eye_blind - 5, 0)
	C.adjustOrganLoss(ORGAN_SLOT_EYES, -5 * removed, updating_health = FALSE)
	return TRUE

/datum/reagent/medicine/peridaxon
	name = "Peridaxon"
	description = "Used to encourage recovery of internal organs and nervous systems. Medicate cautiously."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#561ec3"
	metabolization_rate = 0.1
	overdose_threshold =10
	value = 6

/datum/reagent/medicine/peridaxon/affect_blood(mob/living/carbon/C, removed)
	if(!ishuman(C))
		return

	var/mob/living/carbon/human/H = C
	for(var/obj/item/organ/I as anything in H.processing_organs)
		if(!(I.organ_flags & ORGAN_SYNTHETIC))
			if(istype(I, /obj/item/organ/brain))
				// if we have located an organic brain, apply side effects
				H.adjust_confusion(2 SECONDS)
				H.drowsyness++
				// peridaxon only heals minor brain damage
				if(I.damage >= I.maxHealth * 0.75)
					continue
			I.applyOrganDamage(-3 * removed, updating_health = FALSE)
	return TRUE

/datum/reagent/medicine/hyperzine
	name = "Hyperzine"
	description = "Hyperzine is a highly effective, long lasting, muscle stimulant."
	taste_description = "acid"
	reagent_state = LIQUID
	color = "#ff3300"
	metabolization_rate = 0.03
	overdose_threshold = 15
	value = 3.9

/datum/reagent/medicine/hyperzine/on_mob_metabolize(mob/living/carbon/C, class)
	if(class != CHEM_BLOOD)
		return
	ADD_TRAIT(C, TRAIT_HYPERZINE, CHEM_TRAIT_SOURCE(class))
	C.add_movespeed_modifier(/datum/movespeed_modifier/hyperzine)

/datum/reagent/medicine/hyperzine/on_mob_end_metabolize(mob/living/carbon/C, class)
	if(class != CHEM_BLOOD)
		return
	REMOVE_TRAIT(C, TRAIT_HYPERZINE, CHEM_TRAIT_SOURCE(class))
	if(!HAS_TRAIT(C, TRAIT_HYPERZINE))
		C.remove_movespeed_modifier(/datum/movespeed_modifier/hyperzine)

/datum/reagent/medicine/hyperzine/affect_blood(mob/living/carbon/C, removed)
	if(prob(5))
		spawn(-1)
			C.emote(pick("twitch", "blink_r", "shiver"))
	APPLY_CHEM_EFFECT(C, CE_PULSE, 3)
	APPLY_CHEM_EFFECT(C, CE_STIMULANT, 4)

/datum/reagent/medicine/coagulant
	name = "Coagulant"
	description = "A coagulant capable of staunching both internal and external bleeding."
	taste_description = "iron"
	reagent_state = LIQUID
	color = "#bf0000"
	metabolization_rate = 0.01

/datum/reagent/medicine/coagulant/affect_blood(mob/living/carbon/M, removed)
	if(!ishuman(M))
		return

	APPLY_CHEM_EFFECT(M, CE_ANTICOAGULANT, -1)

	for(var/obj/item/bodypart/BP as anything in M.bodyparts)
		if((BP.bodypart_flags & BP_ARTERY_CUT) && prob(2))
			BP.set_sever_artery(FALSE)

		for(var/datum/wound/W as anything in BP.wounds)
			if(W.bleeding() && prob(10))
				W.bleed_timer = 0
				W.clamp_wound()

/datum/reagent/medicine/coagulant/overdose_process(mob/living/carbon/C)
	APPLY_CHEM_EFFECT(C, CE_BLOCKAGE, 1)

/datum/reagent/medicine/epinephrine
	name = "Epinephrine"
	description = "Adrenaline is a hormone used as a drug to treat cardiac arrest, and as a performance enhancer."
	taste_description = "rush"
	reagent_state = LIQUID
	color = "#c8a5dc"
	overdose_threshold = 20
	metabolization_rate = 0.1
	value = 2

/datum/reagent/medicine/epinephrine/on_mob_metabolize(mob/living/carbon/C, class)
	if(class == CHEM_BLOOD)
		ADD_TRAIT(C, TRAIT_NOCRITDAMAGE, CHEM_TRAIT_SOURCE(class))
		ADD_TRAIT(C, TRAIT_NOSOFTCRIT,CHEM_TRAIT_SOURCE(class))
		to_chat(C, span_alert("Energy rushes through your veins!"))

/datum/reagent/medicine/epinephrine/on_mob_end_metabolize(mob/living/carbon/C, class)
	if(class == CHEM_BLOOD)
		REMOVE_TRAIT(C, TRAIT_NOCRITDAMAGE, CHEM_TRAIT_SOURCE(class))
		REMOVE_TRAIT(C, TRAIT_NOSOFTCRIT,CHEM_TRAIT_SOURCE(class))

/datum/reagent/medicine/epinephrine/affect_blood(mob/living/carbon/C, removed)
	if(volume < 0.2)	//not that effective after initial rush
		APPLY_CHEM_EFFECT(C, CE_PAINKILLER, min(30*volume, 80))
		APPLY_CHEM_EFFECT(C, CE_PULSE, 1)
	else if(volume < 1)
		APPLY_CHEM_EFFECT(C, CE_PAINKILLER, min(15*volume, 20))
	APPLY_CHEM_EFFECT(C, CE_PULSE, 2)
	APPLY_CHEM_EFFECT(C, CE_STIMULANT, 2)

	if(volume >= 4 && C.undergoing_cardiac_arrest())
		if(C.resuscitate())
			log_health(C, "Resuscitated due to epinephrine.")
			holder.remove_reagent(type, 4)
			var/obj/item/organ/heart = C.getorganslot(ORGAN_SLOT_HEART)
			heart.applyOrganDamage(heart.maxHealth * 0.075)
			to_chat(C, span_userdanger("Adrenaline rushes through your body, you refuse to give up!"))

	if(volume > 10)
		C.set_timed_status_effect(5 SECONDS, /datum/status_effect/dizziness, only_if_higher = TRUE)

	C.AdjustAllImmobility(-2 * removed)

/datum/reagent/medicine/ephedrine
	name = "Ephedrine"
	description = "A powerful stimulant that can be used to power through pain and increase athletic ability."
	reagent_state = LIQUID
	color = "#D2FFFA"
	metabolization_rate = 0.3
	overdose_threshold = 30
	addiction_types = list(/datum/addiction/stimulants = 4) //1.6 per 2 seconds

/datum/reagent/medicine/ephedrine/on_mob_metabolize(mob/living/carbon/C, class)
	if(class != CHEM_BLOOD)
		return
	ADD_TRAIT(C, TRAIT_EPHEDRINE, CHEM_TRAIT_SOURCE(class))
	C.add_movespeed_modifier(/datum/movespeed_modifier/reagent/ephedrine)

/datum/reagent/medicine/ephedrine/on_mob_end_metabolize(mob/living/carbon/C, class)
	if(class != CHEM_BLOOD)
		return
	REMOVE_TRAIT(C, TRAIT_EPHEDRINE, CHEM_TRAIT_SOURCE(class))
	if(!HAS_TRAIT(C, TRAIT_EPHEDRINE))
		C.remove_movespeed_modifier(/datum/movespeed_modifier/reagent/ephedrine)

/datum/reagent/medicine/ephedrine/affect_blood(mob/living/carbon/C, removed)
	. = ..()
	if(prob(20))
		var/obj/item/I = C.get_active_held_item()
		if(I && C.dropItemToGround(I))
			to_chat(C, span_notice("Your hands spaz out and you drop what you were holding!"))
			C.set_timed_status_effect(20 SECONDS, /datum/status_effect/jitter, only_if_higher = TRUE)

	C.AdjustAllImmobility(-20 * removed)
	C.stamina.adjust(1 * removed)
	return TRUE

/datum/reagent/medicine/ryetalyn
	name = "Ryetalyn"
	description = "Ryetalyn can cure all genetic mutations and abnormalities via a catalytic process. Known by the brand name \"Mutadone\"."
	taste_description = "acid"
	reagent_state = SOLID
	color = "#004000"
	overdose_threshold = 30
	value = 3.6
	overdose_threshold = 30

/datum/reagent/medicine/ryetalyn/affect_blood(mob/living/carbon/C, removed)
	C.remove_status_effect(/datum/status_effect/jitter)
	if(C.has_dna())
		C.dna.remove_all_mutations(list(MUT_NORMAL, MUT_EXTRA), TRUE)

/datum/reagent/medicine/infuse_plant(datum/plant/plant_datum, datum/plant_gene_holder/plant_dna, list/damage_ref)
	. = ..()
	if(plant_dna.endurance < 0)
		plant_dna.endurance += 1

	if(plant_dna.potency < 0)
		plant_dna.potency += 1

	if(plant_dna.harvest_amt < 0)
		plant_dna.harvest_amt += 1

	if(plant_dna.harvest_yield < 0)
		plant_dna.harvest_yield += 1

	if(plant_dna.maturation < 0)
		plant_dna.maturation += 1

	if(plant_dna.production < 0)
		plant_dna.production += 1

/datum/reagent/medicine/spaceacillin
	name = "Spaceacillin"
	description = "Spaceacillin will prevent a patient from conventionally spreading any diseases they are currently infected with. Also reduces infection in serious burns."
	color = "#E1F2E6"
	metabolization_rate = 0.02

/datum/reagent/medicine/spaceacillin/affect_blood(mob/living/carbon/C, removed)
	APPLY_CHEM_EFFECT(C, CE_ANTIBIOTIC, volume)

/datum/reagent/medicine/haloperidol
	name = "Haloperidol"
	description = "A powerful antipsychotic and sedative. Will help control psychiatric problems, but may cause brain damage."
	reagent_state = LIQUID
	color = "#27870a"
	metabolization_rate = 0.2
	harmful = TRUE

/datum/reagent/medicine/haloperidol/on_mob_metabolize(mob/living/carbon/C, class)
	if(class != CHEM_BLOOD)
		ADD_TRAIT(C, TRAIT_HALOPERIDOL, CHEM_TRAIT_SOURCE(class))

/datum/reagent/medicine/haloperidol/on_mob_end_metabolize(mob/living/carbon/C, class)
	REMOVE_TRAIT(C, TRAIT_HALOPERIDOL, CHEM_TRAIT_SOURCE(class))

/datum/reagent/medicine/haloperidol/affect_blood(mob/living/carbon/C, removed)
	for(var/datum/reagent/drug/R in C.reagents.reagent_list)
		C.reagents.remove_reagent(R.type, 5 * removed)

	if(C.get_timed_status_effect_duration(/datum/status_effect/jitter) >= 6 SECONDS)
		C.adjust_timed_status_effect(-6 SECONDS * removed, /datum/status_effect/jitter)

	if(C.stat == CONSCIOUS)
		C.adjust_drowsyness(16 * removed, up_to = 180)
	else
		C.adjust_drowsyness((16 * removed) / 5, up_to = 180)

	C.adjust_timed_status_effect(-3 * removed, /datum/status_effect/drugginess)

	if (C.hallucination >= 5)
		C.hallucination -= 5 * removed

	if(prob(20))
		C.adjustOrganLoss(ORGAN_SLOT_BRAIN, 1, 50, updating_health = FALSE)

	if(prob(10))
		spawn(-1)
			C.emote("drool")
	return TRUE

/datum/reagent/medicine/leporazine
	name = "Leporazine"
	description = "Leporazine will effectively regulate a patient's body temperature, ensuring it never leaves safe levels."
	color = "#DB90C6"


/datum/reagent/medicine/leporazine/affect_blood(mob/living/carbon/C, removed)
	var/target_temp = C.get_body_temp_normal(apply_change=FALSE)
	if(C.bodytemperature > target_temp)
		C.adjust_bodytemperature(-40 * TEMPERATURE_DAMAGE_COEFFICIENT * removed, target_temp)
	else if(C.bodytemperature < (target_temp + 1))
		C.adjust_bodytemperature(40 * TEMPERATURE_DAMAGE_COEFFICIENT * removed, 0, target_temp)

	if(ishuman(C))
		var/mob/living/carbon/human/humi = C
		if(humi.coretemperature > target_temp)
			humi.adjust_coretemperature(-40 * TEMPERATURE_DAMAGE_COEFFICIENT * removed, target_temp)
		else if(humi.coretemperature < (target_temp + 1))
			humi.adjust_coretemperature(40 * TEMPERATURE_DAMAGE_COEFFICIENT * removed, 0, target_temp)


/datum/reagent/medicine/potass_iodide
	name = "Potassium Iodide"
	description = "Heals low toxin damage while the patient is irradiated, and will halt the damaging effects of radiation."
	reagent_state = LIQUID
	color = "#BAA15D"
	metabolization_rate = 0.4


/datum/reagent/medicine/potass_iodide/on_mob_metabolize(mob/living/carbon/C, class)
	if(class != CHEM_BLOOD)
		return
	ADD_TRAIT(C, TRAIT_HALT_RADIATION_EFFECTS, CHEM_TRAIT_SOURCE(class))

/datum/reagent/medicine/potass_iodide/on_mob_end_metabolize(mob/living/carbon/C, class)
	REMOVE_TRAIT(C, TRAIT_HALT_RADIATION_EFFECTS, CHEM_TRAIT_SOURCE(class))

/datum/reagent/medicine/potass_iodide/affect_blood(mob/living/carbon/C, removed)
	if (HAS_TRAIT(C, TRAIT_IRRADIATED))
		C.adjustToxLoss(-1 * removed)

/datum/reagent/medicine/saline_glucose
	name = "Saline-Glucose"
	description = "Promotes blood rejuvenation in living creatures."
	reagent_state = LIQUID
	color = "#DCDCDC"
	metabolization_rate = 0.1
	overdose_threshold = 60
	taste_description = "sweetness and salt"
	var/last_added = 0
	var/maximum_reachable = BLOOD_VOLUME_NORMAL - 10 //So that normal blood regeneration can continue with salglu active
	/// In addition to acting as temporary blood, this much blood is fully regenerated per unit used.
	var/extra_regen = 1

/datum/reagent/medicine/saline_glucose/affect_blood(mob/living/carbon/C, removed)
	. = ..()
	if(last_added)
		C.adjustBloodVolume(-last_added)
		last_added = 0

	if(C.blood_volume < maximum_reachable) //Can only up to double your effective blood level.
		var/amount_to_add = min(C.blood_volume, 5*volume)
		last_added = C.adjustBloodVolumeUpTo(amount_to_add + maximum_reachable)
		C.adjustBloodVolume(extra_regen * removed)

/datum/reagent/medicine/synthflesh
	name = "Synthflesh"
	description = "Synthetic flesh that weaves itself into organic creatures. Do not ingest."
	reagent_state = LIQUID
	color = "#FFEBEB"

	touch_met = 1
	metabolization_rate = 0.2
	var/spoke

/datum/reagent/medicine/synthflesh/affect_touch(mob/living/carbon/C, removed)
	if(C.getFireLoss() || C.getBruteLoss())
		if(!spoke)
			to_chat(C, span_notice("Your skin feels cold as the synthetic flesh integrates itself into your wounds."))
			spoke = TRUE
		C.heal_overall_damage(2 * removed, 2 * removed, BODYTYPE_ORGANIC, updating_health = FALSE)
		. = TRUE

	if(HAS_TRAIT_FROM(C, TRAIT_HUSK, BURN) && C.getFireLoss() < UNHUSK_DAMAGE_THRESHOLD && (volume >= SYNTHFLESH_UNHUSK_AMOUNT))
		C.cure_husk(BURN)
		C.visible_message("<span class='nicegreen'>A rubbery liquid coats [C]'s burns.") //we're avoiding using the phrases "burnt flesh" and "burnt skin" here because carbies could be a skeleton or a golem or something

/datum/reagent/medicine/synthflesh/affect_blood(mob/living/carbon/C, removed)
	C.adjustToxLoss(1 * removed, cause_of_death = "Synthflesh poisoning")
	return TRUE

/datum/reagent/medicine/atropine
	name = "Atropine"
	description = "If a patient is in critical condition, rapidly heals all damage types as well as regulating oxygen in the body. Excellent for stabilizing wounded patients."
	reagent_state = LIQUID
	color = "#1D3535" //slightly more blue, like epinephrine
	metabolization_rate = 0.1
	overdose_threshold = 35


/datum/reagent/medicine/atropine/affect_blood(mob/living/carbon/C, removed)
	. = ..()
	if(C.health <= C.crit_threshold)
		C.adjustToxLoss(-2 * removed, 0)
		C.adjustBruteLoss(-2 * removed, 0)
		C.adjustFireLoss(-2 * removed, 0)
		C.adjustOxyLoss(-5 * removed, 0)
		. = TRUE
	C.losebreath = 0
	if(prob(20))
		C.set_timed_status_effect(10 SECONDS, /datum/status_effect/dizziness, only_if_higher = TRUE)
		C.set_timed_status_effect(10 SECONDS, /datum/status_effect/jitter, only_if_higher = TRUE)

// Note to self: should be made with lexorin, haloperidol, and clf3
/datum/reagent/medicine/chlorpromazine
	name = "Chlorpromazine"
	description = "A powerful antipsychotic. For schizophrenics, it counteracts their symptoms and anchors them to reality."
	color = "#B31008" // rgb: 139, 166, 233
	taste_description = "sourness"

	metabolization_rate = 0.02
	overdose_threshold = 60

/datum/reagent/medicine/chlorpromazine/affect_blood(mob/living/carbon/C, removed)
	if(HAS_TRAIT(C, TRAIT_INSANITY))
		C.hallucination = 0
	if(volume >= 20)
		holder.add_reagent(/datum/reagent/medicine/haloperidol, removed)

/datum/reagent/medicine/regen_jelly
	name = "Regenerative Jelly"
	description = "Gradually regenerates all types of damage, without harming slime anatomy."
	reagent_state = LIQUID
	color = "#CC23FF"
	taste_description = "jelly"


/datum/reagent/medicine/regen_jelly/expose_mob(mob/living/exposed_mob, reac_volume, exposed_temperature = T20C, datum/reagents/source, methods=TOUCH, show_message = TRUE, touch_protection = 0)
	. = ..()
	if(!ishuman(exposed_mob) || (reac_volume < 0.5))
		return

	var/mob/living/carbon/human/exposed_human = exposed_mob
	exposed_human.hair_color = "#CC22FF"
	exposed_human.facial_hair_color = "#CC22FF"
	exposed_human.update_body_parts()

/datum/reagent/medicine/regen_jelly/affect_blood(mob/living/carbon/C, removed)
	C.adjustBruteLoss(-1.5 * removed, 0)
	C.adjustFireLoss(-1.5 * removed, 0)
	C.adjustOxyLoss(-1.5 * removed, 0)
	C.adjustToxLoss(-1.5 * removed, 0, TRUE) //heals TOXINLOVERs
	. = TRUE

/datum/reagent/medicine/regen_jelly/affect_touch(mob/living/carbon/C, removed)
	return affect_blood(C, removed)

/datum/reagent/medicine/diphenhydramine
	name = "Diphenhydramine"
	description = "Rapidly purges the body of histamine and reduces jitteriness. Slight chance of causing drowsiness."
	reagent_state = LIQUID
	color = "#64FFE6"
	metabolization_rate = 0.1

/datum/reagent/medicine/diphenhydramine/affect_blood(mob/living/carbon/C, removed)
	if(prob(10))
		C.adjust_drowsyness(1)
	C.adjust_timed_status_effect(-2 SECONDS * removed, /datum/status_effect/jitter)
	holder.remove_reagent(/datum/reagent/toxin/histamine, 10 * removed)

/datum/reagent/medicine/inacusiate
	name = "Inacusiate"
	description = "Rapidly repairs damage to the patient's ears to cure deafness, assuming the source of said deafness isn't from genetic mutations, chronic deafness, or a total defecit of ears." //by "chronic" deafness, we mean people with the "deaf" quirk
	color = "#606060" // ditto


/datum/reagent/medicine/inacusiate/on_mob_add(mob/living/owner, amount)
	. = ..()
	RegisterSignal(owner, COMSIG_MOVABLE_HEAR, PROC_REF(owner_hear))

//Lets us hear whispers from far away!
/datum/reagent/medicine/inacusiate/proc/owner_hear(datum/source, message, atom/movable/speaker, datum/language/message_language, raw_message, radio_freq, list/spans, list/message_mods = list())
	SIGNAL_HANDLER
	if(!isliving(holder.my_atom))
		return
	var/mob/living/owner = holder.my_atom
	var/atom/movable/composer = holder.my_atom
	if(message_mods[WHISPER_MODE])
		message = composer.compose_message(owner, message_language, message, , spans, message_mods)

/datum/reagent/medicine/inacusiate/affect_blood(mob/living/carbon/C, removed)
	. = ..()
	var/obj/item/organ/ears/ears = C.getorganslot(ORGAN_SLOT_EARS)
	if(!ears)
		return
	ears.adjustEarDamage(-4 * removed, -4 * removed)

/datum/reagent/medicine/inacusiate/on_mob_delete(mob/living/owner)
	. = ..()
	UnregisterSignal(owner, COMSIG_MOVABLE_HEAR)

/datum/reagent/medicine/insulin
	name = "Insulin"
	description = "Increases sugar depletion rates."
	reagent_state = LIQUID
	color = "#FFFFF0"
	metabolization_rate = 0.1

/datum/reagent/medicine/insulin/affect_blood(mob/living/carbon/C, removed)
	holder.remove_reagent(/datum/reagent/consumable/sugar, 3 * removed)

/datum/reagent/medicine/ipecac
	name = "Ipecac"
	description = "Rapidly induces vomitting to purge the stomach."
	reagent_state = LIQUID
	color = "#19C832"
	metabolization_rate = 0.4
	ingest_met = 0.4
	taste_description = "acid"


/datum/reagent/medicine/ipecac/affect_ingest(mob/living/carbon/C, removed)
	if(prob(15))
		C.vomit(harm = FALSE, force = TRUE, purge_ratio = (rand(15, 30)/100))
	return ..()

/datum/reagent/medicine/ipecac/affect_blood(mob/living/carbon/C, removed)
	C.adjustToxLoss(5 * removed, 0, cause_of_death = "Ipecac")
	. = TRUE

/datum/reagent/medicine/activated_charcoal
	name = "Activated Charcoal"
	description = "Helps the body purge reagents."
	reagent_state = SOLID
	color = "#252525"
	metabolization_rate = 1

/datum/reagent/medicine/activated_charcoal/affect_blood(mob/living/carbon/C, removed)
	for(var/datum/reagent/R in holder.reagent_list)
		if(R.type == type)
			continue
		holder.remove_reagent(R.type, 8 * removed)

	if(prob(3))
		C.vomit(50, FALSE, FALSE, 1, purge_ratio = 0.2)

/datum/reagent/medicine/activated_charcoal/on_hydroponics_apply(datum/plant_tick/plant_tick, datum/reagents/chems, volume, obj/machinery/hydroponics/mytray, mob/user)
	for(var/datum/reagent/R in mytray.reagents.reagent_list)
		if(R.type == type || !istype(R, /datum/reagent/water))
			continue

		mytray.reagents.remove_reagent(R.type, 2)

/datum/reagent/medicine/adenosine
	name = "Adenosine"
	description = "A pharmaceutical used to lower a patient's heartrate. Can be used to restart hearts when dosed correctly."
	reagent_state = LIQUID
	color = "#7F10C0"
	metabolization_rate = 0.5

	overdose_threshold = 10.1

/datum/reagent/medicine/adenosine/affect_blood(mob/living/carbon/C, removed)
	if(overdosed)
		return

	if(current_cycle < SECONDS_TO_REAGENT_CYCLES(10)) // Seconds 1-8 do nothing. (0.5 to 2u)
		return

	if(current_cycle in SECONDS_TO_REAGENT_CYCLES(10) to SECONDS_TO_REAGENT_CYCLES(14)) // Seconds 10-14 stop ya heart. (2.5 to 3.5)
		if(C.set_heartattack(TRUE))
			log_health(C, "Heart stopped due to adenosine misdose.")
			C.Unconscious(3 SECONDS)
		return

	if(current_cycle == SECONDS_TO_REAGENT_CYCLES(16)) // Restart heart after 16 seconds (exactly 4u)
		if(C.set_heartattack(FALSE))
			log_health(C, "Heart restarted due to adenosine.")
		return

	if(current_cycle in SECONDS_TO_REAGENT_CYCLES(18) to SECONDS_TO_REAGENT_CYCLES(28)) // 4.5u to 7u is a safe buffer.
		return

	if(!prob(25)) // Only runs after 7 units have been processed.
		return

	switch(rand(1,10))
		if(1 to 7)
			C.losebreath += 4
		if(8 to 9)
			C.adjustOxyLoss(rand(3, 4), FALSE)
			. = TRUE
		if(10)
			if(C.set_heartattack(TRUE))
				log_health(C, "Heart stopped due to improper adenosine dose.")

/datum/reagent/medicine/adenosine/overdose_process(mob/living/carbon/C)
	if(C.set_heartattack(TRUE))
		log_health(C, "Heart stopped due to adenosine overdose.")

	if(prob(25))
		C.losebreath += 4
		C.adjustOxyLoss(rand(5,25), 0)
	return TRUE

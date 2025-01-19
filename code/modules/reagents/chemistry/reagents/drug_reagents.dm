/datum/reagent/drug
	name = "Drug"
	metabolization_rate = 0.25
	taste_description = "bitterness"
	var/trippy = TRUE //Does this drug make you trip?
	abstract_type = /datum/reagent/drug

/datum/reagent/drug/space_drugs
	name = "Space Drugs"
	description = "An illegal chemical compound used as drug."
	color = "#60A584" // rgb: 96, 165, 132
	overdose_threshold = 30

	addiction_types = list(/datum/addiction/hallucinogens = 10) //4 per 2 seconds

/datum/reagent/drug/space_drugs/affect_blood(mob/living/carbon/C, removed)
	C.set_drugginess_if_lower(15 SECONDS)
	if(isturf(C.loc) && !isspaceturf(C.loc) && !HAS_TRAIT(C, TRAIT_IMMOBILIZED) && prob(10))
		step(C, pick(GLOB.cardinals))
	if(prob(7))
		spawn(-1)
			C.emote(pick("twitch","drool","moan","giggle"))

/datum/reagent/drug/space_drugs/overdose_start(mob/living/carbon/C)
	to_chat(C, span_notice("Whoooaaaaa. Birds in space... freaky."))

/datum/reagent/drug/space_drugs/overdose_process(mob/living/carbon/C)
	if(C.hallucination < volume && prob(10))
		C.hallucination += 5
/datum/reagent/drug/cannabis
	name = "Cannabis"
	description = "A psychoactive drug from the Cannabis plant used for recreational purposes."
	color = "#059033"
	overdose_threshold = 0

	metabolization_rate = 0.05

/datum/reagent/drug/cannabis/affect_blood(mob/living/carbon/C, removed)
	C.apply_status_effect(/datum/status_effect/stoned)
	if(prob(1))
		var/smoke_message = pick("You feel relaxed.","You feel calmed.","Your mouth feels dry.","You could use some water.","Your heart beats quickly.","You feel clumsy.","You crave junk food.","You notice you've been moving more slowly.")
		to_chat(C, "<span class='notice'>[smoke_message]</span>")
	if(prob(2))
		spawn(-1)
			C.emote(pick("smile","laugh","giggle"))

	C.adjust_nutrition(-0.5 * removed) //munchies

	if(prob(4) && C.body_position == LYING_DOWN && !C.IsSleeping()) //chance to fall asleep if lying down
		to_chat(C, "<span class='warning'>You doze off...</span>")
		C.Sleeping(10 SECONDS)

	if(prob(4) && C.buckled && C.body_position != LYING_DOWN && !C.IsParalyzed()) //chance to be couchlocked if sitting
		to_chat(C, "<span class='warning'>It's too comfy to move...</span>")
		C.Paralyze(10 SECONDS)

/datum/reagent/drug/nicotine
	name = "Nicotine"
	description = "Slightly reduces stun times. If overdosed it will deal toxin and oxygen damage."
	reagent_state = LIQUID
	color = "#60A584" // rgb: 96, 165, 132
	taste_description = "smoke"
	trippy = FALSE
	overdose_threshold = 30
	metabolization_rate = 0.01

	addiction_types = list(/datum/addiction/nicotine = 18)

//Nicotine is used as a pesticide IRL.
/datum/reagent/drug/nicotine/on_hydroponics_apply(datum/plant_tick/plant_tick, datum/reagents/chems, volume, obj/machinery/hydroponics/mytray, mob/user)
	if(volume >= 1)
		plant_tick.plant_health_delta -= 0.2

/datum/reagent/drug/nicotine/affect_blood(mob/living/carbon/C, removed)
	if(prob(volume * 20))
		APPLY_CHEM_EFFECT(C, CE_PULSE, 1)

	if(prob(0.5))
		var/smoke_message = pick("You feel relaxed.", "You feel calmed.","You feel alert.","You feel rugged.")
		to_chat(C, span_notice("[smoke_message]"))

	C.remove_status_effect(/datum/status_effect/jitter)
	C.AdjustStun(-10 * removed)
	C.AdjustKnockdown(-10 * removed)
	C.AdjustUnconscious(-10 * removed)
	C.AdjustParalyzed(-10 * removed)
	C.AdjustImmobilized(-10 * removed)
	. = TRUE

/datum/reagent/drug/nicotine/on_mob_metabolize(mob/living/carbon/C, class)
	if(class != CHEM_BLOOD)
		return
	C.stats?.set_skill_modifier(1, /datum/rpg_skill/handicraft, SKILL_SOURCE_NICOTINE)

/datum/reagent/drug/nicotine/on_mob_end_metabolize(mob/living/carbon/C, class)
	if(class != CHEM_BLOOD)
		return
	C.stats?.remove_skill_modifier(/datum/rpg_skill/handicraft, SKILL_SOURCE_NICOTINE)

/datum/reagent/drug/nicotine/overdose_process(mob/living/carbon/C)
	. = ..()
	APPLY_CHEM_EFFECT(C, CE_PULSE, 2)

/datum/reagent/drug/krokodil
	name = "Krokodil"
	description = "Cools and calms you down. If overdosed it will deal significant Brain and Toxin damage."
	reagent_state = LIQUID
	color = "#0064B4"
	overdose_threshold = 20

	addiction_types = list(/datum/addiction/opiods = 18) //7.2 per 2 seconds

/datum/reagent/drug/krokodil/affect_blood(mob/living/carbon/C, removed)
	var/high_message = pick("You feel calC.", "You feel collected.", "You feel like you need to relax.")
	if(prob(5))
		to_chat(C, span_notice("[high_message]"))

/datum/reagent/drug/krokodil/overdose_process(mob/living/carbon/C)
	C.adjustOrganLoss(ORGAN_SLOT_BRAIN, 0.25, updating_health = FALSE)
	C.adjustToxLoss(0.25, 0, cause_of_death = "Krokodil overdose")
	. = TRUE

/datum/reagent/drug/methamphetamine
	name = "Methamphetamine"
	description = "Reduces stun times by about 300%, speeds the user up, and allows the user to quickly recover stamina while dealing a small amount of Brain damage. If overdosed the subject will move randomly, laugh randomly, drop items and suffer from Toxin and Brain damage. If addicted the subject will constantly jitter and drool, before becoming dizzy and losing motor control and eventually suffer heavy toxin damage."
	reagent_state = LIQUID
	color = "#FAFAFA"
	overdose_threshold = 20
	metabolization_rate = 0.15

	addiction_types = list(/datum/addiction/stimulants = 12) //4.8 per 2 seconds

/datum/reagent/drug/methamphetamine/on_mob_metabolize(mob/living/carbon/C, class)
	if(class != CHEM_BLOOD)
		return
	C.add_movespeed_modifier(/datum/movespeed_modifier/reagent/methamphetamine)

/datum/reagent/drug/methamphetamine/on_mob_end_metabolize(mob/living/carbon/C, class)
	if(class != CHEM_BLOOD)
		return
	C.remove_movespeed_modifier(/datum/movespeed_modifier/reagent/methamphetamine)

/datum/reagent/drug/methamphetamine/affect_blood(mob/living/carbon/C, removed)
	var/high_message = pick("You feel hyper.", "You feel like you need to go faster.", "You feel like you can run the world.")
	if(prob(5))
		to_chat(C, span_notice("[high_message]"))

	C.AdjustStun(-40 * removed)
	C.AdjustKnockdown(-40 * removed)
	C.AdjustUnconscious(-40 * removed)
	C.AdjustParalyzed(-40 * removed)
	C.AdjustImmobilized(-40 * removed)
	C.stamina.adjust(20 * removed)
	C.set_jitter_if_lower(10 SECONDS)
	C.adjustOrganLoss(ORGAN_SLOT_BRAIN, rand(1, 4) * removed, updating_health = FALSE)
	if(prob(5))
		spawn(-1)
			C.emote(pick("twitch", "shiver"))
	. = TRUE

/datum/reagent/drug/methamphetamine/overdose_process(mob/living/carbon/C)
	if(!HAS_TRAIT(C, TRAIT_IMMOBILIZED) && !ismovable(C.loc))
		for(var/i in 1 to round(4))
			step(C, pick(GLOB.cardinals))

	if(prob(10))
		spawn(-1)
			C.emote("laugh")
	if(prob(18))
		C.visible_message(span_danger("[C]'s hands flip out and flail everywhere!"))
		C.drop_all_held_items()

	C.adjustToxLoss(1, 0, cause_of_death = "Methamphetamine overdose")
	C.adjustOrganLoss(ORGAN_SLOT_BRAIN, (rand(5, 10) / 10), updating_health = FALSE)
	. = TRUE

/datum/reagent/drug/bath_salts
	name = "Bath Salts"
	description = "Makes you impervious to stuns and grants a stamina regeneration buff, but you will be a nearly uncontrollable tramp-bearded raving lunatic."
	reagent_state = LIQUID
	color = "#FAFAFA"
	overdose_threshold = 20
	taste_description = "salt" // because they're bathsalts?
	addiction_types = list(/datum/addiction/stimulants = 25)  //8 per 2 seconds


	var/datum/brain_trauma/special/psychotic_brawling/bath_salts/rage

/datum/reagent/drug/bath_salts/on_mob_metabolize(mob/living/carbon/C, class)
	if(class != CHEM_BLOOD)
		return
	ADD_TRAIT(C, TRAIT_STUNIMMUNE, type)
	ADD_TRAIT(C, TRAIT_SLEEPIMMUNE, type)
	rage = new()
	C.gain_trauma(rage, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/reagent/drug/bath_salts/on_mob_end_metabolize(mob/living/carbon/C, class)
	if(class != CHEM_BLOOD)
		return
	REMOVE_TRAIT(C, TRAIT_STUNIMMUNE, type)
	REMOVE_TRAIT(C, TRAIT_SLEEPIMMUNE, type)
	if(rage)
		QDEL_NULL(rage)

/datum/reagent/drug/bath_salts/affect_blood(mob/living/carbon/C, removed)
	var/high_message = pick("You feel amped up.", "You feel ready.", "You feel like you can push it to the limit.")
	if(prob(5))
		to_chat(C, span_notice("[high_message]"))

	C.stamina.adjust(5 * removed)
	C.adjustOrganLoss(ORGAN_SLOT_BRAIN, 4 * removed, updating_health = FALSE)
	C.hallucination += 5 * removed
	if(!HAS_TRAIT(C, TRAIT_IMMOBILIZED) && !ismovable(C.loc))
		step(C, pick(GLOB.cardinals))
		step(C, pick(GLOB.cardinals))
	. = TRUE

/datum/reagent/drug/bath_salts/overdose_process(mob/living/carbon/C)
	C.hallucination += 5
	if(!HAS_TRAIT(C, TRAIT_IMMOBILIZED) && !ismovable(C.loc))
		for(var/i in 1 to 8)
			step(C, pick(GLOB.cardinals))

	if(prob(10))
		spawn(-1)
			C.emote(pick("twitch","drool","moan"))
	if(prob(28))
		C.drop_all_held_items()

/datum/reagent/drug/aranesp
	name = "Aranesp"
	description = "Amps you up, gets you going, and rapidly restores stamina damage. Side effects include breathlessness and toxicity."
	reagent_state = LIQUID
	color = "#78FFF0"

	addiction_types = list(/datum/addiction/stimulants = 8)

/datum/reagent/drug/aranesp/affect_blood(mob/living/carbon/C, removed)
	var/high_message = pick("You feel amped up.", "You feel ready.", "You feel like you can push it to the limit.")
	if(prob(5))
		to_chat(C, span_notice("[high_message]"))

	C.stamina.adjust(-18 * removed)
	C.adjustToxLoss(0.5 * removed, 0, cause_of_death = "Aransep poisoning")
	if(prob(30))
		C.losebreath++
		C.adjustOxyLoss(1 * removed, 0)
	. = TRUE

/datum/reagent/drug/pumpup
	name = "Pump-Up"
	description = "Take on the world! A fast acting, hard hitting drug that pushes the limit on what you can handle."
	reagent_state = LIQUID
	color = "#e38e44"
	metabolization_rate = 0.4
	overdose_threshold = 30

	addiction_types = list(/datum/addiction/stimulants = 6) //2.6 per 2 seconds

/datum/reagent/drug/pumpup/on_mob_metabolize(mob/living/carbon/C, class)
	if(class != CHEM_BLOOD)
		return
	ADD_TRAIT(C, TRAIT_STUNRESISTANCE, type)

/datum/reagent/drug/pumpup/on_mob_end_metabolize(mob/living/carbon/C, class)
	if(class != CHEM_BLOOD)
		return
	REMOVE_TRAIT(C, TRAIT_STUNRESISTANCE, type)

/datum/reagent/drug/pumpup/affect_blood(mob/living/carbon/C, removed)
	C.set_jitter_if_lower(10 SECONDS)

	if(prob(5))
		to_chat(C, span_notice("[pick("Go! Go! GO!", "You feel ready...", "You feel invincible...")]"))

	if(prob(14))
		C.losebreath++
		C.adjustToxLoss(2, 0, cause_of_death = "Pump-Up")
		. = TRUE

/datum/reagent/drug/pumpup/overdose_start(mob/living/carbon/C)
	to_chat(C, span_userdanger("You can't stop shaking, your heart beats faster and faster..."))

/datum/reagent/drug/pumpup/overdose_process(mob/living/carbon/C)
	C.set_timed_status_effect(10 SECONDS, /datum/status_effect/jitter, only_if_higher = TRUE)
	if(prob(5))
		C.drop_all_held_items()
	if(prob(14))
		spawn(-1)
			C.emote(pick("twitch","drool"))
	if(prob(20))
		C.losebreath++
		C.stamina.adjust(-4)

	if(prob(14))
		C.adjustToxLoss(2, 0, cause_of_death = "Pump-Up overdose")
	return TRUE

/datum/reagent/drug/maint
	name = "Maintenance Drugs"
	chemical_flags = NONE
	abstract_type = /datum/reagent/drug/maint

/datum/reagent/drug/maint/powder
	name = "Maintenance Powder"
	description = "An unknown powder that you most likely gotten from an assistant, a bored chemist... or cooked yourself. It is a refined form of tar that enhances your mental ability, making you learn stuff a lot faster."
	reagent_state = SOLID
	color = "#ffffff"
	metabolization_rate = 0.1
	overdose_threshold = 15

	addiction_types = list(/datum/addiction/maintenance_drugs = 14)

/datum/reagent/drug/maint/powder/affect_blood(mob/living/carbon/C, removed)
	C.adjustOrganLoss(ORGAN_SLOT_BRAIN, 0.2 * removed, updating_health = FALSE)

	// 5x if you want to OD, you can potentially go higher, but good luck managing the brain damage.
	var/amt = max(round(volume/3, 0.1), 1)
	C?.mind?.experience_multiplier_reasons |= type
	C?.mind?.experience_multiplier_reasons[type] = amt
	return TRUE

/datum/reagent/drug/maint/powder/on_mob_end_metabolize(mob/living/carbon/C)
	C?.mind?.experience_multiplier_reasons[type] = null
	C?.mind?.experience_multiplier_reasons -= type

/datum/reagent/drug/maint/powder/overdose_process(mob/living/carbon/C)
	C.adjustOrganLoss(ORGAN_SLOT_BRAIN, 6, updating_health = FALSE)
	return TRUE

/datum/reagent/drug/maint/sludge
	name = "Maintenance Sludge"
	description = "An unknown sludge that you most likely gotten from an assistant, a bored chemist... or cooked yourself. Half refined, it fills your body with itself, making it more resistant to wounds, but causes toxins to accumulate."
	reagent_state = LIQUID
	color = "#203d2c"
	metabolization_rate = 0.4
	overdose_threshold = 25

	addiction_types = list(/datum/addiction/maintenance_drugs = 8)

/datum/reagent/drug/maint/sludge/on_mob_metabolize(mob/living/carbon/C, class)
	if(class != CHEM_BLOOD)
		return
	ADD_TRAIT(C,TRAIT_HARDLY_WOUNDED, type)

/datum/reagent/drug/maint/sludge/affect_blood(mob/living/carbon/C, removed)
	C.adjustToxLoss(0.5 * removed, FALSE, cause_of_death = "Sludge poisoning")
	return TRUE

/datum/reagent/drug/maint/sludge/on_mob_end_metabolize(mob/living/carbon/C, class)
	if(class != CHEM_BLOOD)
		return
	REMOVE_TRAIT(C, TRAIT_HARDLY_WOUNDED, type)

/datum/reagent/drug/maint/sludge/overdose_process(mob/living/carbon/C)
	//You will be vomiting so the damage is really for a few ticks before you flush it out of your system
	C.adjustToxLoss(1, FALSE, cause_of_death = "Sludge overdose")
	if(prob(10))
		C.adjustToxLoss(5, FALSE, cause_of_death = "Sludge overdose")
		C.vomit()
	return TRUE

/datum/reagent/drug/maint/tar
	name = "Maintenance Tar"
	description = "An unknown tar that you most likely gotten from an assistant, a bored chemist... or cooked yourself. Raw tar, straight from the floor. It can help you with escaping bad situations at the cost of liver damage."
	reagent_state = LIQUID
	color = "#000000"
	overdose_threshold = 30

	addiction_types = list(/datum/addiction/maintenance_drugs = 5)

/datum/reagent/drug/maint/tar/affect_blood(mob/living/carbon/C, removed)
	C.AdjustStun(-10 * removed)
	C.AdjustKnockdown(-10 * removed)
	C.AdjustUnconscious(-10 * removed)
	C.AdjustParalyzed(-10 * removed)
	C.AdjustImmobilized(-10 * removed)
	C.adjustOrganLoss(ORGAN_SLOT_LIVER, 1.5 * removed, updating_health = FALSE)
	return TRUE

/datum/reagent/drug/maint/tar/overdose_process(mob/living/carbon/C)
	C.adjustToxLoss(5, FALSE, cause_of_death = "Tar overdose")
	C.adjustOrganLoss(ORGAN_SLOT_LIVER, 3, updating_health = FALSE)
	return TRUE

/datum/reagent/drug/mushroomhallucinogen
	name = "Mushroom Hallucinogen"
	description = "A strong hallucinogenic drug derived from certain species of mushrooC."
	color = "#E700E7" // rgb: 231, 0, 231
	metabolization_rate = 0.04
	taste_description = "mushroom"

	addiction_types = list(/datum/addiction/hallucinogens = 12)

/datum/reagent/drug/mushroomhallucinogen/affect_blood(mob/living/carbon/psychonaut, removed)
	psychonaut.set_slurring_if_lower(1 SECOND)

	switch(current_cycle)
		if(1 to 5)
			if(prob(10))
				spawn(-1)
					psychonaut.emote(pick("twitch","giggle"))
		if(5 to 10)
			psychonaut.set_jitter_if_lower(20 SECONDS)
			if(prob(20))
				spawn(-1)
					psychonaut.emote(pick("twitch","giggle"))
		if (10 to INFINITY)
			psychonaut.set_jitter_if_lower(20 SECONDS)
			if(prob(32))
				spawn(-1)
					psychonaut.emote(pick("twitch","giggle"))

/datum/reagent/drug/mushroomhallucinogen/on_mob_metabolize(mob/living/psychonaut, class)
	if(class != CHEM_BLOOD)
		return
	if(!psychonaut.hud_used)
		return

	var/atom/movable/plane_master_controller/game_plane_master_controller = psychonaut.hud_used.plane_master_controllers[PLANE_MASTERS_GAME]

	var/list/col_filter_identity = list(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1, 0.000,0,0,0)
	var/list/col_filter_green = list(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1, 0.333,0,0,0)
	var/list/col_filter_blue = list(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1, 0.666,0,0,0)
	var/list/col_filter_red = list(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1, 1.000,0,0,0) //visually this is identical to the identity

	game_plane_master_controller.add_filter("rainbow", 10, color_matrix_filter(col_filter_red, FILTER_COLOR_HSL))

	for(var/filter in game_plane_master_controller.get_filters("rainbow"))
		animate(filter, color = col_filter_identity, time = 0 SECONDS, loop = -1, flags = ANIMATION_PARALLEL)
		animate(color = col_filter_green, time = 4 SECONDS)
		animate(color = col_filter_blue, time = 4 SECONDS)
		animate(color = col_filter_red, time = 4 SECONDS)

	game_plane_master_controller.add_filter("psilocybin_wave", 1, list("type" = "wave", "size" = 2, "x" = 32, "y" = 32))

	for(var/filter in game_plane_master_controller.get_filters("psilocybin_wave"))
		animate(filter, time = 64 SECONDS, loop = -1, easing = LINEAR_EASING, offset = 32, flags = ANIMATION_PARALLEL)

/datum/reagent/drug/mushroomhallucinogen/on_mob_end_metabolize(mob/living/psychonaut, class)
	if(class != CHEM_BLOOD)
		return
	if(!psychonaut.hud_used)
		return
	var/atom/movable/plane_master_controller/game_plane_master_controller = psychonaut.hud_used.plane_master_controllers[PLANE_MASTERS_GAME]
	game_plane_master_controller.remove_filter("rainbow")
	game_plane_master_controller.remove_filter("psilocybin_wave")

/datum/reagent/drug/blastoff
	name = "bLaSToFF"
	description = "A drug for the hardcore party crowd said to enhance ones abilities on the dance floor.\nMost old heads refuse to touch this stuff, perhaps because memories of the luna discoteque incident are seared into their brains."
	reagent_state = LIQUID
	color = "#9015a9"
	taste_description = "holodisk cleaner"
	overdose_threshold = 30

	addiction_types = list(/datum/addiction/hallucinogens = 15)
	///How many flips have we done so far?
	var/flip_count = 0
	///How many spin have we done so far?
	var/spin_count = 0
	///How many flips for a super flip?
	var/super_flip_requirement = 3

/datum/reagent/drug/blastoff/on_mob_metabolize(mob/living/dancer, class)
	if(class != CHEM_BLOOD)
		return
	RegisterSignal(dancer, COMSIG_MOB_EMOTED("flip"), PROC_REF(on_flip))
	RegisterSignal(dancer, COMSIG_MOB_EMOTED("spin"), PROC_REF(on_spin))

	if(!dancer.hud_used)
		return

	var/atom/movable/plane_master_controller/game_plane_master_controller = dancer.hud_used.plane_master_controllers[PLANE_MASTERS_GAME]

	var/list/col_filter_blue = list(0,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1, 0.764,0,0,0) //most blue color
	var/list/col_filter_mid = list(0,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1, 0.832,0,0,0) //red/blue mix midpoint
	var/list/col_filter_red = list(0,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1, 0.900,0,0,0) //most red color

	game_plane_master_controller.add_filter("blastoff_filter", 10, color_matrix_filter(col_filter_mid, FILTER_COLOR_HCY))
	game_plane_master_controller.add_filter("blastoff_wave", 1, list("type" = "wave", "x" = 32, "y" = 32))


	for(var/filter in game_plane_master_controller.get_filters("blastoff_filter"))
		animate(filter, color = col_filter_blue, time = 3 SECONDS, loop = -1, flags = ANIMATION_PARALLEL)
		animate(color = col_filter_mid, time = 3 SECONDS)
		animate(color = col_filter_red, time = 3 SECONDS)
		animate(color = col_filter_mid, time = 3 SECONDS)

	for(var/filter in game_plane_master_controller.get_filters("blastoff_wave"))
		animate(filter, time = 32 SECONDS, loop = -1, easing = LINEAR_EASING, offset = 32, flags = ANIMATION_PARALLEL)

	dancer.sound_environment_override = SOUND_ENVIRONMENT_PSYCHOTIC

/datum/reagent/drug/blastoff/on_mob_end_metabolize(mob/living/dancer, class)
	if(class != CHEM_BLOOD)
		return
	UnregisterSignal(dancer, COMSIG_MOB_EMOTED("flip"))
	UnregisterSignal(dancer, COMSIG_MOB_EMOTED("spin"))

	if(!dancer.hud_used)
		return

	var/atom/movable/plane_master_controller/game_plane_master_controller = dancer.hud_used.plane_master_controllers[PLANE_MASTERS_GAME]

	game_plane_master_controller.remove_filter("blastoff_filter")
	game_plane_master_controller.remove_filter("blastoff_wave")
	dancer.sound_environment_override = NONE

/datum/reagent/drug/blastoff/affect_blood(mob/living/carbon/C, removed)
	C.adjustOrganLoss(ORGAN_SLOT_LUNGS, 0.3 * removed, updating_health = FALSE)
	C.AdjustKnockdown(-20 * removed)

	if(prob(BLASTOFF_DANCE_MOVE_CHANCE_PER_UNIT * volume))
		spawn(-1)
			C.emote("flip")
	return TRUE

/datum/reagent/drug/blastoff/overdose_process(mob/living/carbon/C)
	C.adjustOrganLoss(ORGAN_SLOT_LUNGS, 0.3, updating_health = FALSE)

	if(prob(BLASTOFF_DANCE_MOVE_CHANCE_PER_UNIT * volume))
		spawn(-1)
			C.emote("spin")
	return TRUE

///This proc listens to the flip signal and throws the mob every third flip
/datum/reagent/drug/blastoff/proc/on_flip()
	SIGNAL_HANDLER

	if(!iscarbon(holder.my_atom))
		return
	var/mob/living/carbon/dancer = holder.my_atom

	flip_count++
	if(flip_count < BLASTOFF_DANCE_MOVES_PER_SUPER_MOVE)
		return
	flip_count = 0
	var/atom/throw_target = get_edge_target_turf(dancer, dancer.dir)  //Do a super flip
	dancer.SpinAnimation(speed = 3, loops = 3)
	dancer.visible_message(span_notice("[dancer] does an extravagant flip!"), span_nicegreen("You do an extravagant flip!"))
	dancer.throw_at(throw_target, range = 6, speed = overdosed ? 4 : 1)

///This proc listens to the spin signal and throws the mob every third spin
/datum/reagent/drug/blastoff/proc/on_spin()
	SIGNAL_HANDLER

	if(!iscarbon(holder.my_atom))
		return
	var/mob/living/carbon/dancer = holder.my_atom

	spin_count++
	if(spin_count < BLASTOFF_DANCE_MOVES_PER_SUPER_MOVE)
		return
	spin_count = 0 //Do a super spin.
	dancer.visible_message(span_danger("[dancer] spins around violently!"), span_danger("You spin around violently!"))
	dancer.spin(30, 2)
	if(dancer.disgust < 40)
		dancer.adjust_disgust(10)
	if(!LAZYLEN(dancer.grabbed_by))
		return
	var/dancer_turf = get_turf(dancer)
	for(var/obj/item/hand_item/grab/G in dancer.grabbed_by)
		var/atom/movable/dance_partner = G.assailant
		dance_partner.visible_message(span_danger("[dance_partner] tries to hold onto [dancer], but is thrown back!"), span_danger("You try to hold onto [dancer], but you are thrown back!"), null, COMBAT_MESSAGE_RANGE)
		var/throwtarget = get_edge_target_turf(dancer_turf, get_dir(dancer_turf, get_step_away(dance_partner, dancer_turf)))
		if(overdosed)
			dance_partner.throw_at(target = throwtarget, range = 7, speed = 4)
		else
			dance_partner.throw_at(target = throwtarget, range = 4, speed = 1) //superspeed

/datum/reagent/drug/saturnx
	name = "SaturnX"
	description = "This compound was first discovered during the infancy of cloaking technology and at the time thought to be a promising candidate agent. It was withdrawn for consideration after the researchers discovered a slew of associated safety issues including thought disorders and hepatoxicity."
	reagent_state = SOLID
	taste_description = "metallic bitterness"
	color = "#638b9b"
	overdose_threshold = 25
	metabolization_rate = 0.25

	addiction_types = list(/datum/addiction/maintenance_drugs = 20)

/datum/reagent/drug/saturnx/affect_blood(mob/living/carbon/C, removed)
	C.adjustOrganLoss(ORGAN_SLOT_LIVER, 0.3 * removed, updating_health = FALSE)
	return TRUE

/datum/reagent/drug/saturnx/on_mob_metabolize(mob/living/invisible_man, class)
	if(class != CHEM_BLOOD)
		return
	playsound(invisible_man, 'sound/chemistry/saturnx_fade.ogg', 40)
	to_chat(invisible_man, span_nicegreen("You feel pins and needles all over your skin as your body suddenly becomes transparent!"))
	addtimer(CALLBACK(src, PROC_REF(turn_man_invisible), invisible_man), 10) //just a quick delay to synch up the sound.
	if(!invisible_man.hud_used)
		return

	var/atom/movable/plane_master_controller/game_plane_master_controller = invisible_man.hud_used.plane_master_controllers[PLANE_MASTERS_GAME]

	var/list/col_filter_full = list(1,0,0,0, 0,1.00,0,0, 0,0,1,0, 0,0,0,1, 0,0,0,0)
	var/list/col_filter_twothird = list(1,0,0,0, 0,0.68,0,0, 0,0,1,0, 0,0,0,1, 0,0,0,0)
	var/list/col_filter_half = list(1,0,0,0, 0,0.42,0,0, 0,0,1,0, 0,0,0,1, 0,0,0,0)
	var/list/col_filter_empty = list(1,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,0,1, 0,0,0,0)

	game_plane_master_controller.add_filter("saturnx_filter", 10, color_matrix_filter(col_filter_twothird, FILTER_COLOR_HCY))

	for(var/filter in game_plane_master_controller.get_filters("saturnx_filter"))
		animate(filter, loop = -1, color = col_filter_full, time = 4 SECONDS, easing = CIRCULAR_EASING|EASE_IN, flags = ANIMATION_PARALLEL)
		//uneven so we spend slightly less time with bright colors
		animate(color = col_filter_twothird, time = 6 SECONDS, easing = LINEAR_EASING)
		animate(color = col_filter_half, time = 3 SECONDS, easing = LINEAR_EASING)
		animate(color = col_filter_empty, time = 2 SECONDS, easing = CIRCULAR_EASING|EASE_OUT)
		animate(color = col_filter_half, time = 24 SECONDS, easing = CIRCULAR_EASING|EASE_IN)
		animate(color = col_filter_twothird, time = 12 SECONDS, easing = LINEAR_EASING)

	game_plane_master_controller.add_filter("saturnx_blur", 1, list("type" = "radial_blur", "size" = 0))

	for(var/filter in game_plane_master_controller.get_filters("saturnx_blur"))
		animate(filter, loop = -1, size = 0.04, time = 2 SECONDS, easing = ELASTIC_EASING|EASE_OUT, flags = ANIMATION_PARALLEL)
		animate(size = 0, time = 6 SECONDS, easing = CIRCULAR_EASING|EASE_IN)

///This proc turns the living mob passed as the arg "invisible_man"s invisible by giving him the invisible man trait and updating his body, this changes the sprite of all his organic limbs to a 1 alpha version.
/datum/reagent/drug/saturnx/proc/turn_man_invisible(mob/living/carbon/invisible_man)
	if(!invisible_man.getorganslot(ORGAN_SLOT_LIVER))
		return
	if(invisible_man.undergoing_liver_failure())
		return
	if(HAS_TRAIT(invisible_man, TRAIT_NOMETABOLISM))
		return
	if(invisible_man.has_status_effect(/datum/status_effect/grouped/hard_stasis))
		return

	ADD_TRAIT(invisible_man, TRAIT_INVISIBLE_MAN, name)
	ADD_TRAIT(invisible_man, TRAIT_HIDE_COSMETIC_ORGANS, name)

	var/datum/dna/druggy_dna = invisible_man.has_dna()
	if(druggy_dna?.species)
		druggy_dna.species.species_traits += NOBLOODOVERLAY

	invisible_man.update_body()
	invisible_man.update_hair()
	invisible_man.remove_from_all_data_huds()
	invisible_man.sound_environment_override = SOUND_ENVIROMENT_PHASED

/datum/reagent/drug/saturnx/on_mob_end_metabolize(mob/living/invisible_man, class)
	if(class != CHEM_BLOOD)
		return
	if(HAS_TRAIT(invisible_man, TRAIT_INVISIBLE_MAN))
		invisible_man.add_to_all_human_data_huds() //Is this safe, what do you think, Floyd?
		REMOVE_TRAIT(invisible_man, TRAIT_INVISIBLE_MAN, name)
		REMOVE_TRAIT(invisible_man, TRAIT_HIDE_COSMETIC_ORGANS, name)
		to_chat(invisible_man, span_notice("As you sober up, opacity once again returns to your body meats."))

		var/datum/dna/druggy_dna = invisible_man.has_dna()
		if(druggy_dna?.species)
			druggy_dna.species.species_traits -= NOBLOODOVERLAY

	invisible_man.update_body()
	invisible_man.sound_environment_override = NONE

	if(!invisible_man.hud_used)
		return

	var/atom/movable/plane_master_controller/game_plane_master_controller = invisible_man.hud_used.plane_master_controllers[PLANE_MASTERS_GAME]
	game_plane_master_controller.remove_filter("saturnx_filter")
	game_plane_master_controller.remove_filter("saturnx_blur")

/datum/reagent/drug/saturnx/overdose_process(mob/living/invisible_man)
	if(prob(14))
		spawn(-1)
			invisible_man.emote("giggle")
	if(prob(10))
		spawn(-1)
			invisible_man.emote("laugh")
	invisible_man.adjustOrganLoss(ORGAN_SLOT_LIVER, 0.4, updating_health = FALSE)
	return TRUE

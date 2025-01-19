
//////////////////////////Poison stuff (Toxins & Acids)///////////////////////

/datum/reagent/toxin
	name = "Generic Toxin"
	description = "A toxic chemical."
	color = "#CF3600" // rgb: 207, 54, 0
	taste_description = "bitterness"
	taste_mult = 1.2
	harmful = TRUE
	var/toxpwr = 1.5

	var/silent_toxin = FALSE //won't produce a pain message when processed by liver/life() if there isn't another non-silent toxin present.

// Are you a bad enough dude to poison your own plants?
/datum/reagent/toxin/on_hydroponics_apply(datum/plant_tick/plant_tick, datum/reagents/chems, volume, obj/machinery/hydroponics/mytray, mob/user)
	if(volume >= 1)
		plant_tick.tox_damage += 1

/datum/reagent/toxin/infuse_plant(datum/plant/plant_datum, datum/plant_gene_holder/plant_dna, list/damage_ref)
	. = ..()
	damage_ref += rand(15, 30)

/datum/reagent/toxin/affect_blood(mob/living/carbon/C, removed)
	if(toxpwr)
		C.adjustToxLoss(toxpwr * removed, 0, cause_of_death = "Poisoning")
		. = TRUE

/datum/reagent/toxin/amatoxin
	name = "Amatoxin"
	description = "A powerful poison derived from certain species of mushroom."
	color = "#792300" // rgb: 121, 35, 0
	toxpwr = 2.5
	taste_description = "mushroom"


/datum/reagent/toxin/mutagen
	name = "Unstable Mutagen"
	description = "Might cause unpredictable mutations. Keep away from children."
	color = "#00FF00"
	toxpwr = 0.5
	taste_description = "slime"
	taste_mult = 0.9

/datum/reagent/toxin/mutagen/expose_mob(mob/living/exposed_mob, reac_volume, exposed_temperature = T20C, datum/reagents/source, methods=TOUCH, show_message = TRUE, touch_protection = 0)
	. = ..()
	if(!iscarbon(exposed_mob) || !exposed_mob.has_dna() || HAS_TRAIT(exposed_mob, TRAIT_GENELESS) || HAS_TRAIT(exposed_mob, TRAIT_BADDNA))
		return  //No robots, AIs, aliens, Ians or other mobs should be affected by this.
	var/mob/living/carbon/C = exposed_mob
	if(((methods & VAPOR) && prob(min(33, reac_volume))) || (methods & (INGEST|INJECT)))
		C.random_mutate_unique_identity()
		C.random_mutate_unique_features()
		if(prob(98))
			C.easy_random_mutate(NEGATIVE+MINOR_NEGATIVE)
		else
			C.easy_random_mutate(POSITIVE)
		C.updateappearance()
		C.domutcheck()

/datum/reagent/toxin/mutagen/on_hydroponics_apply(datum/plant_tick/plant_tick, datum/reagents/chems, volume, obj/machinery/hydroponics/mytray, mob/user)
	if(volume >= 1)
		plant_tick.mutation_power += 1
		plant_tick.tox_damage += 1

/datum/reagent/toxin/mutagen/infuse_plant(datum/plant/plant_datum, datum/plant_gene_holder/plant_dna, list/damage_ref)
	. = ..()
	plant_dna.try_mutate_stats(2)
	plant_dna.try_activate_latent_gene(3)
	if(prob(5))
		plant_dna.add_active_gene(new /datum/plant_gene/unstable)
	return plant_dna.try_mutate_type(10)

/datum/reagent/toxin/plasma
	name = "Plasma"
	description = "Plasma in its liquid form."
	taste_description = "bitterness"
	specific_heat = SPECIFIC_HEAT_PLASMA
	taste_mult = 1.5
	color = "#8228A0"
	toxpwr = 3
	material = /datum/material/plasma
	penetrates_skin = NONE
	burning_temperature = 4500//plasma is hot!!
	burning_volume = 0.3//But burns fast
	codex_mechanics = "Plasma will ignite at 519.15 K, take care when handling."

/datum/reagent/toxin/plasma/on_new(data)
	. = ..()
	RegisterSignal(holder, COMSIG_REAGENTS_TEMP_CHANGE, PROC_REF(on_temp_change))

/datum/reagent/toxin/plasma/Destroy()
	UnregisterSignal(holder, COMSIG_REAGENTS_TEMP_CHANGE)
	return ..()

/datum/reagent/toxin/plasma/affect_blood(mob/living/carbon/C, removed)
	. = ..()
	if(holder.has_reagent(/datum/reagent/medicine/epinephrine))
		holder.remove_reagent(/datum/reagent/medicine/epinephrine, 2 * removed)
	C.adjustPlasma(20 * removed)

// Plasma will attempt to ignite at the ignition temperature.
/datum/reagent/toxin/plasma/proc/on_temp_change(datum/reagents/_holder, old_temp)
	SIGNAL_HANDLER
	if(holder.chem_temp < PHORON_FLASHPOINT)
		return
	if(!holder.my_atom || !(holder.flags & OPENCONTAINER))
		return

	var/turf/open/T = get_turf(holder.my_atom)
	if(!istype(T))
		return

	holder.my_atom.visible_message(span_danger("[holder.my_atom] emits a shriek as hot plasma fills the air."))
	T.assume_gas(GAS_PLASMA, volume / REAGENT_GAS_EXCHANGE_FACTOR, holder.chem_temp)
	holder.del_reagent(type)

/datum/reagent/toxin/plasma/expose_turf(turf/exposed_turf, reac_volume, exposed_temperature)
	. = ..()
	if(!istype(exposed_turf))
		return

	if(exposed_temperature >= PHORON_FLASHPOINT)
		exposed_turf.assume_gas(GAS_PLASMA, reac_volume / REAGENT_GAS_EXCHANGE_FACTOR, exposed_temperature)

/datum/reagent/toxin/plasma/expose_mob(mob/living/exposed_mob, reac_volume, exposed_temperature, datum/reagents/source, methods, show_message, touch_protection)
	. = ..()
	if(methods & (TOUCH|VAPOR))
		exposed_mob.adjust_fire_stacks(reac_volume / 5)
		if(prob(50 * reac_volume))
			exposed_mob.expose_plasma()
		return

/datum/reagent/toxin/hot_ice
	name = "Hot Ice Slush"
	description = "Frozen plasma, worth its weight in gold, to the right people."
	reagent_state = SOLID
	color = "#724cb8" // rgb: 114, 76, 184
	taste_description = "thick and smokey"
	specific_heat = SPECIFIC_HEAT_PLASMA
	toxpwr = 3
	material = /datum/material/hot_ice


/datum/reagent/toxin/hot_ice/affect_blood(mob/living/carbon/C, removed)
	. = ..()
	if(holder.has_reagent(/datum/reagent/medicine/epinephrine))
		holder.remove_reagent(/datum/reagent/medicine/epinephrine, 2 * removed)
	C.adjustPlasma(20 * removed)
	C.adjust_bodytemperature(-7 * TEMPERATURE_DAMAGE_COEFFICIENT * removed, C.get_body_temp_normal())

/datum/reagent/toxin/lexorin
	name = "Lexorin"
	description = "A powerful poison used to stop respiration."
	color = "#7DC3A0"
	taste_description = "acid"


/datum/reagent/toxin/lexorin/affect_blood(mob/living/carbon/C, removed)
	. = ..()
	C.adjustBruteLoss(10 * removed, FALSE)
	if (prob(10))
		C.visible_message(
			span_warning("\The [C]'s skin fizzles and flakes away!"),
			span_danger("Your skin fizzles and flakes away!")
		)

	if(!HAS_TRAIT(C, TRAIT_NOBREATH))
		C.adjustOxyLoss(15 * removed, 0)
		if(C.losebreath < (30))
			C.losebreath++

	return TRUE

/datum/reagent/toxin/slimejelly
	name = "Slime Jelly"
	description = "A gooey semi-liquid produced from one of the deadliest lifeforms in existence. SO REAL."
	color = "#801E28" // rgb: 128, 30, 40
	toxpwr = 0
	taste_description = "slime"
	taste_mult = 1.3


/datum/reagent/toxin/slimejelly/affect_blood(mob/living/carbon/C, removed)
	. = ..()
	if(prob(5))
		to_chat(C, span_danger("Your insides burn!"))
		C.adjustToxLoss(rand(20, 60), 0, cause_of_death = "Slime jelly poisoning")
	else if(prob(30))
		C.heal_bodypart_damage(5, updating_health = FALSE)

/datum/reagent/toxin/minttoxin
	name = "Mint Toxin"
	description = "Useful for dealing with undesirable customers."
	color = "#CF3600" // rgb: 207, 54, 0
	toxpwr = 0
	taste_description = "mint"


/datum/reagent/toxin/minttoxin/affect_blood(mob/living/carbon/C, removed)
	. = ..()
	if(HAS_TRAIT(C, TRAIT_FAT))
		C.inflate_gib()

/datum/reagent/toxin/carpotoxin
	name = "Carpotoxin"
	description = "A deadly neurotoxin produced by the dreaded spess carp."
	silent_toxin = TRUE
	color = "#003333" // rgb: 0, 51, 51
	toxpwr = 1
	taste_description = "fish"


/datum/reagent/toxin/zombiepowder
	name = "Zombie Powder"
	description = "A strong neurotoxin that puts the subject into a death-like state."
	silent_toxin = TRUE
	reagent_state = SOLID
	color = "#669900" // rgb: 102, 153, 0
	toxpwr = 0.5
	taste_description = "death"
	penetrates_skin = NONE


/datum/reagent/toxin/zombiepowder/affect_blood(mob/living/carbon/C, removed)
	. = ..()
	if(!HAS_TRAIT(C, TRAIT_ZOMBIEPOWDER))
		if(data?["method"] & INGEST)
			spawn(-1)
				C.fakedeath(type)

	ADD_TRAIT(C, TRAIT_ZOMBIEPOWDER, CHEM_TRAIT_SOURCE(CHEM_BLOOD))
	C.adjustOxyLoss(0.5*removed, 0)

/datum/reagent/toxin/zombiepowder/on_mob_end_metabolize(mob/living/carbon/C, class)
	REMOVE_TRAIT(C, TRAIT_ZOMBIEPOWDER, CHEM_TRAIT_SOURCE(class))
	if(!HAS_TRAIT(C, TRAIT_ZOMBIEPOWDER))
		C.cure_fakedeath(type)

/datum/reagent/toxin/zombiepowder/on_transfer(atom/target_atom, methods, trans_volume)
	. = ..()
	var/datum/reagent/zombiepowder = target_atom.reagents.has_reagent(/datum/reagent/toxin/zombiepowder)
	if(!zombiepowder || !(methods & INGEST))
		return
	LAZYINITLIST(zombiepowder.data)
	zombiepowder.data["method"] |= INGEST

/datum/reagent/toxin/zombiepowder/affect_blood(mob/living/carbon/C, removed)
	. = ..()
	if(HAS_TRAIT(C, TRAIT_FAKEDEATH) && HAS_TRAIT(C, TRAIT_DEATHCOMA))
		return TRUE
	switch(current_cycle)
		if(1 to 5)
			C.adjust_timed_status_effect(1 SECONDS * removed, /datum/status_effect/confusion)
			C.adjust_drowsyness(1 * removed)
			C.adjust_timed_status_effect(6 SECONDS * removed, /datum/status_effect/speech/slurring/drunk)
		if(5 to 8)
			C.stamina.adjust(40 * removed)
		if(9 to INFINITY)
			spawn(-1)
				C.fakedeath(type)

/datum/reagent/toxin/ghoulpowder
	name = "Ghoul Powder"
	description = "A strong neurotoxin that slows metabolism to a death-like state, while keeping the patient fully active. Causes toxin buildup if used too long."
	reagent_state = SOLID
	color = "#664700" // rgb: 102, 71, 0
	toxpwr = 0.8
	taste_description = "death"


/datum/reagent/toxin/ghoulpowder/on_mob_metabolize(mob/living/carbon/C, class)
	ADD_TRAIT(C, TRAIT_FAKEDEATH, CHEM_TRAIT_SOURCE(class))

/datum/reagent/toxin/ghoulpowder/on_mob_end_metabolize(mob/living/carbon/C, class)
	REMOVE_TRAIT(C, TRAIT_FAKEDEATH, CHEM_TRAIT_SOURCE(class))

/datum/reagent/toxin/ghoulpowder/affect_blood(mob/living/carbon/C, removed)
	C.adjustOxyLoss(1 * removed, 0)
	return ..()

/datum/reagent/toxin/mindbreaker
	name = "Lysergic acid diethylamide"
	description = "A powerful hallucinogen. Not a thing to be messed with. For some mental patients. it counteracts their symptoms and anchors them to reality."
	color = "#B31008" // rgb: 139, 166, 233
	toxpwr = 0
	taste_description = "sourness"

	addiction_types = list(/datum/addiction/hallucinogens = 18)  //7.2 per 2 seconds

/datum/reagent/toxin/mindbreaker/affect_blood(mob/living/carbon/C, removed)
	. = ..()
	if(HAS_TRAIT(C, TRAIT_INSANITY))
		C.hallucination = 0
	else
		C.hallucination += 5 * removed

/datum/reagent/toxin/plantbgone
	name = "Plant-B-Gone"
	description = "A harmful toxic mixture to kill plantlife. Do not ingest!"
	color = "#49002E" // rgb: 73, 0, 46
	toxpwr = 1
	taste_mult = 1
	penetrates_skin = NONE


	// Plant-B-Gone is just as bad
/datum/reagent/toxin/plantbgone/on_hydroponics_apply(datum/plant_tick/plant_tick, datum/reagents/chems, volume, obj/machinery/hydroponics/mytray, mob/user)
	if(volume >= 1)
		plant_tick.tox_damage += 10

/datum/reagent/toxin/plantbgone/expose_obj(obj/exposed_obj, reac_volume)
	. = ..()
	if(istype(exposed_obj, /obj/structure/alien/weeds))
		var/obj/structure/alien/weeds/alien_weeds = exposed_obj
		alien_weeds.take_damage(rand(15,35), BRUTE, 0) // Kills alien weeds pretty fast
	else if(istype(exposed_obj, /obj/structure/glowshroom)) //even a small amount is enough to kill it
		qdel(exposed_obj)
	else if(istype(exposed_obj, /obj/structure/spacevine))
		var/obj/structure/spacevine/SV = exposed_obj
		SV.on_chem_effect(src)

/datum/reagent/toxin/plantbgone/expose_mob(mob/living/exposed_mob, reac_volume, exposed_temperature = T20C, datum/reagents/source, methods=TOUCH, show_message = TRUE, touch_protection = 0)
	. = ..()
	var/damage = min(round(0.4 * reac_volume, 0.1), 10)
	if(exposed_mob.mob_biotypes & MOB_PLANT)
		exposed_mob.adjustToxLoss(damage, cause_of_death = "Plant-B-Gone")
	if(!(methods & VAPOR) || !iscarbon(exposed_mob))
		return
	var/mob/living/carbon/exposed_carbon = exposed_mob
	if(!exposed_carbon.wear_mask)
		exposed_carbon.adjustToxLoss(damage, cause_of_death = "Plant-B-Gone")

/datum/reagent/toxin/plantbgone/weedkiller
	name = "Weed Killer"
	description = "A harmful toxic mixture to kill weeds. Do not ingest!"
	color = "#4B004B" // rgb: 75, 0, 75


	//Weed Spray
/datum/reagent/toxin/plantbgone/weedkiller/on_hydroponics_apply(datum/plant_tick/plant_tick, datum/reagents/chems, volume, obj/machinery/hydroponics/mytray, mob/user)
	if(volume >= 1)
		plant_tick.tox_damage += 0.2

/datum/reagent/toxin/plantbgone/weedkiller/infuse_plant(datum/plant/plant_datum, datum/plant_gene_holder/plant_dna, list/damage_ref)
	. = ..()
	damage_ref += rand(50, 60)

/datum/reagent/toxin/pestkiller
	name = "Pest Killer"
	description = "A harmful toxic mixture to kill pests. Do not ingest!"
	color = "#4B004B" // rgb: 75, 0, 75
	toxpwr = 1


//Pest Spray
/datum/reagent/toxin/pestkiller/on_hydroponics_apply(datum/plant_tick/plant_tick, datum/reagents/chems, volume, obj/machinery/hydroponics/mytray, mob/user)
	if(volume >= 1)
		plant_tick.tox_damage += 0.2

/datum/reagent/toxin/pestkiller/expose_mob(mob/living/exposed_mob, reac_volume, exposed_temperature = T20C, datum/reagents/source, methods=TOUCH, show_message = TRUE, touch_protection = 0)
	. = ..()
	if(exposed_mob.mob_biotypes & MOB_BUG)
		var/damage = min(round(0.4*reac_volume, 0.1),10)
		exposed_mob.adjustToxLoss(damage, cause_of_death = "Pestkiller")

/datum/reagent/toxin/pestkiller/affect_blood(mob/living/carbon/C, removed)
	if(!(ismoth(C) || isflyperson(C)))
		return

	C.adjustToxLoss(3 * removed, FALSE, cause_of_death = "Pestkiller")
	return TRUE

/datum/reagent/toxin/pestkiller/affect_touch(mob/living/carbon/C, removed)
	return affect_blood(C, removed)

/datum/reagent/toxin/pestkiller/organic
	name = "Natural Pest Killer"
	description = "An organic mixture used to kill pests, with less of the side effects. Do not ingest!"
	color = "#4b2400" // rgb: 75, 0, 75
	toxpwr = 1


//Pest Spray
/datum/reagent/toxin/pestkiller/organic/on_hydroponics_apply(datum/plant_tick/plant_tick, datum/reagents/chems, volume, obj/machinery/hydroponics/mytray, mob/user)
	if(volume >= 1)
		plant_tick.tox_damage += 0.1


/datum/reagent/toxin/spore
	name = "Spore Toxin"
	description = "A natural toxin produced by blob spores that inhibits vision when ingested."
	color = "#9ACD32"
	toxpwr = 1
	chemical_flags = REAGENT_NO_RANDOM_RECIPE

/datum/reagent/toxin/spore/affect_blood(mob/living/carbon/C, removed)
	. = ..()
	C.damageoverlaytemp = 60
	C.blur_eyes(3 * removed)

/datum/reagent/toxin/spore_burning
	name = "Burning Spore Toxin"
	description = "A natural toxin produced by blob spores that induces combustion in its victim."
	color = "#9ACD32"
	toxpwr = 0.5
	taste_description = "burning"
	chemical_flags = REAGENT_NO_RANDOM_RECIPE

/datum/reagent/toxin/spore_burning/affect_blood(mob/living/carbon/C, removed)
	. = ..()
	C.adjust_fire_stacks(2 * removed)
	C.ignite_mob()

/datum/reagent/toxin/chloralhydrate
	name = "Chloral Hydrate"
	description = "A powerful sedative that induces confusion and drowsiness before putting its target to sleep."
	silent_toxin = TRUE
	reagent_state = SOLID
	color = "#000067" // rgb: 0, 0, 103
	toxpwr = 0
	metabolization_rate = 0.3

/datum/reagent/toxin/chloralhydrate/affect_blood(mob/living/carbon/C, removed)
	. = ..()
	switch(current_cycle)
		if(1 to 10)
			C.adjust_timed_status_effect(2 SECONDS * removed, /datum/status_effect/confusion)
			C.adjust_drowsyness(2 * removed)
		if(10 to 50)
			C.Sleeping(40 * removed)
		if(51 to INFINITY)
			C.Sleeping(40 * removed)
			C.adjustToxLoss(1 * (current_cycle - 50) * removed, 0, cause_of_death = "Chloral hydrate poisoning")
			. = TRUE

/datum/reagent/toxin/fakebeer //disguised as normal beer for use by emagged brobots
	name = "Beer...?"
	description = "A specially-engineered sedative disguised as beer. It induces instant sleep in its target."
	color = "#664300" // rgb: 102, 67, 0
	metabolization_rate = 1.5 * REAGENTS_METABOLISM
	taste_description = "piss water"
	glass_icon_state = "beerglass"
	glass_name = "glass of beer"
	glass_desc = "A freezing pint of beer."
	chemical_flags = REAGENT_NO_RANDOM_RECIPE

/datum/reagent/toxin/fakebeer/affect_blood(mob/living/carbon/C, removed)
	. = ..()
	switch(current_cycle)
		if(40 to 50)
			C.adjust_timed_status_effect(2 SECONDS * removed, /datum/status_effect/confusion)
			C.adjust_drowsyness(2 * removed)
		if(51 to INFINITY)
			C.Sleeping(40 * removed)
			C.adjustToxLoss(1 * (current_cycle - 50) * removed, 0, cause_of_death = "Beer...?")

/datum/reagent/toxin/coffeepowder
	name = "Coffee Grounds"
	description = "Finely ground coffee beans, used to make coffee."
	reagent_state = SOLID
	color = "#5B2E0D" // rgb: 91, 46, 13
	toxpwr = 0.5


/datum/reagent/toxin/teapowder
	name = "Ground Tea Leaves"
	description = "Finely shredded tea leaves, used for making tea."
	reagent_state = SOLID
	color = "#7F8400" // rgb: 127, 132, 0
	toxpwr = 0.1
	taste_description = "green tea"


/datum/reagent/toxin/mushroom_powder
	name = "Mushroom Powder"
	description = "Finely ground polypore mushrooms, ready to be steeped in water to make mushroom tea."
	reagent_state = SOLID
	color = "#67423A" // rgb: 127, 132, 0
	toxpwr = 0.1
	taste_description = "mushrooms"


/datum/reagent/toxin/mutetoxin //the new zombie powder.
	name = "Mute Toxin"
	description = "A nonlethal poison that inhibits speech in its victim."
	silent_toxin = TRUE
	color = "#F0F8FF" // rgb: 240, 248, 255
	toxpwr = 0
	taste_description = "silence"

/datum/reagent/toxin/mutetoxin/affect_blood(mob/living/carbon/C, removed)
	. = ..()
	C.silent = max(C.silent, 3 * removed)

/datum/reagent/toxin/staminatoxin
	name = "Tirizene"
	description = "A nonlethal poison that causes extreme fatigue and weakness in its victim."
	silent_toxin = TRUE
	color = "#6E2828"
	data = 15
	toxpwr = 0


/datum/reagent/toxin/staminatoxin/affect_blood(mob/living/carbon/C, removed)
	. = ..()
	C.stamina.adjust(data * removed)
	data = max(data - 1, 3)

/datum/reagent/toxin/polonium
	name = "Polonium"
	description = "An extremely radioactive material in liquid form. Ingestion results in fatal irradiation."
	reagent_state = LIQUID
	color = "#787878"
	metabolization_rate = 0.125 * REAGENTS_METABOLISM
	toxpwr = 0
	chemical_flags = REAGENT_NO_RANDOM_RECIPE

/datum/reagent/toxin/polonium/affect_blood(mob/living/carbon/C, removed)
	. = ..()
	if (!HAS_TRAIT(C, TRAIT_IRRADIATED) && SSradiation.can_irradiate_basic(C))
		C.AddComponent(/datum/component/irradiated)
	else
		C.adjustToxLoss(1 * removed, FALSE, cause_of_death = "Polonium poisoning")
		return TRUE

/datum/reagent/toxin/histamine
	name = "Histamine"
	description = "Histamine's effects become more dangerous depending on the dosage amount. They range from mildly annoying to incredibly lethal."
	silent_toxin = TRUE
	reagent_state = LIQUID
	color = "#FA6464"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	overdose_threshold = 30
	toxpwr = 0
	chemical_flags = REAGENT_NO_RANDOM_RECIPE

/datum/reagent/toxin/histamine/affect_blood(mob/living/carbon/C, removed)
	if(prob(33))
		switch(pick(1, 2, 3, 4))
			if(1)
				to_chat(C, span_danger("You can barely see!"))
				C.blur_eyes(3)
			if(2)
				spawn(-1)
					C.emote("cough")
			if(3)
				spawn(-1)
					C.emote("sneeze")
			if(4)
				if(prob(75))
					to_chat(C, span_danger("You scratch at an itch."))
					C.adjustBruteLoss(2, 0)
					. = TRUE

/datum/reagent/toxin/histamine/overdose_process(mob/living/carbon/C)
	C.adjustOxyLoss(2, FALSE)
	C.adjustBruteLoss(2, FALSE, FALSE, BODYTYPE_ORGANIC)
	C.adjustToxLoss(2, FALSE, cause_of_death = "Histamine overdose")
	. = TRUE

/datum/reagent/toxin/venom
	name = "Venom"
	description = "An exotic poison extracted from highly toxic fauna. Causes scaling amounts of toxin damage and bruising depending and dosage. Often decays into Histamine."
	reagent_state = LIQUID
	color = "#F0FFF0"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	toxpwr = 0
	chemical_flags = REAGENT_NO_RANDOM_RECIPE
	///Mob Size of the current mob sprite.
	var/current_size = RESIZE_DEFAULT_SIZE

/datum/reagent/toxin/venom/affect_blood(mob/living/carbon/C, removed)
	ADD_TRAIT(C, TRAIT_VENOMSIZE, CHEM_TRAIT_SOURCE(CHEM_BLOOD))
	var/newsize = 1.1 * RESIZE_DEFAULT_SIZE
	C.update_transform(newsize/current_size)
	current_size = newsize

	toxpwr = 0.1 * volume
	C.adjustBruteLoss((0.3 * volume) * removed, 0)
	. = TRUE
	if(prob(15))
		holder.add_reagent(/datum/reagent/toxin/histamine, pick(5, 10))
		holder.remove_reagent(/datum/reagent/toxin/venom, 1.1)
	else
		..()

/datum/reagent/toxin/venom/on_mob_end_metabolize(mob/living/carbon/C, class)
	REMOVE_TRAIT(C, TRAIT_VENOMSIZE, CHEM_TRAIT_SOURCE(class))
	if(!HAS_TRAIT(C, TRAIT_VENOMSIZE))
		C.update_transform(RESIZE_DEFAULT_SIZE/current_size)
		current_size = RESIZE_DEFAULT_SIZE

/datum/reagent/toxin/fentanyl
	name = "Fentanyl"
	description = "Fentanyl will inhibit brain function and cause toxin damage before eventually knocking out its victim."
	reagent_state = LIQUID
	color = "#64916E"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	toxpwr = 0

	addiction_types = list(/datum/addiction/opiods = 25)

/datum/reagent/toxin/fentanyl/affect_blood(mob/living/carbon/C, removed)
	C.adjustOrganLoss(ORGAN_SLOT_BRAIN, 3 * removed, 150, updating_health = FALSE)
	if(C.getToxLoss() <= 60)
		C.adjustToxLoss(1 * removed, 0, cause_of_death = "Fentanyl")
	if(current_cycle >= 18)
		C.Sleeping(40 * removed)
	return TRUE

/datum/reagent/toxin/cyanide
	name = "Cyanide"
	description = "An infamous poison known for its use in assassination. Causes small amounts of toxin damage with a small chance of oxygen damage or a stun."
	reagent_state = LIQUID
	color = "#00B4FF"
	metabolization_rate = 0.125 * REAGENTS_METABOLISM
	toxpwr = 1.25


/datum/reagent/toxin/cyanide/affect_blood(mob/living/carbon/C, removed)
	. = ..()
	if(prob(5))
		C.losebreath += 1
	if(prob(8))
		to_chat(C, span_danger("You feel horrendously weak!"))
		C.Stun(40)
		C.adjustToxLoss(2 * removed, 0, cause_of_death = "Cyanide poisoning")

/datum/reagent/toxin/bad_food
	name = "Bad Food"
	description = "The result of some abomination of cookery, food so bad it's toxic."
	reagent_state = LIQUID
	color = "#d6d6d8"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	toxpwr = 0.5
	taste_description = "bad cooking"


/datum/reagent/toxin/itching_powder
	name = "Itching Powder"
	description = "A powder that induces itching upon contact with the skin. Causes the victim to scratch at their itches and has a very low chance to decay into Histamine."
	silent_toxin = TRUE
	reagent_state = LIQUID
	color = "#C8C8C8"
	metabolization_rate = 0.4 * REAGENTS_METABOLISM
	toxpwr = 0
	penetrates_skin = TOUCH|VAPOR


/datum/reagent/toxin/itching_powder/affect_blood(mob/living/carbon/C, removed)
	if(prob(15))
		to_chat(C, span_danger("You scratch at your head."))
		C.adjustBruteLoss(0.2*removed, 0)
		. = TRUE
	if(prob(15))
		to_chat(C, span_danger("You scratch at your leg."))
		C.adjustBruteLoss(0.2*removed, 0)
		. = TRUE
	if(prob(15))
		to_chat(C, span_danger("You scratch at your arm."))
		C.adjustBruteLoss(0.2*removed, 0)
		. = TRUE
	if(prob(3))
		holder.add_reagent(/datum/reagent/toxin/histamine,rand(1,3))
		holder.remove_reagent(/datum/reagent/toxin/itching_powder,1.2)
		return
	..()
	return TRUE

/datum/reagent/toxin/itching_powder/affect_touch(mob/living/carbon/C, removed)
	if(prob(15))
		to_chat(C, span_danger("You scratch at your head."))
		C.adjustBruteLoss(0.2*removed, 0)
		. = TRUE
	if(prob(15))
		to_chat(C, span_danger("You scratch at your leg."))
		C.adjustBruteLoss(0.2*removed, 0)
		. = TRUE
	if(prob(15))
		to_chat(C, span_danger("You scratch at your arm."))
		C.adjustBruteLoss(0.2*removed, 0)
		. = TRUE
	if(prob(3))
		C.bloodstream.add_reagent(/datum/reagent/toxin/histamine,rand(1,3))
		return

/datum/reagent/toxin/pancuronium
	name = "Pancuronium"
	description = "An undetectable toxin that swiftly incapacitates its victim. May also cause breathing failure."
	silent_toxin = TRUE
	reagent_state = LIQUID
	color = "#195096"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	toxpwr = 0
	taste_mult = 0 // undetectable, I guess?
	chemical_flags = REAGENT_NO_RANDOM_RECIPE

/datum/reagent/toxin/pancuronium/affect_blood(mob/living/carbon/C, removed)
	if(current_cycle >= 10)
		C.Stun(40 * removed)
	if(prob(20))
		C.losebreath += 4

/datum/reagent/toxin/sodium_thiopental
	name = "Sodium Thiopental"
	description = "Sodium Thiopental induces heavy weakness in its target as well as unconsciousness."
	silent_toxin = TRUE
	reagent_state = LIQUID
	color = "#6496FA"
	metabolization_rate = 0.75 * REAGENTS_METABOLISM
	toxpwr = 0
	chemical_flags = REAGENT_NO_RANDOM_RECIPE

/datum/reagent/toxin/sodium_thiopental/on_mob_add(mob/living/carbon/C, amount, class)
	. = ..()
	ADD_TRAIT(C, TRAIT_ANTICONVULSANT, CHEM_TRAIT_SOURCE(class))

/datum/reagent/toxin/sodium_thiopental/on_mob_delete(mob/living/carbon/C, class)
	. = ..()
	REMOVE_TRAIT(C, TRAIT_ANTICONVULSANT, CHEM_TRAIT_SOURCE(class))

/datum/reagent/toxin/sodium_thiopental/affect_blood(mob/living/carbon/C, removed)
	if(current_cycle >= 10)
		C.Sleeping(40 * removed)
	C.stamina.adjust(-10 * removed)
	return TRUE

/datum/reagent/toxin/sulfonal
	name = "Sulfonal"
	description = "A stealthy poison that deals minor toxin damage and eventually puts the target to sleep."
	silent_toxin = TRUE
	reagent_state = LIQUID
	color = "#7DC3A0"
	metabolization_rate = 0.125 * REAGENTS_METABOLISM
	toxpwr = 0.5


/datum/reagent/toxin/sulfonal/affect_blood(mob/living/carbon/C, removed)
	. = ..()
	if(current_cycle >= 22)
		C.Sleeping(40 * removed)

/datum/reagent/toxin/amanitin
	name = "Amanitin"
	description = "A very powerful delayed toxin. Upon full metabolization, a massive amount of toxin damage will be dealt depending on how long it has been in the victim's bloodstream."
	silent_toxin = TRUE
	reagent_state = LIQUID
	color = "#FFFFFF"
	toxpwr = 0
	metabolization_rate = 0.5 * REAGENTS_METABOLISM

	var/delayed_toxin_damage = 0

/datum/reagent/toxin/amanitin/affect_blood(mob/living/carbon/C, removed)
	. = ..()
	delayed_toxin_damage += (removed * 3)

/datum/reagent/toxin/amanitin/on_mob_end_metabolize(mob/living/carbon/C, class)
	C.log_message("has taken [delayed_toxin_damage] toxin damage from amanitin toxin", LOG_ATTACK)
	C.adjustToxLoss(delayed_toxin_damage, FALSE, cause_of_death = "Amanitin")
	delayed_toxin_damage = 0
	return TRUE

/datum/reagent/toxin/lipolicide
	name = "Lipolicide"
	description = "A powerful toxin that will destroy fat cells, massively reducing body weight in a short time. Deadly to those without nutriment in their body."
	silent_toxin = TRUE
	taste_description = "mothballs"
	reagent_state = LIQUID
	color = "#F0FFF0"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	toxpwr = 0

/datum/reagent/toxin/lipolicide/affect_blood(mob/living/carbon/C, removed)
	. = ..()
	if(C.nutrition <= NUTRITION_LEVEL_STARVING)
		C.adjustToxLoss(1 * removed, 0, cause_of_death = "Lipolicide poisoning")
		. = TRUE
	C.adjust_nutrition(-3 * removed) // making the chef more valuable, one meme trap at a time
	C.overeatduration = 0

/datum/reagent/toxin/curare
	name = "Curare"
	description = "Causes slight toxin damage followed by chain-stunning and oxygen damage."
	reagent_state = LIQUID
	color = "#191919"
	metabolization_rate = 0.125 * REAGENTS_METABOLISM
	toxpwr = 1
	chemical_flags = REAGENT_NO_RANDOM_RECIPE

/datum/reagent/toxin/curare/affect_blood(mob/living/carbon/C, removed)
	. = ..()
	if(current_cycle >= 11)
		C.Paralyze(60 * removed)
	C.adjustOxyLoss(0.5 * removed, 0)
	. = TRUE

/datum/reagent/toxin/heparin //Based on a real-life anticoagulant. I'm not a doctor, so this won't be realistic.
	name = "Heparin"
	description = "A powerful anticoagulant. All open cut wounds on the victim will open up and bleed much faster"
	silent_toxin = TRUE
	reagent_state = LIQUID
	color = "#C8C8C8" //RGB: 200, 200, 200
	metabolization_rate = 0.2 * REAGENTS_METABOLISM
	toxpwr = 0

/datum/reagent/toxin/heparin/on_mob_metabolize(mob/living/carbon/C, class)
	if(class != CHEM_BLOOD)
		return
	ADD_TRAIT(C, TRAIT_BLOODY_MESS, CHEM_TRAIT_SOURCE(class))

/datum/reagent/toxin/heparin/affect_blood(mob/living/carbon/C, removed)
	. = ..()
	APPLY_CHEM_EFFECT(C, CE_ANTICOAGULANT, 1)

/datum/reagent/toxin/heparin/on_mob_end_metabolize(mob/living/carbon/C, class)
	if(class != CHEM_BLOOD)
		return
	REMOVE_TRAIT(C, TRAIT_BLOODY_MESS, CHEM_TRAIT_SOURCE(class))

/datum/reagent/toxin/rotatium //Rotatium. Fucks up your rotation and is hilarious
	name = "Rotatium"
	description = "A constantly swirling, oddly colourful fluid. Causes the consumer's sense of direction and hand-eye coordination to become wild."
	silent_toxin = TRUE
	reagent_state = LIQUID
	color = "#AC88CA" //RGB: 172, 136, 202
	metabolization_rate = 0.6 * REAGENTS_METABOLISM
	toxpwr = 0.5
	taste_description = "spinning"


/datum/reagent/toxin/rotatium/affect_blood(mob/living/carbon/C, removed)
	. = ..()
	if(C.hud_used)
		if(current_cycle >= 20 && (current_cycle % 20) == 0)
			ADD_TRAIT(C, TRAIT_ROTATIUM, CHEM_TRAIT_SOURCE(CHEM_BLOOD))
			var/atom/movable/plane_master_controller/pm_controller = C.hud_used.plane_master_controllers[PLANE_MASTERS_GAME]

			var/rotation = min(round(current_cycle/20), 89) // By this point the player is probably puking and quitting anyway
			for(var/key in pm_controller.controlled_planes)
				animate(pm_controller.controlled_planes[key], transform = matrix(rotation, MATRIX_ROTATE), time = 5, easing = QUAD_EASING, loop = -1)
				animate(transform = matrix(-rotation, MATRIX_ROTATE), time = 5, easing = QUAD_EASING)


/datum/reagent/toxin/rotatium/on_mob_end_metabolize(mob/living/carbon/C, class)
	REMOVE_TRAIT(C, TRAIT_ROTATIUM, CHEM_TRAIT_SOURCE(class))
	if(C?.hud_used && !HAS_TRAIT(C, TRAIT_ROTATIUM))
		var/atom/movable/plane_master_controller/pm_controller = C.hud_used.plane_master_controllers[PLANE_MASTERS_GAME]
		for(var/key in pm_controller.controlled_planes)
			animate(pm_controller.controlled_planes[key], transform = matrix(), time = 5, easing = QUAD_EASING)

/datum/reagent/toxin/anacea
	name = "Anacea"
	description = "A toxin that quickly purges medicines and metabolizes very slowly."
	reagent_state = LIQUID
	color = "#3C5133"
	metabolization_rate = 0.08 * REAGENTS_METABOLISM
	toxpwr = 0.15


/datum/reagent/toxin/anacea/affect_blood(mob/living/carbon/C, removed)
	. = ..()
	var/remove_amt = 5
	if(holder.has_reagent(/datum/reagent/medicine/activated_charcoal))
		remove_amt = 0.5
	for(var/datum/reagent/medicine/R in holder.reagent_list)
		holder.remove_reagent(R.type, remove_amt * removed)

/datum/reagent/toxin/acid/fluacid
	name = "Fluorosulfuric Acid"
	description = "Fluorosulfuric acid is an extremely corrosive chemical substance."
	color = "#5050FF"
	toxpwr = 2
	acidpwr = 42


// SERIOUSLY
/datum/reagent/toxin/acid/fluacid/on_hydroponics_apply(datum/plant_tick/plant_tick, datum/reagents/chems, volume, obj/machinery/hydroponics/mytray, mob/user)
	if(volume >= 1)
		plant_tick.fire_damage += 10

/datum/reagent/toxin/acid/fluacid/affect_blood(mob/living/carbon/C, removed)
	. = ..()
	C.adjustFireLoss((current_cycle/15) * removed, 0)

/datum/reagent/toxin/acid/nitracid
	name = "Nitric Acid"
	description = "Nitric acid is an extremely corrosive chemical substance that violently reacts with living organic tissue."
	color = "#5050FF"
	toxpwr = 3
	acidpwr = 5.0

/datum/reagent/toxin/acid/nitracid/affect_blood(mob/living/carbon/C, removed)
	. = ..()
	C.adjustFireLoss(10 * removed, FALSE) //here you go nervar

/datum/reagent/toxin/delayed
	name = "Toxin Microcapsules"
	description = "Causes heavy toxin damage after a brief time of inactivity."
	reagent_state = LIQUID
	metabolization_rate = 0 //stays in the system until active.
	var/actual_metaboliztion_rate = REAGENTS_METABOLISM
	toxpwr = 0
	var/actual_toxpwr = 5
	var/delay = 30
	chemical_flags = REAGENT_NO_RANDOM_RECIPE

/datum/reagent/toxin/delayed/affect_blood(mob/living/carbon/C, removed)
	if(current_cycle > delay)
		C.adjustToxLoss(actual_toxpwr * removed, 0, cause_of_death = "Toxin microcapsules")
		if(prob(10))
			C.Paralyze(20)
		. = TRUE
	else
		holder.add_reagent(type, removed) // GET BACK IN THERE

/datum/reagent/toxin/mimesbane
	name = "Mime's Bane"
	description = "A nonlethal neurotoxin that interferes with the victim's ability to gesture."
	silent_toxin = TRUE
	color = "#F0F8FF" // rgb: 240, 248, 255
	toxpwr = 0
	taste_description = "stillness"

/datum/reagent/toxin/mimesbane/on_mob_metabolize(mob/living/carbon/C, class)
	if(class != CHEM_BLOOD)
		return
	ADD_TRAIT(C, TRAIT_EMOTEMUTE, CHEM_TRAIT_SOURCE(class))

/datum/reagent/toxin/mimesbane/on_mob_end_metabolize(mob/living/carbon/C, class)
	if(class != CHEM_BLOOD)
		return
	REMOVE_TRAIT(C, TRAIT_EMOTEMUTE, CHEM_TRAIT_SOURCE(class))

/datum/reagent/toxin/bonehurtingjuice //oof ouch
	name = "Bone Hurting Juice"
	description = "A strange substance that looks a lot like water. Drinking it is oddly tempting. Oof ouch."
	silent_toxin = TRUE //no point spamming them even more.
	color = "#AAAAAA77" //RGBA: 170, 170, 170, 77
	toxpwr = 0
	taste_description = "bone hurting"
	overdose_threshold = 50

/datum/reagent/toxin/bonehurtingjuice/on_mob_metabolize(mob/living/carbon/C, class)
	if(class == CHEM_BLOOD)
		spawn(-1)
			C.say("oof ouch my bones", forced = /datum/reagent/toxin/bonehurtingjuice)

/datum/reagent/toxin/bonehurtingjuice/affect_blood(mob/living/carbon/C, removed)
	C.stamina.adjust(-7.5 * removed)
	if(prob(20))
		switch(rand(1, 2))
			if(1)
				spawn(-1)
					C.say(pick("oof.", "ouch.", "my bones.", "oof ouch.", "oof ouch my bones."), forced = /datum/reagent/toxin/bonehurtingjuice)
			if(2)
				to_chat(C, span_warning("Your bones hurt!"))

/datum/reagent/toxin/bonehurtingjuice/overdose_process(mob/living/carbon/C)
	if(prob(4)) //big oof
		var/selected_part = pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG) //God help you if the same limb gets picked twice quickly.
		var/obj/item/bodypart/bp = C.get_bodypart(selected_part)
		if(bp)
			if(bp.break_bones())
				playsound(C, get_sfx(SFX_DESECRATION), 50, TRUE, -1)
				spawn(-1)
					C.say("OOF!!", forced = /datum/reagent/toxin/bonehurtingjuice)
		else //SUCH A LUST FOR REVENGE!!!
			to_chat(C, span_warning("A phantom limb hurts!"))
			spawn(-1)
				C.say("Why are we still here, just to suffer?", forced = /datum/reagent/toxin/bonehurtingjuice)

/datum/reagent/toxin/bungotoxin
	name = "Bungotoxin"
	description = "A horrible cardiotoxin that protects the humble bungo pit."
	silent_toxin = TRUE
	color = "#EBFF8E"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	toxpwr = 0
	taste_description = "tannin"


/datum/reagent/toxin/bungotoxin/affect_blood(mob/living/carbon/C, removed)
	. = ..()
	C.adjustOrganLoss(ORGAN_SLOT_HEART, 3 * removed, updating_health = FALSE)

	// If our mob's currently dizzy from anything else, we will also gain confusion
	var/mob_dizziness = C.get_timed_status_effect_duration(/datum/status_effect/confusion)
	if(mob_dizziness > 0)
		// Gain confusion equal to about half the duration of our current dizziness
		C.set_timed_status_effect(mob_dizziness / 2, /datum/status_effect/confusion)

	if(current_cycle >= 12 && prob(8))
		var/tox_message = pick("You feel your heart spasm in your chest.", "You feel faint.","You feel you need to catch your breath.","You feel a prickle of pain in your chest.")
		to_chat(C, span_warning("[tox_message]"))

	return TRUE
/datum/reagent/toxin/leadacetate
	name = "Lead Acetate"
	description = "Used hundreds of years ago as a sweetener, before it was realized that it's incredibly poisonous."
	reagent_state = SOLID
	color = "#2b2b2b" // rgb: 127, 132, 0
	toxpwr = 0.5
	taste_mult = 1.3
	taste_description = "sugary sweetness"


/datum/reagent/toxin/leadacetate/affect_blood(mob/living/carbon/C, removed)
	C.adjustOrganLoss(ORGAN_SLOT_EARS, 1 * removed, updating_health = FALSE)
	C.adjustOrganLoss(ORGAN_SLOT_BRAIN, 1 * removed, updating_health = FALSE)
	if(prob(1))
		to_chat(C, span_notice("What was that? Did I hear something?"))
		C.adjust_timed_status_effect(5 SECONDS, /datum/status_effect/confusion)
	return ..() || TRUE

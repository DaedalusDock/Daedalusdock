/datum/reagent/water
	name = "Water"
	description = "An ubiquitous chemical substance that is composed of hydrogen and oxygen."
	color = "#AAAAAA77" // rgb: 170, 170, 170, 77 (alpha)
	taste_description = "water"
	glass_icon_state = "glass_clear"
	glass_name = "glass of water"
	glass_desc = "The father of all refreshments."
	shot_glass_icon_state = "shotglassclear"
	chemical_flags = REAGENT_CLEANS

	metabolization_rate = 2
	ingest_met = 2

/datum/reagent/water/expose_turf(turf/open/exposed_turf, reac_volume, exposed_temperature)
	. = ..()
	if(!istype(exposed_turf))
		return

	if(reac_volume >= 5)
		exposed_turf.MakeSlippery(TURF_WET_WATER, 10 SECONDS, min(reac_volume*1.5 SECONDS, 60 SECONDS))

	for(var/mob/living/simple_animal/slime/exposed_slime in exposed_turf)
		exposed_slime.apply_water()

	qdel(exposed_turf.active_hotspot)
	if(exposed_turf.simulated)
		var/datum/gas_mixture/air = exposed_turf.return_air()
		var/adjust_temp = abs(air.temperature - exposed_temperature) / air.group_multiplier
		if(air.temperature > exposed_temperature)
			adjust_temp *= -1
		air.temperature = max(air.temperature + adjust_temp, TCMB)

/datum/reagent/water/expose_obj(obj/exposed_obj, reac_volume, exposed_temperature)
	. = ..()
	exposed_obj.extinguish()
	exposed_obj.wash(CLEAN_TYPE_ACID)
	// Monkey cube
	if(istype(exposed_obj, /obj/item/food/monkeycube))
		var/obj/item/food/monkeycube/cube = exposed_obj
		cube.Expand()

	// Dehydrated carp
	else if(istype(exposed_obj, /obj/item/toy/plush/carpplushie/dehy_carp))
		var/obj/item/toy/plush/carpplushie/dehy_carp/dehy = exposed_obj
		dehy.Swell() // Makes a carp

	else if(istype(exposed_obj, /obj/item/stack/sheet/hairlesshide))
		var/obj/item/stack/sheet/hairlesshide/HH = exposed_obj
		new /obj/item/stack/sheet/wethide(get_turf(HH), HH.amount)
		qdel(HH)

/// How many wet stacks you get per units of water when it's applied by touch.
#define WATER_TO_WET_STACKS_FACTOR_TOUCH 0.5
/// How many wet stacks you get per unit of water when it's applied by vapor. Much less effective than by touch, of course.
#define WATER_TO_WET_STACKS_FACTOR_VAPOR 0.1
/*
 * Water reaction to a mob
 */
/datum/reagent/water/expose_mob(mob/living/exposed_mob, reac_volume, exposed_temperature = T20C, datum/reagents/source, methods=TOUCH, show_message = TRUE, touch_protection = 0)
	. = ..()
	if(methods & TOUCH)
		exposed_mob.adjust_wet_stacks(reac_volume * WATER_TO_WET_STACKS_FACTOR_TOUCH) // Water makes you wet, at a 50% water-to-wet-stacks ratio. Which, in turn, gives you some mild protection from being set on fire!

		if(ishuman(exposed_mob))
			var/mob/living/carbon/human/H = exposed_mob
			var/obj/item/clothing/mask/cigarette/S = H.wear_mask
			if (istype(S) && S.lit)
				var/obj/item/clothing/C = H.head
				if (!istype(C) || !(C.flags_cover & HEADCOVERSMOUTH))
					S.extinguish()

	if(methods & VAPOR)
		exposed_mob.adjust_wet_stacks(reac_volume * WATER_TO_WET_STACKS_FACTOR_VAPOR) // Spraying someone with water with the hope to put them out is just simply too funny to me not to add it.

/datum/reagent/water/affect_blood(mob/living/carbon/C, removed)
	. = ..()
	if(C.blood_volume)
		C.blood_volume += 0.05 * removed

#undef WATER_TO_WET_STACKS_FACTOR_TOUCH
#undef WATER_TO_WET_STACKS_FACTOR_VAPOR

/datum/reagent/water/holywater
	name = "Holy Water"
	description = "Water blessed by some deity."
	color = "#E0E8EF" // rgb: 224, 232, 239
	glass_icon_state = "glass_clear"
	glass_name = "glass of holy water"
	glass_desc = "A glass of holy water."
	self_consuming = TRUE //divine intervention won't be limited by the lack of a liver
	chemical_flags = REAGENT_CLEANS | REAGENT_IGNORE_MOB_SIZE
	touch_met = INFINITY
	ingest_met = INFINITY
	metabolization_rate = 1

// Holy water. Mostly the same as water, it also heals the plant a little with the power of the spirits. Also ALSO increases instability.
/datum/reagent/water/holywater/on_hydroponics_apply(datum/plant_tick/plant_tick, datum/reagents/chems, volume, obj/machinery/hydroponics/mytray, mob/user)
	if(volume >= 1)
		plant_tick.plant_health_delta += 0.2
		plant_tick.mutation_power += 0.1

/datum/reagent/water/holywater/on_mob_metabolize(mob/living/carbon/C, class)
	..()
	ADD_TRAIT(C, TRAIT_HOLY, CHEM_TRAIT_SOURCE(class))

/datum/reagent/water/holywater/on_mob_add(mob/living/L, amount)
	. = ..()
	if(data)
		data["misc"] = 0

/datum/reagent/water/holywater/on_mob_end_metabolize(mob/living/carbon/C, class)
	REMOVE_TRAIT(C, TRAIT_HOLY, CHEM_TRAIT_SOURCE(class))
	..()

/datum/reagent/water/holywater/expose_mob(mob/living/exposed_mob, reac_volume, exposed_temperature = T20C, datum/reagents/source, methods=TOUCH, show_message = TRUE, touch_protection = 0)
	. = ..()
	if(IS_CULTIST(exposed_mob))
		to_chat(exposed_mob, span_userdanger("A vile holiness begins to spread its shining tendrils through your mind, purging the Geometer of Blood's influence!"))

/datum/reagent/water/holywater/affect_ingest(mob/living/carbon/C, removed)
	SHOULD_CALL_PARENT(FALSE) //We're going straight into blood through jesus i guess
	holder.trans_to(C.bloodstream, volume)

/datum/reagent/water/holywater/affect_touch(mob/living/carbon/C, removed)
	. = ..()
	holder.trans_to(C.bloodstream, volume)

/datum/reagent/water/holywater/affect_blood(mob/living/carbon/C, removed)
	. = ..()

	C.adjust_timed_status_effect(1 SECONDS * removed, /datum/status_effect/jitter, max_duration = 20 SECONDS)
	if(IS_CULTIST(C))
		for(var/datum/action/innate/cult/blood_magic/BM in C.actions)
			to_chat(C, span_cultlarge("Your blood rites falter as holy water scours your body!"))
			for(var/datum/action/innate/cult/blood_spell/BS in BM.spells)
				qdel(BS)
	if(current_cycle >= 10)
		C.adjust_timed_status_effect(1 SECONDS * removed, /datum/status_effect/speech/stutter, max_duration = 20 SECONDS)
		C.set_timed_status_effect(10 SECONDS, /datum/status_effect/dizziness, only_if_higher = TRUE)
		if(IS_CULTIST(C) && prob(5))
			spawn(-1)
				C.say(pick("Av'te Nar'Sie","Pa'lid Mors","INO INO ORA ANA","SAT ANA!","Daim'niodeis Arc'iai Le'eones","R'ge Na'sie","Diabo us Vo'iscum","Eld' Mon Nobis"), forced = "holy water")
			if(prob(10))
				C.visible_message(span_danger("[C] starts having a seizure!"), span_userdanger("You have a seizure!"))
				C.Unconscious(12 SECONDS)
				to_chat(C, "<span class='cultlarge'>[pick("Your blood is your bond - you are nothing without it", "Do not forget your place", \
				"All that power, and you still fail?", "If you cannot scour this poison, I shall scour your meager life!")].</span>")

	if(current_cycle >= 30)
		if(IS_CULTIST(C))
			C.mind.remove_antag_datum(/datum/antagonist/cult)
			C.Unconscious(10 SECONDS)
		C.remove_status_effect(/datum/status_effect/jitter)
		C.remove_status_effect(/datum/status_effect/speech/stutter)
		holder.remove_reagent(type, volume) // maybe this is a little too perfect and a max() cap on the statuses would be better??
		return

/datum/reagent/water/holywater/expose_turf(turf/exposed_turf, reac_volume, exposed_temperature)
	. = ..()
	if(reac_volume >= 10)
		for(var/obj/effect/rune/R in exposed_turf)
			qdel(R)
		exposed_turf.Bless()

/datum/reagent/water/hollowwater
	name = "Hollow Water"
	description = "An ubiquitous chemical substance that is composed of hydrogen and oxygen, but it looks kinda hollow."
	color = "#88878777"
	taste_description = "emptyiness"


/datum/reagent/blood
	data = list(
		"viruses"=null,
		"blood_DNA"=null,
		"blood_type"=null,
		"resistances"=null,
		"trace_chem"=null,"mind"=null,
		"ckey"=null,"gender"=null,
		"real_name"=null,"cloneable"=null,
		"factions"=null,
		"quirks"=null
	)
	name = "Blood"
	description = "A suspension of organic cells necessary for the transport of oxygen. Keep inside at all times."
	color = "#C80000" // rgb: 200, 0, 0
	metabolization_rate = 5 //fast rate so it disappears fast.
	taste_description = "iron"
	taste_mult = 1.3
	glass_icon_state = "glass_red"
	glass_name = "glass of tomato juice"
	glass_desc = "Are you sure this is tomato juice?"
	shot_glass_icon_state = "shotglassred"
	penetrates_skin = NONE

/datum/reagent/blood/expose_mob(mob/living/exposed_mob, exposed_temperature, reac_volume, methods, show_message, touch_protection)
	. = ..()
	if(data?["viruses"])
		for(var/thing in data["viruses"])
			var/datum/pathogen/strain = thing

			if((strain.spread_flags & PATHOGEN_SPREAD_SPECIAL) || (strain.spread_flags & PATHOGEN_SPREAD_NON_CONTAGIOUS))
				continue

			if((methods & (TOUCH|VAPOR)) && (strain.spread_flags & PATHOGEN_SPREAD_CONTACT_FLUIDS))
				exposed_mob.try_contact_contract_pathogen(strain)


/datum/reagent/blood/affect_blood(mob/living/carbon/C, removed)
	if(isnull(data))
		return

	if(data["viruses"])
		for(var/datum/pathogen/strain as anything in data["viruses"])

			if((strain.spread_flags & (PATHOGEN_SPREAD_SPECIAL|PATHOGEN_SPREAD_NON_CONTAGIOUS)))
				continue

			C.try_contract_pathogen(strain)

	if(!(C.get_blood_id() == /datum/reagent/blood))
		return

	var/datum/blood/blood_type = data["blood_type"]

	if(isnull(blood_type) || !C.dna.blood_type.is_compatible(blood_type.type))
		C.reagents.add_reagent(/datum/reagent/toxin, removed)
	else
		C.adjustBloodVolume(round(removed, 0.1))

/datum/reagent/blood/affect_touch(mob/living/carbon/C, removed)
	for(var/datum/pathogen/strain as anything in data?["viruses"])

		if((strain.spread_flags & PATHOGEN_SPREAD_SPECIAL) || (strain.spread_flags & PATHOGEN_SPREAD_NON_CONTAGIOUS))
			continue

		if(strain.spread_flags & PATHOGEN_SPREAD_CONTACT_FLUIDS)
			C.try_contact_contract_pathogen(strain)

/datum/reagent/blood/on_new(list/data)
	. = ..()
	if(istype(data))
		SetViruses(src, data)

/datum/reagent/blood/on_merge(list/mix_data)
	if(data && mix_data)
		if(data["blood_type"] != mix_data["blood_type"])
			data["blood_type"] = GET_BLOOD_REF(/datum/blood/slurry)
		if(data["blood_DNA"] != mix_data["blood_DNA"])
			data["cloneable"] = 0 //On mix, consider the genetic sampling unviable for pod cloning if the DNA sample doesn't match.

		if(data["viruses"] || mix_data["viruses"])

			var/list/mix1 = data["viruses"]
			var/list/mix2 = mix_data["viruses"]

			// Stop issues with the list changing during mixing.
			var/list/to_mix = list()

			for(var/datum/pathogen/advance/AD in mix1)
				to_mix += AD
			for(var/datum/pathogen/advance/AD in mix2)
				to_mix += AD

			var/datum/pathogen/advance/AD = Advance_Mix(to_mix)
			if(AD)
				var/list/preserve = list(AD)
				for(var/D in data["viruses"])
					if(!istype(D, /datum/pathogen/advance))
						preserve += D
				data["viruses"] = preserve
	return 1

/datum/reagent/blood/proc/get_diseases()
	. = list()
	if(data && data["viruses"])
		for(var/thing in data["viruses"])
			var/datum/pathogen/D = thing
			. += D

/datum/reagent/blood/expose_turf(turf/exposed_turf, reac_volume)//splash the blood all over the place
	. = ..()
	if(!istype(exposed_turf))
		return
	if(reac_volume < 3)
		return

	var/obj/effect/decal/cleanable/blood/bloodsplatter = locate() in exposed_turf //find some blood here
	if(!bloodsplatter)
		bloodsplatter = new(exposed_turf, data["viruses"])
	else if(LAZYLEN(data["viruses"]))
		var/list/viri_to_add = list()
		for(var/datum/pathogen/virus in data["viruses"])
			if(virus.spread_flags & PATHOGEN_SPREAD_CONTACT_FLUIDS)
				viri_to_add += virus
		if(LAZYLEN(viri_to_add))
			bloodsplatter.AddComponent(/datum/component/infective, viri_to_add)
	if(data["blood_DNA"])
		bloodsplatter.add_blood_DNA(list(data["blood_DNA"] = data["blood_type"]))

/// Improvised reagent that induces vomiting. Created by dipping a dead mouse in welder fluid.
/datum/reagent/yuck
	name = "Organic Slurry"
	description = "A mixture of various colors of fluid. Induces vomiting."
	glass_name = "glass of ...yuck!"
	glass_desc = "It smells like a carcass, and doesn't look much better."
	color = "#545000"
	taste_description = "insides"
	taste_mult = 4
	ingest_met = 0.08
	var/yuck_cycle = 0 //! The `current_cycle` when puking starts.

/datum/reagent/yuck/on_mob_add(mob/living/L)
	. = ..()
	if(HAS_TRAIT(L, TRAIT_NOHUNGER)) //they can't puke
		holder.del_reagent(type)

#define YUCK_PUKE_CYCLES 3 // every X cycle is a puke
#define YUCK_PUKES_TO_STUN 3 // hit this amount of pukes in a row to start stunning
/datum/reagent/yuck/affect_ingest(mob/living/carbon/C, removed)
	if(!yuck_cycle)
		if(prob(10))
			var/dread = pick("Something is moving in your stomach...", \
				"A wet growl echoes from your stomach...", \
				"For a moment you feel like your surroundings are moving, but it's your stomach...")
			to_chat(C, span_warning("[dread]"))
			yuck_cycle = current_cycle
	else
		var/yuck_cycles = current_cycle - yuck_cycle
		if(yuck_cycles % YUCK_PUKE_CYCLES == 0)
			if(yuck_cycles >= YUCK_PUKE_CYCLES * YUCK_PUKES_TO_STUN)
				holder.remove_reagent(type, 5)
			C.vomit(rand(14, 26), stun = yuck_cycles >= YUCK_PUKE_CYCLES * YUCK_PUKES_TO_STUN)
	if(holder)
		return ..()

#undef YUCK_PUKE_CYCLES
#undef YUCK_PUKES_TO_STUN

/datum/reagent/yuck/on_mob_end_metabolize(mob/living/carbon/C)
	yuck_cycle = 0 // reset vomiting

/datum/reagent/yuck/on_transfer(atom/A, methods=TOUCH, trans_volume)
	if((methods & INGEST) || !iscarbon(A))
		return ..()

	A.reagents.remove_reagent(type, trans_volume)
	A.reagents.add_reagent(/datum/reagent/fuel, trans_volume * 0.75)
	A.reagents.add_reagent(/datum/reagent/water, trans_volume * 0.25)

	return ..()

/datum/reagent/hair_dye
	name = "Quantum Hair Dye"
	description = "Has a high chance of making you look like a mad scientist."
	reagent_state = LIQUID
	var/list/potential_colors = list("#00aadd","#aa00ff","#ff7733","#dd1144","#dd1144","#00bb55","#00aadd","#ff7733","#ffcc22","#008844","#0055ee","#dd2222","#ffaa00") // fucking hair code
	color = "#C8A5DC"
	taste_description = "sourness"
	penetrates_skin = NONE


/datum/reagent/hair_dye/New()
	SSticker.OnRoundstart(CALLBACK(src,PROC_REF(UpdateColor)))
	return ..()

/datum/reagent/hair_dye/proc/UpdateColor()
	color = pick(potential_colors)

/datum/reagent/hair_dye/affect_ingest(mob/living/carbon/C, removed) //What the fuck is wrong with you
	C.adjustToxLoss(2 * removed, FALSE, cause_of_death = "Ingesting hair dye")
	return ..() || TRUE

/datum/reagent/hair_dye/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message=TRUE, touch_protection=FALSE)
	. = ..()
	if(!(methods & (TOUCH|VAPOR)) || !ishuman(exposed_mob))
		return

	var/mob/living/carbon/human/exposed_human = exposed_mob
	exposed_human.hair_color = pick(potential_colors)
	exposed_human.facial_hair_color = pick(potential_colors)
	exposed_human.update_body_parts()

//////////////////////////////////Hydroponics stuff///////////////////////////////

/datum/reagent/plantnutriment
	name = "Generic Nutriment"
	description = "Some kind of nutriment. You can't really tell what it is. You should probably report it, along with how you obtained it."
	color = "#000000" // RBG: 0, 0, 0
	var/tox_prob = 0
	taste_description = "plant food"

/datum/reagent/plantnutriment/affect_blood(mob/living/carbon/C, removed)
	if(prob(tox_prob *2))
		C.adjustToxLoss(1 * removed, 0, cause_of_death = "Plant nutriment poisoning")
		. = TRUE

/datum/reagent/plantnutriment/eznutriment
	name = "E-Z-Nutrient"
	description = "Contains electrolytes. It's what plants crave."
	color = "#376400" // RBG: 50, 100, 0
	tox_prob = 5


/datum/reagent/plantnutriment/eznutriment/on_hydroponics_apply(datum/plant_tick/plant_tick, datum/reagents/chems, volume, obj/machinery/hydroponics/mytray, mob/user)
	if(volume >= 1)
		plant_tick.potency_mod += 0.5
		plant_tick.plant_growth_delta += 2.5
		#ifndef UNIT_TESTS
		plant_tick.mutation_power += 0.1
		#endif
		plant_tick.yield_mod += 0.2

/datum/reagent/plantnutriment/left4zednutriment
	name = "Left 4 Zed"
	description = "Unstable nutriment that makes plants mutate more often than usual."
	color = "#1A1E4D" // RBG: 26, 30, 77
	tox_prob = 13


/datum/reagent/plantnutriment/left4zednutriment/on_hydroponics_apply(datum/plant_tick/plant_tick, datum/reagents/chems, volume, obj/machinery/hydroponics/mytray, mob/user)
	if(volume >= 1)
		plant_tick.plant_health_delta += 1
		plant_tick.mutation_power += 0.8

/datum/reagent/plantnutriment/robustharvestnutriment
	name = "Robust Harvest"
	description = "Very potent nutriment that slows plants from mutating."
	color = "#9D9D00" // RBG: 157, 157, 0
	tox_prob = 8


/datum/reagent/plantnutriment/robustharvestnutriment/on_hydroponics_apply(datum/plant_tick/plant_tick, datum/reagents/chems, volume, obj/machinery/hydroponics/mytray, mob/user)
	if(volume >= 1)
		plant_tick.mutation_power -= 0.25
		plant_tick.potency_mod += 0.1
		plant_tick.yield_mod += 0.1

/datum/reagent/plantnutriment/endurogrow
	name = "Enduro Grow"
	description = "A specialized nutriment, which decreases product quantity and potency, but strengthens the plants endurance."
	color = "#a06fa7" // RBG: 160, 111, 167
	tox_prob = 8


/datum/reagent/plantnutriment/endurogrow/on_hydroponics_apply(datum/plant_tick/plant_tick, datum/reagents/chems, volume, obj/machinery/hydroponics/mytray, mob/user)
	if(volume >= 1)
		plant_tick.endurance_mod += 0.35
		plant_tick.potency_mod -= 0.15
		plant_tick.yield_mod -= 0.15

/datum/reagent/plantnutriment/liquidearthquake
	name = "Liquid Earthquake"
	description = "A specialized nutriment, which increases the plant's production speed, as well as it's susceptibility to weeds."
	color = "#912e00" // RBG: 145, 46, 0
	tox_prob = 13


/datum/reagent/plantnutriment/liquidearthquake/on_hydroponics_apply(datum/plant_tick/plant_tick, datum/reagents/chems, volume, obj/machinery/hydroponics/mytray, mob/user)
	if(volume >= 1)
		plant_tick.production_mod -= 0.2

// Bee chemicals

/datum/reagent/royal_bee_jelly
	name = "Royal Bee Jelly"
	description = "Royal Bee Jelly, if injected into a Queen Space Bee said bee will split into two bees."
	color = "#00ff80"
	taste_description = "strange honey"


/datum/reagent/royal_bee_jelly/affect_blood(mob/living/carbon/C, removed)
	if(prob(1))
		spawn(-1)
			C.say(pick("Bzzz...","BZZ BZZ","Bzzzzzzzzzzz..."), forced = "royal bee jelly")

//Misc reagents

/datum/reagent/romerol
	name = "Romerol"
	// the REAL zombie powder
	description = "Romerol is a highly experimental bioterror agent \
		which causes dormant nodules to be etched into the grey matter of \
		the subject. These nodules only become active upon death of the \
		host, upon which, the secondary structures activate and take control \
		of the host body."
	color = "#123524" // RGB (18, 53, 36)
	metabolization_rate = INFINITY
	taste_description = "brains"

/datum/reagent/romerol/expose_mob(mob/living/exposed_mob, reac_volume, exposed_temperature = T20C, datum/reagents/source, methods=TOUCH, show_message = TRUE, touch_protection = 0)
	. = ..()
	// Silently add the zombie infection organ to be activated upon death
	if(!exposed_mob.getorganslot(ORGAN_SLOT_ZOMBIE))
		var/obj/item/organ/zombie_infection/nodamage/ZI = new()
		ZI.Insert(exposed_mob)

// Virology virus food chems.

/datum/reagent/toxin/mutagen/mutagenvirusfood
	name = "Mutagenic Agar"
	color = "#A3C00F" // rgb: 163,192,15
	taste_description = "sourness"


/datum/reagent/toxin/mutagen/mutagenvirusfood/sugar
	name = "Sucrose Agar"
	color = "#41B0C0" // rgb: 65,176,192
	taste_description = "sweetness"


/datum/reagent/medicine/synaptizine/synaptizinevirusfood
	name = "Virus Rations"
	color = "#D18AA5" // rgb: 209,138,165
	taste_description = "bitterness"


/datum/reagent/toxin/plasma/plasmavirusfood
	name = "Virus Plasma"
	color = "#A270A8" // rgb: 166,157,169
	taste_description = "bitterness"
	taste_mult = 1.5


/datum/reagent/toxin/plasma/plasmavirusfood/weak
	name = "Weakened Virus Plasma"
	color = "#A28CA5" // rgb: 206,195,198
	taste_description = "bitterness"
	taste_mult = 1.5


/datum/reagent/uranium/uraniumvirusfood
	name = "Decaying Uranium Gel"
	color = "#67ADBA" // rgb: 103,173,186
	taste_description = "the inside of a reactor"


/datum/reagent/uranium/uraniumvirusfood/unstable
	name = "Unstable Uranium Gel"
	color = "#2FF2CB" // rgb: 47,242,203
	taste_description = "the inside of a reactor"


/datum/reagent/uranium/uraniumvirusfood/stable
	name = "Stable Uranium Gel"
	color = "#04506C" // rgb: 4,80,108
	taste_description = "the inside of a reactor"


/datum/reagent/technetium
	name = "Technetium 99"
	description = "A radioactive tracer agent that can improve a scanner's ability to detect internal organ damage. Will poison the patient when present very slowly, purging or using a low dose is recommended after use."
	metabolization_rate = 0.2

/datum/reagent/technetium/affect_blood(mob/living/carbon/C, removed)
	if(!(current_cycle % 8))
		C.adjustToxLoss(5 * removed, FALSE, cause_of_death = "Technetium 99 poisoning")
		. = TRUE

/datum/reagent/helgrasp
	name = "Helgrasp"
	description = "This rare and forbidden concoction is thought to bring you closer to the grasp of the Norse goddess Hel."
	metabolization_rate = 0.4  //This is fast
	//Keeps track of the hand timer so we can cleanup on removal
	var/list/timer_ids

//Warns you about the impenting hands
/datum/reagent/helgrasp/on_mob_add(mob/living/L, amount)
	to_chat(L, span_hierophant("You hear laughter as malevolent hands apparate before you, eager to drag you down to hell...! Look out!"))
	playsound(L.loc, 'sound/chemistry/ahaha.ogg', 80, TRUE, -1) //Very obvious tell so people can be ready
	. = ..()

/datum/reagent/helgrasp/affect_blood(mob/living/carbon/C, removed)
	spawn(-1)
		spawn_hands(C)
	var/hands = 1
	var/time = 1
	while(hands < 2) //we already made a hand now so start from 1
		LAZYADD(timer_ids, addtimer(CALLBACK(src, PROC_REF(spawn_hands), C), (time*hands) SECONDS, TIMER_STOPPABLE)) //keep track of all the timers we set up
		hands += time

/datum/reagent/helgrasp/proc/spawn_hands(mob/living/carbon/owner)
	if(!owner && iscarbon(holder.my_atom))//Catch timer
		owner = holder.my_atom
	//Adapted from the end of the curse - but lasts a short time
	var/grab_dir = turn(owner.dir, pick(-90, 90, 180, 180)) //grab them from a random direction other than the one faced, favoring grabbing from behind
	var/turf/spawn_turf = get_ranged_target_turf(owner, grab_dir, 8)//Larger range so you have more time to dodge
	if(!spawn_turf)
		return
	new/obj/effect/temp_visual/dir_setting/curse/grasp_portal(spawn_turf, owner.dir)
	playsound(spawn_turf, 'sound/effects/curse2.ogg', 80, TRUE, -1)
	var/obj/projectile/curse_hand/hel/hand = new (spawn_turf)
	hand.preparePixelProjectile(owner, spawn_turf)
	if(QDELETED(hand)) //safety check if above fails - above has a stack trace if it does fail
		return
	hand.fire()

//At the end, we clear up any loose hanging timers just in case and spawn any remaining lag_remaining hands all at once.
/datum/reagent/helgrasp/on_mob_delete(mob/living/owner)
	for(var/id in timer_ids) // So that we can be certain that all timers are deleted at the end.
		deltimer(id)
	timer_ids.Cut()
	return ..()

/datum/reagent/helgrasp/heretic
	name = "Grasp of the Mansus"
	description = "The Hand of the Mansus is at your neck."
	metabolization_rate = 0.2

// unholy water, but for heretics.
// why couldn't they have both just used the same reagent?
// who knows.
// maybe nar'sie is considered to be too "mainstream" of a god to worship in the heretic community.
/datum/reagent/eldritch
	name = "Eldritch Essence"
	description = "A strange liquid that defies the laws of physics. \
		It re-energizes and heals those who can see beyond this fragile reality, \
		but is incredibly harmful to the closed-minded. It metabolizes very quickly."
	taste_description = "Ag'hsj'saje'sh"
	color = "#1f8016"
	metabolization_rate = 2.5 * REAGENTS_METABOLISM  //0.5u/second
	chemical_flags = REAGENT_NO_RANDOM_RECIPE

/datum/reagent/eldritch/affect_blood(mob/living/carbon/drinker, removed)
	. = ..()
	if(IS_HERETIC(drinker))
		drinker.adjust_drowsyness(-5 * removed)
		drinker.AdjustAllImmobility(-40 * removed)
		drinker.stamina.adjust(-10 * removed)
		drinker.adjustToxLoss(-2 * removed, FALSE, forced = TRUE)
		drinker.adjustOxyLoss(-2 * removed, FALSE)
		drinker.adjustBruteLoss(-2 * removed, FALSE)
		drinker.adjustFireLoss(-2 * removed, FALSE)
		if(drinker.blood_volume < BLOOD_VOLUME_NORMAL)
			drinker.blood_volume += 3 * removed
	else
		drinker.adjustOrganLoss(ORGAN_SLOT_BRAIN, 3 * removed, 150, updating_health = FALSE)
		drinker.adjustToxLoss(2 * removed, FALSE, cause_of_death = "The devil")
		drinker.adjustFireLoss(2 * removed, FALSE)
		drinker.adjustOxyLoss(2 * removed, FALSE)
		drinker.adjustBruteLoss(2 * removed, FALSE)
	return TRUE

/datum/reagent/cellulose
	name = "Cellulose Fibers"
	description = "A crystaline polydextrose polymer, plants swear by this stuff."
	reagent_state = SOLID
	color = "#E6E6DA"
	taste_mult = 0


/datum/reagent/diethylamine
	name = "Diethylamine"
	description = "A secondary amine, mildly corrosive."
	color = "#604030" // rgb: 96, 64, 48
	taste_description = "iron"


// This is more bad ass, and pests get hurt by the corrosive nature of it, not the plant. The new trade off is it culls stability.
/datum/reagent/diethylamine/on_hydroponics_apply(datum/plant_tick/plant_tick, datum/reagents/chems, volume, obj/machinery/hydroponics/mytray, mob/user)
	. = ..()
	if(volume >= 1)
		plant_tick.plant_growth_delta += 1.2

/datum/reagent/pax
	name = "Pax 400"
	description = "A colorless liquid that suppresses violence in its subjects."
	color = "#AAAAAA55"
	taste_description = "water"
	metabolization_rate = 0.05

/datum/reagent/pax/on_mob_metabolize(mob/living/carbon/C, class)
	if(class != CHEM_BLOOD)
		return
	ADD_TRAIT(C, TRAIT_PACIFISM, CHEM_TRAIT_SOURCE(class))

/datum/reagent/pax/on_mob_end_metabolize(mob/living/carbon/C, class)
	if(class != CHEM_BLOOD)
		return
	REMOVE_TRAIT(C, TRAIT_PACIFISM, CHEM_TRAIT_SOURCE(class))

/datum/reagent/monkey_powder
	name = "Monkey Powder"
	description = "Just add water!"
	color = "#9C5A19"
	taste_description = "bananas"


/datum/reagent/liquidgibs
	name = "Liquid Gibs"
	color = "#CC4633"
	description = "You don't even want to think about what's in here."
	taste_description = "gross iron"
	shot_glass_icon_state = "shotglassred"
	material = /datum/material/meat


/datum/reagent/fuel/unholywater //if you somehow managed to extract this from someone, dont splash it on yourself and have a smoke
	name = "Unholy Water"
	description = "Something that shouldn't exist on this plane of existence."
	taste_description = "suffering"
	metabolization_rate = 2.5 * REAGENTS_METABOLISM  //0.5u/second
	penetrates_skin = TOUCH|VAPOR


/datum/reagent/fuel/unholywater/affect_blood(mob/living/carbon/C, removed)
	if(IS_CULTIST(C))
		C.adjust_drowsyness(-5* removed)
		C.AdjustAllImmobility(-40 * removed)
		C.stamina.adjust(10 * removed)
		C.adjustToxLoss(-2 * removed, 0)
		C.adjustOxyLoss(-2 * removed, 0)
		C.adjustBruteLoss(-2 * removed, 0)
		C.adjustFireLoss(-2 * removed, 0)
		if(ishuman(C) && C.blood_volume < BLOOD_VOLUME_NORMAL)
			C.blood_volume += 3 * removed
	else  // Will deal about 90 damage when 50 units are thrown
		C.adjustOrganLoss(ORGAN_SLOT_BRAIN, 3 * removed, 150, updating_health = FALSE)
		C.adjustToxLoss(1 * removed, 0, cause_of_death = "The devil")
		C.adjustFireLoss(1 * removed, 0)
		C.adjustOxyLoss(1 * removed, 0)
		C.adjustBruteLoss(1 * removed, 0)

	return TRUE


/datum/reagent/glitter
	name = "Generic Glitter"
	description = "if you can see this description, contact a coder."
	color = "#FFFFFF" //pure white
	taste_description = "plastic"
	reagent_state = SOLID
	var/glitter_type = /obj/effect/decal/cleanable/glitter


/datum/reagent/glitter/expose_turf(turf/exposed_turf, reac_volume)
	. = ..()
	if(!istype(exposed_turf))
		return
	new glitter_type(exposed_turf)

/datum/reagent/glitter/pink
	name = "Pink Glitter"
	description = "pink sparkles that get everywhere"
	color = "#ff8080" //A light pink color
	glitter_type = /obj/effect/decal/cleanable/glitter/pink


/datum/reagent/glitter/white
	name = "White Glitter"
	description = "white sparkles that get everywhere"
	glitter_type = /obj/effect/decal/cleanable/glitter/white


/datum/reagent/glitter/blue
	name = "Blue Glitter"
	description = "blue sparkles that get everywhere"
	color = "#4040FF" //A blueish color
	glitter_type = /obj/effect/decal/cleanable/glitter/blue


/datum/reagent/mulligan
	name = "Mulligan Toxin"
	description = "This toxin will rapidly change the DNA of living creatures."
	color = "#5EFF3B" //RGB: 94, 255, 59
	metabolization_rate = INFINITY
	taste_description = "slime"


/datum/reagent/mulligan/affect_blood(mob/living/carbon/human/H, removed)
	if(!istype(H))
		return
	var/datum/reagents/R = H.get_ingested_reagents()
	if(R)
		R.del_reagent(type)
	to_chat(H, span_warning("You grit your teeth in pain as your body rapidly mutates!"))
	H.visible_message(span_danger("[H]'s skin melts away, as they morph into a new form!"))
	randomize_human(H)
	H.dna.update_dna_identity()


/datum/reagent/lye
	name = "Sodium Hydroxide"
	description = "Also known as Lye. As a profession making this is somewhat underwhelming."
	reagent_state = LIQUID
	color = "#FFFFD6" // very very light yellow
	taste_description = "acid"


/datum/reagent/vaccine
	//data must contain virus type
	name = "Vaccine"
	description = "A suspension of degraded viral material suitable for use in inoculation."
	color = "#C81040" // rgb: 200, 16, 64
	taste_description = "slime"
	penetrates_skin = NONE

/datum/reagent/vaccine/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message=TRUE, touch_protection=0)
	. = ..()
	if(!islist(data) || !(methods & (INGEST|INJECT)))
		return

	for(var/thing in exposed_mob.diseases)
		var/datum/pathogen/infection = thing
		if(infection.get_id() in data)
			infection.force_cure()
	LAZYOR(exposed_mob.disease_resistances, data)

/datum/reagent/vaccine/affect_blood(mob/living/carbon/C, removed)
	if(!islist(data))
		return
	for(var/thing in C.diseases)
		var/datum/pathogen/infection = thing
		if(infection.get_id() in data)
			infection.force_cure()
	LAZYOR(C.disease_resistances, data)


/datum/reagent/vaccine/on_merge(list/data)
	if(istype(data))
		src.data |= data.Copy()

/datum/reagent/vaccine/fungal_tb
	name = "Vaccine (Fungal Tuberculosis)"
	description = "A suspension of degraded viral material suitable for use in inoculation. Taggants suspended in the solution report it to be targeting Fungal Tuberculosis."

/datum/reagent/vaccine/fungal_tb/New(data)
	. = ..()
	var/list/cached_data
	if(!data)
		cached_data = list()
	else
		cached_data = data
	cached_data |= "[/datum/pathogen/tuberculosis]"
	src.data = cached_data

/datum/reagent/barbers_aid
	name = "Barber's Aid"
	description = "A solution to hair loss across the world."
	reagent_state = LIQUID
	color = "#A86B45" //hair is brown
	taste_description = "sourness"
	penetrates_skin = NONE


/datum/reagent/barbers_aid/affect_touch(mob/living/carbon/C, removed)
	var/mob/living/carbon/human/exposed_human = C
	var/datum/sprite_accessory/hair/picked_hair = pick(GLOB.hairstyles_list)
	var/datum/sprite_accessory/facial_hair/picked_beard = pick(GLOB.facial_hairstyles_list)
	to_chat(exposed_human, span_notice("Hair starts sprouting from your scalp."))
	exposed_human.hairstyle = picked_hair
	exposed_human.facial_hairstyle = picked_beard
	exposed_human.update_body_parts()

	holder.del_reagent(type)

/datum/reagent/growthserum
	name = "Growth Serum"
	description = "A commercial chemical designed to help older men in the bedroom."//not really it just makes you a giant
	color = "#ff0000"//strong red. rgb 255, 0, 0
	var/current_size = RESIZE_DEFAULT_SIZE
	taste_description = "bitterness" // apparently what viagra tastes like


/datum/reagent/growthserum/affect_blood(mob/living/carbon/C, removed)
	var/newsize = current_size
	switch(volume)
		if(0 to 19)
			newsize = 1.25*RESIZE_DEFAULT_SIZE
		if(20 to 49)
			newsize = 1.5*RESIZE_DEFAULT_SIZE
		if(50 to 99)
			newsize = 2*RESIZE_DEFAULT_SIZE
		if(100 to 199)
			newsize = 2.5*RESIZE_DEFAULT_SIZE
		if(200 to INFINITY)
			newsize = 3.5*RESIZE_DEFAULT_SIZE

	C.update_transform(newsize/current_size)
	current_size = newsize

/datum/reagent/growthserum/on_mob_end_metabolize(mob/living/carbon/C, class)
	if(class != CHEM_BLOOD)
		return

	C.update_transform(RESIZE_DEFAULT_SIZE/current_size)
	current_size = RESIZE_DEFAULT_SIZE

/datum/reagent/impedrezene // Impairs mental function correctly, takes an overwhelming dose to kill.
	name = "Impedrezene"
	description = "Impedrezene is a narcotic that impedes one's ability by slowing down the higher brain cell functions."
	taste_description = "numbness"
	reagent_state = LIQUID
	color = "#c8a5dc"
	overdose_threshold = 30
	value = 1.8

/datum/reagent/impedrezene/on_mob_metabolize(mob/living/carbon/C, class)
	ADD_TRAIT(C, TRAIT_IMPEDREZENE, CHEM_TRAIT_SOURCE(class))
	C.add_movespeed_modifier(/datum/movespeed_modifier/impedrezene)

/datum/reagent/impedrezene/affect_blood(mob/living/carbon/C, removed)
	C.set_jitter_if_lower(10 SECONDS)

	if(prob(80))
		C.set_timed_status_effect(10 SECONDS, /datum/status_effect/confusion, only_if_higher = TRUE)
	if(prob(50))
		C.drowsyness = max(C.drowsyness, 3)
	if(prob(10))
		spawn(-1)
			C.emote("drool")
		C.set_timed_status_effect(10 SECONDS, /datum/status_effect/speech/stutter, only_if_higher = TRUE)

	var/obj/item/organ/brain/B = C.getorganslot(ORGAN_SLOT_BRAIN)
	if(B)
		if (B.damage < 60)
			C.adjustOrganLoss(ORGAN_SLOT_BRAIN, 14 * removed, updating_health = FALSE)
		else
			C.adjustOrganLoss(ORGAN_SLOT_BRAIN, 7 * removed, updating_health = FALSE)
	return TRUE

/datum/reagent/impedrezene/on_mob_metabolize(mob/living/carbon/C, class)
	REMOVE_TRAIT(C, TRAIT_IMPEDREZENE, CHEM_TRAIT_SOURCE(class))
	if(!HAS_TRAIT_FROM(C, TRAIT_IMPEDREZENE, CHEM_TRAIT_SOURCE(CHEM_BLOOD)))
		C.remove_movespeed_modifier(/datum/movespeed_modifier/impedrezene)

/datum/reagent/brimdust
	name = "Brimdust"
	description = "A brimdemon's dust. Consumption is not recommended, although plants like it."
	reagent_state = SOLID
	color = "#522546"
	taste_description = "burning"


/datum/reagent/brimdust/affect_blood(mob/living/carbon/C, removed)
	C.adjustFireLoss((ispodperson(C) ? -1 : 1) * removed, FALSE)
	return TRUE

/datum/reagent/brimdust/on_hydroponics_apply(datum/plant_tick/plant_tick, datum/reagents/chems, volume, obj/machinery/hydroponics/mytray, mob/user)
	if(volume >= 1)
		plant_tick.potency_mod += 0.5
		plant_tick.plant_health_delta += 0.5

/datum/reagent/spider_extract
	name = "Spider Extract"
	description = "A highly specialized extract coming from the Australicus sector, used to create broodmother spiders."
	color = "#ED2939"
	taste_description = "upside down"

/datum/reagent/bone_dust
	name = "Bone Dust"
	color = "#dbcdcb"
	description = "Ground up bones."
	taste_description = "the most disgusting grain in existence"

/datum/reagent/saltpetre
	name = "Saltpetre"
	description = "Volatile. Controversial. Third Thing."
	reagent_state = LIQUID
	color = "#60A584" // rgb: 96, 165, 132
	taste_description = "cool salt"


// Saltpetre is used for gardening IRL, to simplify highly, it speeds up growth and strengthens plants
/datum/reagent/saltpetre/on_hydroponics_apply(datum/plant_tick/plant_tick, datum/reagents/chems, volume, obj/machinery/hydroponics/mytray, mob/user)
	if(volume >= 1)
		plant_tick.plant_growth_delta += 2.5
		plant_tick.potency_mod += 0.5

		if(mytray.growing.gene_holder.harvest_yield > 1)
			plant_tick.yield_mod -= 0.25

/datum/reagent/saltpetre/infuse_plant(datum/plant/plant_datum, datum/plant_gene_holder/plant_dna, list/damage_ref)
	. = ..()
	plant_dna.potency += rand(2, 8)
	plant_dna.harvest_yield += rand(0, 2)

/datum/reagent/cordiolis_hepatico
	name = "Cordiolis Hepatico"
	description = "A strange, pitch-black reagent that seems to absorb all light. Effects unknown."
	color = "#000000"
	self_consuming = TRUE
	chemical_flags = REAGENT_NO_RANDOM_RECIPE

/datum/reagent/cordiolis_hepatico/on_mob_add(mob/living/carbon/C, amount, class)
	if(class == CHEM_BLOOD)
		ADD_TRAIT(C, TRAIT_STABLELIVER, type)
		ADD_TRAIT(C, TRAIT_STABLEHEART, type)

/datum/reagent/cordiolis_hepatico/on_mob_delete(mob/living/carbon/C, class)
	if(class == CHEM_BLOOD)
		REMOVE_TRAIT(C, TRAIT_STABLEHEART, type)
		REMOVE_TRAIT(C, TRAIT_STABLELIVER, type)

/datum/reagent/metafactor
	name = "Mitogen Metabolism Factor"
	description = "This enzyme catalyzes the conversion of nutricious food into healing peptides."
	metabolization_rate = 0.0625 * 0.2 //slow metabolism rate so the patient can self heal with food even after the troph has metabolized away for amazing reagent efficency.
	reagent_state = SOLID
	color = "#FFBE00"
	overdose_threshold = 10


/datum/reagent/metafactor/overdose_start(mob/living/carbon/C)
	metabolization_rate = 0.4

/datum/reagent/metafactor/overdose_process(mob/living/carbon/C)
	if(prob(10))
		C.vomit()

/datum/reagent/fungalspores
	name = "Tubercle Bacillus Cosmosis Microbes"
	description = "Active fungal spores."
	color = "#92D17D" // rgb: 146, 209, 125
	taste_description = "slime"
	penetrates_skin = NONE
	ingest_met = INFINITY
	touch_met = INFINITY
	metabolization_rate = INFINITY

/datum/reagent/fungalspores/affect_ingest(mob/living/carbon/C, removed)
	C.try_contract_pathogen(new /datum/pathogen/tuberculosis(), FALSE, TRUE)
	return ..()

/datum/reagent/fungalspores/affect_blood(mob/living/carbon/C, removed)
	C.try_contract_pathogen(new /datum/pathogen/tuberculosis(), FALSE, TRUE)

/datum/reagent/fungalspores/affect_touch(mob/living/carbon/C, removed)
	if(prob(min(volume,100)*(1 - C.get_permeability_protection())))
		C.try_contract_pathogen(new /datum/pathogen/tuberculosis(), FALSE, TRUE)


#define CRYO_SPEED_PREFACTOR 0.4
#define CRYO_SPEED_CONSTANT 0.1

/datum/reagent/glycerol
	name = "Glycerol"
	description = "Glycerol is a simple polyol compound. Glycerol is sweet-tasting and of low toxicity."
	color = "#D3B913"
	taste_description = "sweetness"

/datum/reagent/cryptobiolin
	name = "Cryptobiolin"
	description = "Cryptobiolin causes confusion and dizziness."
	color = "#ADB5DB" //i hate default violets and 'crypto' keeps making me think of cryo so it's light blue now
	metabolization_rate = 0.3
	taste_description = "sourness"

/datum/reagent/cryptobiolin/affect_blood(mob/living/carbon/C, removed)
	. = ..()
	C.set_timed_status_effect(2 SECONDS, /datum/status_effect/dizziness, only_if_higher = TRUE)

	// Cryptobiolin adjusts the mob's confusion down to 20 seconds if it's higher,
	// or up to 1 second if it's lower, but will do nothing if it's in between
	var/confusion_left = C.get_timed_status_effect_duration(/datum/status_effect/confusion)
	if(confusion_left < 1 SECONDS)
		C.set_timed_status_effect(1 SECONDS, /datum/status_effect/confusion)

	else if(confusion_left > 20 SECONDS)
		C.set_timed_status_effect(20 SECONDS, /datum/status_effect/confusion)

//used for changeling's adrenaline power
/datum/reagent/medicine/changelingadrenaline
	name = "Changeling Adrenaline"
	description = "Reduces the duration of unconciousness, knockdown and stuns. Restores stamina, but deals toxin damage when overdosed."
	color = "#C1151D"
	overdose_threshold = 30
	chemical_flags = REAGENT_NO_RANDOM_RECIPE

/datum/reagent/medicine/changelingadrenaline/affect_blood(mob/living/carbon/C, removed)
	C.AdjustAllImmobility(-20 * removed)
	C.stamina.adjust(10 * removed)
	C.set_timed_status_effect(20 SECONDS * removed, /datum/status_effect/jitter, only_if_higher = TRUE)
	C.set_timed_status_effect(20 SECONDS * removed, /datum/status_effect/dizziness, only_if_higher = TRUE)
	return TRUE

/datum/reagent/medicine/changelingadrenaline/on_mob_metabolize(mob/living/carbon/C, class)
	if(class == CHEM_BLOOD)
		ADD_TRAIT(C, TRAIT_SLEEPIMMUNE, type)
		ADD_TRAIT(C, TRAIT_STUNRESISTANCE, type)
		C.add_movespeed_mod_immunities(type, /datum/movespeed_modifier/pain)

/datum/reagent/medicine/changelingadrenaline/on_mob_end_metabolize(mob/living/carbon/C, class)
	if(class == CHEM_BLOOD)
		REMOVE_TRAIT(C, TRAIT_SLEEPIMMUNE, type)
		REMOVE_TRAIT(C, TRAIT_STUNRESISTANCE, type)
		C.remove_movespeed_mod_immunities(type, /datum/movespeed_modifier/pain)
		C.remove_status_effect(/datum/status_effect/dizziness)
		C.remove_status_effect(/datum/status_effect/jitter)

/datum/reagent/medicine/changelingadrenaline/overdose_process(mob/living/carbon/C)
	C.adjustToxLoss(0.2, 0, cause_of_death = "Changeling adrenaline overdose")
	return TRUE

/datum/reagent/medicine/changelinghaste
	name = "Changeling Haste"
	description = "Drastically increases movement speed, but deals toxin damage."
	color = "#AE151D"
	metabolization_rate = 0.5
	chemical_flags = REAGENT_NO_RANDOM_RECIPE

/datum/reagent/medicine/changelinghaste/on_mob_metabolize(mob/living/carbon/C, class)
	if(class == CHEM_BLOOD)
		C.add_movespeed_modifier(/datum/movespeed_modifier/reagent/changelinghaste)

/datum/reagent/medicine/changelinghaste/on_mob_end_metabolize(mob/living/carbon/C, class)
	if(class == CHEM_BLOOD)
		C.remove_movespeed_modifier(/datum/movespeed_modifier/reagent/changelinghaste)

/datum/reagent/medicine/changelinghaste/affect_blood(mob/living/carbon/C, removed)
	C.adjustToxLoss(0.2, 0, cause_of_death = "Changeling haste")
	return TRUE

/datum/reagent/gold
	name = "Gold"
	description = "Gold is a dense, soft, shiny metal and the most malleable and ductile metal known."
	reagent_state = SOLID
	color = "#F7C430" // rgb: 247, 196, 48
	taste_description = "expensive metal"
	material = /datum/material/gold

/datum/reagent/nitrous_oxide
	name = "Nitrous Oxide"
	description = "A potent oxidizer used as fuel in rockets and as an anaesthetic during surgery."
	reagent_state = LIQUID
	metabolization_rate = 0.3
	color = "#808080"
	taste_description = "sweetness"

/datum/reagent/nitrous_oxide/expose_turf(turf/open/exposed_turf, reac_volume)
	. = ..()
	if(istype(exposed_turf))
		var/temp = holder ? holder.chem_temp : T20C
		exposed_turf.assume_gas(GAS_N2O, reac_volume / REAGENT_GAS_EXCHANGE_FACTOR, temp)

/datum/reagent/nitrous_oxide/expose_mob(mob/living/exposed_mob, reac_volume, exposed_temperature = T20C, datum/reagents/source, methods=TOUCH, show_message = TRUE, touch_protection = 0)
	. = ..()
	if(methods & VAPOR)
		exposed_mob.adjust_drowsyness(max(round(reac_volume, 1), 2))

/datum/reagent/nitrous_oxide/affect_blood(mob/living/carbon/C, removed)
	. = ..()
	C.adjust_drowsyness(2 * removed)
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		H.adjustBloodVolume(-10 * removed)

	if(prob(20))
		C.losebreath += 2
		C.adjust_timed_status_effect(2 SECONDS, /datum/status_effect/confusion, max_duration = 5 SECONDS)

/datum/reagent/slug_slime
	name = "Antibiotic Slime"
	description = "Cleansing slime extracted from a slug. Great for cleaning surfaces, or sterilization before surgery."
	reagent_state = LIQUID
	color = "#c4dfa1"
	taste_description = "sticky mouthwash"

/datum/reagent/slug_slime/expose_turf(turf/open/exposed_turf, reac_volume)
	. = ..()
	if(!istype(exposed_turf))
		return
	if(reac_volume >= 1)
		exposed_turf.MakeSlippery(TURF_WET_WATER, 15 SECONDS, min(reac_volume * 1 SECONDS, 40 SECONDS))

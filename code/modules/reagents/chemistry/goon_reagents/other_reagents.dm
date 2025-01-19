/datum/reagent/uranium
	name = "Uranium"
	description = "A jade-green metallic chemical element in the actinide series, weakly radioactive."
	reagent_state = SOLID
	color = "#5E9964" //this used to be silver, but liquid uranium can still be green and it's more easily noticeable as uranium like this so why bother?
	taste_description = "the inside of a reactor"
	/// How much tox damage to deal per tick
	var/tox_damage = 0.5
	material = /datum/material/uranium


/datum/reagent/uranium/affect_blood(mob/living/carbon/C, removed)
	C.adjustToxLoss(tox_damage * removed, FALSE, cause_of_death = "Uranium poisoning")
	return TRUE

/datum/reagent/uranium/expose_turf(turf/exposed_turf, reac_volume)
	. = ..()
	if((reac_volume < 3) || isspaceturf(exposed_turf))
		return

	var/obj/effect/decal/cleanable/greenglow/glow = locate() in exposed_turf.contents
	if(!glow)
		glow = new(exposed_turf)
	if(!QDELETED(glow))
		glow.reagents.add_reagent(type, reac_volume)

//Mutagenic chem side-effects.
/datum/reagent/uranium/on_hydroponics_apply(datum/plant_tick/plant_tick, datum/reagents/chems, volume, obj/machinery/hydroponics/mytray, mob/user)
	if(volume >= 1)
		plant_tick.radiation_damage += 2
		plant_tick.mutation_power += 0.2

/datum/reagent/uranium/infuse_plant(datum/plant/plant_datum, datum/plant_gene_holder/plant_dna, list/damage_ref)
	. = ..()
	plant_dna.try_mutate_stats(1)
	plant_dna.try_activate_latent_gene(2)
	return plant_dna.try_mutate_type(1)

/datum/reagent/uranium/radium
	name = "Radium"
	description = "Radium is an alkaline earth metal. It is extremely radioactive."
	reagent_state = SOLID
	color = "#00CC00" // ditto
	taste_description = "the colour blue and regret"
	tox_damage = 1
	material = null


/datum/reagent/uranium/radium/on_hydroponics_apply(datum/plant_tick/plant_tick, datum/reagents/chems, volume, obj/machinery/hydroponics/mytray, mob/user)
	if(volume >= 1)
		plant_tick.radiation_damage += 2
		plant_tick.mutation_power += 0.2

/datum/reagent/fuel/oil
	name = "Oil"
	description = "Burns in a small smoky fire, can be used to get Ash."
	reagent_state = LIQUID
	color = "#2D2D2D"
	taste_description = "oil"
	burning_temperature = 1200//Oil is crude
	burning_volume = 0.05 //but has a lot of hydrocarbons

	addiction_types = null

/datum/reagent/stable_plasma
	name = "Stable Plasma"
	description = "Non-flammable plasma locked into a liquid form that cannot ignite or become gaseous/solid."
	reagent_state = LIQUID
	color = "#2D2D2D"
	taste_description = "bitterness"
	taste_mult = 1.5


/datum/reagent/stable_plasma/affect_blood(mob/living/carbon/C, removed)
	C.adjustPlasma(10 * removed)

/datum/reagent/fuel
	name = "Welding Fuel"
	description = "Required for welders. Flammable."
	color = "#660000" // rgb: 102, 0, 0
	taste_description = "gross metal"
	glass_icon_state = "dr_gibb_glass"
	glass_name = "glass of welder fuel"
	glass_desc = "Unless you're an industrial tool, this is probably not safe for consumption."
	penetrates_skin = NONE
	burning_temperature = 1725 //more refined than oil
	burning_volume = 0.2

	addiction_types = list(/datum/addiction/alcohol = 4)

/datum/reagent/fuel/expose_mob(mob/living/exposed_mob, reac_volume, exposed_temperature = T20C, datum/reagents/source, methods=TOUCH, show_message = TRUE, touch_protection = 0)//Splashing people with welding fuel to make them easy to ignite!
	. = ..()
	if(methods & (TOUCH|VAPOR))
		exposed_mob.adjust_fire_stacks(reac_volume / 10)

/datum/reagent/fuel/affect_blood(mob/living/carbon/C, removed)
	C.adjustToxLoss(0.5 * removed, 0, cause_of_death = "Ingesting fuel")
	return TRUE

/datum/reagent/space_cleaner
	name = "Space Cleaner"
	description = "A compound used to clean things."
	color = "#A5F0EE" // rgb: 165, 240, 238
	taste_description = "sourness"
	reagent_weight = 0.6 //so it sprays further
	penetrates_skin = NONE
	touch_met = 2
	var/clean_types = CLEAN_WASH
	chemical_flags = REAGENT_CLEANS

/datum/reagent/space_cleaner/expose_obj(obj/exposed_obj, reac_volume)
	. = ..()
	exposed_obj?.wash(clean_types)

/datum/reagent/space_cleaner/expose_turf(turf/exposed_turf, reac_volume)
	. = ..()
	if(reac_volume < 1)
		return

	exposed_turf.wash(clean_types)
	for(var/am in exposed_turf)
		var/atom/movable/movable_content = am
		if(ismopable(movable_content)) // Mopables will be cleaned anyways by the turf wash
			continue
		movable_content.wash(clean_types)

	for(var/mob/living/simple_animal/slime/exposed_slime in exposed_turf)
		exposed_slime.adjustToxLoss(rand(5,10))

	exposed_turf.AddComponent(/datum/component/smell, INTENSITY_STRONG, SCENT_ODOR, "bleach", 3, 5 MINUTES)

/datum/reagent/space_cleaner/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message=TRUE, touch_protection=0)
	. = ..()
	if(methods & (TOUCH|VAPOR))
		exposed_mob.wash(clean_types)

/datum/reagent/space_cleaner/affect_touch(mob/living/carbon/C, removed)
	C.adjustFireLoss(2 * removed, 0) // burns
	return TRUE

/datum/reagent/space_cleaner/ez_clean
	name = "EZ Clean"
	description = "A powerful, acidic cleaner sold by Waffle Co. Affects organic matter while leaving other objects unaffected."
	metabolization_rate = 0.5
	taste_description = "acid"
	penetrates_skin = VAPOR

/datum/reagent/space_cleaner/ez_clean/affect_blood(mob/living/carbon/C, removed)
	C.adjustBruteLoss(1.665*removed, FALSE)
	C.adjustFireLoss(1.665*removed, FALSE)
	C.adjustToxLoss(1.665*removed, FALSE, cause_of_death = "Ingesting space cleaner")
	return TRUE

/datum/reagent/space_cleaner/ez_clean/expose_mob(mob/living/exposed_mob, reac_volume, exposed_temperature = T20C, datum/reagents/source, methods=TOUCH, show_message = TRUE, touch_protection = 0)
	. = ..()
	if((methods & (TOUCH|VAPOR)) && !issilicon(exposed_mob))
		exposed_mob.adjustBruteLoss(1.5)
		exposed_mob.adjustFireLoss(1.5)

///Used for clownery
/datum/reagent/lube
	name = "Space Lube"
	description = "Lubricant is a substance introduced between two moving surfaces to reduce the friction and wear between them. giggity."
	color = "#009CA8" // rgb: 0, 156, 168
	taste_description = "cherry" // by popular demand
	var/lube_kind = TURF_WET_LUBE ///What kind of slipperiness gets added to turfs


/datum/reagent/lube/expose_turf(turf/open/exposed_turf, reac_volume)
	. = ..()
	if(!istype(exposed_turf))
		return
	if(reac_volume >= 1)
		exposed_turf.MakeSlippery(lube_kind, 15 SECONDS, min(reac_volume * 2 SECONDS, 120))

///Stronger kind of lube. Applies TURF_WET_SUPERLUBE.
/datum/reagent/lube/superlube
	name = "Super Duper Lube"
	description = "This \[REDACTED\] has been outlawed after the incident on \[DATA EXPUNGED\]."
	lube_kind = TURF_WET_SUPERLUBE
	chemical_flags = REAGENT_NO_RANDOM_RECIPE

/datum/reagent/stimulants
	name = "Stimulants"
	description = "Increases stun resistance and movement speed in addition to restoring minor damage and weakness. Overdose causes weakness and toxin damage."
	color = "#78008C"
	metabolization_rate = 0.2
	overdose_threshold = 60
	chemical_flags = REAGENT_NO_RANDOM_RECIPE
	addiction_types = list(/datum/addiction/stimulants = 4) //0.8 per 2 seconds

/datum/reagent/stimulants/on_mob_metabolize(mob/living/carbon/C, class)
	if(class != CHEM_BLOOD)
		return
	ADD_TRAIT(C, TRAIT_STUNRESISTANCE, CHEM_TRAIT_SOURCE(class))
	ADD_TRAIT(C, TRAIT_STIMULANTS, CHEM_TRAIT_SOURCE(class))
	C.add_movespeed_modifier(/datum/movespeed_modifier/reagent/stimulants)

/datum/reagent/stimulants/affect_blood(mob/living/carbon/C, removed)
	APPLY_CHEM_EFFECT(C, CE_STIMULANT, 10)

/datum/reagent/stimulants/on_mob_end_metabolize(mob/living/carbon/C, class)
	if(class != CHEM_BLOOD)
		return
	REMOVE_TRAIT(C, TRAIT_STUNRESISTANCE, CHEM_TRAIT_SOURCE(class))
	REMOVE_TRAIT(C, TRAIT_STIMULANTS, CHEM_TRAIT_SOURCE(class))
	if(!HAS_TRAIT(C, TRAIT_STIMULANTS))
		C.remove_movespeed_modifier(/datum/movespeed_modifier/reagent/stimulants)

/datum/reagent/stimulants/affect_blood(mob/living/carbon/C, removed)
	if(C.health < 50 && C.health > 0)
		C.adjustOxyLoss(-1 * removed, 0)
		C.adjustToxLoss(-1 * removed, 0)
		C.adjustBruteLoss(-1 * removed, 0)
		C.adjustFireLoss(-1 * removed, 0)
	C.AdjustAllImmobility(-60 * removed)
	C.stamina.adjust(30 * removed)
	. = TRUE

/datum/reagent/stimulants/overdose_process(mob/living/carbon/C)
	if(prob(25))
		C.stamina.adjust(2.5)
		C.adjustToxLoss(1, 0, cause_of_death = "Stimulant overdose")
		C.losebreath++
		. = TRUE

/datum/reagent/ash
	name = "Ash"
	description = "Supposedly phoenixes rise from these, but you've never seen it."
	reagent_state = LIQUID
	color = "#515151"
	taste_description = "ash"

/datum/reagent/ash/on_hydroponics_apply(datum/plant_tick/plant_tick, datum/reagents/chems, volume, obj/machinery/hydroponics/mytray, mob/user)
	if(volume >= 1)
		plant_tick.plant_growth_delta += 0.4
		plant_tick.plant_health_delta += 0.2

// [Original ants concept by Keelin on Goon]
/datum/reagent/ants
	name = "Ants"
	description = "A genetic crossbreed between ants and termites, their bites land at a 3 on the Schmidt Pain Scale."
	reagent_state = SOLID
	color = "#993333"
	taste_mult = 1.3
	taste_description = "tiny legs scuttling down the back of your throat"
	metabolization_rate = 1 //1u per second
	glass_name = "glass of ants"
	glass_desc = "Bottoms up...?"

	/// How much damage the ants are going to be doing (rises with each tick the ants are in someone's body)
	var/ant_damage = 0
	/// Tells the debuff how many ants we are being covered with.
	var/amount_left = 0
	/// List of possible common statements to scream when eating ants
	var/static/list/ant_screams = list(
		"THEY'RE UNDER MY SKIN!!",
		"GET THEM OUT OF ME!!",
		"HOLY HELL THEY BURN!!",
		"MY GOD THEY'RE INSIDE ME!!",
		"GET THEM OUT!!"
		)

/datum/reagent/ants/affect_ingest(mob/living/carbon/C, removed)
	C.adjustBruteLoss(max(0.1, round((ant_damage * 0.025),0.1)), FALSE) //Scales with time. Roughly 32 brute with 100u.
	ant_damage++
	if(ant_damage < 5) // Makes ant food a little more appetizing, since you won't be screaming as much.
		return TRUE

	if(prob(10))
		spawn(-1)
			C.say(pick(ant_screams), forced = /datum/reagent/ants)
	if(prob(30))
		spawn(-1)
			C.emote("scream")
	if(prob(5)) // Stuns, but purges ants.
		C.vomit(rand(5,10), FALSE, TRUE, 1, TRUE, FALSE, purge_ratio = 1)
	. = TRUE
	..()

/datum/reagent/ants/affect_touch(mob/living/carbon/C, removed)
	return affect_ingest(C, removed)

/datum/reagent/ants/on_mob_end_metabolize(mob/living/living_anthill)
	ant_damage = 0
	to_chat(living_anthill, "<span class='notice'>You feel like the last of the ants are out of your system.</span>")
	return ..()

/datum/reagent/ants/affect_touch(mob/living/carbon/C, removed)
	. = ..()
	C.apply_status_effect(/datum/status_effect/ants, round(removed, 0.1))

/datum/reagent/ants/expose_obj(obj/exposed_obj, reac_volume)
	. = ..()
	var/turf/open/my_turf = exposed_obj.loc // No dumping ants on an object in a storage slot
	if(!istype(my_turf)) //Are we actually in an open turf?
		return
	var/static/list/accepted_types = typecacheof(list(/obj/machinery/atmospherics, /obj/structure/cable, /obj/structure/disposalpipe))
	if(!accepted_types[exposed_obj.type]) // Bypasses pipes, vents, and cables to let people create ant mounds on top easily.
		return
	expose_turf(my_turf, reac_volume)

/datum/reagent/ants/expose_turf(turf/exposed_turf, reac_volume)
	. = ..()
	if(!istype(exposed_turf) || isspaceturf(exposed_turf)) // Is the turf valid
		return
	if((reac_volume <= 10)) // Makes sure people don't duplicate ants.
		return

	var/obj/effect/decal/cleanable/ants/pests = locate() in exposed_turf.contents
	if(!pests)
		pests = new(exposed_turf)
	var/spilled_ants = (round(reac_volume,1) - 5) // To account for ant decals giving 3-5 ants on initialize.
	pests.reagents.add_reagent(/datum/reagent/ants, spilled_ants)
	pests.update_ant_damage()

/datum/reagent/phenol
	name = "Phenol"
	description = "An aromatic ring of carbon with a hydroxyl group. A useful precursor to some medicines, but has no healing properties on its own."
	reagent_state = LIQUID
	color = "#E7EA91"
	taste_description = "acid"

/datum/reagent/acetone
	name = "Acetone"
	description = "A colorless liquid solvent used in chemical synthesis."
	taste_description = "acid"
	reagent_state = LIQUID
	color = "#808080"
	metabolization_rate = 0.04
	value = DISPENSER_REAGENT_VALUE

/datum/reagent/acetone/affect_blood(mob/living/carbon/C, removed)
	C.adjustToxLoss(removed * 3, FALSE, cause_of_death = "Ingesting acetone")
	return TRUE

/datum/reagent/acetone/expose_obj(obj/exposed_obj, reac_volume, exposed_temperature)
	. = ..()
	if(istype(exposed_obj, /obj/item/paper))
		var/obj/item/paper/paperaffected = exposed_obj
		paperaffected.clearpaper()
		to_chat(usr, span_notice("The solution dissolves the ink on the paper."))
		return

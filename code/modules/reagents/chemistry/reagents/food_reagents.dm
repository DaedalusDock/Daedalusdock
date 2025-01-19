///////////////////////////////////////////////////////////////////
					//Food Reagents
//////////////////////////////////////////////////////////////////


// Part of the food code. Also is where all the food
// condiments, additives, and such go.


/datum/reagent/consumable
	name = "Consumable"
	taste_description = "generic food"
	taste_mult = 4
	abstract_type = /datum/reagent/consumable
	/// How much nutrition this reagent supplies
	var/nutriment_factor = 1 * REAGENTS_METABOLISM
	var/quality = 0 //affects mood, typically higher for mixed drinks with more complex recipes'

/datum/reagent/consumable/New()
	. = ..()
	ingest_met = metabolization_rate

/datum/reagent/consumable/affect_ingest(mob/living/carbon/C, removed)
	C.adjust_nutrition(nutriment_factor * removed)
	return ..()

/datum/reagent/consumable/nutriment
	name = "Nutriment"
	description = "All the vitamins, minerals, and carbohydrates the body needs in pure forC."
	reagent_state = SOLID
	nutriment_factor = 15 * REAGENTS_METABOLISM
	color = "#664330" // rgb: 102, 67, 48


	var/brute_heal = 1
	var/burn_heal = 0

/datum/reagent/consumable/nutriment/on_hydroponics_apply(datum/plant_tick/plant_tick, datum/reagents/chems, volume, obj/machinery/hydroponics/mytray, mob/user)
	if(volume >= 1)
		plant_tick.plant_health_delta += 1
		plant_tick.plant_growth_delta += 1

/datum/reagent/consumable/nutriment/affect_ingest(mob/living/carbon/C, removed)
	if(prob(60))
		C.heal_bodypart_damage(brute = brute_heal * removed, burn = burn_heal * removed)
		. = TRUE
	return ..() || .

/datum/reagent/consumable/nutriment/on_new(list/supplied_data)
	. = ..()
	if(!data)
		return
	// taste data can sometimes be ("salt" = 3, "chips" = 1)
	// and we want it to be in the form ("salt" = 0.75, "chips" = 0.25)
	// which is called "normalizing"
	if(!supplied_data)
		supplied_data = data

	// if data isn't an associative list, this has some WEIRD side effects
	// TODO probably check for assoc list?

	data = counterlist_normalise(supplied_data)

/datum/reagent/consumable/nutriment/on_merge(list/newdata, newvolume)
	. = ..()
	if(!islist(newdata) || !newdata.len)
		return

	// data for nutriment is one or more (flavour -> ratio)
	// where all the ratio values adds up to 1

	var/list/taste_amounts = list()
	if(data)
		taste_amounts = data.Copy()

	counterlist_scale(taste_amounts, volume)

	var/list/other_taste_amounts = newdata.Copy()
	counterlist_scale(other_taste_amounts, newvolume)

	counterlist_combine(taste_amounts, other_taste_amounts)

	counterlist_normalise(taste_amounts)

	data = taste_amounts

/datum/reagent/consumable/nutriment/get_taste_description(mob/living/taster)
	return data

/datum/reagent/consumable/nutriment/vitamin
	name = "Vitamin"
	description = "All the best vitamins, minerals, and carbohydrates the body needs in pure forC."


	brute_heal = 1
	burn_heal = 1

/datum/reagent/consumable/nutriment/vitamin/affect_ingest(mob/living/carbon/C, removed)
	if(C.satiety < 600)
		C.satiety += 10 * removed
	return ..()

/datum/reagent/consumable/nutriment/vitamin/affect_blood(mob/living/carbon/C, removed)
	if(C.satiety < 600)
		C.satiety += 20 * removed //Doubled to account for ingestion only putting half into the blood stream

/// The basic resource of vat growing.
/datum/reagent/consumable/nutriment/protein
	name = "Protein"
	description = "A natural polyamide made up of amino acids. An essential constituent of mosts known forms of life."
	brute_heal = 0.8 //Rewards the player for eating a balanced diet.
	nutriment_factor = 9 * REAGENTS_METABOLISM //45% as calorie dense as corn oil.


/datum/reagent/consumable/nutriment/organ_tissue
	name = "Organ Tissue"
	description = "Natural tissues that make up the bulk of organs, providing many vitamins and minerals."
	taste_description = "rich earthy pungent"


/datum/reagent/consumable/cooking_oil
	name = "Cooking Oil"
	description = "A variety of cooking oil derived from fat or plants. Used in food preparation and frying."
	color = "#EADD6B" //RGB: 234, 221, 107 (based off of canola oil)
	taste_mult = 0.8
	taste_description = "oil"
	nutriment_factor = 7 * REAGENTS_METABOLISM //Not very healthy on its own
	metabolization_rate = 2
	ingest_met = 2
	penetrates_skin = NONE
	var/fry_temperature = 450 //Around ~350 F (117 C) which deep fryers operate around in the real world


/datum/reagent/consumable/cooking_oil/expose_obj(obj/exposed_obj, reac_volume)
	. = ..()
	if(!holder || (holder.chem_temp <= fry_temperature))
		return
	if(!isitem(exposed_obj) || istype(exposed_obj, /obj/item/food/deepfryholder))
		return
	if(is_type_in_typecache(exposed_obj, GLOB.oilfry_blacklisted_items) || (exposed_obj.resistance_flags & INDESTRUCTIBLE))
		exposed_obj.loc.visible_message(span_notice("The hot oil has no effect on [exposed_obj]!"))
		return
	if(exposed_obj.atom_storage)
		exposed_obj.loc.visible_message(span_notice("The hot oil splatters about as [exposed_obj] touches it. It seems too full to cook properly!"))
		return
	exposed_obj.loc.visible_message(span_warning("[exposed_obj] rapidly fries as it's splashed with hot oil! Somehow."))
	var/obj/item/food/deepfryholder/fry_target = new(exposed_obj.drop_location(), exposed_obj)
	fry_target.fry(volume)
	fry_target.reagents.add_reagent(/datum/reagent/consumable/cooking_oil, reac_volume)

/datum/reagent/consumable/cooking_oil/expose_mob(mob/living/exposed_mob, methods, reac_volume, show_message, touch_protection)
	. = ..()
	if(!(methods & (VAPOR|TOUCH)) || isnull(holder) || (holder.chem_temp < fry_temperature)) //Directly coats the mob, and doesn't go into their bloodstream
		return

	var/oil_damage = ((holder.chem_temp / fry_temperature) * 0.33) //Damage taken per unit
	if(methods & TOUCH)
		oil_damage *= max(1 - touch_protection, 0)
	var/FryLoss = round(min(38, oil_damage * reac_volume))
	if(!HAS_TRAIT(exposed_mob, TRAIT_OIL_FRIED))
		exposed_mob.visible_message(span_warning("The boiling oil sizzles as it covers [exposed_mob]!"), \
		span_userdanger("You're covered in boiling oil!"))
		if(FryLoss)
			exposed_mob.emote("scream")
		playsound(exposed_mob, 'sound/machines/fryer/deep_fryer_emerge.ogg', 25, TRUE)
		ADD_TRAIT(exposed_mob, TRAIT_OIL_FRIED, "cooking_oil_react")
		addtimer(CALLBACK(exposed_mob, TYPE_PROC_REF(/mob/living, unfry_mob)), 3)
	if(FryLoss)
		exposed_mob.apply_damage(FryLoss, BURN, spread_damage = TRUE)

/datum/reagent/consumable/cooking_oil/expose_turf(turf/open/exposed_turf, reac_volume)
	. = ..()
	if(!istype(exposed_turf) || isgroundlessturf(exposed_turf) || (reac_volume < 5))
		return

	exposed_turf.MakeSlippery(TURF_WET_LUBE, min_wet_time = 10 SECONDS, wet_time_to_add = reac_volume * 1.5 SECONDS)
	exposed_turf.name = "Deep-fried [initial(exposed_turf.name)]"
	exposed_turf.add_atom_colour(color, TEMPORARY_COLOUR_PRIORITY)

/datum/reagent/consumable/sugar
	name = "Sucrose"
	description = "The organic compound commonly known as table sugar and sometimes called saccharose. This white, odorless, crystalline powder has a pleasing, sweet taste."
	reagent_state = SOLID
	color = "#FFFFFF" // rgb: 255, 255, 255
	taste_mult = 1.5
	nutriment_factor = 10 * REAGENTS_METABOLISM
	metabolization_rate = 0.4
	ingest_met = 0.4
	overdose_threshold = 200
	taste_description = "sweetness"

/datum/reagent/consumable/sugar/overdose_start(mob/living/carbon/C)
	to_chat(C, span_userdanger("Your body quakes as you collapse to the ground!"))
	C.AdjustSleeping(600)
	. = TRUE

/datum/reagent/consumable/sugar/overdose_process(mob/living/carbon/C)
	C.Sleeping(40)
	. = TRUE

/datum/reagent/consumable/virus_food
	name = "Virus Food"
	description = "A mixture of water and milk. Virus cells can use this mixture to reproduce."
	nutriment_factor = 2 * REAGENTS_METABOLISM
	color = "#899613" // rgb: 137, 150, 19
	taste_description = "watery milk"


	// Compost for EVERYTHING
/datum/reagent/consumable/virus_food/on_hydroponics_apply(datum/plant_tick/plant_tick, datum/reagents/chems, volume, obj/machinery/hydroponics/mytray, mob/user)
	if(volume >= 1)
		plant_tick.plant_health_delta -= 0.2

/datum/reagent/consumable/soysauce
	name = "Soysauce"
	description = "A salty sauce made from the soy plant."
	nutriment_factor = 2 * REAGENTS_METABOLISM
	color = "#792300" // rgb: 121, 35, 0
	taste_description = "umami"


/datum/reagent/consumable/ketchup
	name = "Ketchup"
	description = "Ketchup, catsup, whatever. It's tomato paste."
	nutriment_factor = 5 * REAGENTS_METABOLISM
	color = "#731008" // rgb: 115, 16, 8
	taste_description = "ketchup"



/datum/reagent/consumable/capsaicin
	name = "Capsaicin Oil"
	description = "This is what makes chilis hot."
	color = "#B31008" // rgb: 179, 16, 8
	taste_description = "hot peppers"
	taste_mult = 1.5


/datum/reagent/consumable/capsaicin/affect_ingest(mob/living/carbon/C, removed)
	var/heating = 0
	switch(current_cycle)
		if(1 to 15)
			heating = 5
		if(15 to 25)
			heating = 10
		if(25 to 35)
			heating = 15
		if(35 to INFINITY)
			heating = 20
	C.adjust_bodytemperature(heating * TEMPERATURE_DAMAGE_COEFFICIENT * removed)
	return ..()

/datum/reagent/consumable/frostoil
	name = "Frost Oil"
	description = "A special oil that noticeably chills the body. Extracted from chilly peppers and slimes."
	color = "#8BA6E9" // rgb: 139, 166, 233
	taste_description = "mint"

	///40 joules per unit.
	specific_heat = 40

/datum/reagent/consumable/frostoil/affect_ingest(mob/living/carbon/C, removed)
	var/cooling = 0
	switch(current_cycle)
		if(1 to 15)
			cooling = -10
			if(holder.has_reagent(/datum/reagent/consumable/capsaicin))
				holder.remove_reagent(/datum/reagent/consumable/capsaicin, 5 * removed)
		if(15 to 25)
			cooling = -20
		if(25 to 35)
			cooling = -30
			if(prob(1))
				spawn(-1)
					C.emote("shiver")
		if(35 to INFINITY)
			cooling = -40
			if(prob(5))
				C.emote("shiver")
	C.adjust_bodytemperature(cooling * TEMPERATURE_DAMAGE_COEFFICIENT * removed, 50)
	return ..()

/datum/reagent/consumable/frostoil/expose_turf(turf/exposed_turf, reac_volume)
	. = ..()
	if(reac_volume < 1)
		return

	if(isopenturf(exposed_turf) && exposed_turf.simulated)
		var/turf/open/exposed_open_turf = exposed_turf
		var/datum/gas_mixture/air = exposed_turf.return_air()
		exposed_open_turf.MakeSlippery(wet_setting=TURF_WET_ICE, min_wet_time=100, wet_time_to_add=reac_volume SECONDS) // Is less effective in high pressure/high heat capacity environments. More effective in low pressure.
		var/temperature = air.temperature
		var/heat_capacity = air.getHeatCapacity()
		air.temperature = max(air.temperature - ((temperature - TCMB) * (heat_capacity * reac_volume * specific_heat) / (heat_capacity + reac_volume * specific_heat)) / heat_capacity, TCMB) // Exchanges environment temperature with reagent. Reagent is at 2.7K with a heat capacity of 40J per unit.
	if(reac_volume < 5)
		return
	for(var/mob/living/simple_animal/slime/exposed_slime in exposed_turf)
		exposed_slime.adjustToxLoss(rand(15,30))

/datum/reagent/consumable/condensedcapsaicin
	name = "Condensed Capsaicin"
	description = "A chemical agent used for self-defense and in police work."
	color = "#B31008" // rgb: 179, 16, 8
	taste_description = "scorching agony"
	penetrates_skin = NONE


/datum/reagent/consumable/condensedcapsaicin/expose_mob(mob/living/exposed_mob, reac_volume, exposed_temperature = T20C, datum/reagents/source, methods=TOUCH, show_message = TRUE, touch_protection = 0)
	. = ..()
	if(!ishuman(exposed_mob))
		return

	var/mob/living/carbon/victim = exposed_mob
	if(methods & (TOUCH|VAPOR))
		var/pepper_proof = victim.is_pepper_proof()

		//check for protection
		//actually handle the pepperspray effects
		if (!(pepper_proof)) // you need both eye and mouth protection
			if(prob(5))
				spawn(-1)
					victim.emote("scream")
			victim.blur_eyes(5) // 10 seconds
			victim.blind_eyes(3) // 6 seconds
			victim.set_timed_status_effect(5 SECONDS, /datum/status_effect/confusion, only_if_higher = TRUE)
			victim.Knockdown(3 SECONDS)
			victim.add_movespeed_modifier(/datum/movespeed_modifier/reagent/pepperspray)
			addtimer(CALLBACK(victim, TYPE_PROC_REF(/mob, remove_movespeed_modifier), /datum/movespeed_modifier/reagent/pepperspray), 10 SECONDS)
		victim.update_damage_hud()

/datum/reagent/consumable/condensedcapsaicin/affect_ingest(mob/living/carbon/C, removed)
	if(!holder.has_reagent(/datum/reagent/consumable/milk))
		if(prob(10))
			C.visible_message(span_warning("[C] [pick("dry heaves!","coughs!","splutters!")]"))
	return ..()

/datum/reagent/consumable/salt
	name = "Sodium Chloride"
	description = "No dude, that's salt."
	reagent_state = SOLID
	color = "#FFFFFF" // rgb: 255,255,255
	taste_description = "salt"
	penetrates_skin = NONE

/datum/reagent/consumable/salt/expose_turf(turf/exposed_turf, reac_volume)
	. = ..()
	if(!istype(exposed_turf) || (reac_volume < 1))
		return

	new/obj/effect/decal/cleanable/food/salt(exposed_turf)

/datum/reagent/consumable/blackpepper
	name = "Black Pepper"
	description = "A powder ground from peppercorns. *AAAACHOOO*"
	reagent_state = SOLID
	// no color (ie, black)
	taste_description = "pepper"


/datum/reagent/consumable/coco
	name = "Coco Powder"
	description = "A fatty, bitter paste made from coco beans."
	reagent_state = SOLID
	nutriment_factor = 5 * REAGENTS_METABOLISM
	color = "#302000" // rgb: 48, 32, 0
	taste_description = "bitterness"


/datum/reagent/consumable/garlic //NOTE: having garlic in your blood stops vampires from biting you.
	name = "Garlic Juice"
	description = "Crushed garlic. Chefs love it, but it can make you smell bad."
	color = "#FEFEFE"
	taste_description = "garlic"
	ingest_met = 0.03

/datum/reagent/consumable/garlic/on_mob_metabolize(mob/living/carbon/C, class)
	if(class == CHEM_INGEST)
		ADD_TRAIT(C, TRAIT_GARLIC_BREATH, CHEM_TRAIT_SOURCE(class))

/datum/reagent/consumable/garlic/on_mob_end_metabolize(mob/living/carbon/C, class)
	if(class == CHEM_INGEST)
		REMOVE_TRAIT(C, TRAIT_GARLIC_BREATH, CHEM_TRAIT_SOURCE(class))

/datum/reagent/consumable/garlic/affect_blood(mob/living/carbon/C, removed)
	if(isvampire(C)) //incapacitating but not lethal. Unfortunately, vampires cannot vomit.
		if(prob(min(current_cycle, 25)))
			to_chat(C, span_danger("You can't get the scent of garlic out of your nose! You can barely think..."))
			C.Paralyze(10)
			C.set_timed_status_effect(20 SECONDS, /datum/status_effect/jitter, only_if_higher = TRUE)
	else
		var/obj/item/organ/liver/liver = C.getorganslot(ORGAN_SLOT_LIVER)
		if(liver && HAS_TRAIT(liver, TRAIT_CULINARY_METABOLISM))
			if(prob(20)) //stays in the system much longer than sprinkles/banana juice, so heals slower to partially compensate
				C.heal_bodypart_damage(brute = 1 * removed, burn = 1 * removed, updating_health = FALSE)
				. = TRUE

/datum/reagent/consumable/sprinkles
	name = "Sprinkles"
	description = "Multi-colored little bits of sugar, commonly found on donuts. Loved by cops."
	color = "#FF00FF" // rgb: 255, 0, 255
	taste_description = "childhood whimsy"


/datum/reagent/consumable/sprinkles/affect_ingest(mob/living/carbon/C, removed)
	var/obj/item/organ/liver/liver = C.getorganslot(ORGAN_SLOT_LIVER)
	if(liver && HAS_TRAIT(liver, TRAIT_LAW_ENFORCEMENT_METABOLISM))
		C.heal_bodypart_damage(1 * removed, 1 * removed, updating_health = FALSE)
		. = TRUE
	return ..() || .

/datum/reagent/consumable/cornoil
	name = "Corn Oil"
	description = "An oil derived from various types of corn."
	nutriment_factor = 20 * REAGENTS_METABOLISM
	color = "#302000" // rgb: 48, 32, 0
	taste_description = "slime"


/datum/reagent/consumable/cornoil/expose_turf(turf/open/exposed_turf, reac_volume)
	. = ..()
	if(!istype(exposed_turf))
		return
	exposed_turf.MakeSlippery(TURF_WET_LUBE, min_wet_time = 10 SECONDS, wet_time_to_add = reac_volume*2 SECONDS)
	var/obj/effect/hotspot/hotspot = exposed_turf.active_hotspot
	if(hotspot)
		var/datum/gas_mixture/lowertemp = exposed_turf.remove_air(exposed_turf.return_air().total_moles)
		lowertemp.temperature = max( min(lowertemp.temperature-2000,lowertemp.temperature / 2) ,0)
		lowertemp.react()
		exposed_turf.assume_air(lowertemp)
		qdel(hotspot)

/datum/reagent/consumable/enzyme
	name = "Universal Enzyme"
	description = "A universal enzyme used in the preparation of certain chemicals and foods."
	color = "#365E30" // rgb: 54, 94, 48
	taste_description = "sweetness"


/datum/reagent/consumable/dry_ramen
	name = "Dry Ramen"
	description = "Space age food, since August 25, 1958. Contains dried noodles, vegetables, and chemicals that boil in contact with water."
	reagent_state = SOLID
	color = "#302000" // rgb: 48, 32, 0
	taste_description = "dry and cheap noodles"


/datum/reagent/consumable/hot_ramen
	name = "Hot Ramen"
	description = "The noodles are boiled, the flavors are artificial, just like being back in school."
	nutriment_factor = 5 * REAGENTS_METABOLISM
	color = "#302000" // rgb: 48, 32, 0
	taste_description = "wet and cheap noodles"


/datum/reagent/consumable/nutraslop
	name = "Nutraslop"
	description = "Mixture of leftover prison foods served on previous days."
	nutriment_factor = 5 * REAGENTS_METABOLISM
	color = "#3E4A00" // rgb: 62, 74, 0
	taste_description = "your imprisonment"


/datum/reagent/consumable/hot_ramen/affect_ingest(mob/living/carbon/C, removed)
	C.adjust_bodytemperature(10 * TEMPERATURE_DAMAGE_COEFFICIENT * removed, 0, C.get_body_temp_normal())
	return ..()

/datum/reagent/consumable/hell_ramen
	name = "Hell Ramen"
	description = "The noodles are boiled, the flavors are artificial, just like being back in school."
	nutriment_factor = 5 * REAGENTS_METABOLISM
	color = "#302000" // rgb: 48, 32, 0
	taste_description = "wet and cheap noodles on fire"


/datum/reagent/consumable/hell_ramen/affect_ingest(mob/living/carbon/C, removed)
	C.adjust_bodytemperature(10 * TEMPERATURE_DAMAGE_COEFFICIENT * removed)
	return ..()

/datum/reagent/consumable/flour
	name = "Flour"
	description = "This is what you rub all over yourself to pretend to be a ghost."
	reagent_state = SOLID
	color = "#FFFFFF" // rgb: 0, 0, 0
	taste_description = "chalky wheat"


/datum/reagent/consumable/flour/expose_turf(turf/exposed_turf, reac_volume)
	. = ..()
	if(isspaceturf(exposed_turf))
		return

	var/obj/effect/decal/cleanable/food/flour/reagentdecal = new(exposed_turf)
	reagentdecal = locate() in exposed_turf //Might have merged with flour already there.
	if(reagentdecal)
		reagentdecal.reagents.add_reagent(/datum/reagent/consumable/flour, reac_volume)

/datum/reagent/consumable/cherryjelly
	name = "Cherry Jelly"
	description = "Totally the best. Only to be spread on foods with excellent lateral symmetry."
	color = "#801E28" // rgb: 128, 30, 40
	taste_description = "cherry"


/datum/reagent/consumable/bluecherryjelly
	name = "Blue Cherry Jelly"
	description = "Blue and tastier kind of cherry jelly."
	color = "#00F0FF"
	taste_description = "blue cherry"

/datum/reagent/consumable/rice
	name = "Rice"
	description = "tiny nutritious grains"
	reagent_state = SOLID
	nutriment_factor = 3 * REAGENTS_METABOLISM
	color = "#FFFFFF" // rgb: 0, 0, 0
	taste_description = "rice"


/datum/reagent/consumable/vanilla
	name = "Vanilla Powder"
	description = "A fatty, bitter paste made from vanilla pods."
	reagent_state = SOLID
	nutriment_factor = 5 * REAGENTS_METABOLISM
	color = "#FFFACD"
	taste_description = "vanilla"


/datum/reagent/consumable/eggyolk
	name = "Egg Yolk"
	description = "It's full of protein."
	nutriment_factor = 4 * REAGENTS_METABOLISM
	color = "#FFB500"
	taste_description = "egg"


/datum/reagent/consumable/eggwhite
	name = "Egg White"
	description = "It's full of even more protein."
	nutriment_factor = 1.5 * REAGENTS_METABOLISM
	color = "#fffdf7"
	taste_description = "bland egg"


/datum/reagent/consumable/corn_starch
	name = "Corn Starch"
	description = "A slippery solution."
	color = "#DBCE95"
	taste_description = "slime"

/datum/reagent/consumable/corn_syrup
	name = "Corn Syrup"
	description = "Decays into sugar."
	color = "#DBCE95"
	ingest_met = 0.6
	taste_description = "sweet slime"


/datum/reagent/consumable/corn_syrup/affect_ingest(mob/living/carbon/C, removed)
	holder.add_reagent(/datum/reagent/consumable/sugar, 3 * removed)
	return ..()

/datum/reagent/consumable/honey
	name = "Honey"
	description = "Sweet sweet honey that decays into sugar. Has antibacterial and natural healing properties."
	color = "#d3a308"
	nutriment_factor = 15 * REAGENTS_METABOLISM
	ingest_met = 0.2
	taste_description = "sweetness"

#warn honey
// 	// On the other hand, honey has been known to carry pollen with it rarely. Can be used to take in a lot of plant qualities all at once, or harm the plant.
// /datum/reagent/consumable/honey/on_hydroponics_apply(datum/plant_tick/plant_tick, datum/reagents/chems, volume, obj/machinery/hydroponics/mytray, mob/user)
// 	. = ..()
// 	if(chems.has_reagent(type, 1))
// 		if(myseed && prob(20))
// 			mytray.pollinate(1)
// 		else
// 			mytray.adjust_weedlevel(rand(1,2))
// 			mytray.adjust_pestlevel(rand(1,2))

/datum/reagent/consumable/honey/affect_ingest(mob/living/carbon/C, removed)
	holder.add_reagent(/datum/reagent/consumable/sugar, 3 * removed)
	if(prob(33))
		var/heal = -1 * removed
		C.adjustBruteLoss(heal, 0)
		C.adjustFireLoss(heal, 0)
		C.adjustOxyLoss(heal, 0)
		C.adjustToxLoss(heal, 0)
		. = TRUE
	return ..() || .

/datum/reagent/consumable/mayonnaise
	name = "Mayonnaise"
	description = "A white and oily mixture of mixed egg yolks."
	color = "#DFDFDF"
	taste_description = "mayonnaise"


/datum/reagent/consumable/mold // yeah, ok, togopal, I guess you could call that a condiment
	name = "Mold"
	description = "This condiment will make any food break the mold. Or your stomach."
	color ="#708a88"
	taste_description = "rancid fungus"


/datum/reagent/consumable/eggrot
	name = "Rotten Eggyolk"
	description = "It smells absolutely dreadful."
	color ="#708a88"
	taste_description = "rotten eggs"


/datum/reagent/consumable/tearjuice
	name = "Tear Juice"
	description = "A blinding substance extracted from certain onions."
	color = "#c0c9a0"
	taste_description = "bitterness"


/datum/reagent/consumable/tearjuice/expose_mob(mob/living/exposed_mob, reac_volume, exposed_temperature = T20C, datum/reagents/source, methods=TOUCH, show_message = TRUE, touch_protection = 0)
	. = ..()
	if(!(methods & INGEST) || !((methods & (TOUCH|VAPOR)) && (exposed_mob.is_mouth_covered() || exposed_mob.is_eyes_covered())))
		return

	var/obj/item/organ/eyes/E = exposed_mob.getorganslot(ORGAN_SLOT_EYES)
	if(!E && !(E.organ_flags & ORGAN_SYNTHETIC)) //can't blind somebody with no eyes
		to_chat(exposed_mob, span_notice("Your eye sockets feel wet."))
	else if(!(E.organ_flags & ORGAN_SYNTHETIC))
		if(!exposed_mob.eye_blurry)
			to_chat(exposed_mob, span_warning("Tears well up in your eyes!"))
		exposed_mob.blind_eyes(2)
		exposed_mob.blur_eyes(5)

/datum/reagent/consumable/tearjuice/affect_ingest(mob/living/carbon/C, removed)
	if(C.eye_blurry) //Don't worsen vision if it was otherwise fine
		C.blur_eyes(4 * removed)
		if(prob(10))
			to_chat(C, span_warning("Your eyes sting!"))
			C.blind_eyes(2)

	return ..()

/datum/reagent/consumable/nutriment/stabilized
	name = "Stabilized Nutriment"
	description = "A bioengineered protien-nutrient structure designed to decompose in high saturation. In layman's terms, it won't get you fat."
	reagent_state = SOLID
	nutriment_factor = 15 * REAGENTS_METABOLISM
	color = "#664330" // rgb: 102, 67, 48


/datum/reagent/consumable/nutriment/stabilized/affect_ingest(mob/living/carbon/C, removed)
	if(C.nutrition > NUTRITION_LEVEL_FULL - 25)
		C.adjust_nutrition(-3 * nutriment_factor * removed)
	return ..()

/datum/reagent/consumable/clownstears
	name = "Clown's Tears"
	description = "The sorrow and melancholy of a thousand bereaved clowns, forever denied their Honkmechs."
	nutriment_factor = 5 * REAGENTS_METABOLISM
	color = "#eef442" // rgb: 238, 244, 66
	taste_description = "mournful honking"



/datum/reagent/consumable/liquidelectricity
	name = "Liquid Electricity"
	description = "The blood of Ethereals, and the stuff that keeps them going. Great for them, horrid for anyone else."
	nutriment_factor = 5 * REAGENTS_METABOLISM
	color = "#97ee63"
	taste_description = "pure electricity"


/datum/reagent/consumable/liquidelectricity/enriched
	name = "Enriched Liquid Electricity"

/datum/reagent/consumable/liquidelectricity/affect_blood(mob/living/carbon/C, removed)
	. = ..()
	var/obj/item/organ/stomach/ethereal/stomach = C.getorganslot(ORGAN_SLOT_STOMACH)
	if(istype(stomach))
		stomach.adjust_charge(removed * 60)

/datum/reagent/consumable/liquidelectricity/enriched/affect_blood(mob/living/carbon/C, removed)
	. = ..()
	if(isethereal(C))
		C.blood_volume += 2 * removed
	else if(prob(20)) //lmao at the newbs who eat energy bars
		C.electrocute_act(rand(5,10), 1, NONE) //the shock is coming from inside the house
		playsound(C, SFX_SPARKS, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)

/datum/reagent/consumable/astrotame
	name = "Astrotame"
	description = "A space age artifical sweetener."
	nutriment_factor = 0
	ingest_met = 0.4
	reagent_state = SOLID
	color = "#FFFFFF" // rgb: 255, 255, 255
	taste_mult = 8
	taste_description = "sweetness"
	overdose_threshold = 17

/datum/reagent/consumable/astrotame/overdose_process(mob/living/carbon/C)
	if(C.disgust < 80)
		C.adjust_disgust(10)

/datum/reagent/consumable/secretsauce
	name = "Secret Sauce"
	description = "What could it be?"
	nutriment_factor = 2 * REAGENTS_METABOLISM
	color = "#792300"
	taste_description = "indescribable"
	quality = FOOD_AMAZING
	taste_mult = 100

/datum/reagent/consumable/nutriment/peptides
	name = "Peptides"
	color = "#BBD4D9"
	taste_description = "mint frosting"
	description = "These restorative peptides not only speed up wound healing, but are nutritious as well!"
	nutriment_factor = 10 * REAGENTS_METABOLISM // 33% less than nutriment to reduce weight gain
	brute_heal = 3
	burn_heal = 1


/datum/reagent/consumable/caramel
	name = "Caramel"
	description = "Who would have guessed that heated sugar could be so delicious?"
	nutriment_factor = 10 * REAGENTS_METABOLISM
	color = "#D98736"
	taste_mult = 2
	taste_description = "caramel"
	reagent_state = SOLID


/datum/reagent/consumable/char
	name = "Char"
	description = "Essence of the grill. Has strange properties when overdosed."
	reagent_state = LIQUID
	nutriment_factor = 5 * REAGENTS_METABOLISM
	color = "#C8C8C8"
	taste_mult = 6
	taste_description = "smoke"
	overdose_threshold = 15


/datum/reagent/consumable/char/overdose_process(mob/living/C)
	if(prob(25))
		spawn(-1)
			C.say(pick_list_replacements(BOOMER_FILE, "boomer"), forced = /datum/reagent/consumable/char)

/datum/reagent/consumable/bbqsauce
	name = "BBQ Sauce"
	description = "Sweet, smoky, savory, and gets everywhere. Perfect for grilling."
	nutriment_factor = 5 * REAGENTS_METABOLISM
	color = "#78280A" // rgb: 120 40, 10
	taste_mult = 2.5 //sugar's 1.5, capsacin's 1.5, so a good middle ground.
	taste_description = "smokey sweetness"


/datum/reagent/consumable/chocolatepudding
	name = "Chocolate Pudding"
	description = "A great dessert for chocolate lovers."
	color = "#800000"
	quality = DRINK_VERYGOOD
	nutriment_factor = 4 * REAGENTS_METABOLISM
	taste_description = "sweet chocolate"
	glass_icon_state = "chocolatepudding"
	glass_name = "chocolate pudding"
	glass_desc = "Tasty."

	glass_price = DRINK_PRICE_EASY

/datum/reagent/consumable/vanillapudding
	name = "Vanilla Pudding"
	description = "A great dessert for vanilla lovers."
	color = "#FAFAD2"
	quality = DRINK_VERYGOOD
	nutriment_factor = 4 * REAGENTS_METABOLISM
	taste_description = "sweet vanilla"
	glass_icon_state = "vanillapudding"
	glass_name = "vanilla pudding"
	glass_desc = "Tasty."


/datum/reagent/consumable/laughsyrup
	name = "Laughin' Syrup"
	description = "The product of juicing Laughin' Peas. Fizzy, and seems to change flavour based on what it's used with!"
	color = "#803280"
	nutriment_factor = 5 * REAGENTS_METABOLISM
	taste_mult = 2
	taste_description = "fizzy sweetness"


/datum/reagent/consumable/gravy
	name = "Gravy"
	description = "A mixture of flour, water, and the juices of cooked meat."
	taste_description = "gravy"
	color = "#623301"
	taste_mult = 1.2


/datum/reagent/consumable/pancakebatter
	name = "Pancake Batter"
	description = "A very milky batter. 5 units of this on the griddle makes a mean pancake."
	taste_description = "milky batter"
	color = "#fccc98"


/datum/reagent/consumable/korta_flour
	name = "Korta Flour"
	description = "A coarsely ground, peppery flour made from korta nut shells."
	taste_description = "earthy heat"
	color = "#EEC39A"


/datum/reagent/consumable/korta_milk
	name = "Korta Milk"
	description = "A milky liquid made by crushing the centre of a korta nut."
	taste_description = "sugary milk"
	color = "#FFFFFF"


/datum/reagent/consumable/korta_nectar
	name = "Korta Nectar"
	description = "A sweet, sugary syrup made from crushed sweet korta nuts."
	color = "#d3a308"
	nutriment_factor = 5 * REAGENTS_METABOLISM
	ingest_met = 0.2
	taste_description = "peppery sweetness"

/datum/reagent/consumable/whipped_cream
	name = "Whipped Cream"
	description = "A white fluffy cream made from whipping cream at intense speed."
	color = "#efeff0"
	nutriment_factor = 4 * REAGENTS_METABOLISM
	taste_description = "fluffy sweet cream"


/datum/reagent/consumable/peanut_butter
	name = "Peanut Butter"
	description = "A rich, creamy spread produced by grinding peanuts."
	taste_description = "peanuts"
	color = "#D9A066"


/datum/reagent/consumable/peanut_butter/affect_ingest(mob/living/carbon/C, removed) //ET loves peanut butter
	if(isabductor(C))
		C.set_timed_status_effect(30 SECONDS * removed, /datum/status_effect/drugginess, only_if_higher = TRUE)
	return ..()

/datum/reagent/consumable/vinegar
	name = "Vinegar"
	description = "Useful for pickling, or putting on chips."
	taste_description = "acid"
	color = "#661F1E"


//A better oil, representing choices like olive oil, argan oil, avocado oil, etc.
/datum/reagent/consumable/quality_oil
	name = "Quality Oil"
	description = "A high quality oil, suitable for dishes where the oil is a key flavour."
	taste_description = "olive oil"
	color = "#DBCF5C"


/datum/reagent/consumable/cornmeal
	name = "Cornmeal"
	description = "Ground cornmeal, for making corn related things."
	taste_description = "raw cornmeal"
	color = "#ebca85"


/datum/reagent/consumable/yoghurt
	name = "Yoghurt"
	description = "Creamy natural yoghurt, with applications in both food and drinks."
	taste_description = "yoghurt"
	color = "#efeff0"
	nutriment_factor = 2 * REAGENTS_METABOLISM


/datum/reagent/consumable/cornmeal_batter
	name = "Cornmeal Batter"
	description = "An eggy, milky, corny mixture that's not very good raw."
	taste_description = "raw batter"
	color = "#ebca85"

/datum/reagent/consumable/tinlux
	name = "Tinea Luxor"
	description = "A stimulating ichor which causes luminescent fungi to grow on the skin. "
	color = "#b5a213"
	taste_description = "tingling mushroom"
	chemical_flags = REAGENT_DEAD_PROCESS

/datum/reagent/consumable/tinlux/on_mob_add(mob/living/living_mob)
	. = ..()
	living_mob.apply_status_effect(/datum/status_effect/tinlux_light) //infinite duration

/datum/reagent/consumable/tinlux/on_mob_delete(mob/living/living_mob)
	. = ..()
	living_mob.remove_status_effect(/datum/status_effect/tinlux_light)

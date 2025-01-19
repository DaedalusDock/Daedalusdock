GLOBAL_LIST_INIT(name2reagent, build_name2reagent())

/proc/build_name2reagent()
	. = list()
	for (var/t in subtypesof(/datum/reagent))
		var/datum/reagent/R = t
		if (length(initial(R.name)))
			.[ckey(initial(R.name))] = t


//Various reagents
//Toxin & acid reagents
//Hydroponics stuff

/// A single reagent
/datum/reagent
	/// datums don't have names by default
	var/name = ""
	/// nor do they have descriptions
	var/description = ""
	/// Text to insert into the "mechanics" section of the codex.
	var/codex_mechanics = ""
	///J/(K*mol)
	var/specific_heat = SPECIFIC_HEAT_DEFAULT
	/// used by taste messages
	var/taste_description = "metaphorical salt"
	///how this taste compares to others. Higher values means it is more noticable
	var/taste_mult = 1
	/// use for specialty drinks.
	var/glass_name = "glass of ...what?"
	/// desc applied to glasses with this reagent
	var/glass_desc = "You can't really tell what this is."
	/// Icon for the... glass.
	var/glass_icon = 'icons/obj/drinks.dmi'
	/// Otherwise just sets the icon to a normal glass with the mixture of the reagents in the glass.
	var/glass_icon_state = null
	/// used for shot glasses, mostly for alcohol
	var/shot_glass_icon_state = null
	/// fallback icon if  the reagent has no glass or shot glass icon state. Used for restaurants.
	var/fallback_icon_state = null
	/// reagent holder this belongs to
	var/datum/reagents/holder = null
	/// LIQUID, SOLID, GAS
	var/reagent_state = LIQUID
	/// Special data associated with the reagent that will be passed on upon transfer to a new holder.
	var/list/data
	/// increments everytime on_mob_life is called
	var/current_cycle = 0
	///pretend this is moles
	var/volume = 0
	///The molar mass of the reagent - if you're adding a reagent that doesn't have a recipe, just add a random number between 10 - 800. Higher numbers are "harder" but it's mostly arbitary.
	var/mass
	/// color it looks in containers etc
	var/color = "#000000" // rgb: 0, 0, 0

	///how fast the reagent is metabolized by the mob
	var/metabolization_rate = 0.2
	/// How fast the reagent metabolizes on touch
	var/touch_met = 0.01
	/// How fast the reagent metabolizes when ingested. NOTE: Due to how reagents are coded, if you have an on_metabolize() for blood, this MUST be greater than metabolization_rate.
	var/ingest_met = 1

	/// above this overdoses happen
	var/overdose_threshold = 0
	/// You fucked up and this is now triggering its overdose effects, purge that shit quick.
	var/overdosed = FALSE
	///if false stops metab in liverless mobs
	var/self_consuming = FALSE
	///affects how far it travels when sprayed
	var/reagent_weight = 1
	///is it currently metabolizing
	var/metabolizing = FALSE
	/// is it bad for you? Currently only used for borghypo. C2s and Toxins have it TRUE by default.
	var/harmful = FALSE
	/// Are we from a material? We might wanna know that for special stuff. Like metalgen. Is replaced with a ref of the material on New()
	var/datum/material/material
	///The set of exposure methods this penetrates skin with.
	var/penetrates_skin = VAPOR
	/// See fermi_readme.dm REAGENT_DEAD_PROCESS, REAGENT_DONOTSPLIT, REAGENT_INVISIBLE, REAGENT_SNEAKYNAME, REAGENT_SPLITRETAINVOL, REAGENT_CANSYNTH, REAGENT_IMPURE
	var/chemical_flags = NONE

	/// Does this reagent and its recipe appear in the Codex?
	var/show_in_codex = TRUE

	///Thermodynamic vars
	///How hot this reagent burns when it's on fire - null means it can't burn
	var/burning_temperature = null
	///How much is consumed when it is burnt per second
	var/burning_volume = 0.5

	///Assoc list with key type of addiction this reagent feeds, and value amount of addiction points added per unit of reagent metabolzied (which means * REAGENTS_METABOLISM every life())
	var/list/addiction_types = null

	///The amount a robot will pay for a glass of this (20 units but can be higher if you pour more, be frugal!)
	var/glass_price
	/// Cargo value per unit
	var/value = 0
	//The closest abstract type this reagent belongs to. Used to detect creation of abstract chemicals.
	abstract_type = /datum/reagent


/datum/reagent/New()
	SHOULD_CALL_PARENT(TRUE)
	. = ..()

	if(material)
		material = GET_MATERIAL_REF(material)
	if(glass_price)
		AddElement(/datum/element/venue_price, glass_price)
	if(!mass)
		mass = rand(10, 800)
	if(isabstract(src))//Are we trying to instantiate an abstract reagent?
		CRASH("Attempted to create abstract reagent [type]")

/datum/reagent/Destroy() // This should only be called by the holder, so it's already handled clearing its references
	. = ..()
	holder = null

///Called whenever a reagent is on fire, or is in a holder that is on fire. (WIP)
/datum/reagent/proc/burn(datum/reagents/holder)
	return

/// Called from [/datum/reagents/proc/metabolize]
/datum/reagent/proc/on_mob_life(mob/living/carbon/M, location, do_addiction)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	current_cycle++
	var/removed = metabolization_rate
	if(ingest_met && (location == CHEM_INGEST))
		removed = ingest_met
	if(touch_met && (location == CHEM_TOUCH))
		removed = touch_met

	removed *= M.metabolism_efficiency
	removed = min(removed, volume)

	if(do_addiction && length(addiction_types))
		for(var/addiction in addiction_types)
			M.mind?.add_addiction_points(addiction, addiction_types[addiction] * removed)

	//adjust effective amounts - removed, dose, and max_dose - for mob size
	var/effective = removed
	if(!(chemical_flags & REAGENT_IGNORE_MOB_SIZE) && location != CHEM_TOUCH)
		effective *= (MOB_SIZE_HUMAN/M.mob_size)

	var/remove_from_holder = FALSE
	if(effective >= (metabolization_rate * 0.1) || effective >= 0.1)
		switch(location)
			if(CHEM_BLOOD)
				if(type == M.dna?.species.exotic_blood)
					M.adjustBloodVolumeUpTo(round(volume, 0.1), BLOOD_VOLUME_MAXIMUM)
					holder.del_reagent(type)
					return
				else
					. = affect_blood(M, effective)
					remove_from_holder = TRUE

			if(CHEM_TOUCH)
				. = affect_touch(M, effective)
				remove_from_holder = TRUE

			if(CHEM_INGEST)
				if(type == M.dna?.species.exotic_blood)
					M.adjustBloodVolumeUpTo(round(volume / 5, 0.1), BLOOD_VOLUME_MAXIMUM)
					holder.del_reagent(type)
					return
				else
					. = affect_ingest(M, effective)
					// Thanos snap a small portion of what we processed.
					// This is only after transfering to Blood because we're nice :)
					holder?.remove_reagent(type, ingest_met * 0.2)

	if(remove_from_holder)
		// Holder can go null if we're removed from our container during processing.
		holder?.remove_reagent(type, removed)

/datum/reagent/proc/affect_blood(mob/living/carbon/C, removed)
	SHOULD_NOT_SLEEP(TRUE)
	return

/// Ingestion process. Call parent *after* your override's body, as holder can go null as a result of trans_id_to.
/datum/reagent/proc/affect_ingest(mob/living/carbon/C, removed)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)

	// Annoys the living hell out of me, but this ensures nothing outright breaks and causes
	// constant metabolism start/stop.
	holder.trans_id_to(C.bloodstream, src, max(ingest_met, metabolization_rate + 0.01), TRUE)

/// Touch process. Don't get covered in acid, now!
/datum/reagent/proc/affect_touch(mob/living/carbon/C, removed)
	SHOULD_NOT_SLEEP(TRUE)
	return

/*
Used to run functions before a reagent is transfered. Returning TRUE will block the transfer attempt.
Primarily used in reagents/reaction_agents
*/
/datum/reagent/proc/intercept_reagents_transfer(datum/reagents/target)
	return FALSE

///Called after a reagent is transfered
/datum/reagent/proc/on_transfer(atom/A, methods=TOUCH, trans_volume)
	return

/// Called when this reagent is first added to a mob
/datum/reagent/proc/on_mob_add(mob/living/carbon/C, amount, class)
	SHOULD_NOT_SLEEP(TRUE)
	return

/// Called when this reagent is removed while inside a mob
/datum/reagent/proc/on_mob_delete(mob/living/carbon/C, class)
	SHOULD_NOT_SLEEP(TRUE)
	return

/// Called when this reagent first starts being metabolized. Does NOT get called during microdoses, such as when going from stomach to blood.
/datum/reagent/proc/on_mob_metabolize(mob/living/carbon/C, class)
	SHOULD_NOT_SLEEP(TRUE)
	return

/// Called when this reagent stops being metabolized by a liver
/datum/reagent/proc/on_mob_end_metabolize(mob/living/carbon/C, class)
	SHOULD_NOT_SLEEP(TRUE)
	return

/// Called after add_reagents creates a new reagent.
/datum/reagent/proc/on_new(data)
	if(data)
		src.data = data

/// Called when two reagents of the same are mixing.
/datum/reagent/proc/on_merge(data, amount)
	return

/// Called if the reagent has passed the overdose threshold and is set to be triggering overdose effects
/datum/reagent/proc/overdose_process(mob/living/carbon/C)
	SHOULD_NOT_SLEEP(TRUE)
	APPLY_CHEM_EFFECT(C, CE_TOXIN, 1)
	C.adjustToxLoss(0.2, FALSE, cause_of_death = "Overdose")
	return TRUE

/// Called when an overdose starts
/datum/reagent/proc/overdose_start(mob/living/carbon/C)
	SHOULD_NOT_SLEEP(TRUE)
	return

/// Called when an overdose ends
/datum/reagent/proc/overdose_end(mob/living/carbon/C)
	SHOULD_NOT_SLEEP(TRUE)
	return

/**
 * New, standardized method for chemicals to affect hydroponics trays.
 * Defined on a per-chem level as opposed to by the tray.
 * Can affect plant's health, stats, or cause the plant to react in certain ways.
 */
/datum/reagent/proc/on_hydroponics_apply(datum/plant_tick/plant_tick, datum/reagents/chems, volume, obj/machinery/hydroponics/mytray, mob/user)
	if(!mytray)
		return

/**
 * Called by the Plantmaster to infuse a plant.
 * Returns an amount to damage the plant.
 * Args:
 * * plant_datum: The plant being infused.
 * * plant_dna: The plant's gene holder.
 * * damage_ref: Lists are references abuse. Add a number to the list to deal damage to the seed.
 */
/datum/reagent/proc/infuse_plant(datum/plant/plant_datum, datum/plant_gene_holder/plant_dna, list/damage_ref) as /obj/item/seeds
	RETURN_TYPE(/obj/item/seeds)
	return

/// Should return a associative list where keys are taste descriptions and values are strength ratios
/datum/reagent/proc/get_taste_description(mob/living/taster)
	return list("[taste_description]" = 1)

/proc/pretty_string_from_reagent_list(list/reagent_list)
	//Convert reagent list to a printable string for logging etc
	var/list/rs = list()
	for (var/datum/reagent/R in reagent_list)
		rs += "[R.name], [R.volume]"

	return rs.Join(" | ")



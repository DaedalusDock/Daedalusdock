/**
 * Finds and extracts seeds from an object
 *
 * Checks if the object is such that creates a seed when extracted.  Used by seed
 * extractors or posably anything that would create seeds in some way.  The seeds
 * are dropped either at the extractor, if it exists, or where the original object
 * was and it qdel's the object
 *
 * Arguments:
 * * O - Object containing the seed, can be the loc of the dumping of seeds
 * * t_max - Amount of seed copies to dump, -1 is ranomized
 * * extractor - Seed Extractor, used as the dumping loc for the seeds and seed multiplier
 * * user - checks if we can remove the object from the inventory
 * *
 */
/proc/seedify(obj/item/O, t_max, obj/machinery/seed_extractor/extractor, mob/living/user)
	var/t_amount = 0
	var/list/seeds = list()
	if(t_max == -1)
		if(extractor)
			t_max = rand(1,4) * extractor.seed_multiplier
		else
			t_max = rand(1,4)

	var/seedloc = O.loc
	if(extractor)
		seedloc = extractor.loc

	if(istype(O, /obj/item/food/grown))
		var/obj/item/food/grown/F = O
		if(F.plant_datum)
			if(user && !user.temporarilyRemoveItemFromInventory(O)) //couldn't drop the item
				return

			var/seed_path = F.plant_datum.seed_path
			while(t_amount < t_max)
				var/obj/item/seeds/t_prod = new seed_path(null, F.plant_datum)
				seeds.Add(t_prod)
				t_prod.forceMove(seedloc)
				t_amount++

			qdel(O)
			return seeds

	else if(istype(O, /obj/item/grown))
		var/obj/item/grown/F = O
		if(F.plant_datum)
			if(user && !user.temporarilyRemoveItemFromInventory(O))
				return

			var/seed_path = F.plant_datum.seed_path
			while(t_amount < t_max)
				var/obj/item/seeds/t_prod = new seed_path(null, F.plant_datum)
				t_prod.forceMove(seedloc)
				t_amount++
			qdel(O)
		return 1

	return 0


/obj/machinery/seed_extractor
	name = "Plantmaster Mk.V"
	desc = "Extracts and bags seeds from produce."
	icon = 'icons/obj/hydroponics/equipment.dmi'
	icon_state = "sextractor"
	density = TRUE
	circuit = /obj/item/circuitboard/machine/seed_extractor

	/// Seeds to their data list.
	var/list/seeds_to_data = list()

	var/max_seeds = 1000
	var/seed_multiplier = 1

	/// The selected seed for splicing.
	var/obj/item/seeds/splice_target

	var/obj/item/reagent_containers/beaker

	/// I'm lazy and feeling soulful.
	var/obj/item/plant_analyzer/internal_analyzer

/obj/machinery/seed_extractor/Initialize(mapload, obj/item/seeds/new_seed)
	. = ..()
	register_context()
	internal_analyzer = new(null)

/obj/machinery/seed_extractor/add_context(
	atom/source,
	list/context,
	obj/item/held_item,
	mob/living/user,
)

	if(held_item?.get_plant_datum())
		context[SCREENTIP_CONTEXT_LMB] = "Make seeds"
		return CONTEXTUAL_SCREENTIP_SET

	if(istype(held_item, /obj/item/storage/bag/plants) && (locate(/obj/item/seeds) in held_item.contents))
		context[SCREENTIP_CONTEXT_LMB] = "Store seeds"
		return CONTEXTUAL_SCREENTIP_SET

	return NONE

/obj/machinery/seed_extractor/Destroy()
	QDEL_LIST(seeds_to_data)
	QDEL_NULL(internal_analyzer)
	QDEL_NULL(beaker)
	QDEL_NULL(splice_target)
	return ..()

/obj/machinery/seed_extractor/RefreshParts()
	. = ..()
	for(var/obj/item/stock_parts/matter_bin/B in component_parts)
		max_seeds = initial(max_seeds) * B.rating
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		seed_multiplier = initial(seed_multiplier) * M.rating

/obj/machinery/seed_extractor/examine(mob/user)
	. = ..()
	if(in_range(user, src) || isobserver(user))
		. += span_notice("The status display reads: Extracting <b>[seed_multiplier] to [seed_multiplier * 4]</b> seed(s) per piece of produce.<br>Machine can store up to <b>[max_seeds]</b> seeds.")

/obj/machinery/seed_extractor/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	default_unfasten_wrench(user, tool)
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/machinery/seed_extractor/attackby(obj/item/attacking_item, mob/living/user, params)
	if(!isliving(user) || user.combat_mode)
		return ..()

	if(default_deconstruction_screwdriver(user, "sextractor_open", "sextractor", attacking_item))
		return TRUE

	if(default_pry_open(attacking_item))
		return TRUE

	if(default_deconstruction_crowbar(attacking_item))
		return TRUE

	if(is_reagent_container(attacking_item))
		if(replace_beaker(user, attacking_item))
			return TRUE

	if(istype(attacking_item, /obj/item/storage/bag/plants))
		var/loaded = 0
		for(var/obj/item/seeds/to_store in attacking_item.contents)
			if(contents.len >= max_seeds)
				to_chat(user, span_warning("[src] is full."))
				break
			if(!add_seed(to_store, attacking_item))
				continue
			loaded += 1

		if(loaded)
			to_chat(user, span_notice("You put as many seeds from [attacking_item] into [src] as you can."))
			update_static_data_for_all()
		else
			to_chat(user, span_warning("There are no seeds in [attacking_item]."))

		return TRUE

	if(seedify(attacking_item, -1, src, user))
		to_chat(user, span_notice("You extract some seeds."))
		return TRUE

	else if(istype(attacking_item, /obj/item/seeds))
		if(contents.len >= max_seeds)
			to_chat(user, span_warning("[src] is full."))

		else if(add_seed(attacking_item, user))
			to_chat(user, span_notice("You add [attacking_item] to [src]."))
			update_static_data_for_all()

		else
			to_chat(user, span_warning("You can't seem to add [attacking_item] to [src]."))
		return TRUE

	else if(!attacking_item.tool_behaviour) // Using the wrong tool shouldn't assume you want to turn it into seeds.
		to_chat(user, span_warning("You can't extract any seeds from [attacking_item]!"))
		return TRUE

	return ..()

/obj/machinery/seed_extractor/Exited(atom/movable/gone, direction)
	. = ..()

	if(gone == beaker)
		beaker = null

	if(gone == splice_target)
		splice_target = null

	if(QDELING(src))
		return

	set_seed_data(gone, TRUE)
	update_static_data_for_all()

/// Replaces the beaker, or removes it, or adds it.
/obj/machinery/seed_extractor/proc/replace_beaker(mob/living/user, obj/item/new_beaker)
	if(beaker)
		try_put_in_hand(beaker, user)

	if(new_beaker)
		if(user)
			if(!user.transferItemToLoc(new_beaker, src))
				return FALSE
		else
			new_beaker.forceMove(src)

		beaker = new_beaker

	return TRUE


/** Add Seeds Proc.
 *
 * Adds the seeds to the contents and to an associated list that pregenerates the data
 * needed to go to the ui handler
 *
 * to_add - what seed are we adding?
 * taking_from - where are we taking the seed from? A mob, a bag, etc?
 **/
/obj/machinery/seed_extractor/proc/add_seed(obj/item/seeds/to_add, atom/taking_from)
	if(taking_from)
		if(ismob(taking_from))
			var/mob/mob_loc = taking_from
			if(!mob_loc.transferItemToLoc(to_add, src))
				return FALSE

		else if(!taking_from.atom_storage?.attempt_remove(to_add, src, silent = TRUE))
			return FALSE

	set_seed_data(to_add)

	if(ismob(taking_from))
		SStgui.try_update_ui(taking_from, src)

	return TRUE

/obj/machinery/seed_extractor/proc/set_seed_data(obj/item/seeds/seed, remove = FALSE)
	if(remove)
		seeds_to_data -= seed
	else
		seeds_to_data[seed] = list(
			"ref" = ref(seed),
			"name" = seed.plant_datum.name,
			"damage" = seed.seed_damage,
			"genome" = seed.plant_datum.genome,
			"potency" = seed.plant_datum.gene_holder.potency,
			"endurance" = seed.plant_datum.gene_holder.endurance,
			"production" = seed.plant_datum.gene_holder.production,
			"maturation" = seed.plant_datum.gene_holder.maturation,
			"yield" = seed.plant_datum.gene_holder.harvest_yield,
		)

/obj/machinery/seed_extractor/ui_state(mob/user)
	return GLOB.notcontained_state

/obj/machinery/seed_extractor/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SeedExtractor", name)
		ui.open()

/obj/machinery/seed_extractor/ui_static_data()
	var/list/seed_data_list = list()
	for(var/seed in seeds_to_data)
		seed_data_list[++seed_data_list.len] = seeds_to_data[seed]

	. = list()
	.["seeds"] = seed_data_list

/obj/machinery/seed_extractor/ui_data()
	var/list/data = list()
	var/list/beaker_data = list(
		"loaded" = !!beaker,
		"max_volume" = beaker?.reagents.maximum_volume,
		"volume" = beaker?.reagents.total_volume,
	)

	if(beaker)
		var/list/reagents = list()
		beaker_data["reagents"] = reagents

		for(var/datum/reagent/R as anything in beaker.reagents.reagent_list)
			reagents[++reagents.len] = list(
				"name" = R.name,
				"volume" = R.volume
			)

	data["splice_target"] = seeds_to_data[splice_target]
	data["beaker"] = beaker_data
	return data

/obj/machinery/seed_extractor/ui_act(action, params)
	. = ..()
	if(.)
		return

	switch(action)
		if("eject")
			var/obj/item/seeds/found_seed = locate(params["ref"]) in seeds_to_data
			if(!found_seed)
				return

			if(usr)
				var/mob/user = usr
				if(user.put_in_hands(found_seed))
					to_chat(user, span_notice("You take [found_seed] out of the slot."))
					return TRUE

			found_seed.forceMove(drop_location())
			visible_message(span_notice("[found_seed] falls onto the floor."), null, span_hear("You hear a soft clatter."), COMBAT_MESSAGE_RANGE)
			return TRUE

		if("splice")
			var/obj/item/seeds/found_seed = locate(params["ref"]) in seeds_to_data
			if(!found_seed)
				return

			if(found_seed == splice_target)
				splice_target = null
				return TRUE

			if(isnull(splice_target))
				splice_target = found_seed
				return TRUE

			splice(splice_target, found_seed)
			return TRUE

		if("label")
			var/obj/item/seeds/found_seed = locate(params["ref"]) in seeds_to_data
			if(!found_seed)
				return

			var/new_name = strip_html(params["name"])
			if(!length(new_name) || (found_seed.name == new_name))
				return

			found_seed.name = new_name
			set_seed_data(found_seed)
			update_static_data_for_all()
			return TRUE

		if("analyze")
			var/obj/item/seeds/found_seed = locate(params["ref"]) in seeds_to_data
			if(!found_seed)
				return

			internal_analyzer.do_plant_stats_scan(found_seed, usr)
			return TRUE

		if("infuse")
			noop()

		if("eject_beaker")
			if(!beaker)
				return

			if(replace_beaker(usr))
				return TRUE

/obj/machinery/seed_extractor/proc/splice(obj/item/seeds/seed_one, obj/item/seeds/seed_two)
	var/datum/plant/plant_one = seed_one.plant_datum
	var/datum/plant/plant_two = seed_two.plant_datum

	if(!plant_one || !plant_two)
		return FALSE

	var/datum/plant/dominant_species
	var/datum/plant/recessive_species

	var/species_dominance = plant_one.gene_holder.species_dominance - plant_two.gene_holder.species_dominance
	switch(species_dominance)
		if(1)
			dominant_species = plant_one
		if(0)
			dominant_species = pick(plant_one, plant_two)
		if(-1)
			dominant_species = plant_two

	recessive_species = dominant_species == plant_one ? plant_two : plant_one

	var/new_seed_type = dominant_species.seed_path
	var/obj/item/seeds/new_seed = new new_seed_type(src)
	var/datum/plant/new_plant = new_seed.plant_datum

	new_plant.is_hybrid = TRUE
	new_plant.generation = max(dominant_species.generation, recessive_species.generation) + 1

	if(dominant_species.name != recessive_species.name)
		var/part1 = copytext(dominant_species.name, 1, round(length(dominant_species.name) * 0.65 + 1.5))
		var/part2 = copytext(recessive_species.name, round(length(recessive_species.name) * 0.45 + 1), 0)
		new_plant.name = "[part1][part2]"
	else
		new_plant.name = dominant_species.name

	new_plant.species = dominant_species.species
	new_plant.growing_icon = dominant_species.growing_icon
	new_plant.icon_dead = dominant_species.icon_dead
	new_plant.icon_grow = dominant_species.icon_grow
	new_plant.icon_harvest = dominant_species.icon_harvest

	new_plant.base_health = dominant_species.base_health

	new_plant.genome = round((dominant_species.genome + recessive_species.genome) / 2)
	new_seed.name = "[new_plant.name] seed"

	for(var/datum/plant_gene/gene as anything in dominant_species.gene_holder.gene_list)
		if(gene.gene_flags & PLANT_GENE_UNSPLICABLE)
			continue

		new_plant.gene_holder.add_active_gene(gene.Copy())

	new_plant.innate_genes = dominant_species.innate_genes | recessive_species.innate_genes
	new_plant.latent_genes = dominant_species.latent_genes | recessive_species.latent_genes

	for(var/innate_gene in new_plant.innate_genes)
		new_plant.gene_holder.add_active_gene(new innate_gene)

	new_plant.reagents_per_potency = list()
	for(var/reagent_path in dominant_species.reagents_per_potency)
		new_plant.reagents_per_potency[reagent_path] = dominant_species.reagents_per_potency[reagent_path]

	for(var/reagent_path in (recessive_species.reagents_per_potency - dominant_species.reagents_per_potency))
		new_plant.reagents_per_potency[reagent_path] = recessive_species.reagents_per_potency[reagent_path]

	var/datum/plant_gene_holder/dominant_dna = dominant_species.gene_holder
	var/datum/plant_gene_holder/recessive_dna = recessive_species.gene_holder

	new_plant.gene_holder.potency = SShydroponics.splice_alleles(dominant_dna.potency_dominance, recessive_dna.potency_dominance, dominant_dna.potency, recessive_dna.potency)
	new_plant.base_potency = SShydroponics.splice_alleles(dominant_dna.potency_dominance, recessive_dna.potency_dominance, dominant_species.base_potency, recessive_species.base_potency)

	new_plant.gene_holder.endurance = SShydroponics.splice_alleles(dominant_dna.endurance_dominance, recessive_dna.endurance_dominance, dominant_dna.endurance, recessive_dna.endurance)
	new_plant.base_endurance = SShydroponics.splice_alleles(dominant_dna.endurance_dominance, recessive_dna.endurance_dominance, dominant_species.base_endurance, recessive_species.base_endurance)

	new_plant.gene_holder.production = SShydroponics.splice_alleles(dominant_dna.produce_time_dominance, recessive_dna.produce_time_dominance, dominant_dna.production, recessive_dna.production)
	new_plant.base_production = SShydroponics.splice_alleles(dominant_dna.produce_time_dominance, recessive_dna.produce_time_dominance, dominant_species.base_production, recessive_species.base_production)

	new_plant.gene_holder.maturation = SShydroponics.splice_alleles(dominant_dna.growth_time_dominance, recessive_dna.growth_time_dominance, dominant_dna.maturation, recessive_dna.maturation)
	new_plant.base_maturation = SShydroponics.splice_alleles(dominant_dna.growth_time_dominance, recessive_dna.growth_time_dominance, dominant_species.base_maturation, recessive_species.base_maturation)

	new_plant.gene_holder.harvest_yield = SShydroponics.splice_alleles(dominant_dna.yield_dominance, recessive_dna.yield_dominance, dominant_dna.harvest_yield, recessive_dna.harvest_yield)
	new_plant.base_harvest_yield = SShydroponics.splice_alleles(dominant_dna.yield_dominance, recessive_dna.yield_dominance, dominant_species.base_harvest_yield, recessive_species.base_harvest_yield)

	new_plant.gene_holder.harvest_amt = SShydroponics.splice_alleles(dominant_dna.harvest_amt_dominance, recessive_dna.harvest_amt_dominance, dominant_dna.harvest_amt, recessive_dna.harvest_amt)
	new_plant.base_harvest_amt = SShydroponics.splice_alleles(dominant_dna.harvest_amt_dominance, recessive_dna.harvest_amt_dominance, dominant_species.base_harvest_amt, recessive_species.base_harvest_amt)

	new_seed.forceMove(src)
	add_seed(new_seed)
	update_static_data_for_all()

	qdel(seed_one)
	qdel(seed_two)
	return TRUE

/obj/machinery/seed_extractor/proc/get_splice_chance(obj/item/seeds/seed_one, obj/item/seeds/seed_two)
	var/datum/plant/plant_one = seed_one.plant_datum
	var/datum/plant/plant_two = seed_two.plant_datum

	var/splice_chance = 100
	var/genome_delta = abs(plant_one.genome - plant_two.genome)

	splice_chance -= genome_delta * 10

	return min(splice_chance, 0)

/obj/machinery/seed_extractor/proc/try_infuse(mob/living/user, obj/item/seeds/seed)
	if(beaker.reagents.total_volume < 10)
		return FALSE

	var/list/valid_reagents = list()
	for(var/datum/reagent/R as anything in beaker.reagents.reagent_list)
		if(R.volume < 10)
			continue

		valid_reagents[capitalize(R.name)] = R

	if(!length(valid_reagents))
		return FALSE

	var/chosen = tgui_input_list(user, "Select a reagent to infuse", "Infusion", valid_reagents)
	if(isnull(valid_reagents))
		return FALSE

	var/datum/reagent/chosen_reagent = valid_reagents[chosen]
	if(!beaker?.reagents.has_reagent(chosen_reagent.type, 10))
		return FALSE

	seed.damage_seed(rand(3, 7))
	beaker.reagents.remove_reagent(chosen_reagent.type, 10)
	if(QDELETED(seed))
		to_chat(user, span_warning("The seed was destroyed."))
		playsound(src, 'sound/machines/buzz-sigh.ogg', 50)
		return TRUE

	var/obj/item/seeds/new_seed = seed.plant_datum.infuse(chosen_reagent)
	if(QDELETED(seed) && isnull(new_seed))
		to_chat(user, span_warning("The seed was destroyed."))
		playsound(src, 'sound/machines/buzz-sigh.ogg', 50)
		return TRUE

	if(new_seed)
		add_seed(new_seed)
		to_chat(user, span_notice("You've created [new_seed]."))
		playsound(src, 'sound/machines/chime.ogg', 50)
		return TRUE

	to_chat(user, span_notice("Infusion of [seed] successful."))
	playsound(src, 'sound/machines/chime.ogg', 50)
	return TRUE

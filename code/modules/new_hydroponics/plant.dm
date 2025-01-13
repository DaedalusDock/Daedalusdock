/datum/plant
	var/name = "BAD NAME"

	/// Ref to the seed we're in, if any.
	var/obj/item/seeds/in_seed

	/// Used to update icons. Should match the name in the sprites unless all icon_* are overridden.
	var/species = ""
	///the file that stores the sprites of the growing plant from this seed.
	var/growing_icon = 'icons/obj/hydroponics/growing.dmi'
	/// How many icon states there are between start and mature (inclusive)
	var/growthstages = 6
	/// Used to override grow icon (default is `"[species]-grow"`). You can use one grow icon for multiple closely related plants with it.
	var/icon_grow
	/// Used to override dead icon (default is `"[species]-dead"`). You can use one dead icon for multiple closely related plants with it.
	var/icon_dead
	/// Used to override harvest icon (default is `"[species]-harvest"`). If null, plant will use `[icon_grow][growthstages]`.
	var/icon_harvest

	/// The starting health value of this plant.
	var/base_health = 15
	/// The baseline amount of time to reach maturity. Half of this value is the time to reach "Growing"
	var/time_to_grow = 40 SECONDS
	/// The baseline amount of time AFTER reaching maturity to produce a harvest.
	var/time_to_produce = 40 SECONDS

	// * Stats * //
	/// The starting amount of endurance this plant has.
	var/base_endurance = 0
	/// The starting amount of potency this plant has.
	var/base_potency = 0

	/// Typepath of the product upon harvesting.
	var/product_path
	/// Type of seed produced.
	var/seed_path = /obj/item/seeds
	/// How many instances of the product are yielded per harvest.
	var/harvest_yield = 1
	/// How many times you can harvest this plant.
	var/harvest_amt = 1

	var/list/reagents_per_potency

	/// Innate genes that all instances of this plant have.
	var/list/innate_genes
	/// Genes this plant has, may or may not be active.
	var/list/latent_genes
	/// Possible mutation paths for this plant.
	var/list/possible_mutations

	/// A pseudoarbitrary value. When attempting to splice two plants together, a larger difference in genome value makes it more difficult.
	var/genome = 1
	#warn impl genome

	/// Rarity, decides export value.
	var/rarity = 0

	/// If the plant needs water to survive.
	var/needs_water = TRUE
	/// If this plant was created as a result of genetic splicing.
	var/is_hybrid = FALSE

	//* Stateful vars *//

	///The status of the plant in the tray. Whether it's harvestable, alive, missing or dead.
	var/plant_status = PLANT_DEAD

	/// The genes of the plant.
	var/datum/plant_gene_holder/gene_holder

/datum/plant/New(random_genes)
	gene_holder = new()
	if(random_genes)
		gene_holder.randomize_alleles()

	for(var/path in possible_mutations)
		possible_mutations -= path
		possible_mutations += SShydroponics.mutation_list[path]

/datum/plant/Destroy()
	in_seed = null
	return ..()

/datum/plant/proc/Copy()
	RETURN_TYPE(/datum/plant)
	var/datum/plant/new_plant = new type()
	new_plant.gene_holder.CopyFrom(gene_holder)

	return new_plant

/**
 * Returns the plant's growth state.
 * Args:
 * * gene_holder: The plant's plant_gene_holder
 * * growth: Given growth time
 */
/datum/plant/proc/get_growth_status(growth)
	if(growth <= 0)
		return PLANT_DEAD

	if(growth >= get_growth_for_state(PLANT_HARVESTABLE))
		return PLANT_HARVESTABLE

	else if(growth >= get_growth_for_state(PLANT_MATURE))
		return PLANT_MATURE

	else if(growth >= get_growth_for_state(PLANT_GROWING))
		return PLANT_GROWING

	else
		return PLANT_PLANTED

/// Get the required growth value to reach a given state.
/datum/plant/proc/get_growth_for_state(desired_state)
	switch(desired_state)
		if(PLANT_HARVESTABLE)
			return get_effective_stat(PLANT_STAT_PRODUCE_TIME)
		if(PLANT_MATURE)
			return gene_holder.get_effective_stat(PLANT_STAT_GROW_TIME)
		if(PLANT_GROWING)
			return gene_holder.get_effective_stat(PLANT_STAT_GROW_TIME) / 2

/// Returns the given stat, including active gene modifiers.
/datum/plant/proc/get_effective_stat(stat)
	var/base_val = 0
	switch(stat)
		if(PLANT_STAT_GROW_TIME)
			base_val = time_to_grow
		if(PLANT_STAT_PRODUCE_TIME)
			base_val = time_to_produce
		if(PLANT_STAT_ENDURANCE)
			base_val = base_endurance
		if(PLANT_STAT_POTENCY)
			base_val = base_potency
		if(PLANT_STAT_YIELD)
			base_val = harvest_yield
		if(PLANT_STAT_HARVEST_AMT)
			base_val = harvest_amt

	. = base_val

	. += gene_holder.get_effective_stat(stat)

/**
 * This is where plant chemical products are handled.
 *
 * Individually, the formula for individual amounts of chemicals is Potency * the chemical production %, rounded to the fullest 1.
 * Specific chem handling is also handled here, like bloodtype, food taste within nutriment, and the auto-distilling/autojuicing traits.
 * This is where chemical reactions can occur, and the heating / cooling traits effect the reagent container.
 */
/datum/plant/proc/prepare_product(obj/item/product)
	ASSERT(product.reagents)

	var/reagent_max = 0
	for(var/reagent_path in reagents_per_potency)
		reagent_max += reagents_per_potency[reagent_path]

	if(!(IS_EDIBLE(product) || istype(product, /obj/item/grown)))
		return

	var/obj/item/food/grown/grown_edible = product
	var/potency = get_effective_stat(PLANT_STAT_POTENCY)

	for(var/reagent_path in reagents_per_potency)
		var/reagent_overflow_mod = reagents_per_potency[reagent_path]
		if(reagent_max > 1)
			reagent_overflow_mod = (reagents_per_potency[reagent_path] / reagent_max)

		var/edible_vol = grown_edible.reagents?.maximum_volume || 0

		 //the plant will always have at least 1u of each of the reagents in its reagent production traits
		var/amount = max(1, round((edible_vol) * (potency/100) * reagent_overflow_mod, 1)) //the plant will always have at least 1u of each of the reagents in its reagent production traits

		var/list/data
		switch(reagent_path)
			if(/datum/reagent/blood)
				data = list("blood_type" = /datum/blood/human/omin)

			if(/datum/reagent/consumable/nutriment, /datum/reagent/consumable/nutriment/vitamin)
				if(istype(grown_edible))
					data = grown_edible.tastes // apple tastes of apple.

		product.reagents.add_reagent(reagent_path, amount, data)

	//Handles the juicing trait, swaps nutriment and vitamins for that species various juices if they exist. Mutually exclusive with distilling.
	if(gene_holder.has_active_gene(/datum/plant_gene/product_trait/juicing) && grown_edible.juice_results)
		grown_edible.juice(grown_edible.reagents)

	else if(gene_holder.has_active_gene(/datum/plant_gene/product_trait/brewing) && grown_edible.distill_reagent)
		var/amount = grown_edible.reagents.has_reagent(/datum/reagent/consumable/nutriment) + product.reagents.has_reagent(/datum/reagent/consumable/nutriment/vitamin)
		grown_edible.reagents.add_reagent(grown_edible.distill_reagent, amount/2)


	/// The number of nutriments we have inside of our plant, for use in our heating / cooling genes
	var/num_nutriment = product.reagents.has_reagent(/datum/reagent/consumable/nutriment)

	// Heats up the plant's contents by 25 kelvin per 1 unit of nutriment. Mutually exclusive with cooling.
	if(gene_holder.has_active_gene(/datum/plant_gene/product_trait/chem_heating))
		product.visible_message(span_notice("[product] releases freezing air, consuming its nutriments to heat its contents."))
		product.reagents.remove_reagent(/datum/reagent/consumable/nutriment, num_nutriment)
		product.reagents.chem_temp = min(1000, (product.reagents.chem_temp + num_nutriment * 25))
		product.reagents.handle_reactions()
		playsound(product.loc, 'sound/effects/wounds/sizzle2.ogg', 5)

	// Cools down the plant's contents by 5 kelvin per 1 unit of nutriment. Mutually exclusive with heating.
	else if(gene_holder.has_active_gene(/datum/plant_gene/product_trait/chem_cooling))
		product.visible_message(span_notice("[product] releases a blast of hot air, consuming its nutriments to cool its contents."))
		product.reagents.remove_reagent(/datum/reagent/consumable/nutriment, num_nutriment)
		product.reagents.chem_temp = max(3, (product.reagents.chem_temp + num_nutriment * -5))
		product.reagents.handle_reactions()
		playsound(product.loc, 'sound/effects/space_wind.ogg', 50)

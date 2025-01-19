/datum/plant_mutation
	/// The type of seed to mutate into
	var/datum/plant/plant_type

	/// Chance to mutate on trigger.
	var/mutation_chance = 10

	/// Stat ranges that must be fallen into.
	var/list/ranges = list(
		PLANT_STAT_ENDURANCE = list(-INFINITY, INFINITY),
		PLANT_STAT_POTENCY = list(-INFINITY, INFINITY),
		PLANT_STAT_MATURATION = list(-INFINITY, INFINITY),
		PLANT_STAT_PRODUCTION = list(-INFINITY, INFINITY),
		PLANT_STAT_HARVEST_AMT = list(-INFINITY, INFINITY),
		PLANT_STAT_YIELD = list(-INFINITY, INFINITY)
	)

	/// Required genes.
	var/list/required_genes = null

	/// Reagents that need to be present to trigger an infusion.
	var/list/infusion_reagents = null

/// Check if this mutation can be applied to a given plant.
/datum/plant_mutation/proc/can_mutate(datum/plant/P)
	for(var/gene_path in required_genes)
		if(!P.gene_holder.has_active_gene_of_type(gene_path))
			return FALSE

	for(var/stat in ranges)
		var/list/stat_range = ranges[stat]
		var/lower = stat_range[1]
		var/upper = stat_range[2]
		if((lower == -INFINITY) && (upper == INFINITY))
			continue
		if(!(P.get_effective_stat(stat) in lower to upper))
			return FALSE

	return TRUE

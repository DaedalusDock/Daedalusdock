PROCESSING_SUBSYSTEM_DEF(hydroponics)
	name = "Hydroponics"
	flags = SS_HIBERNATE
	wait = 5 SECONDS


	var/list/gene_list = list()

	var/list/mutation_list = list()

	var/list/non_abstract_plant_types = list()

/datum/controller/subsystem/processing/hydroponics/Initialize(start_timeofday)
	. = ..()
	for(var/datum/plant_gene/path as anything in subtypesof(/datum/plant_gene))
		if(isabstract(path))
			continue

		gene_list[path] = new path

	for(var/datum/plant_mutation/path as anything in subtypesof(/datum/plant_mutation))
		if(isabstract(path))
			continue

		mutation_list[path] = new path

	for(var/datum/plant/path as anything in subtypesof(/datum/plant))
		if(isabstract(path))
			continue
		non_abstract_plant_types += path

/datum/controller/subsystem/processing/hydroponics/proc/splice_alleles(allele_one, allele_two, value_one, value_two)
	if(allele_one == allele_two)
		// Both were dominant or recessive, average them
		return round((allele_one + allele_two) / 2)

	var/dominance = allele_one - allele_two

	// Allele 1 was dominant. (1 - 0 == 1)
	if(dominance > 0)
		return value_one

	// Allele 1 was recessive. (0 - 1 == -1)
	else
		return value_two

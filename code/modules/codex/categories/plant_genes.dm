/datum/codex_category/plant_genes
	name = "Plant Genes"
	desc = "Information on plant genes found in game."

/datum/codex_category/plant_genes/Populate()
	for(var/datum/plant_gene/gene as anything in subtypesof(/datum/plant_gene))
		if(isabstract(gene))
			continue

		var/datum/codex_entry/entry = new(
			_display_name = "[initial(gene.name)] (plant gene)",
			_associated_paths = list(gene),
			_mechanics_text = initial(gene.desc),
		)

		items += entry

	return ..()

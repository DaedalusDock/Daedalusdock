/// Makes the plant embed on thrown impact.
/datum/plant_gene/trait/sticky
	name = "Prickly Adhesion"
	examine_line = "<span class='info'>It's quite sticky.</span>"
	trait_ids = THROW_IMPACT_ID
	mutability_flags = PLANT_GENE_REMOVABLE | PLANT_GENE_MUTATABLE | PLANT_GENE_GRAFTABLE

/datum/plant_gene/trait/sticky/on_new_plant(obj/item/product, newloc)
	. = ..()
	if(!.)
		return

	var/datum/plant/our_plant = product.get_plant_datum()
	if(our_plant.gene_holder.has_active_gene(/datum/plant_gene/trait/stinging))
		product.embedding = EMBED_POINTY
	else
		product.embedding = EMBED_HARMLESS

	product.updateEmbedding()
	product.throwforce = (our_plant.get_effective_stat(PLANT_STAT_POTENCY) / 20)

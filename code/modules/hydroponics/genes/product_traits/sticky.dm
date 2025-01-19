/// Makes the plant embed on thrown impact.
/datum/plant_gene/product_trait/sticky
	name = "Prickly Adhesion"
	examine_line = "<span class='info'>It's quite sticky.</span>"
	trait_ids = THROW_IMPACT_ID
	gene_flags = PLANT_GENE_MUTATABLE

/datum/plant_gene/product_trait/sticky/on_new_product(obj/item/product, newloc, datum/plant/plant_datum)
	. = ..()
	if(!.)
		return

	var/datum/plant/our_plant = product.get_plant_datum()
	if(our_plant.gene_holder.has_active_gene_of_type(/datum/plant_gene/product_trait/stinging))
		product.embedding = EMBED_POINTY
	else
		product.embedding = EMBED_HARMLESS

	product.updateEmbedding()
	product.throwforce = (our_plant.get_effective_stat(PLANT_STAT_POTENCY) / 20)

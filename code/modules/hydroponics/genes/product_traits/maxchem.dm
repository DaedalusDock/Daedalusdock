/**
 * A plant trait that causes the plant's capacity to double.
 *
 * When harvested, the plant's individual capacity is set to double it's default.
 * However, the plant's maximum yield is also halved, only up to 5.
 */
/datum/plant_gene/product_trait/maxchem
	name = "Densified Chemicals"
	rate = 2
	trait_flags = TRAIT_HALVES_YIELD
	gene_flags = PLANT_GENE_MUTATABLE

/datum/plant_gene/product_trait/maxchem/on_new_product(obj/item/our_plant, newloc)
	. = ..()
	if(!.)
		return

	var/obj/item/food/grown/grown_plant = our_plant
	if(istype(grown_plant, /obj/item/food/grown))
		//Grown foods use the edible component so we need to change their max_volume var
		grown_plant.max_volume *= rate
	else
		//Grown inedibles however just use a reagents holder, so.
		our_plant.reagents?.maximum_volume *= rate

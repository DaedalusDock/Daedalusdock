/// Traiit for plants eaten in 1 bite.
/datum/plant_gene/product_trait/one_bite
	name = "Large Bites"

/datum/plant_gene/product_trait/one_bite/on_new_product(obj/item/product, newloc, datum/plant/plant_datum)
	. = ..()
	if(!.)
		return

	var/obj/item/food/grown/grown_plant = product
	if(istype(grown_plant))
		grown_plant.bite_consumption_mod = 100

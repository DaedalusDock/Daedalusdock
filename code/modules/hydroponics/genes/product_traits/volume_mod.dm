/// Traits for plants with a different base max_volume.
/datum/plant_gene/product_trait/modified_volume
	name = "Deep Vesicles"
	/// The new number we set the plant's max_volume to.
	var/new_capcity = 100

/datum/plant_gene/product_trait/modified_volume/on_new_product(obj/item/product, newloc, datum/plant/plant_datum)
	. = ..()
	if(!.)
		return

	var/obj/item/food/grown/grown_plant = product
	if(istype(grown_plant))
		grown_plant.max_volume = new_capcity

/// Omegaweed's funny 420 max volume gene
/datum/plant_gene/product_trait/modified_volume/omega_weed
	name = "Dank Vesicles"
	new_capcity = 420

/// Cherry Bomb's increased max volume gene
/datum/plant_gene/product_trait/modified_volume/cherry_bomb
	name = "Powder-Filled Bulbs"
	new_capcity = 125

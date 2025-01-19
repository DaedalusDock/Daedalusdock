/**
 * A plant trait that causes the plant to gain aesthetic googly eyes.
 *
 * Has no functional purpose outside of causing japes, adds eyes over the plant's sprite, which are adjusted for size by potency.
 */
/datum/plant_gene/product_trait/eyes
	name = "Oculary Mimicry"
	/// Our googly eyes appearance.
	var/image/googly

/datum/plant_gene/product_trait/eyes/on_new_product(obj/item/product, newloc, datum/plant/plant_datum)
	. = ..()
	if(!.)
		return

	if(!googly)
		googly ||= image('icons/obj/hydroponics/harvest.dmi', "eyes")
		googly.appearance_flags = RESET_COLOR
	product.add_overlay(googly)

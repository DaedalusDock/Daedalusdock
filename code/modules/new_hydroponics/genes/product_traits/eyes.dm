/**
 * A plant trait that causes the plant to gain aesthetic googly eyes.
 *
 * Has no functional purpose outside of causing japes, adds eyes over the plant's sprite, which are adjusted for size by potency.
 */
/datum/plant_gene/trait/eyes
	name = "Oculary Mimicry"
	mutability_flags = PLANT_GENE_REMOVABLE | PLANT_GENE_MUTATABLE | PLANT_GENE_GRAFTABLE
	/// Our googly eyes appearance.
	var/image/googly

/datum/plant_gene/trait/eyes/on_new_plant(obj/item/product, newloc)
	. = ..()
	if(!.)
		return

	if(!googly)
		googly ||= image('icons/obj/hydroponics/harvest.dmi', "eyes")
		googly.appearance_flags = RESET_COLOR
	product.add_overlay(googly)

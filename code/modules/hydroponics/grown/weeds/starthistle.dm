// Starthistle
/datum/plant/starthistle
	species = "starthistle"
	name = "starthistle"

	growthstages = 3
	growing_icon = 'icons/obj/hydroponics/growing_flowers.dmi'

	seed_path = /obj/item/seeds/starthistle

	innate_genes = list(/datum/plant_gene/product_trait/plant_type/weed_hardy)
	possible_mutations = list(/datum/plant_mutation/starthistle_galaxy)

/obj/item/seeds/starthistle
	name = "pack of starthistle seeds"
	desc = "A robust species of weed that often springs up in-between the cracks of spaceship parking lots."
	icon_state = "seed-starthistle"

	plant_type = /datum/plant/starthistle

//Galaxy Thistle
/datum/plant_mutation/starthistle_galaxy
	plant_type = /datum/plant/galaxythistle

/datum/plant/galaxythistle
	species = "galaxythistle"
	name = "galaxythistle"

	growthstages = 3
	growing_icon = 'icons/obj/hydroponics/growing_flowers.dmi'

	seed_path = /obj/item/seeds/galaxythistle
	product_path = /obj/item/food/grown/galaxythistle

	reagents_per_potency = list(/datum/reagent/consumable/nutriment = 0.05, /datum/reagent/medicine/peridaxon = 0.1)
	possible_mutations = null

/obj/item/seeds/galaxythistle
	name = "pack of galaxythistle seeds"
	desc = "An impressive species of weed that is thought to have evolved from the simple milk thistle. Contains flavolignans that can help repair a damaged organs."
	icon_state = "seed-galaxythistle"

	plant_type = /datum/plant/galaxythistle

/obj/item/food/grown/galaxythistle
	plant_datum = /datum/plant/galaxythistle
	name = "galaxythistle flower head"
	desc = "This spiny cluster of florets reminds you of the highlands."
	icon_state = "galaxythistle"
	bite_consumption_mod = 2
	foodtypes = VEGETABLES
	wine_power = 35
	tastes = list("thistle" = 2, "artichoke" = 1)

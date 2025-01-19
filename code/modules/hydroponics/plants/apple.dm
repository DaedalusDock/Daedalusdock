// Apple
/datum/plant_mutation/pineapple_apple
	plant_type = /datum/plant/apple

	ranges = list(
		PLANT_STAT_ENDURANCE = list(-INFINITY, INFINITY),
		PLANT_STAT_POTENCY = list(-INFINITY, INFINITY),
		PLANT_STAT_MATURATION = list(-INFINITY, INFINITY),
		PLANT_STAT_PRODUCTION = list(-INFINITY, INFINITY),
		PLANT_STAT_HARVEST_AMT = list(-INFINITY, INFINITY),
		PLANT_STAT_YIELD = list(3, INFINITY)
	)

/datum/plant/apple
	name = "Apple Tree"
	species = "apple"

	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'
	icon_grow = "apple-grow"
	icon_dead = "apple-dead"

	seed_path = /obj/item/seeds/apple
	product_path = /obj/item/food/grown/apple
	base_harvest_yield = 3

	innate_genes = list(/datum/plant_gene/product_trait/one_bite)
	latent_genes = list(/datum/plant_gene/quality/superior, /datum/plant_gene/unstable)

	possible_mutations = list(/datum/plant_mutation/apple_gold)
	reagents_per_potency = list(
		/datum/reagent/consumable/nutriment/vitamin = 0.04,
		/datum/reagent/consumable/nutriment = 0.1
	)

/obj/item/seeds/apple
	name = "pack of apple seeds"
	desc = "These seeds grow into apple trees."
	icon_state = "seed-apple"

	plant_type = /datum/plant/apple

/obj/item/food/grown/apple
	plant_datum = /datum/plant/apple
	name = "apple"
	desc = "It's a little piece of Eden."
	icon_state = "apple"
	foodtypes = FRUIT
	juice_results = list(/datum/reagent/consumable/applejuice = 0)
	tastes = list("apple" = 1)
	distill_reagent = /datum/reagent/consumable/ethanol/hcider


// Gold Apple
/datum/plant_mutation/apple_gold
	plant_type = /datum/plant/apple/gold
	ranges = list(
		PLANT_STAT_ENDURANCE = list(20, INFINITY),
		PLANT_STAT_POTENCY = list(20, INFINITY),
		PLANT_STAT_MATURATION = list(-INFINITY, INFINITY),
		PLANT_STAT_PRODUCTION = list(-INFINITY, INFINITY),
		PLANT_STAT_HARVEST_AMT = list(-INFINITY, INFINITY),
		PLANT_STAT_YIELD = list(-INFINITY, INFINITY)
	)

	infusion_reagents = list(/datum/reagent/gold)

/datum/plant/apple/gold
	species = "goldapple"
	name = "Golden Apple Tree"

	seed_path = /obj/item/seeds/apple/gold
	product_path = /obj/item/food/grown/apple/gold
	reagents_per_potency = list(
		/datum/reagent/gold = 0.2,
		/datum/reagent/consumable/nutriment/vitamin = 0.04,
		/datum/reagent/consumable/nutriment = 0.1
	)

	latent_genes = list(/datum/plant_gene/quality/superior)

	possible_mutations = null
	rarity = 40 // Alchemy!

/obj/item/seeds/apple/gold
	name = "pack of golden apple seeds"
	desc = "These seeds grow into golden apple trees. Good thing there are no firebirds in space."
	icon_state = "seed-goldapple"

/obj/item/food/grown/apple/gold
	plant_datum = /datum/plant/apple/gold
	name = "golden apple"
	desc = "Emblazoned upon the apple is the word 'Kallisti'."
	icon_state = "goldapple"
	distill_reagent = null
	wine_power = 50

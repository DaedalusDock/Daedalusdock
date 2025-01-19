// Soybeans
/datum/plant/soybean
	species = "soybean"
	name = "soybean plants"

	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'
	icon_grow = "soybean-grow"
	icon_dead = "soybean-dead"
	growthstages = 4

	possible_mutations = list(/datum/plant_mutation/soybean_koi)

	seed_path = /obj/item/seeds/soya
	product_path = /obj/item/food/grown/soybeans
	base_harvest_yield = 3

	latent_genes = list(/datum/plant_gene/quality/inferior, /datum/plant_gene/metabolism_fast, /datum/plant_gene/seedless)

	reagents_per_potency = list(
		/datum/reagent/consumable/nutriment/vitamin = 0.04,
		/datum/reagent/consumable/nutriment = 0.05,
		/datum/reagent/consumable/cooking_oil = 0.03
	)

/obj/item/seeds/soya
	name = "pack of soybean seeds"
	desc = "These seeds grow into soybean plants."
	icon_state = "seed-soybean"

	plant_type = /datum/plant/soybean

/obj/item/food/grown/soybeans
	plant_datum = /datum/plant/soybean
	name = "soybeans"
	desc = "It's pretty bland, but oh the possibilities..."
	gender = PLURAL
	icon_state = "soybeans"
	foodtypes = VEGETABLES
	grind_results = list(/datum/reagent/consumable/soymilk = 0)
	tastes = list("soy" = 1)
	wine_power = 20

// Koibean
/datum/plant_mutation/soybean_koi
	plant_type = /datum/plant/soybean/koi

	mutation_chance = 5

/datum/plant/soybean/koi
	species = "koibean"
	name = "Koibean Plants"

	seed_path = /obj/item/seeds/soya/koi
	product_path = /obj/item/food/grown/koibeans

	base_potency = 10

	possible_mutations = null
	reagents_per_potency = list(
		/datum/reagent/toxin/carpotoxin = 0.1,
		/datum/reagent/consumable/nutriment/vitamin = 0.04,
		/datum/reagent/consumable/nutriment = 0.05
	)


/obj/item/seeds/soya/koi
	name = "pack of koibean seeds"
	desc = "These seeds grow into koibean plants."
	icon_state = "seed-koibean"

	plant_type = /datum/plant/soybean/koi

/obj/item/food/grown/koibeans
	plant_datum = /datum/plant/soybean/koi
	name = "koibean"
	desc = "Something about these seems fishy."
	icon_state = "koibeans"
	foodtypes = VEGETABLES
	tastes = list("koi" = 1)
	wine_power = 40

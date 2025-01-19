// Berries
/datum/plant/berry
	species = "berry"
	name = "Berry Bush"

	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'
	icon_grow = "berry-grow" // Uses one growth icons set for all the subtypes
	icon_dead = "berry-dead" // Same for the dead icon

	product_path = /obj/item/food/grown/berries
	seed_path = /obj/item/seeds/berry

	possible_mutations = list(
		/datum/plant_mutation/berry_glow,
		/datum/plant_mutation/berry_poison
	)

	reagents_per_potency = list(
		/datum/reagent/consumable/nutriment/vitamin = 0.04,
		/datum/reagent/consumable/nutriment = 0.1
	)

	latent_genes = list(/datum/plant_gene/metabolism_fast, /datum/plant_gene/seedless)
	base_harvest_yield = 4

/obj/item/seeds/berry
	name = "pack of berry seeds"
	desc = "These seeds grow into berry bushes."
	icon_state = "seed-berry"
	plant_type = /datum/plant/berry

/obj/item/food/grown/berries
	plant_datum = /datum/plant/berry
	name = "bunch of berries"
	desc = "Nutritious!"
	icon_state = "berrypile"
	gender = PLURAL
	foodtypes = FRUIT
	juice_results = list(/datum/reagent/consumable/berryjuice = 0)
	tastes = list("berry" = 1)
	distill_reagent = /datum/reagent/consumable/ethanol/gin

// Poison Berries
/datum/plant_mutation/berry_poison
	plant_type = /datum/plant/berry/poison

	ranges = list(
		PLANT_STAT_ENDURANCE = list(-INFINITY, INFINITY),
		PLANT_STAT_POTENCY = list(10, INFINITY),
		PLANT_STAT_MATURATION = list(-INFINITY, INFINITY),
		PLANT_STAT_PRODUCTION = list(-INFINITY, INFINITY),
		PLANT_STAT_HARVEST_AMT = list(-INFINITY, INFINITY),
		PLANT_STAT_YIELD = list(-INFINITY, INFINITY)
	)

/datum/plant/berry/poison
	species = "poisonberry"
	name = "Poison-Berry Bush"

	product_path = /obj/item/food/grown/berries/poison
	seed_path = /obj/item/seeds/berry/poison

	reagents_per_potency = list(
		/datum/reagent/toxin/cyanide = 0.15,
		/datum/reagent/toxin/staminatoxin = 0.2,
		/datum/reagent/consumable/nutriment/vitamin = 0.04,
		/datum/reagent/consumable/nutriment = 0.1
	)

	reagents_per_potency = list(
		/datum/reagent/toxin/cyanide = 0.15,
		/datum/reagent/toxin/staminatoxin = 0.2,
		/datum/reagent/consumable/nutriment/vitamin = 0.04,
		/datum/reagent/consumable/nutriment = 0.1
	)

	possible_mutations = list(/datum/plant_mutation/berry_death)
	rarity = 10 // Mildly poisonous berries are common in reality

/obj/item/seeds/berry/poison
	name = "pack of poison-berry seeds"
	desc = "These seeds grow into poison-berry bushes."
	icon_state = "seed-poisonberry"
	plant_type = /datum/plant/berry/poison

/obj/item/food/grown/berries/poison
	plant_datum = /datum/plant/berry/poison
	name = "bunch of poison-berries"
	desc = "Taste so good, you might die!"
	icon_state = "poisonberrypile"
	bite_consumption_mod = 3
	foodtypes = FRUIT | TOXIC
	juice_results = list(/datum/reagent/consumable/poisonberryjuice = 0)
	tastes = list("poison-berry" = 1)
	distill_reagent = null
	wine_power = 35

// Death Berries
/datum/plant_mutation/berry_death
	plant_type = /datum/plant/berry/death

	ranges = list(
		PLANT_STAT_ENDURANCE = list(20, INFINITY),
		PLANT_STAT_POTENCY = list(30, INFINITY),
		PLANT_STAT_MATURATION = list(-INFINITY, INFINITY),
		PLANT_STAT_PRODUCTION = list(-INFINITY, INFINITY),
		PLANT_STAT_HARVEST_AMT = list(-INFINITY, INFINITY),
		PLANT_STAT_YIELD = list(-INFINITY, INFINITY)
	)

	infusion_reagents = list(/datum/reagent/toxin/carpotoxin)

/datum/plant/berry/death
	species = "deathberry"
	name = "Death Berry Bush"

	product_path = /obj/item/food/grown/berries/death
	seed_path = /obj/item/seeds/berry/death

	rarity = 30

	possible_mutations = null
	reagents_per_potency = list(
		/datum/reagent/toxin/lexorin = 0.08,
		/datum/reagent/toxin/staminatoxin = 0.1,
		/datum/reagent/consumable/nutriment/vitamin = 0.04,
		/datum/reagent/consumable/nutriment = 0.1
	)

/obj/item/seeds/berry/death
	name = "pack of death-berry seeds"
	desc = "These seeds grow into death berries."
	icon_state = "seed-deathberry"
	plant_type = /datum/plant/berry/death

/obj/item/food/grown/berries/death
	plant_datum = /datum/plant/berry/death
	name = "bunch of death-berries"
	desc = "Taste so good, you will die!"
	icon_state = "deathberrypile"
	bite_consumption_mod = 3
	foodtypes = FRUIT | TOXIC
	tastes = list("death-berry" = 1)
	distill_reagent = null
	wine_power = 50

// Glow Berries
/datum/plant_mutation/berry_glow
	plant_type = /datum/plant/berry/glow

	ranges = list(
		PLANT_STAT_ENDURANCE = list(20, INFINITY),
		PLANT_STAT_POTENCY = list(-INFINITY, INFINITY),
		PLANT_STAT_MATURATION = list(-INFINITY, INFINITY),
		PLANT_STAT_PRODUCTION = list(-INFINITY, INFINITY),
		PLANT_STAT_HARVEST_AMT = list(-INFINITY, INFINITY),
		PLANT_STAT_YIELD = list(-INFINITY, INFINITY)
	)

	mutation_chance = 6

/datum/plant/berry/glow
	species = "glowberry"
	name = "glowberry bush"

	product_path = /obj/item/food/grown/berries/glow
	seed_path = /obj/item/seeds/berry/glow

	innate_genes = list(/datum/plant_gene/product_trait/glow/white)

	possible_mutations = null

	reagents_per_potency = list(
		/datum/reagent/uranium = 0.25,
		/datum/reagent/iodine = 0.2,
		/datum/reagent/consumable/nutriment/vitamin = 0.04,
		/datum/reagent/consumable/nutriment = 0.1
	)

/obj/item/seeds/berry/glow
	name = "pack of glow-berry seeds"
	desc = "These seeds grow into glow-berry bushes."
	icon_state = "seed-glowberry"
	plant_type = /datum/plant/berry/glow

/obj/item/food/grown/berries/glow
	plant_datum = /datum/plant/berry/glow
	name = "bunch of glow-berries"
	desc = "Nutritious!"
	bite_consumption_mod = 3
	icon_state = "glowberrypile"
	foodtypes = FRUIT
	tastes = list("glow-berry" = 1)
	distill_reagent = null
	wine_power = 60

// Grapes
/datum/plant/grape
	species = "grape"
	name = "Grape Vine"

	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'
	icon_grow = "grape-grow"
	icon_dead = "grape-dead"
	growthstages = 2

	seed_path = /obj/item/seeds/grape
	product_path = /obj/item/food/grown/grapes
	base_harvest_yield = 4

	possible_mutations = list(/datum/plant_mutation/grape/green)

	latent_genes = list(/datum/plant_gene/metabolism_fast, /datum/plant_gene/seedless)

	reagents_per_potency = list(
		/datum/reagent/consumable/nutriment/vitamin = 0.04,
		/datum/reagent/consumable/nutriment = 0.1,
		/datum/reagent/consumable/sugar = 0.1
	)

/obj/item/seeds/grape
	name = "pack of grape seeds"
	desc = "These seeds grow into grape vines."
	icon_state = "seed-grapes"
	plant_type = /datum/plant/grape

/obj/item/food/grown/grapes
	plant_datum = /datum/plant/grape
	name = "bunch of grapes"
	desc = "Nutritious!"
	icon_state = "grapes"
	bite_consumption_mod = 2
	foodtypes = FRUIT
	juice_results = list(/datum/reagent/consumable/grapejuice = 0)
	tastes = list("grape" = 1)
	distill_reagent = /datum/reagent/consumable/ethanol/wine

/obj/item/food/grown/grapes/make_dryable()
	AddElement(/datum/element/dryable, /obj/item/food/no_raisin/healthy)

// Green Grapes
/datum/plant_mutation/grape/green
	plant_type = /datum/plant/grape/green

	ranges = list(
		PLANT_STAT_ENDURANCE = list(5, INFINITY),
		PLANT_STAT_POTENCY = list(-INFINITY, INFINITY),
		PLANT_STAT_MATURATION = list(-INFINITY, INFINITY),
		PLANT_STAT_PRODUCTION = list(-INFINITY, INFINITY),
		PLANT_STAT_HARVEST_AMT = list(-INFINITY, INFINITY),
		PLANT_STAT_YIELD = list(4, INFINITY)
	)

/datum/plant/grape/green
	species = "greengrape"
	name = "green-grape Vine"

	seed_path = /obj/item/seeds/grape/green
	product_path = /obj/item/food/grown/grapes/green
	base_harvest_yield = 4

	possible_mutations = null

	reagents_per_potency = list(
		/datum/reagent/consumable/nutriment/vitamin = 0.04,
		/datum/reagent/consumable/nutriment = 0.1,
		/datum/reagent/consumable/sugar = 0.1,
		/datum/reagent/medicine/kelotane = 0.2
	)

/obj/item/seeds/grape/green
	name = "pack of green grape seeds"
	desc = "These seeds grow into green-grape vines."
	icon_state = "seed-greengrapes"
	plant_type = /datum/plant/grape/green

/obj/item/food/grown/grapes/green
	plant_datum = /datum/plant/grape/green
	name = "bunch of green grapes"
	icon_state = "greengrapes"
	bite_consumption_mod = 3
	tastes = list("green grape" = 1)
	distill_reagent = /datum/reagent/consumable/ethanol/cognac

// Toechtauese Berries
/datum/plant/toechtauese
	species = "toechtauese"
	name  = "töchtaüse bush"

	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'
	icon_grow = "toechtauese-grow"
	icon_dead = "toechtauese-dead"

	seed_path = /obj/item/seeds/toechtauese
	product_path = /obj/item/food/grown/toechtauese

	reagents_per_potency = list(
		/datum/reagent/consumable/toechtauese_juice = 0.1,
		/datum/reagent/toxin/itching_powder = 0.04
	)

/obj/item/seeds/toechtauese
	name = "pack of töchtaüse berry seeds"
	desc = "These seeds grow into töchtaüse bushes."
	icon_state = "seed-toechtauese"
	plant_type = /datum/plant/toechtauese

/obj/item/food/grown/toechtauese
	plant_datum = /datum/plant/toechtauese
	name = "töchtaüse berries"
	desc = "A branch with töchtaüse berries on it. They're a favourite on the Mothic Fleet, but not in this form."
	icon_state = "toechtauese_branch"
	foodtypes = FRUIT
	grind_results = list(/datum/reagent/consumable/toechtauese_juice = 0, /datum/reagent/toxin/itching_powder = 0)
	juice_results = list(/datum/reagent/consumable/toechtauese_juice = 0, /datum/reagent/toxin/itching_powder = 0)
	tastes = list("fiery itchy pain" = 1)
	distill_reagent = /datum/reagent/toxin/itching_powder

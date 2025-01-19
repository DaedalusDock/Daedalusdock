// Cannabis
/datum/plant/cannabis
	species = "cannabis"
	name = "cannabis"

	growing_icon = 'goon/icons/obj/hydroponics.dmi'
	icon_grow = "cannabis-grow" // Uses one growth icons set for all the subtypes
	icon_dead = "cannabis-dead" // Same for the dead icon
	growthstages = 1

	seed_path = /obj/item/seeds/cannabis
	product_path = /obj/item/food/grown/cannabis

	reagents_per_potency = list(/datum/reagent/drug/cannabis = 0.15)

	possible_mutations = list(
		/datum/plant_mutation/rainbowweed,
		/datum/plant_mutation/deathweed,
		/datum/plant_mutation/lifeweed,
		/datum/plant_mutation/omegaweed
	)

/obj/item/seeds/cannabis
	name = "pack of cannabis seeds"
	desc = "Taxable."
	icon_state = "seed-cannabis"
	plant_type = /datum/plant/cannabis

// Rainbow cannabis
/datum/plant_mutation/rainbowweed
	infusion_reagents = list(/datum/reagent/toxin/mindbreaker)

/datum/plant/cannabis/rainbow
	species = "megacannabis"
	name = "rainbow weed"

	seed_path = /obj/item/seeds/cannabis/rainbow
	product_path = /obj/item/food/grown/cannabis/rainbow

	possible_mutations = null
	reagents_per_potency = list(
		/datum/reagent/colorful_reagent = 0.05,
		/datum/reagent/medicine/haloperidol = 0.03,
		/datum/reagent/toxin/mindbreaker = 0.1,
		/datum/reagent/toxin/lipolicide = 0.15,
		/datum/reagent/drug/space_drugs = 0.15
	)
	rarity = 40

/obj/item/seeds/cannabis/rainbow
	name = "pack of rainbow weed seeds"
	desc = "These seeds grow into rainbow weed. Groovy... and also highly addictive."
	icon_state = "seed-megacannabis"
	plant_type = /datum/plant/cannabis/rainbow

// Death cannabis
/datum/plant_mutation/deathweed
	plant_type = /datum/plant/cannabis/death
	ranges = list(
		PLANT_STAT_ENDURANCE = list(10, 30),
		PLANT_STAT_POTENCY = list(-INFINITY, INFINITY),
		PLANT_STAT_MATURATION = list(-INFINITY, INFINITY),
		PLANT_STAT_PRODUCTION = list(-INFINITY, 30),
		PLANT_STAT_HARVEST_AMT = list(-INFINITY, INFINITY),
		PLANT_STAT_YIELD = list(-INFINITY, INFINITY)
	)

	infusion_reagents = list(/datum/reagent/toxin/cyanide)

/datum/plant/cannabis/death
	species = "blackcannabis"
	name = "deathweed"

	seed_path = /obj/item/seeds/cannabis/death
	product_path = /obj/item/food/grown/cannabis/death

	possible_mutations = null
	reagents_per_potency = list(/datum/reagent/toxin/cyanide = 0.35, /datum/reagent/drug/cannabis = 0.15)
	rarity = 40

/obj/item/seeds/cannabis/death
	name = "pack of deathweed seeds"
	desc = "These seeds grow into deathweed. Not groovy."
	icon_state = "seed-blackcannabis"
	plant_type = /datum/plant/cannabis/death

// White cannabis
/datum/plant_mutation/lifeweed
	plant_type = /datum/plant/cannabis/white

	ranges = list(
		PLANT_STAT_ENDURANCE = list(10, 30),
		PLANT_STAT_POTENCY = list(-INFINITY, INFINITY),
		PLANT_STAT_MATURATION = list(-INFINITY, INFINITY),
		PLANT_STAT_PRODUCTION = list(30, INFINITY),
		PLANT_STAT_HARVEST_AMT = list(-INFINITY, INFINITY),
		PLANT_STAT_YIELD = list(4, INFINITY)
	)

	mutation_chance = 20

	infusion_reagents = list(/datum/reagent/medicine/tricordrazine)

/datum/plant/cannabis/white
	species = "whitecannabis"
	name = "lifeweed"

	seed_path = /obj/item/seeds/cannabis/white
	product_path = /obj/item/food/grown/cannabis/white
	possible_mutations = null
	reagents_per_potency = list(
		/datum/reagent/medicine/tricordrazine = 0.35,
		/datum/reagent/drug/cannabis = 0.15
	)
	rarity = 40

/obj/item/seeds/cannabis/white
	name = "pack of lifeweed seeds"
	desc = "I will give unto him that is munchies of the fountain of the cravings of life, freely."
	icon_state = "seed-whitecannabis"

	plant_type = /datum/plant/cannabis/white

// Ultimate cannabis
/datum/plant_mutation/omegaweed
	plant_type = /datum/plant/cannabis/ultimate

	ranges = list(
		PLANT_STAT_ENDURANCE = list(-INFINITY, INFINITY),
		PLANT_STAT_POTENCY = list(-INFINITY, INFINITY),
		PLANT_STAT_MATURATION = list(-INFINITY, INFINITY),
		PLANT_STAT_PRODUCTION = list(420, INFINITY),
		PLANT_STAT_HARVEST_AMT = list(-INFINITY, INFINITY),
		PLANT_STAT_YIELD = list(-INFINITY, INFINITY)
	)

	infusion_reagents = list(
		/datum/reagent/medicine/haloperidol,
		/datum/reagent/toxin/mindbreaker,
	)
	mutation_chance = 100

/datum/plant_mutation/omegaweed/New()
	infusion_reagents += typesof(/datum/reagent/drug)

/datum/plant/cannabis/ultimate
	species = "ocannabis"
	name = "omega weed"

	innate_genes = list(/datum/plant_gene/product_trait/glow/green)

	product_path = /obj/item/food/grown/cannabis/ultimate
	seed_path = /obj/item/seeds/cannabis/ultimate

	possible_mutations = null

	reagents_per_potency = list(
		/datum/reagent/drug/cannabis = 0.3,
		/datum/reagent/toxin/mindbreaker = 0.3,
		/datum/reagent/mercury = 0.15,
		/datum/reagent/lithium = 0.15,
		/datum/reagent/medicine/atropine = 0.15,
		/datum/reagent/drug/methamphetamine = 0.15,
		/datum/reagent/drug/bath_salts = 0.15,
		/datum/reagent/drug/krokodil = 0.15,
		/datum/reagent/toxin/lipolicide = 0.15,
		/datum/reagent/drug/nicotine = 0.1
	)

/obj/item/seeds/cannabis/ultimate
	name = "pack of omega weed seeds"
	desc = "These seeds grow into omega weed."
	icon_state = "seed-ocannabis"
	plant_type = /datum/plant/cannabis/ultimate


// ---------------------------------------------------------------

/obj/item/food/grown/cannabis
	plant_datum = /datum/plant/cannabis
	icon = 'goon/icons/obj/hydroponics.dmi'
	name = "cannabis leaf"
	desc = "Recently legalized in most galaxies."
	icon_state = "cannabis"
	bite_consumption_mod = 4
	foodtypes = VEGETABLES //i dont really know what else weed could be to be honest
	tastes = list("cannabis" = 1)
	wine_power = 20

/obj/item/food/grown/cannabis/rainbow
	plant_datum = /datum/plant/cannabis/rainbow
	name = "rainbow cannabis leaf"
	desc = "Is it supposed to be glowing like that...?"
	icon_state = "megacannabis"
	wine_power = 60

/obj/item/food/grown/cannabis/death
	plant_datum = /datum/plant/cannabis/death
	name = "death cannabis leaf"
	desc = "Looks a bit dark. Oh well."
	icon_state = "blackcannabis"
	wine_power = 40

/obj/item/food/grown/cannabis/white
	plant_datum = /datum/plant/cannabis/white
	name = "white cannabis leaf"
	desc = "It feels smooth and nice to the touch."
	icon_state = "whitecannabis"
	wine_power = 10

/obj/item/food/grown/cannabis/ultimate
	plant_datum = /datum/plant/cannabis/ultimate
	name = "omega cannabis leaf"
	desc = "You feel dizzy looking at it. What the fuck?"
	icon_state = "ocannabis"
	bite_consumption_mod = 2 // Ingesting like 40 units of drugs in 1 bite at 100 potency
	wine_power = 90

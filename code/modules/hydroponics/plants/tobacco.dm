// Tobacco
/datum/plant/tobacco
	species = "tobacco"
	name = "tobacco"

	growthstages = 3
	icon_dead = "tobacco-dead"

	seed_path = /obj/item/seeds/tobacco
	product_path = /obj/item/food/grown/tobacco
	reagents_per_potency = list(/datum/reagent/drug/nicotine = 0.03, /datum/reagent/consumable/nutriment = 0.03)

	possible_mutations = list(/datum/plant_mutation/tobacco_space)

/obj/item/seeds/tobacco
	name = "pack of tobacco seeds"
	desc = "These seeds grow into tobacco plants."
	icon_state = "seed-tobacco"

	plant_type = /datum/plant/tobacco

/obj/item/food/grown/tobacco
	plant_datum = /datum/plant/tobacco
	name = "tobacco leaves"
	desc = "Dry them out to make some smokes."
	icon_state = "tobacco_leaves"
	distill_reagent = /datum/reagent/consumable/ethanol/creme_de_menthe //Menthol, I guess.

// Space Tobacco
/datum/plant_mutation/tobacco_space
	plant_type = /datum/plant/tobacco/space
	ranges = list(
		PLANT_STAT_ENDURANCE = list(5, INFINITY),
		PLANT_STAT_POTENCY = list(15, INFINITY),
		PLANT_STAT_MATURATION = list(-INFINITY, INFINITY),
		PLANT_STAT_PRODUCTION = list(-INFINITY, INFINITY),
		PLANT_STAT_HARVEST_AMT = list(-INFINITY, INFINITY),
		PLANT_STAT_YIELD = list(-INFINITY, INFINITY)
	)

/datum/plant/tobacco/space
	species = "stobacco"
	name = "space tobacco"

	seed_path = /obj/item/seeds/tobacco/space
	product_path = /obj/item/food/grown/tobacco/space

	reagents_per_potency = list(/datum/reagent/medicine/dexalin = 0.05, /datum/reagent/drug/nicotine = 0.08, /datum/reagent/consumable/nutriment = 0.03)
	possible_mutations = null
	rarity = 20

/obj/item/seeds/tobacco/space
	name = "pack of space tobacco seeds"
	desc = "These seeds grow into space tobacco plants."
	icon_state = "seed-stobacco"

	plant_type = /datum/plant/tobacco/space

/obj/item/food/grown/tobacco/space
	plant_datum = /datum/plant/tobacco/space
	name = "space tobacco leaves"
	desc = "Dry them out to make some space-smokes."
	icon_state = "stobacco_leaves"
	bite_consumption_mod = 2
	distill_reagent = null
	wine_power = 50

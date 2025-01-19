//This is part of replicapod.dm in the old system. Renamed because replica pods cringe.

/datum/plant/cabbage
	species = "cabbage"
	name = "Cabbages"

	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'

	seed_path = /obj/item/seeds/cabbage
	product_path = /obj/item/food/grown/cabbage

	growthstages = 1
	base_harvest_yield = 4

	base_endurance = 25

	reagents_per_potency = list(
		/datum/reagent/consumable/nutriment/vitamin = 0.04,
		/datum/reagent/consumable/nutriment = 0.1
		)

/obj/item/seeds/cabbage
	name = "pack of cabbage seeds"
	desc = "These seeds grow into cabbages."
	icon_state = "seed-cabbage"

	plant_type = /datum/plant/cabbage

/obj/item/food/grown/cabbage
	plant_datum = /datum/plant/cabbage
	name = "cabbage"
	desc = "Ewwwwwwwwww. Cabbage."
	icon_state = "cabbage"
	foodtypes = VEGETABLES
	wine_power = 20

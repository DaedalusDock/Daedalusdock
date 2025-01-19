// Finally, peas.
/datum/plant/peas
	species = "peas"
	name = "pea vines"

	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'
	icon_grow = "peas-grow"
	icon_dead = "peas-dead"
	growthstages = 3

	seed_path = /obj/item/seeds/peas
	product_path = /obj/item/food/grown/peas
	base_harvest_yield = 3

	reagents_per_potency = list(/datum/reagent/consumable/nutriment/vitamin = 0.1, /datum/reagent/consumable/nutriment = 0.05, /datum/reagent/water = 0.05)

/obj/item/seeds/peas
	name = "pack of pea pods"
	desc = "These seeds grows into vitamin rich peas!"
	icon_state = "seed-peas"

	plant_type = /datum/plant/peas

/obj/item/food/grown/peas
	plant_datum = /datum/plant/peas
	name = "peapod"
	desc = "Finally... peas."
	icon_state = "peas"
	foodtypes = VEGETABLES
	tastes = list ("peas" = 1, "chalky saltiness" = 1)
	wine_power = 50
	wine_flavor = "what is, distressingly, fermented peas."

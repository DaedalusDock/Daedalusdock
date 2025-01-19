/datum/plant/garlic
	species = "garlic"
	name = "garlic sprouts"

	growthstages = 3
	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'

	seed_path = /obj/item/seeds/garlic
	product_path = /obj/item/food/grown/garlic
	reagents_per_potency = list(/datum/reagent/consumable/garlic = 0.15, /datum/reagent/consumable/nutriment = 0.1)

/obj/item/seeds/garlic
	name = "pack of garlic seeds"
	desc = "A packet of extremely pungent seeds."
	icon_state = "seed-garlic"

	plant_type = /datum/plant/garlic

/obj/item/food/grown/garlic
	plant_datum = /datum/plant/garlic
	name = "garlic"
	desc = "Delicious, but with a potentially overwhelming odor."
	icon_state = "garlic"
	tastes = list("garlic" = 1)
	wine_power = 10

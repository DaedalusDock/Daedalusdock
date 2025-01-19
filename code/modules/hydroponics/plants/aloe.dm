/datum/plant/aloe
	name = "aloe"
	species = "aloe"

	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'
	growthstages = 5

	seed_path = /obj/item/seeds/aloe
	product_path = /obj/item/food/grown/aloe

	base_harvest_yield = 3

	reagents_per_potency = list(
		/datum/reagent/consumable/nutriment/vitamin = 0.05,
		/datum/reagent/consumable/nutriment = 0.05
	)

/obj/item/seeds/aloe
	name = "pack of aloe seeds"
	desc = "These seeds grow into aloe."
	icon_state = "seed-aloe"

	plant_type = /datum/plant/aloe

/obj/item/food/grown/aloe
	plant_datum = /datum/plant/aloe
	name = "aloe"
	desc = "Cut leaves from the aloe plant."
	icon_state = "aloe"
	bite_consumption_mod = 3
	foodtypes = VEGETABLES
	juice_results = list(/datum/reagent/consumable/aloejuice = 0)
	distill_reagent = /datum/reagent/consumable/ethanol/tequila

/obj/item/food/grown/aloe/microwave_act(obj/machinery/microwave/M)
	new /obj/item/stack/medical/aloe(drop_location(), 2)
	qdel(src)

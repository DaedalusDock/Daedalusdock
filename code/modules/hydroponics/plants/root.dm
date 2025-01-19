// Carrot
/datum/plant/carrot
	species = "carrot"
	name = "carrots"

	growthstages = 3
	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'

	seed_path = /obj/item/seeds/carrot
	product_path = /datum/plant/carrot

	reagents_per_potency = list(/datum/reagent/medicine/imidazoline = 0.25, /datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.05)
	possible_mutations = list(/datum/plant_mutation/carrot_parsnip)

/obj/item/seeds/carrot
	name = "pack of carrot seeds"
	desc = "These seeds grow into carrots."
	icon_state = "seed-carrot"

	plant_type = /datum/plant/carrot

/obj/item/food/grown/carrot
	plant_datum = /datum/plant/carrot
	name = "carrot"
	desc = "It's good for the eyes!"
	icon_state = "carrot"
	bite_consumption_mod = 2
	foodtypes = VEGETABLES
	juice_results = list(/datum/reagent/consumable/carrotjuice = 0)
	wine_power = 30

/obj/item/food/grown/carrot/attackby(obj/item/I, mob/user, params)
	if(I.sharpness & SHARP_EDGED)
		to_chat(user, span_notice("You sharpen the carrot into a shiv with [I]."))
		var/obj/item/knife/shiv/carrot/Shiv = new /obj/item/knife/shiv/carrot
		remove_item_from_storage(user)
		qdel(src)
		user.put_in_hands(Shiv)
	else
		return ..()

// Parsnip
/datum/plant_mutation/carrot_parsnip
	plant_type = /datum/plant/carrot/parsnip

/datum/plant/carrot/parsnip
	species = "parsnip"
	name = "parsnips"

	icon_dead = "carrot-dead"

	seed_path = /obj/item/seeds/carrot/parsnip
	product_path = /obj/item/food/grown/parsnip

	reagents_per_potency = list(/datum/reagent/consumable/nutriment/vitamin = 0.05, /datum/reagent/consumable/nutriment = 0.05, /datum/reagent/aluminium = 0.05)
	possible_mutations = null

/obj/item/seeds/carrot/parsnip
	name = "pack of parsnip seeds"
	desc = "These seeds grow into parsnips."
	icon_state = "seed-parsnip"

	plant_type = /datum/plant/carrot/parsnip

/obj/item/food/grown/parsnip
	plant_datum = /datum/plant/carrot/parsnip
	name = "parsnip"
	desc = "Closely related to carrots."
	icon_state = "parsnip"
	foodtypes = VEGETABLES
	juice_results = list(/datum/reagent/consumable/parsnipjuice = 0)
	wine_power = 35


// White-Beet
/datum/plant/whitebeet
	species = "whitebeet"
	name = "white-beets"

	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'
	icon_dead = "whitebeet-dead"

	seed_path = /obj/item/seeds/whitebeet
	product_path = /obj/item/food/grown/whitebeet

	reagents_per_potency = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/sugar = 0.2, /datum/reagent/consumable/nutriment = 0.05)
	possible_mutations = list(/datum/plant_mutation/whitebeet_redbeet)

/obj/item/seeds/whitebeet
	name = "pack of white-beet seeds"
	desc = "These seeds grow into sugary beet producing plants."
	icon_state = "seed-whitebeet"

	plant_type = /datum/plant/whitebeet

/obj/item/food/grown/whitebeet
	plant_datum = /datum/plant/whitebeet
	name = "white-beet"
	desc = "You can't beat white-beet."
	icon_state = "whitebeet"
	bite_consumption_mod = 3
	foodtypes = VEGETABLES
	wine_power = 40

// Red Beet
/datum/plant_mutation/whitebeet_redbeet
	plant_type = /datum/plant/redbeet
	mutation_chance = 5

/datum/plant/redbeet
	species = "redbeet"
	name = "red-beets"

	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'
	icon_dead = "whitebeet-dead"

	seed_path = /obj/item/seeds/redbeet
	product_path = /obj/item/food/grown/redbeet

	latent_genes = list(/datum/plant_gene/product_trait/maxchem)
	reagents_per_potency = list(/datum/reagent/consumable/nutriment/vitamin = 0.05, /datum/reagent/consumable/nutriment = 0.05)

/obj/item/seeds/redbeet
	name = "pack of redbeet seeds"
	desc = "These seeds grow into red beet producing plants."
	icon_state = "seed-redbeet"

	plant_type = /datum/plant/redbeet

/obj/item/food/grown/redbeet
	plant_datum = /datum/plant/redbeet
	name = "red beet"
	desc = "You can't beat red beet."
	icon_state = "redbeet"
	bite_consumption_mod = 2
	foodtypes = VEGETABLES
	wine_power = 60

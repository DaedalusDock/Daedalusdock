// Chili
/datum/plant/chilli
	species = "chili"
	name = "chili plants"

	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'
	icon_grow = "chili-grow" // Uses one growth icons set for all the subtypes
	icon_dead = "chili-dead" // Same for the dead icon

	base_harvest_yield = 4

	seed_path = /obj/item/seeds/chili
	product_path = /obj/item/food/grown/chili

	possible_mutations = list(/datum/plant_mutation/chilli_ghost)
	reagents_per_potency = list(/datum/reagent/consumable/capsaicin = 0.25, /datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.04)

/obj/item/seeds/chili
	name = "pack of chili seeds"
	desc = "These seeds grow into chili plants. HOT! HOT! HOT!"
	icon_state = "seed-chili"

	plant_type = /datum/plant/chilli

/obj/item/food/grown/chili
	plant_datum = /datum/plant/chilli
	name = "chili"
	desc = "It's spicy! Wait... IT'S BURNING ME!!"
	icon_state = "chilipepper"
	bite_consumption_mod = 2
	foodtypes = FRUIT
	wine_power = 20

// Ghost Chili
/datum/plant_mutation/chilli_ghost
	plant_type = /datum/plant/chilli/ghost

/datum/plant/chilli/ghost
	species = "chilighost"
	name = "ghost chili plants"

	base_harvest_yield = 3
	product_path = /obj/item/food/grown/ghost_chili
	seed_path = /obj/item/seeds/chili/ghost
	base_harvest_yield = 3

	innate_genes = list(/datum/plant_gene/product_trait/backfire/chili_heat)

	possible_mutations = null

	reagents_per_potency = list(/datum/reagent/consumable/condensedcapsaicin = 0.3, /datum/reagent/consumable/capsaicin = 0.55, /datum/reagent/consumable/nutriment = 0.04)
	rarity = 20

/obj/item/seeds/chili/ghost
	name = "pack of ghost chili seeds"
	desc = "These seeds grow into a chili said to be the hottest in the galaxy."
	icon_state = "seed-chilighost"

/obj/item/food/grown/ghost_chili
	plant_datum = /datum/plant/chilli/ghost
	name = "ghost chili"
	desc = "It seems to be vibrating gently."
	icon_state = "ghostchilipepper"
	bite_consumption_mod = 5
	foodtypes = FRUIT
	wine_power = 50

// Bell Pepper
/datum/plant/chilli/bell_pepper
	species = "bellpepper"
	name = "Bell Pepper Plants"

	seed_path = /obj/item/seeds/chili/bell_pepper
	product_path = /obj/item/food/grown/bell_pepper
	base_harvest_yield = 3

	possible_mutations = null
	reagents_per_potency = list(/datum/reagent/consumable/nutriment/vitamin = 0.08, /datum/reagent/consumable/nutriment = 0.04)

/obj/item/seeds/chili/bell_pepper
	name = "pack of bell pepper seeds"
	desc = "These seeds grow into bell pepper plants. MILD! MILD! MILD!"
	icon_state = "seed-bell-pepper"

	plant_type = /datum/plant/chilli/bell_pepper

/obj/item/food/grown/bell_pepper
	plant_datum = /datum/plant/chilli/bell_pepper
	name = "bell pepper"
	desc = "A big mild pepper that's good for many things."
	icon_state = "bell_pepper"
	foodtypes = FRUIT

/obj/item/food/grown/bell_pepper/MakeBakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/roasted_bell_pepper, rand(15 SECONDS, 35 SECONDS), TRUE, TRUE)

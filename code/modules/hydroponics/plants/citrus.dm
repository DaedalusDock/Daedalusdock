// Citrus - base type
/obj/item/food/grown/citrus
	plant_datum = /datum/plant/lime
	name = "citrus"
	desc = "It's so sour, your face will twist."
	icon_state = "lime"
	foodtypes = FRUIT
	wine_power = 30


// Orange
/datum/plant/orange
	species = "orange"
	name = "orange tree"

	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'
	icon_grow = "lime-grow"
	icon_dead = "lime-dead"

	seed_path = /obj/item/seeds/orange
	product_path = /obj/item/food/grown/citrus/orange

	possible_mutations = list(/datum/plant_mutation/lime, /datum/plant_mutation/lemon)
	reagents_per_potency = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.05)

/obj/item/seeds/orange
	name = "pack of orange seeds"
	desc = "Sour seeds."
	icon_state = "seed-orange"

	plant_type = /datum/plant/orange

/obj/item/food/grown/citrus/orange
	plant_datum = /datum/plant/orange
	name = "orange"
	desc = "It's a tangy fruit."
	icon_state = "orange"
	foodtypes = ORANGES
	juice_results = list(/datum/reagent/consumable/orangejuice = 0)
	distill_reagent = /datum/reagent/consumable/ethanol/triple_sec

// Lime
/datum/plant_mutation/lime
	plant_type = /datum/plant/lime

/datum/plant/lime
	species = "lime"
	name = "lime tree"

	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'

	seed_path = /obj/item/seeds/lime
	product_path = /obj/item/food/grown/citrus/lime

	possible_mutations = list(/datum/plant_mutation/lemon)
	reagents_per_potency = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.05)

/obj/item/seeds/lime
	name = "pack of lime seeds"
	desc = "These are very sour seeds."
	icon_state = "seed-lime"

	plant_type = /datum/plant/lime

/obj/item/food/grown/citrus/lime
	plant_datum = /datum/plant/lime
	name = "lime"
	desc = "It's so sour, your face will twist."
	icon_state = "lime"
	juice_results = list(/datum/reagent/consumable/limejuice = 0)

// Lemon
/datum/plant_mutation/lemon
	plant_type = /datum/plant/lemon

/datum/plant/lemon
	species = "lemon"
	name = "lemon tree"

	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'
	icon_grow = "lime-grow"
	icon_dead = "lime-dead"

	seed_path = /obj/item/seeds/lemon
	product_path = /obj/item/food/grown/citrus/lemon

	possible_mutations = list(/datum/plant_mutation/lemon_fire, /datum/plant_mutation/lime)

	reagents_per_potency = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.05)

/obj/item/seeds/lemon
	name = "pack of lemon seeds"
	desc = "These are sour seeds."
	icon_state = "seed-lemon"

	plant_type = /datum/plant/lemon

/obj/item/food/grown/citrus/lemon
	plant_datum = /datum/plant/lemon
	name = "lemon"
	desc = "When life gives you lemons, make lemonade."
	icon_state = "lemon"
	juice_results = list(/datum/reagent/consumable/lemonjuice = 0)

/datum/plant_mutation/lemon_fire
	plant_type = /datum/plant/lemon_fire

	infusion_reagents = list(/datum/reagent/phlogiston)

/datum/plant/lemon_fire
	species = "firelemon"
	name = "combustible lemon tree"

	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'
	icon_grow = "lime-grow"
	icon_dead = "lime-dead"

	seed_path = /obj/item/seeds/firelemon
	product_path = /obj/item/food/grown/firelemon

	innate_genes = list(/datum/plant_gene/product_trait/bomb_plant/potency_based)

	reagents_per_potency = list(/datum/reagent/consumable/nutriment = 0.05, /datum/reagent/fuel = 0.05)

// Combustible lemon
/obj/item/seeds/firelemon //combustible lemon is too long so firelemon
	name = "pack of combustible lemon seeds"
	desc = "When life gives you lemons, don't make lemonade. Make life take the lemons back! Get mad! I don't want your damn lemons!"
	icon_state = "seed-firelemon"

	plant_type = /datum/plant/lemon_fire

/obj/item/food/grown/firelemon
	plant_datum = /datum/plant/lemon_fire
	name = "Combustible Lemon"
	desc = "Made for burning houses down."
	icon_state = "firelemon"
	alt_icon = "firelemon_active"
	foodtypes = FRUIT
	wine_power = 70

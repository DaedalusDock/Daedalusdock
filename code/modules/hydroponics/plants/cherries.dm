// Cherries
/datum/plant/cherry
	species = "cherry"
	name = "cherries"

	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'
	icon_grow = "cherry-grow"
	icon_dead = "cherry-dead"
	icon_harvest = "cherry-harvest"
	growthstages = 5

	seed_path = /obj/item/seeds/cherry
	product_path = /obj/item/food/grown/cherries

	latent_genes = list(/datum/plant_gene/metabolism_fast, /datum/plant_gene/seedless)

	possible_mutations = list(/datum/plant_mutation/cherry_blue, /datum/plant_mutation/cherry_bulb)
	reagents_per_potency = list(/datum/reagent/consumable/nutriment = 0.07, /datum/reagent/consumable/sugar = 0.07)

/obj/item/seeds/cherry
	name = "pack of cherry pits"
	desc = "Careful not to crack a tooth on one... That'd be the pits."
	icon_state = "seed-cherry"

	plant_type = /datum/plant/cherry

/obj/item/food/grown/cherries
	plant_datum = /datum/plant/cherry
	name = "cherries"
	desc = "Great for toppings!"
	icon_state = "cherry"
	gender = PLURAL
	bite_consumption_mod = 2
	foodtypes = FRUIT
	grind_results = list(/datum/reagent/consumable/cherryjelly = 0)
	tastes = list("cherry" = 1)
	wine_power = 30

// Blue Cherries
/datum/plant_mutation/cherry_blue
	plant_type = /datum/plant/cherry/blue

/datum/plant/cherry/blue
	species = "bluecherry"
	name = "Blue Cherry Tree"

	seed_path = /obj/item/seeds/cherry/blue
	product_path = /obj/item/food/grown/bluecherries

	possible_mutations = null

	reagents_per_potency = list(/datum/reagent/consumable/nutriment = 0.07, /datum/reagent/consumable/sugar = 0.07, /datum/reagent/oxygen = 0.07)
	rarity = 10

/obj/item/seeds/cherry/blue
	name = "pack of blue cherry pits"
	desc = "The blue kind of cherries."
	icon_state = "seed-bluecherry"

	plant_type = /datum/plant/cherry/blue

/obj/item/food/grown/bluecherries
	plant_datum = /datum/plant/cherry/blue
	name = "blue cherries"
	desc = "They're cherries that are blue."
	icon_state = "bluecherry"
	bite_consumption_mod = 2
	foodtypes = FRUIT
	grind_results = list(/datum/reagent/consumable/bluecherryjelly = 0)
	tastes = list("blue cherry" = 1)
	wine_power = 50

//Cherry Bulbs
/datum/plant_mutation/cherry_bulb
	plant_type = /datum/plant/cherry/bulb
	required_genes = list(/datum/plant_gene/product_trait/glow)

/datum/plant/cherry/bulb
	species = "cherrybulb"
	name = "cherry bulb tree"

	seed_path = /obj/item/seeds/cherry/bulb
	product_path = /obj/item/food/grown/cherrybulbs
	innate_genes = list(/datum/plant_gene/product_trait/glow/pink)

	possible_mutations = null

	reagents_per_potency = list(/datum/reagent/consumable/nutriment = 0.07, /datum/reagent/consumable/sugar = 0.07)
	rarity = 10

/obj/item/seeds/cherry/bulb
	name = "pack of cherry bulb pits"
	desc = "The glowy kind of cherries."
	icon_state = "seed-cherrybulb"

	plant_type = /datum/plant/cherry/bulb

/obj/item/food/grown/cherrybulbs
	plant_datum = /datum/plant/cherry/bulb
	name = "cherry bulbs"
	desc = "They're like little Space Christmas lights!"
	icon_state = "cherry_bulb"
	bite_consumption_mod = 2
	foodtypes = FRUIT
	grind_results = list(/datum/reagent/consumable/cherryjelly = 0)
	tastes = list("cherry" = 1)
	wine_power = 50

//Cherry Bombs
/datum/plant/cherry/bomb
	species = "cherry_bomb"
	name = "cherry bomb tree"

	seed_path = /obj/item/seeds/cherry/bomb
	product_path = /obj/item/food/grown/cherry_bomb

	possible_mutations = null

	reagents_per_potency = list(/datum/reagent/consumable/nutriment = 0.1, /datum/reagent/consumable/sugar = 0.1, /datum/reagent/gunpowder = 0.7)
	rarity = 60 //See above

/obj/item/seeds/cherry/bomb
	name = "pack of cherry bomb pits"
	desc = "They give you vibes of dread and frustration."
	icon_state = "seed-cherry_bomb"


/obj/item/food/grown/cherry_bomb
	name = "cherry bombs"
	desc = "You think you can hear the hissing of a tiny fuse."
	icon_state = "cherry_bomb"
	alt_icon = "cherry_bomb_lit"
	plant_datum = /datum/plant/cherry/bomb
	bite_consumption_mod = 3
	wine_power = 80

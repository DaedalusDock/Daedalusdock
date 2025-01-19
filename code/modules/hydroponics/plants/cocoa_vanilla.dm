// Cocoa Pod
/datum/plant/cocoa
	species = "cocoapod"
	name = "cocoa"

	growthstages = 5
	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'
	icon_grow = "cocoapod-grow"
	icon_dead = "cocoapod-dead"

	seed_path = /obj/item/seeds/cocoapod
	product_path = /obj/item/food/grown/cocoapod

	reagents_per_potency = list(/datum/reagent/consumable/coco = 0.25, /datum/reagent/consumable/nutriment = 0.1)
	possible_mutations = list(/datum/plant_mutation/cocoa_vanilla, /datum/plant_mutation/cocoa_bungo)

/obj/item/seeds/cocoapod
	name = "pack of cocoa pod seeds"
	desc = "These seeds grow into cacao trees. They look fattening." //SIC: cocoa is the seeds. The trees are spelled cacao.
	icon_state = "seed-cocoapod"

	plant_type = /datum/plant/cocoa

/obj/item/food/grown/cocoapod
	plant_datum = /datum/plant/cocoa
	name = "cocoa pod"
	desc = "Fattening... Mmmmm... chucklate."
	icon_state = "cocoapod"
	bite_consumption_mod = 2
	foodtypes = FRUIT
	tastes = list("cocoa" = 1)
	distill_reagent = /datum/reagent/consumable/ethanol/creme_de_cacao

// Vanilla Pod
/datum/plant_mutation/cocoa_vanilla
	plant_type = /datum/plant/cocoa/vanilla

/datum/plant/cocoa/vanilla
	species = "vanillapod"
	name = "vanilla tree"

	seed_path = /obj/item/seeds/cocoapod/vanillapod
	product_path = /obj/item/food/grown/vanillapod

	reagents_per_potency = list(/datum/reagent/consumable/vanilla = 0.25, /datum/reagent/consumable/nutriment = 0.1)
	possible_mutations = null

/obj/item/seeds/cocoapod/vanillapod
	name = "pack of vanilla pod seeds"
	desc = "These seeds grow into vanilla trees. They look fattening."
	icon_state = "seed-vanillapod"

	plant_type = /datum/plant/cocoa/vanilla

/obj/item/food/grown/vanillapod
	plant_datum = /datum/plant/cocoa/vanilla
	name = "vanilla pod"
	desc = "Fattening... Mmmmm... vanilla."
	icon_state = "vanillapod"
	bite_consumption_mod = 2
	foodtypes = FRUIT
	tastes = list("vanilla" = 1)
	distill_reagent = /datum/reagent/consumable/vanilla //Takes longer, but you can get even more vanilla from it.

/datum/plant_mutation/cocoa_bungo
	plant_type = /datum/plant/cocoa/bungotree
	mutation_chance = 0

/datum/plant/cocoa/bungotree
	species = "bungotree"
	name = "bungo tree"

	growthstages = 4
	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'
	icon_grow = "bungotree-grow"
	icon_dead = "bungotree-dead"

	seed_path = /obj/item/seeds/cocoapod/bungotree
	product_path = /obj/item/food/grown/bungofruit

	reagents_per_potency = list(/datum/reagent/consumable/enzyme = 0.1, /datum/reagent/consumable/nutriment = 0.1)
	possible_mutations = null
	rarity = 15

/obj/item/seeds/cocoapod/bungotree
	name = "pack of bungo tree seeds"
	desc = "These seeds grow into bungo trees. They appear to be heavy and almost perfectly spherical."
	icon_state = "seed-bungotree"

	plant_type = /datum/plant/cocoa/bungotree

/obj/item/food/grown/bungofruit
	plant_datum = /datum/plant/cocoa/bungotree
	name = "bungo fruit"
	desc = "A strange fruit, tough leathery skin protects its juicy flesh and large poisonous seed."
	icon_state = "bungo"
	bite_consumption_mod = 2
	trash_type = /obj/item/food/grown/bungopit
	foodtypes = FRUIT
	juice_results = list(/datum/reagent/consumable/bungojuice = 0)
	tastes = list("bungo" = 2, "tropical fruitiness" = 1)
	distill_reagent = null

/obj/item/food/grown/bungopit
	plant_datum = /datum/plant/cocoa/bungotree
	name = "bungo pit"
	icon_state = "bungopit"
	bite_consumption_mod = 5
	desc = "A large seed, it is said to be potent enough to be able to stop a mans heart."
	w_class = WEIGHT_CLASS_TINY
	throwforce = 5
	throw_range = 7
	foodtypes = TOXIC
	tastes = list("acrid bitterness" = 1)

/obj/item/food/grown/bungopit/Initialize(mapload)
	. =..()
	reagents.clear_reagents()
	reagents.add_reagent(/datum/reagent/toxin/bungotoxin, cached_potency * 0.10) //More than this will kill at too low potency
	reagents.add_reagent(/datum/reagent/consumable/nutriment, cached_potency * 0.04)

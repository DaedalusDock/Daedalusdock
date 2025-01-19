/datum/plant/flower
	abstract_type = /datum/plant/flower

	growing_icon = 'icons/obj/hydroponics/growing_flowers.dmi'


// Poppy
/datum/plant/flower/poppy
	species = "poppy"
	name = "Poppy flowers"

	icon_grow = "poppy-grow"
	icon_dead = "poppy-dead"

	seed_path = /obj/item/seeds/poppy
	product_path = /obj/item/food/grown/poppy

	growthstages = 3

	possible_mutations = list(
		/datum/plant_mutation/geranium,
	)
	reagents_per_potency = list(
		/datum/reagent/medicine/morphine = 0.2,
		/datum/reagent/consumable/nutriment = 0.05
		)


/obj/item/seeds/poppy
	name = "pack of poppy seeds"
	desc = "These seeds grow into poppies."
	icon_state = "seed-poppy"

	plant_type = /datum/plant/flower/poppy


/datum/plant_mutation/geranium
	plant_type = /datum/plant/flower/geranium

/obj/item/food/grown/poppy
	plant_datum = /datum/plant/flower/poppy
	name = "poppy"
	desc = "Long-used as a symbol of rest, peace, and death."
	icon_state = "map_flower"
	slot_flags = ITEM_SLOT_HEAD
	alternate_worn_layer = ABOVE_BODY_FRONT_HEAD_LAYER
	bite_consumption_mod = 2
	foodtypes = VEGETABLES | GROSS
	distill_reagent = /datum/reagent/consumable/ethanol/vermouth
	greyscale_config = /datum/greyscale_config/flower_simple
	greyscale_config_worn = /datum/greyscale_config/flower_simple_worn
	greyscale_colors = "#d23838"

// Lily

/datum/plant/flower/lily
	species = "lily"
	name = "Lily Plants"

	icon_dead = "poppy-dead"
	icon_grow = "poppy-grow"
	growthstages = 3

	seed_path = /obj/item/seeds/lily
	product_path = /obj/item/food/grown/poppy/lily

	possible_mutations = list(
		/datum/plant_mutation/trumpet,
	)

	reagents_per_potency = list(
		/datum/reagent/consumable/nutriment = 0.05
	)

/obj/item/seeds/lily
	name = "pack of lily seeds"
	desc = "These seeds grow into lilies."
	icon_state = "seed-lily"

	plant_type = /datum/plant/flower/lily

/datum/plant_mutation/trumpet
	plant_type = /datum/plant/flower/trumpet

/obj/item/food/grown/poppy/lily
	plant_datum = /datum/plant/flower/lily
	name = "lily"
	desc = "A beautiful orange flower."
	greyscale_colors = "#fe881f"

//Spacemans's Trumpet

/datum/plant/flower/trumpet
	species = "spacemanstrumpet"
	name = "Spaceman's Trumpet Plant"

	growthstages = 4
	base_harvest_yield = 4
	rarity = 30

	icon_grow = "spacemanstrumpet-grow"
	icon_dead = "spacemanstrumpet-dead"

	seed_path = /obj/item/seeds/trumpet
	product_path = /obj/item/food/grown/trumpet

	reagents_per_potency = list(/datum/reagent/consumable/nutriment = 0.05)

/obj/item/seeds/trumpet
	name = "pack of spaceman's trumpet seeds"
	desc = "A plant sculped by extensive genetic engineering. The spaceman's trumpet is said to bear no resemblance to its wild ancestors. Inside NT AgriSci circles it is better known as NTPW-0372."
	icon_state = "seed-trumpet"

	plant_type = /datum/plant/flower/trumpet


/obj/item/food/grown/trumpet
	plant_datum = /datum/plant/flower/trumpet
	name = "spaceman's trumpet"
	desc = "A vivid flower that smells faintly of freshly cut grass. Touching the flower seems to stain the skin some time after contact, yet most other surfaces seem to be unaffected by this phenomenon."
	icon_state = "spacemanstrumpet"
	bite_consumption_mod = 2
	foodtypes = VEGETABLES

// Geranium
/datum/plant/flower/geranium
	species = "geranium"
	name = "Geraniums"

	icon_dead = "poppy-dead"
	icon_grow = "poppy-grow"
	growthstages = 3

	seed_path = /obj/item/seeds/geranium
	product_path = /obj/item/food/grown/poppy/geranium

	reagents_per_potency = list(
		/datum/reagent/medicine/morphine = 0.2,
		/datum/reagent/consumable/nutriment = 0.05
	)

	possible_mutations = list(
		/datum/plant_mutation/fraxinella
	)

/datum/plant_mutation/fraxinella
	plant_type = /datum/plant/flower/fraxinella

/obj/item/seeds/geranium
	name = "pack of geranium seeds"
	desc = "These seeds grow into geranium."
	icon_state = "seed-geranium"

	plant_type = /datum/plant/flower/geranium

/obj/item/food/grown/poppy/geranium
	plant_datum = /datum/plant/flower/geranium
	name = "geranium"
	desc = "A beautiful blue flower."
	greyscale_colors = "#1499bb"

///Fraxinella seeds.
/datum/plant/flower/fraxinella
	species = "fraxinella"
	name = "Fraxinella Plants"

	icon_dead = "poppy-dead"
	icon_grow = "poppy-grow"
	growthstages = 3

	rarity = 15
	seed_path = /obj/item/seeds/fraxinella
	product_path = /obj/item/food/grown/poppy/geranium/fraxinella

	reagents_per_potency = list(
		/datum/reagent/consumable/nutriment = 0.05,
		/datum/reagent/fuel/oil = 0.05
	)

/obj/item/seeds/fraxinella
	name = "pack of fraxinella seeds"
	desc = "These seeds grow into fraxinella."
	icon_state = "seed-fraxinella"

	plant_type = /datum/plant/flower/fraxinella

/obj/item/food/grown/poppy/geranium/fraxinella
	plant_datum = /datum/plant/flower/fraxinella
	name = "fraxinella"
	desc = "A beautiful light pink flower."
	icon_state = "fraxinella"
	distill_reagent = /datum/reagent/ash
	greyscale_config = null
	greyscale_config_worn = null
	greyscale_colors = null

// Harebell
/datum/plant/flower/harebell
	species = "harebell"
	name = "Harebells"

	growthstages = 4

	seed_path = /obj/item/seeds/harebell
	product_path = /obj/item/food/grown/harebell

	reagents_per_potency = list(/datum/reagent/consumable/nutriment = 0.04)

/obj/item/seeds/harebell
	name = "pack of harebell seeds"
	desc = "These seeds grow into pretty little flowers."
	icon_state = "seed-harebell"

	plant_type = /datum/plant/flower/harebell

/obj/item/food/grown/harebell
	plant_datum = /datum/plant/flower/harebell
	name = "harebell"
	desc = "\"I'll sweeten thy sad grave: thou shalt not lack the flower that's like thy face, pale primrose, nor the azured hare-bell, like thy veins; no, nor the leaf of eglantine, whom not to slander, out-sweeten'd not thy breath.\""
	icon_state = "harebell"
	slot_flags = ITEM_SLOT_HEAD
	alternate_worn_layer = ABOVE_BODY_FRONT_HEAD_LAYER
	bite_consumption_mod = 2
	distill_reagent = /datum/reagent/consumable/ethanol/vermouth

// Sunflower
/datum/plant/flower/sunflower
	species = "sunflower"
	name = "Sunflowers"

	growthstages = 3

	seed_path = /obj/item/seeds/sunflower
	product_path = /obj/item/food/grown/sunflower

	innate_genes = list(/datum/plant_gene/product_trait/attack/sunflower_attack)

	possible_mutations = list(
		/datum/plant_mutation/moonflower,
		/datum/plant_mutation/novaflower
	)
	reagents_per_potency = list(
		/datum/reagent/consumable/cornoil = 0.08,
		/datum/reagent/consumable/nutriment = 0.04
	)

/datum/plant_mutation/moonflower
	plant_type = /datum/plant/flower/moonflower

/datum/plant_mutation/novaflower
	plant_type = /datum/plant/flower/novaflower

/obj/item/seeds/sunflower
	name = "pack of sunflower seeds"
	desc = "These seeds grow into sunflowers."
	icon_state = "seed-sunflower"

	plant_type = /datum/plant/flower/sunflower

/obj/item/food/grown/sunflower // FLOWER POWER!
	plant_datum = /datum/plant/flower/sunflower
	name = "sunflower"
	desc = "It's beautiful! A certain person might beat you to death if you trample these."
	icon_state = "sunflower"
	lefthand_file = 'icons/mob/inhands/weapons/plants_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/plants_righthand.dmi'
	foodtypes = VEGETABLES
	damtype = BURN
	force = 0
	slot_flags = ITEM_SLOT_HEAD
	alternate_worn_layer = ABOVE_BODY_FRONT_HEAD_LAYER
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 1
	throw_range = 3

/obj/item/food/grown/sunflower/make_dryable()
	AddElement(/datum/element/dryable, /obj/item/food/semki/healthy) //yum

// Moonflower
/datum/plant/flower/moonflower
	species = "moonflower"
	name = "Moonflowers"

	icon_grow = "moonflower-grow"
	icon_dead = "sunflower-dead"
	growthstages = 3

	rarity = 15

	seed_path = /obj/item/seeds/moonflower
	product_path = /obj/item/food/grown/moonflower

	reagents_per_potency = list(
		/datum/reagent/consumable/ethanol/moonshine = 0.2,
		/datum/reagent/consumable/nutriment/vitamin = 0.02,
		/datum/reagent/consumable/nutriment = 0.02
		)

/obj/item/seeds/moonflower
	name = "pack of moonflower seeds"
	desc = "These seeds grow into moonflowers."
	icon_state = "seed-moonflower"

	plant_type = /datum/plant/flower/moonflower

/obj/item/food/grown/moonflower
	plant_datum = /datum/plant/flower/moonflower
	name = "moonflower"
	desc = "Store in a location at least 50 yards away from werewolves."
	icon_state = "moonflower"
	slot_flags = ITEM_SLOT_HEAD
	alternate_worn_layer = ABOVE_BODY_FRONT_HEAD_LAYER
	distill_reagent = /datum/reagent/consumable/ethanol/absinthe //It's made from flowers.

// Novaflower
/datum/plant/flower/novaflower
	species = "novaflower"
	name = "Novaflowers"

	icon_grow = "novaflower-grow"
	icon_dead = "sunflower-dead"
	growthstages = 3

	rarity = 20

	seed_path = /obj/item/seeds/novaflower
	product_path = /obj/item/grown/novaflower

	innate_genes = list(/datum/plant_gene/product_trait/backfire/novaflower_heat, /datum/plant_gene/product_trait/attack/novaflower_attack)

	reagents_per_potency = list(
		/datum/reagent/consumable/condensedcapsaicin = 0.25,
		/datum/reagent/consumable/capsaicin = 0.3,
		/datum/reagent/consumable/nutriment = 0
		)

/obj/item/seeds/novaflower
	name = "pack of novaflower seeds"
	desc = "These seeds grow into novaflowers."
	icon_state = "seed-novaflower"

	plant_type = /datum/plant/flower/novaflower

/obj/item/grown/novaflower
	plant_datum = /datum/plant/flower/novaflower
	name = "\improper novaflower"
	desc = "These beautiful flowers have a crisp smokey scent, like a summer bonfire."
	icon_state = "novaflower"
	lefthand_file = 'icons/mob/inhands/weapons/plants_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/plants_righthand.dmi'
	damtype = BURN
	force = 0
	slot_flags = ITEM_SLOT_HEAD
	alternate_worn_layer = ABOVE_BODY_FRONT_HEAD_LAYER
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 1
	throw_range = 3
	attack_verb_continuous = list("roasts", "scorches", "burns")
	attack_verb_simple = list("roast", "scorch", "burn")
	grind_results = list(/datum/reagent/consumable/capsaicin = 0, /datum/reagent/consumable/condensedcapsaicin = 0)

// Rose
/datum/plant/flower/rose
	species = "rose"
	name = "Rose Bush"

	growthstages = 3
	icon_grow = "rose-grow"
	icon_dead = "rose-dead"

	seed_path = /obj/item/seeds/rose
	product_path = /obj/item/food/grown/rose

	possible_mutations = list(/datum/plant_mutation/carbonrose)
	reagents_per_potency = list(
		/datum/reagent/consumable/nutriment = 0.05,
		/datum/reagent/medicine/tricordrazine = 0.1,
		/datum/reagent/fuel/oil = 0.05
	)

/datum/plant_mutation/carbonrose
	plant_type = /datum/plant/flower/carbon_rose

/obj/item/seeds/rose
	name = "pack of rose seeds"
	desc = "These seeds grow into roses."
	icon_state = "seed-rose"

	plant_type = /datum/plant/flower/rose

/obj/item/food/grown/rose
	plant_datum = /datum/plant/flower/rose
	name = "\improper rose"
	desc = "The classic fleur d'amour - flower of love. Watch for its thorns!"
	base_icon_state = "rose"
	icon_state = "rose"
	worn_icon_state = "rose"
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	slot_flags = ITEM_SLOT_HEAD | ITEM_SLOT_MASK
	alternate_worn_layer = ABOVE_BODY_FRONT_HEAD_LAYER
	bite_consumption_mod = 2
	foodtypes = VEGETABLES | GROSS

// Carbon Rose
/datum/plant/flower/carbon_rose
	species = "carbonrose"
	name = "Carbon Rose Flower"

	rarity = 10

	growthstages = 3
	icon_grow = "carbonrose-grow"
	icon_dead = "carbonrose-dead"

	seed_path = /obj/item/seeds/carbon_rose
	product_path = /obj/item/grown/carbon_rose
	reagents_per_potency = list(/datum/reagent/carbon = 0.1)

/obj/item/seeds/carbon_rose
	name = "pack of carbon rose seeds"
	desc = "These seeds grow into carbon roses."
	icon_state = "seed-carbonrose"

	plant_type = /datum/plant/flower/carbon_rose

/obj/item/grown/carbon_rose
	plant_datum = /datum/plant/flower/carbon_rose
	name = "carbon rose"
	desc = "The all new fleur d'amour gris - the flower of love, modernized, with no harsh thorns."
	icon_state = "carbonrose"
	lefthand_file = 'icons/mob/inhands/weapons/plants_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/plants_righthand.dmi'
	force = 0
	throwforce = 0
	slot_flags = ITEM_SLOT_HEAD
	alternate_worn_layer = ABOVE_BODY_FRONT_HEAD_LAYER
	throw_speed = 1
	throw_range = 3

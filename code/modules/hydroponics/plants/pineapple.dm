// Pineapple!
/datum/plant/pineapple
	species = "pineapple"
	name = "pineapple plant"

	product_path = /obj/item/food/grown/pineapple
	seed_path = /obj/item/seeds/pineapple

	growthstages = 3
	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'

	latent_genes = list(/datum/plant_gene/product_trait/juicing)
	reagents_per_potency = list(/datum/reagent/consumable/nutriment/vitamin = 0.02, /datum/reagent/consumable/nutriment = 0.2, /datum/reagent/water = 0.04)
	possible_mutations = list(/datum/plant_mutation/pineapple_apple)

/obj/item/seeds/pineapple
	name = "pack of pineapple seeds"
	desc = "Oooooooooooooh!"
	icon_state = "seed-pineapple"

	plant_type = /datum/plant/pineapple

/obj/item/food/grown/pineapple
	plant_datum = /datum/plant/pineapple
	name = "pineapples"
	desc = "Blorble."
	icon_state = "pineapple"
	bite_consumption_mod = 2
	force = 4
	throwforce = 8
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_continuous = list("stings", "pines")
	attack_verb_simple = list("sting", "pine")
	throw_speed = 1
	throw_range = 5
	w_class = WEIGHT_CLASS_NORMAL
	foodtypes = FRUIT | PINEAPPLE
	juice_results = list(/datum/reagent/consumable/pineapplejuice = 0)
	tastes = list("pineapple" = 1)
	wine_power = 40


/obj/item/food/grown/pineapple/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/pineappleslice, 3, 15)

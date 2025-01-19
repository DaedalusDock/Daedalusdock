// Potato
/datum/plant/potato
	species = "potato"
	name = "potatoes"

	growthstages = 4
	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'
	icon_grow = "potato-grow"
	icon_dead = "potato-dead"

	seed_path = /obj/item/seeds/potato
	product_path = /obj/item/food/grown/potato

	innate_genes = list(/datum/plant_gene/product_trait/battery, /datum/plant_gene/product_trait/one_bite)
	reagents_per_potency = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1)

	possible_mutations = list(/datum/plant_mutation/potato_sweet)

/obj/item/seeds/potato
	name = "pack of potato seeds"
	desc = "Boil 'em! Mash 'em! Stick 'em in a stew!"
	icon_state = "seed-potato"

	plant_type = /datum/plant/potato

/obj/item/food/grown/potato
	plant_datum = /datum/plant/potato
	name = "potato"
	desc = "Boil 'em! Mash 'em! Stick 'em in a stew!"
	icon_state = "potato"
	foodtypes = VEGETABLES
	juice_results = list(/datum/reagent/consumable/potato_juice = 0)
	distill_reagent = /datum/reagent/consumable/ethanol/vodka

/obj/item/food/grown/potato/wedges
	name = "potato wedges"
	desc = "Slices of neatly cut potato."
	icon_state = "potato_wedges"
	bite_consumption_mod = 100

/obj/item/food/grown/potato/attackby(obj/item/W, mob/user, params)
	if(W.sharpness)
		to_chat(user, span_notice("You cut the potato into wedges with [W]."))
		var/obj/item/food/grown/potato/wedges/Wedges = new /obj/item/food/grown/potato/wedges
		remove_item_from_storage(user)
		qdel(src)
		user.put_in_hands(Wedges)
	else
		return ..()


// Sweet Potato
/datum/plant_mutation/potato_sweet
	plant_type = /datum/plant/potato/sweet

	infusion_reagents = list(/datum/reagent/consumable/sugar)

/datum/plant/potato/sweet
	species = "sweetpotato"
	name = "sweet potato"

	seed_path = /obj/item/seeds/potato/sweet
	product_path = /obj/item/food/grown/potato/sweet

	reagents_per_potency = list(/datum/reagent/consumable/nutriment/vitamin = 0.1, /datum/reagent/consumable/sugar = 0.1, /datum/reagent/consumable/nutriment = 0.1)
	possible_mutations = null

/obj/item/seeds/potato/sweet
	name = "pack of sweet potato seeds"
	desc = "These seeds grow into sweet potato plants."
	icon_state = "seed-sweetpotato"

	plant_type = /datum/plant/potato/sweet

/obj/item/food/grown/potato/sweet
	plant_datum = /datum/plant/potato/sweet
	name = "sweet potato"
	desc = "It's sweet."
	icon_state = "sweetpotato"
	distill_reagent = /datum/reagent/consumable/ethanol/sbiten

/obj/item/food/grown/potato/sweet/MakeBakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/yakiimo, rand(15 SECONDS, 35 SECONDS), TRUE, TRUE)

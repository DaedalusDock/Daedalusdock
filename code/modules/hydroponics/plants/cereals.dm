// Wheat
/datum/plant/wheat
	species = "wheat"
	name = "wheat stalks"
	icon_dead = "wheat-dead"

	seed_path = /obj/item/seeds/wheat
	product_path = /obj/item/food/grown/wheat
	base_harvest_amt =4

	reagents_per_potency = list(
		/datum/reagent/consumable/nutriment = 0.04,
	)

	possible_mutations = list(
		/datum/plant_mutation/wheat_oat,
		/datum/plant_mutation/wheat_meat,
		/datum/plant_mutation/wheat_rice,
	)

/obj/item/seeds/wheat
	name = "pack of wheat seeds"
	desc = "These may, or may not, grow into wheat."
	icon_state = "seed-wheat"
	plant_type = /datum/plant/wheat

/obj/item/food/grown/wheat
	plant_datum = /datum/plant/wheat
	name = "wheat"
	desc = "Sigh... wheat... a-grain?"
	gender = PLURAL
	icon_state = "wheat"
	bite_consumption_mod = 0.5 // Chewing on wheat grains?
	foodtypes = GRAIN
	grind_results = list(/datum/reagent/consumable/flour = 0)
	tastes = list("wheat" = 1)
	distill_reagent = /datum/reagent/consumable/ethanol/beer

// Oat
/datum/plant_mutation/wheat_oat
	plant_type = /datum/plant/wheat/oat

/datum/plant/wheat/oat
	species = "oat"
	name = "Oat Stalks"
	product_path = /obj/item/food/grown/oat
	seed_path = /obj/item/seeds/wheat/oat

	possible_mutations = null

/obj/item/seeds/wheat/oat
	name = "pack of oat seeds"
	desc = "These may, or may not, grow into oat."
	icon_state = "seed-oat"

	plant_type = /datum/plant/wheat/oat

/obj/item/food/grown/oat
	plant_datum = /datum/plant/wheat/oat
	name = "oat"
	desc = "Eat oats, do squats."
	gender = PLURAL
	icon_state = "oat"
	bite_consumption_mod = 0.5
	foodtypes = GRAIN
	grind_results = list(/datum/reagent/consumable/flour = 0)
	tastes = list("oat" = 1)
	distill_reagent = /datum/reagent/consumable/ethanol/ale

// Rice
/datum/plant_mutation/wheat_rice
	plant_type = /datum/plant/wheat/rice

/datum/plant/wheat/rice
	species = "rice"
	name = "rice stalks"

	growthstages = 3

	seed_path = /obj/item/seeds/wheat/rice
	product_path = /obj/item/food/grown/rice
	possible_mutations = null

/obj/item/seeds/wheat/rice
	name = "pack of rice seeds"
	desc = "These may, or may not, grow into rice."
	icon_state = "seed-rice"

	plant_type = /datum/plant/wheat/rice

/obj/item/food/grown/rice
	plant_datum = /datum/plant/wheat/rice
	name = "rice"
	desc = "Rice to meet you."
	gender = PLURAL
	icon_state = "rice"
	bite_consumption_mod = 0.5
	foodtypes = GRAIN
	grind_results = list(/datum/reagent/consumable/rice = 0)
	tastes = list("rice" = 1)
	distill_reagent = /datum/reagent/consumable/ethanol/sake

//Meatwheat - grows into synthetic meat

/datum/plant_mutation/wheat_meat
	plant_type = /datum/plant/wheat/meat
	mutation_chance = 0

/datum/plant/wheat/meat
	species = "meatwheat"
	name = "meatwheat"

	seed_path = /obj/item/seeds/wheat/meat
	product_path = /obj/item/food/grown/meatwheat
	possible_mutations = null

/obj/item/seeds/wheat/meat
	name = "pack of meatwheat seeds"
	desc = "If you ever wanted to drive a vegetarian to insanity, here's how."
	icon_state = "seed-meatwheat"

	plant_type = /datum/plant/wheat/meat

/obj/item/food/grown/meatwheat
	name = "meatwheat"
	desc = "Some blood-drenched wheat stalks. You can crush them into what passes for meat if you squint hard enough."
	icon_state = "meatwheat"
	gender = PLURAL
	bite_consumption_mod = 0.5
	plant_datum = /datum/plant/wheat/meat
	foodtypes = MEAT | GRAIN
	grind_results = list(/datum/reagent/consumable/flour = 0, /datum/reagent/blood = 0)
	tastes = list("meatwheat" = 1)
	can_distill = FALSE

/obj/item/food/grown/meatwheat/attack_self(mob/living/user)
	user.visible_message(span_notice("[user] crushes [src] into meat."), span_notice("You crush [src] into something that resembles meat."))
	playsound(user, 'sound/effects/blobattack.ogg', 50, TRUE)
	var/obj/item/food/meat/slab/meatwheat/M = new
	qdel(src)
	user.put_in_hands(M)
	return 1

/datum/plant/nettle
	species = "nettle"
	name = "nettles"

	growthstages = 5

	seed_path = /obj/item/seeds/nettle
	product_path = /obj/item/food/grown/nettle

	innate_genes = list(
		/datum/plant_gene/product_trait/plant_type/weed_hardy,
		/datum/plant_gene/product_trait/attack/nettle_attack,
		/datum/plant_gene/product_trait/backfire/nettle_burn
	)

	reagents_per_potency = list(/datum/reagent/toxin/acid = 0.5)

/obj/item/seeds/nettle
	name = "pack of nettle seeds"
	desc = "These seeds grow into nettles."
	icon_state = "seed-nettle"

	plant_type = /datum/plant/nettle

/datum/plant_mutation/nettles_death
	plant_type = /datum/plant/nettle/death

/datum/plant/nettle/death
	species = "deathnettle"
	name = "death nettles"

	seed_path = /obj/item/seeds/nettle/death
	product_path = /obj/item/food/grown/nettle/death

	innate_genes = list(
		/datum/plant_gene/product_trait/plant_type/weed_hardy,
		/datum/plant_gene/product_trait/stinging,
		/datum/plant_gene/product_trait/attack/nettle_attack/death,
		/datum/plant_gene/product_trait/backfire/nettle_burn/death
	)

	reagents_per_potency = list(/datum/reagent/toxin/acid/fluacid = 0.5, /datum/reagent/toxin/acid = 0.5)
	rarity = 20

/obj/item/seeds/nettle/death
	name = "pack of death-nettle seeds"
	desc = "These seeds grow into death-nettles."
	icon_state = "seed-deathnettle"

	plant_type = /datum/plant/nettle/death

/obj/item/food/grown/nettle // "snack"
	plant_datum = /datum/plant/nettle
	name = "\improper nettle"
	desc = "It's probably <B>not</B> wise to touch it with bare hands..."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "nettle"
	bite_consumption_mod = 2
	lefthand_file = 'icons/mob/inhands/weapons/plants_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/plants_righthand.dmi'
	damtype = BURN
	force = 15
	hitsound = 'sound/weapons/bladeslice.ogg'
	throwforce = 5
	w_class = WEIGHT_CLASS_TINY
	throw_range = 3
	attack_verb_continuous = list("stings")
	attack_verb_simple = list("sting")

/obj/item/food/grown/nettle/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] is eating some of [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
	return (BRUTELOSS|TOXLOSS)

/obj/item/food/grown/nettle/death
	plant_datum = /datum/plant/nettle/death
	name = "\improper deathnettle"
	desc = "The <span class='danger'>glowing</span> nettle incites <span class='boldannounce'>rage</span> in you just from looking at it!"
	icon_state = "deathnettle"
	bite_consumption_mod = 4 // I guess if you really wanted to
	force = 30
	throwforce = 15

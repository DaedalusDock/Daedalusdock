// Pumpkin
/datum/plant/pumpkin
	species = "pumpkin"
	name = "pumpkin vine"

	growthstages = 3
	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'
	icon_grow = "pumpkin-grow"
	icon_dead = "pumpkin-dead"

	seed_path = /obj/item/seeds/pumpkin
	product_path = /obj/item/food/grown/pumpkin
	base_harvest_amt =3

	reagents_per_potency = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.2)

/obj/item/seeds/pumpkin
	name = "pack of pumpkin seeds"
	desc = "These seeds grow into pumpkin vines."
	icon_state = "seed-pumpkin"

	plant_type = /datum/plant/pumpkin

/obj/item/food/grown/pumpkin
	plant_datum = /datum/plant/pumpkin
	name = "pumpkin"
	desc = "It's large and scary."
	icon_state = "pumpkin"
	bite_consumption_mod = 2
	foodtypes = FRUIT
	juice_results = list(/datum/reagent/consumable/pumpkinjuice = 0)
	wine_power = 20
	///Which type of lantern this gourd produces when carved.
	var/carved_type = /obj/item/clothing/head/hardhat/pumpkinhead

/obj/item/food/grown/pumpkin/attackby(obj/item/W as obj, mob/user as mob, params)
	if(W.sharpness & SHARP_EDGED)
		user.show_message(span_notice("You carve a face into [src]!"), MSG_VISUAL)
		new carved_type(user.loc)
		qdel(src)
		return
	else
		return ..()

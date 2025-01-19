/datum/plant/onion
	species = "onion"
	name = "onion sprouts"

	growthstages = 3
	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'

	seed_path = /obj/item/seeds/onion
	product_path = /obj/item/food/grown/onion

	reagents_per_potency = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1)
	possible_mutations = list(/datum/plant_mutation/onion_red)

/obj/item/seeds/onion
	name = "pack of onion seeds"
	desc = "These seeds grow into onions."
	icon_state = "seed-onion"

	plant_type = /datum/plant/onion

/obj/item/food/grown/onion
	plant_datum = /datum/plant/onion
	name = "onion"
	desc = "Nothing to cry over."
	icon_state = "onion"
	tastes = list("onions" = 1)
	wine_power = 30

/obj/item/food/grown/onion/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/onion_slice, 2, 15)

/datum/plant_mutation/onion_red
	plant_type = /datum/plant/onion/red
	ranges = list(
		PLANT_STAT_ENDURANCE = list(-INFINITY, INFINITY),
		PLANT_STAT_POTENCY = list(-25, INFINITY),
		PLANT_STAT_MATURATION = list(-INFINITY, INFINITY),
		PLANT_STAT_PRODUCTION = list(-INFINITY, INFINITY),
		PLANT_STAT_HARVEST_AMT = list(-INFINITY, INFINITY),
		PLANT_STAT_YIELD = list(-INFINITY, INFINITY)
	)

	infusion_reagents = list(/datum/reagent/consumable/capsaicin)

/datum/plant/onion/red
	species = "onion_red"
	name = "red onion sprouts"

	seed_path = /obj/item/seeds/onion/red

	reagents_per_potency = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1, /datum/reagent/consumable/tearjuice = 0.05)
	possible_mutations = null

/obj/item/seeds/onion/red
	name = "pack of red onion seeds"
	desc = "For growing exceptionally potent onions."
	icon_state = "seed-onionred"

	plant_type = /datum/plant/onion/red

/obj/item/food/grown/onion/red
	plant_datum = /datum/plant/onion/red
	name = "red onion"
	desc = "Purple despite the name."
	icon_state = "onion_red"
	wine_power = 60

/obj/item/food/grown/onion/red/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/onion_slice/red, 2, 15)

/obj/item/food/grown/onion/UsedforProcessing(mob/living/user, obj/item/I, list/chosen_option)
	var/datum/effect_system/fluid_spread/smoke/chem/S = new //Since the onion is destroyed when it's sliced,
	var/splat_location = get_turf(src) //we need to set up the smoke beforehand
	S.attach(splat_location)
	S.set_up(0, location = splat_location, carry = reagents, silent = FALSE)
	S.start()
	qdel(S)
	return ..()

/obj/item/food/onion_slice
	name = "onion slices"
	desc = "Rings, not for wearing."
	icon_state = "onionslice"
	food_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/nutriment/vitamin = 2)
	gender = PLURAL
	w_class = WEIGHT_CLASS_TINY
	microwaved_type = /obj/item/food/onionrings

/obj/item/food/onion_slice/red
	name = "red onion slices"
	desc = "They shine like exceptionally low quality amethyst."
	icon_state = "onionslice_red"
	food_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/nutriment/vitamin = 2, /datum/reagent/consumable/tearjuice = 2.5)

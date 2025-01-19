//Korta Nut
/datum/plant/korta_nut
	species = "kortanut"
	name = "korta nut bush"

	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'
	icon_grow = "kortanut-grow"
	icon_dead = "kortanut-dead"

	seed_path = /obj/item/seeds/korta_nut
	product_path = /obj/item/food/grown/korta_nut

	innate_genes = list(/datum/plant_gene/product_trait/one_bite)
	possible_mutations = list(/datum/plant_mutation/korta_nut_sweet)
	reagents_per_potency = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1)

/obj/item/seeds/korta_nut
	name = "pack of korta nut seeds"
	desc = "These seeds grow into korta nut bushes."
	icon_state = "seed-korta"

	plant_type = /datum/plant/korta_nut

/obj/item/food/grown/korta_nut
	plant_datum = /datum/plant/korta_nut
	name = "korta nut"
	desc = "A little nut of great importance. Has a peppery shell which can be ground into flour and a soft, pulpy interior that produces a milky fluid when juiced. Or you can eat them whole, as a quick snack."
	icon_state = "korta_nut"
	foodtypes = NUTS
	grind_results = list(/datum/reagent/consumable/korta_flour = 0)
	juice_results = list(/datum/reagent/consumable/korta_milk = 0)
	tastes = list("peppery heat" = 1)
	distill_reagent = /datum/reagent/consumable/ethanol/kortara

//Sweet Korta Nut
/datum/plant_mutation/korta_nut_sweet
	plant_type = /datum/plant/korta_nut/sweet

/datum/plant/korta_nut/sweet
	species = "kortanut"
	name = "sweet korta nut bush"

	seed_path = /obj/item/seeds/korta_nut/sweet
	product_path = /obj/item/food/grown/korta_nut/sweet

	possible_mutations = null

	reagents_per_potency = list(/datum/reagent/consumable/korta_nectar = 0.1, /datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1)
	rarity = 20

/obj/item/seeds/korta_nut/sweet
	name = "pack of sweet korta nut seeds"
	desc = "These seeds grow into sweet korta nuts, a mutation of the original species that produces a thick syrup used as a sweetener."
	icon_state = "seed-sweetkorta"

/obj/item/food/grown/korta_nut/sweet
	plant_datum = /datum/plant/korta_nut/sweet
	name = "sweet korta nut"
	desc = "A sweet treat lizards love to eat."
	icon_state = "korta_nut"
	grind_results = list(/datum/reagent/consumable/korta_flour = 0)
	juice_results = list(/datum/reagent/consumable/korta_milk = 0, /datum/reagent/consumable/korta_nectar = 0)
	tastes = list("peppery sweet" = 1)
	distill_reagent = /datum/reagent/consumable/ethanol/kortara

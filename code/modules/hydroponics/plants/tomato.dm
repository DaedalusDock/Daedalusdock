// Tomato
/datum/plant/tomato
	species = "tomato"
	name = "tomato plant"

	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'
	icon_grow = "tomato-grow"
	icon_dead = "tomato-dead"

	seed_path = /obj/item/seeds/tomato
	product_path = /obj/item/food/grown/tomato

	innate_genes = list(/datum/plant_gene/product_trait/squash)
	latent_genes = list(/datum/plant_gene/quality/inferior)

	reagents_per_potency = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1)

	possible_mutations = list(/datum/plant_mutation/tomato_blood, /datum/plant_mutation/tomato_blue, /datum/plant_mutation/tomato_killer)

/obj/item/seeds/tomato
	name = "pack of tomato seeds"
	desc = "These seeds grow into tomato plants."
	icon_state = "seed-tomato"

	plant_type = /datum/plant/tomato

/obj/item/food/grown/tomato
	plant_datum = /datum/plant/tomato
	name = "tomato"
	desc = "I say to-mah-to, you say tom-mae-to."
	icon_state = "tomato"
	splat_type = /obj/effect/decal/cleanable/food/tomato_smudge
	foodtypes = FRUIT
	grind_results = list(/datum/reagent/consumable/ketchup = 0)
	juice_results = list(/datum/reagent/consumable/tomatojuice = 0)
	distill_reagent = /datum/reagent/consumable/enzyme

// Blood Tomato
/datum/plant_mutation/tomato_blood
	plant_type = /datum/plant/tomato/blood
	infusion_reagents = list(/datum/reagent/blood)

/datum/plant/tomato/blood
	species = "bloodtomato"
	name = "blood tomato plant"

	seed_path = /obj/item/seeds/tomato/blood
	product_path = /obj/item/food/grown/tomato/blood

	reagents_per_potency = list(/datum/reagent/blood = 0.2, /datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1)
	possible_mutations = null

/obj/item/seeds/tomato/blood
	name = "pack of blood-tomato seeds"
	desc = "These seeds grow into blood-tomato plants."
	icon_state = "seed-bloodtomato"

	plant_type = /datum/plant/tomato/blood

/obj/item/food/grown/tomato/blood
	plant_datum = /datum/plant/tomato/blood
	name = "blood-tomato"
	desc = "So bloody...so...very...bloody....AHHHH!!!!"
	icon_state = "bloodtomato"
	bite_consumption_mod = 3
	splat_type = /obj/effect/gibspawner/generic
	foodtypes = FRUIT | GROSS
	grind_results = list(/datum/reagent/consumable/ketchup = 0, /datum/reagent/blood = 0)
	distill_reagent = /datum/reagent/consumable/ethanol/bloody_mary

// Blue Tomato
/datum/plant_mutation/tomato_blue
	plant_type = /datum/plant/tomato/blue
	infusion_reagents = list(/datum/reagent/lube)

/datum/plant/tomato/blue
	species = "bluetomato"
	name = "blue tomato plant"

	icon_grow = "bluetomato-grow"

	seed_path = /obj/item/seeds/tomato/blue
	product_path = /obj/item/food/grown/tomato/blue
	base_harvest_yield = 2

	innate_genes = list(/datum/plant_gene/product_trait/slip)

	reagents_per_potency = list(/datum/reagent/lube = 0.2, /datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1)
	possible_mutations = null

/obj/item/seeds/tomato/blue
	name = "pack of blue-tomato seeds"
	desc = "These seeds grow into blue-tomato plants."
	icon_state = "seed-bluetomato"

	plant_type = /datum/plant/tomato/blue

/obj/item/food/grown/tomato/blue
	plant_datum = /datum/plant/tomato/blue
	name = "blue-tomato"
	desc = "I say blue-mah-to, you say blue-mae-to."
	icon_state = "bluetomato"
	bite_consumption_mod = 2
	splat_type = /obj/effect/decal/cleanable/oil
	distill_reagent = /datum/reagent/consumable/laughter

// Killer Tomato
/datum/plant_mutation/tomato_killer
	plant_type = /datum/plant/tomato/killer

/datum/plant/tomato/killer
	species = "killertomato"
	name = "killer tomato plant"

	icon_grow = "killertomato-grow"
	icon_harvest = "killertomato-harvest"
	icon_dead = "killertomato-dead"
	growthstages = 2

	base_harvest_yield = 2

	seed_path = /obj/item/seeds/tomato/killer
	product_path = /obj/item/food/grown/tomato/killer

	innate_genes = list(/datum/plant_gene/product_trait/mob_transformation/tomato)

	possible_mutations = null
	rarity = 30

/obj/item/seeds/tomato/killer
	name = "pack of killer-tomato seeds"
	desc = "These seeds grow into killer-tomato plants."
	icon_state = "seed-killertomato"

	plant_type = /datum/plant/tomato/killer

/obj/item/food/grown/tomato/killer
	plant_datum = /datum/plant/tomato/killer
	name = "\improper killer-tomato"
	desc = "I say to-mah-to, you say tom-mae-to... OH GOD IT'S EATING MY LEGS!!"
	icon_state = "killertomato"
	distill_reagent = /datum/reagent/consumable/ethanol/demonsblood

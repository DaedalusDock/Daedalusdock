// Grass
/datum/plant/grass
	species = "grass"
	name = "grass"

	growthstages = 2
	icon_grow = "grass-grow"
	icon_dead = "grass-dead"

	seed_path = /obj/item/seeds/grass
	product_path = /obj/item/food/grown/grass
	base_harvest_yield = 5

	reagents_per_potency = list(/datum/reagent/consumable/nutriment = 0.02, /datum/reagent/hydrogen = 0.05)
	possible_mutations = list(/datum/plant_mutation/grass_fairy)

/obj/item/seeds/grass
	name = "pack of grass seeds"
	desc = "These seeds grow into grass. Yummy!"
	icon_state = "seed-grass"

	plant_type = /datum/plant/grass

/obj/item/food/grown/grass
	plant_datum = /datum/plant/grass
	name = "grass"
	desc = "Green and lush."
	icon_state = "grassclump"
	bite_consumption_mod = 0.5 // Grazing on grass
	var/stacktype = /obj/item/stack/tile/grass
	var/tile_coefficient = 0.02 // 1/50
	wine_power = 15

/obj/item/food/grown/grass/attack_self(mob/user)
	to_chat(user, span_notice("You prepare the astroturf."))
	var/grassAmt = 1 + round(cached_potency * tile_coefficient) // The grass we're holding
	for(var/obj/item/food/grown/grass/G in user.loc) // The grass on the floor
		if(G.type != type)
			continue
		grassAmt += 1 + round(G.cached_potency * tile_coefficient)
		qdel(G)
	new stacktype(user.drop_location(), grassAmt)
	qdel(src)

//Fairygrass
/datum/plant_mutation/grass_fairy
	plant_type = /datum/plant/grass/fairy

	required_genes = list(/datum/plant_gene/product_trait/glow/blue)

/datum/plant/grass/fairy
	species = "fairygrass"
	name = "fairygrass"

	icon_grow = "fairygrass-grow"
	icon_dead = "fairygrass-dead"

	seed_path = /obj/item/seeds/grass/fairy
	product_path = /obj/item/food/grown/grass/fairy

	reagents_per_potency = list(/datum/reagent/consumable/nutriment = 0.02, /datum/reagent/hydrogen = 0.05, /datum/reagent/drug/space_drugs = 0.15)
	possible_mutations = null

/obj/item/seeds/grass/fairy
	name = "pack of fairygrass seeds"
	desc = "These seeds grow into a more mystical grass."
	icon_state = "seed-fairygrass"

	plant_type = /datum/plant/grass/fairy

/obj/item/food/grown/grass/fairy
	plant_datum = /datum/plant/grass/fairy
	name = "fairygrass"
	desc = "Blue, glowing, and smells fainly of mushrooms."
	icon_state = "fairygrassclump"
	bite_consumption_mod = 1
	stacktype = /obj/item/stack/tile/fairygrass

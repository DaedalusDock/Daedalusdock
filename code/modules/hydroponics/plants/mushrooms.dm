/obj/item/food/grown/mushroom
	name = "mushroom"
	bite_consumption_mod = 3
	foodtypes = VEGETABLES
	wine_power = 40

// Reishi
/datum/plant/reishi
	species = "reishi"
	name = "reishi"

	growthstages = 3
	growing_icon = 'icons/obj/hydroponics/growing_mushrooms.dmi'

	seed_path = /obj/item/seeds/reishi
	product_path = /obj/item/food/grown/mushroom/reishi

	innate_genes = list(/datum/plant_gene/product_trait/plant_type/fungal_metabolism)
	reagents_per_potency = list(/datum/reagent/medicine/morphine = 0.35, /datum/reagent/medicine/dylovene = 0.35, /datum/reagent/consumable/nutriment = 0)

/obj/item/seeds/reishi
	name = "pack of reishi mycelium"
	desc = "This mycelium grows into something medicinal and relaxing."
	icon_state = "mycelium-reishi"

	plant_type = /datum/plant/reishi

/obj/item/food/grown/mushroom/reishi
	plant_datum = /datum/plant/reishi
	name = "reishi"
	desc = "<I>Ganoderma lucidum</I>: A special fungus known for its medicinal and stress relieving properties."
	icon_state = "reishi"

// Fly Amanita
/datum/plant/amanita
	species = "amanita"
	name = "fly amanita"

	growthstages = 2
	growing_icon = 'icons/obj/hydroponics/growing_mushrooms.dmi'

	seed_path = /obj/item/seeds/amanita
	product_path = /obj/item/food/grown/mushroom/amanita

	reagents_per_potency = list(
		/datum/reagent/drug/mushroomhallucinogen = 0.04,
		/datum/reagent/toxin/amatoxin = 0.35,
		/datum/reagent/consumable/nutriment = 0,
		/datum/reagent/growthserum = 0.1
	)

	innate_genes = list(/datum/plant_gene/product_trait/plant_type/fungal_metabolism)

/obj/item/seeds/amanita
	name = "pack of fly amanita mycelium"
	desc = "This mycelium grows into something horrible."
	icon_state = "mycelium-amanita"

	plant_type = /datum/plant/amanita

/obj/item/food/grown/mushroom/amanita
	plant_datum = /datum/plant/amanita
	name = "fly amanita"
	desc = "<I>Amanita Muscaria</I>: Learn poisonous mushrooms by heart. Only pick mushrooms you know."
	icon_state = "amanita"

// Destroying Angel
/datum/plant/angel
	species = "angel"
	name = "destroying angels"

	growing_icon = 'icons/obj/hydroponics/growing_mushrooms.dmi'
	growthstages = 2

	seed_path = /obj/item/seeds/angel
	product_path = /obj/item/food/grown/mushroom/angel

	innate_genes = list(/datum/plant_gene/product_trait/plant_type/fungal_metabolism)
	reagents_per_potency = list(
		/datum/reagent/drug/mushroomhallucinogen = 0.04,
		/datum/reagent/toxin/amatoxin = 0.1,
		/datum/reagent/consumable/nutriment = 0,
		/datum/reagent/toxin/amanitin = 0.2
	)

	rarity = 30

/obj/item/seeds/angel
	name = "pack of destroying angel mycelium"
	desc = "This mycelium grows into something devastating."
	icon_state = "mycelium-angel"

	plant_type = /datum/plant/angel

/obj/item/food/grown/mushroom/angel
	plant_datum = /datum/plant/angel
	name = "destroying angel"
	desc = "<I>Amanita Virosa</I>: Deadly poisonous basidiomycete fungus filled with alpha amatoxins."
	icon_state = "angel"
	wine_power = 60

// Liberty Cap
/datum/plant/liberty
	species = "liberty"
	name = "liberty cap"

	growing_icon = 'icons/obj/hydroponics/growing_mushrooms.dmi'
	growthstages = 2

	product_path = /obj/item/food/grown/mushroom/libertycap
	seed_path = /obj/item/seeds/liberty


	innate_genes = list(/datum/plant_gene/product_trait/plant_type/fungal_metabolism)
	reagents_per_potency = list(/datum/reagent/drug/mushroomhallucinogen = 0.25, /datum/reagent/consumable/nutriment = 0.02)

/obj/item/seeds/liberty
	name = "pack of liberty-cap mycelium"
	desc = "This mycelium grows into liberty-cap mushrooms."
	icon_state = "mycelium-liberty"

	plant_type = /datum/plant/liberty

/obj/item/food/grown/mushroom/libertycap
	plant_datum = /datum/plant/liberty
	name = "liberty-cap"
	desc = "<I>Psilocybe Semilanceata</I>: Liberate yourself!"
	icon_state = "libertycap"
	wine_power = 80

// Plump Helmet
/datum/plant/plump
	species = "plump"
	name = "plump helmet"

	growthstages = 2
	growing_icon = 'icons/obj/hydroponics/growing_mushrooms.dmi'

	seed_path = /obj/item/seeds/plump
	product_path = /obj/item/food/grown/mushroom/plumphelmet

	possible_mutations = list(/datum/plant_mutation/plump_walking)
	innate_genes = list(/datum/plant_gene/product_trait/plant_type/fungal_metabolism)
	reagents_per_potency = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1)

/obj/item/seeds/plump
	name = "pack of plump-helmet mycelium"
	desc = "This mycelium grows into helmets... maybe."
	icon_state = "mycelium-plump"

	plant_type = /datum/plant/plump

/obj/item/food/grown/mushroom/plumphelmet
	plant_datum = /datum/plant/plump
	name = "plump-helmet"
	desc = "<I>Plumus Hellmus</I>: Plump, soft and s-so inviting~"
	icon_state = "plumphelmet"
	distill_reagent = /datum/reagent/consumable/ethanol/manly_dorf

// Walking Mushroom
/datum/plant_mutation/plump_walking
	plant_type = /datum/plant/plump/walking

/datum/plant/plump/walking
	species = "walkingmushroom"
	name = "walking mushroom"
	possible_mutations = null

	growthstages = 2
	innate_genes = list(/datum/plant_gene/product_trait/plant_type/fungal_metabolism, /datum/plant_gene/product_trait/mob_transformation/shroom)
	latent_genes = list(/datum/plant_gene/product_trait/eyes)

	rarity = 30

/obj/item/seeds/plump/walkingmushroom
	name = "pack of walking mushroom mycelium"
	desc = "This mycelium will grow into huge stuff!"
	icon_state = "mycelium-walkingmushroom"

	plant_type = /datum/plant/plump/walking

/obj/item/food/grown/mushroom/walkingmushroom
	plant_datum = /datum/plant/plump/walking
	name = "walking mushroom"
	desc = "<I>Plumus Locomotus</I>: The beginning of the great walk."
	icon_state = "walkingmushroom"
	can_distill = FALSE

// Chanterelle
/datum/plant/chanter
	species = "chanter"
	name = "chanterelle"

	growing_icon = 'icons/obj/hydroponics/growing_mushrooms.dmi'
	growthstages = 2

	seed_path = /obj/item/seeds/chanter
	product_path = /obj/item/food/grown/mushroom/chanterelle

	innate_genes = list(/datum/plant_gene/product_trait/plant_type/fungal_metabolism)
	reagents_per_potency = list(/datum/reagent/consumable/nutriment = 0.1)

	possible_mutations = list(/datum/plant_mutation/chanter_jupiter)

/obj/item/seeds/chanter
	name = "pack of chanterelle mycelium"
	desc = "This mycelium grows into chanterelle mushrooms."
	icon_state = "mycelium-chanter"

	plant_type = /datum/plant/chanter

/obj/item/food/grown/mushroom/chanterelle
	plant_datum = /datum/plant/chanter
	name = "chanterelle cluster"
	desc = "<I>Cantharellus Cibarius</I>: These jolly yellow little shrooms sure look tasty!"
	icon_state = "chanterelle"

//Jupiter Cup
/datum/plant_mutation/chanter_jupiter
	plant_type = /datum/plant/chanter/jupiter

/datum/plant/chanter/jupiter
	species = "jupitercup"
	name = "jupiter cup"

	growthstages = 2
	growing_icon = 'icons/obj/hydroponics/growing_mushrooms.dmi'

	innate_genes = list(
		/datum/plant_gene/product_trait/plant_type/fungal_metabolism,
		/datum/plant_gene/reagent/preset/liquidelectricity,
		/datum/plant_gene/product_trait/carnivory/jupitercup
	)

	possible_mutations = null

/obj/item/seeds/chanter/jupitercup
	name = "pack of jupiter cup mycelium"
	desc = "This mycelium grows into jupiter cups. Zeus would be envious at the power at your fingertips."
	icon_state = "mycelium-jupitercup"

	plant_type = /datum/plant/chanter/jupiter

/obj/item/food/grown/mushroom/jupitercup
	plant_datum = /datum/plant/chanter/jupiter
	name = "jupiter cup"
	desc = "A strange red mushroom, its surface is moist and slick. You wonder how many tiny worms have met their fate inside."
	icon_state = "jupitercup"

// Glowshroom
/datum/plant/glowshroom
	species = "glowshroom"
	name = "glowshroom"

	growing_icon = 'icons/obj/hydroponics/growing_mushrooms.dmi'
	growthstages = 3

	seed_path = /obj/item/seeds/glowshroom
	product_path = /obj/item/food/grown/mushroom/glowshroom

	innate_genes = list(/datum/plant_gene/product_trait/glow, /datum/plant_gene/product_trait/plant_type/fungal_metabolism)
	reagents_per_potency = list(/datum/reagent/uranium/radium = 0.1, /datum/reagent/phosphorus = 0.1, /datum/reagent/consumable/nutriment = 0.04)

	possible_mutations = list(/datum/plant_mutation/glowshroom_glowcap, /datum/plant_mutation/glowshroom_shadow)
	rarity = 20

/obj/item/seeds/glowshroom
	name = "pack of glowshroom mycelium"
	desc = "This mycelium -glows- into mushrooms!"
	icon_state = "mycelium-glowshroom"

	plant_type = /datum/plant/glowshroom

/obj/item/food/grown/mushroom/glowshroom
	plant_datum = /datum/plant/glowshroom
	name = "glowshroom cluster"
	desc = "<I>Mycena Bregprox</I>: This species of mushroom glows in the dark."
	icon_state = "glowshroom"
	var/effect_path = /obj/structure/glowshroom
	wine_power = 50

/obj/item/food/grown/mushroom/glowshroom/attack_self(mob/user)
	if(isspaceturf(user.loc))
		return FALSE

	if(!isturf(user.loc))
		to_chat(user, span_warning("You need more space to plant [src]."))
		return FALSE

	var/count = 0
	var/maxcount = 1
	for(var/tempdir in GLOB.cardinals)
		var/turf/closed/wall = get_step(user.loc, tempdir)
		if(istype(wall))
			maxcount++

	for(var/obj/structure/glowshroom/G in user.loc)
		count++
		if(count >= maxcount)
			to_chat(user, span_warning("There are too many shrooms here to plant [src]."))
			return FALSE

	new effect_path(user.loc, plant_datum)
	to_chat(user, span_notice("You plant [src]."))
	qdel(src)
	return TRUE


// Glowcap
/datum/plant_mutation/glowshroom_glowcap
	required_genes = list(/datum/plant_gene/product_trait/cell_charge)

/datum/plant/glowshroom/glowcap
	species = "glowcap"
	name = "glowcap"

	icon_harvest = "glowcap-harvest"
	growthstages = 4

	product_path = /obj/item/food/grown/mushroom/glowshroom/glowcap
	seed_path = /obj/item/seeds/glowshroom/glowcap

	innate_genes = list(/datum/plant_gene/product_trait/glow/red, /datum/plant_gene/product_trait/cell_charge, /datum/plant_gene/product_trait/plant_type/fungal_metabolism)
	reagents_per_potency = list(/datum/reagent/consumable/nutriment = 0.04)
	possible_mutations = null
	rarity = 30

/obj/item/seeds/glowshroom/glowcap
	name = "pack of glowcap mycelium"
	desc = "This mycelium -powers- into mushrooms!"
	icon_state = "mycelium-glowcap"

	plant_type = /datum/plant/glowshroom/glowcap

/obj/item/food/grown/mushroom/glowshroom/glowcap
	plant_datum = /datum/plant/glowshroom/glowcap
	name = "glowcap cluster"
	desc = "<I>Mycena Ruthenia</I>: This species of mushroom glows in the dark, but isn't actually bioluminescent. They're warm to the touch..."
	icon_state = "glowcap"
	effect_path = /obj/structure/glowshroom/glowcap
	tastes = list("glowcap" = 1)


//Shadowshroom
/datum/plant_mutation/glowshroom_shadow
	plant_type = /datum/plant/glowshroom/shadow

/datum/plant/glowshroom/shadow
	species = "shadowshroom"
	icon_grow = "shadowshroom-grow"
	icon_dead = "shadowshroom-dead"
	name = "shadowshroom"

	growthstages = 3

	seed_path = /obj/item/seeds/glowshroom/shadowshroom
	product_path = /obj/item/food/grown/mushroom/glowshroom/shadowshroom

	innate_genes = list(/datum/plant_gene/product_trait/glow/shadow, /datum/plant_gene/product_trait/plant_type/fungal_metabolism)
	reagents_per_potency = list(/datum/reagent/uranium/radium = 0.2, /datum/reagent/consumable/nutriment = 0.04)
	possible_mutations = null

	rarity = 30

/obj/item/seeds/glowshroom/shadowshroom
	name = "pack of shadowshroom mycelium"
	desc = "This mycelium will grow into something shadowy."
	icon_state = "mycelium-shadowshroom"

	plant_type = /datum/plant/glowshroom/shadow


/obj/item/food/grown/mushroom/glowshroom/shadowshroom
	plant_datum = /datum/plant/glowshroom/shadow
	name = "shadowshroom cluster"
	desc = "<I>Mycena Umbra</I>: This species of mushroom emits shadow instead of light."
	icon_state = "shadowshroom"
	effect_path = /obj/structure/glowshroom/shadowshroom
	tastes = list("shadow" = 1, "mushroom" = 1)
	wine_power = 60

/obj/item/food/grown/mushroom/glowshroom/shadowshroom/attack_self(mob/user)
	. = ..()
	if(.)
		investigate_log("was planted by [key_name(user)] at [AREACOORD(user)]", INVESTIGATE_BOTANY)

/datum/plant/puffball
	species = "odiouspuffball"
	name = "odious puffball"

	growing_icon = 'icons/obj/hydroponics/growing_mushrooms.dmi'
	icon_grow = "odiouspuffball-grow"
	icon_dead = "odiouspuffball-dead"
	icon_harvest = "odiouspuffball-harvest"
	growthstages = 3

	seed_path = /obj/item/seeds/odious_puffball
	product_path = /obj/item/food/grown/mushroom/odious_puffball

	innate_genes = list(/datum/plant_gene/product_trait/smoke, /datum/plant_gene/product_trait/plant_type/fungal_metabolism, /datum/plant_gene/product_trait/squash)
	reagents_per_potency = list(/datum/reagent/toxin/spore = 0.2, /datum/reagent/consumable/nutriment = 0.04)

	rarity = 35

/obj/item/seeds/odious_puffball
	name = "pack of odious pullball spores"
	desc = "These spores reek! Disgusting."
	icon_state = "seed-odiouspuffball"

	plant_type = /datum/plant/puffball

/obj/item/food/grown/mushroom/odious_puffball
	plant_datum = /datum/plant/puffball
	name = "odious puffball"
	desc = "<I>Lycoperdon Faetidus</I>: This puffball is considered a great nuisance not only because of the highly irritating nature of its spores, but also because of its considerable size and unsightly appearance."
	icon_state = "odious_puffball"
	tastes = list("rotten garlic" = 2, "mushroom" = 1, "spores" = 1)
	wine_power = 50

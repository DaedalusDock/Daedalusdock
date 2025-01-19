/datum/plant/cotton
	species = "cotton"
	name = "Cotton"

	icon_harvest = "cotton-harvest"
	icon_dead = "cotton-dead"
	growing_icon = 'icons/obj/hydroponics/growing.dmi'
	growthstages = 3

	seed_path = /obj/item/seeds/cotton
	product_path = /obj/item/grown/cotton

	possible_mutations = list(
		/datum/plant_mutation/cotton_durathread
	)

/obj/item/seeds/cotton
	name = "pack of cotton seeds"
	desc = "A pack of seeds that'll grow into a cotton plant. Assistants make good free labor if neccesary."
	icon_state = "seed-cotton"

	plant_type = /datum/plant/cotton

/obj/item/grown/cotton
	plant_datum = /datum/plant/cotton
	name = "cotton bundle"
	desc = "A fluffy bundle of cotton."
	icon_state = "cotton"
	force = 0
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_range = 3
	attack_verb_continuous = list("pomfs")
	attack_verb_simple = list("pomf")

	var/cotton_type = /obj/item/stack/sheet/cotton
	var/cotton_name = "raw cotton"

/obj/item/grown/cotton/attack_self(mob/user)
	user.show_message(span_notice("You pull some [cotton_name] out of the [name]!"), MSG_VISUAL)
	var/seed_modifier = 0
	if(plant_datum)
		seed_modifier = round(cached_potency / 25)
	var/amount = 1 + seed_modifier
	var/obj/item/stack/cotton = new cotton_type(user.drop_location(), amount)
	to_chat(user, span_notice("You pull [src] apart, salvaging [amount] [cotton.name]."))
	qdel(src)

//reinforced mutated variant
/datum/plant_mutation/cotton_durathread
	plant_type = /datum/plant/cotton/durathread

	ranges = list(
		PLANT_STAT_ENDURANCE = list(50, INFINITY),
		PLANT_STAT_POTENCY = list(-INFINITY, INFINITY),
		PLANT_STAT_MATURATION = list(-INFINITY, INFINITY),
		PLANT_STAT_PRODUCTION = list(-INFINITY, INFINITY),
		PLANT_STAT_HARVEST_AMT = list(-INFINITY, INFINITY),
		PLANT_STAT_YIELD = list(-INFINITY, INFINITY)
	)
	mutation_chance = 100

/datum/plant/cotton/durathread
	species = "durathread"
	name = "Durathread"

	icon_harvest = "durathread-harvest"
	icon_dead = "cotton-dead"
	growthstages = 3

	possible_mutations = null

/obj/item/seeds/cotton/durathread
	name = "pack of durathread seeds"
	desc = "A pack of seeds that'll grow into an extremely durable thread that could easily rival plasteel if woven properly."
	icon_state = "seed-durathread"

	plant_type = /datum/plant/cotton/durathread

/obj/item/grown/cotton/durathread
	plant_datum = /datum/plant/cotton/durathread
	name = "durathread bundle"
	desc = "A tough bundle of durathread, good luck unraveling this."
	icon_state = "durathread"
	force = 5
	throwforce = 5
	w_class = WEIGHT_CLASS_NORMAL
	throw_range = 3
	attack_verb_continuous = list("bashes", "batters", "bludgeons", "whacks")
	attack_verb_simple = list("bash", "batter", "bludgeon", "whack")
	cotton_type = /obj/item/stack/sheet/cotton/durathread
	cotton_name = "raw durathread"

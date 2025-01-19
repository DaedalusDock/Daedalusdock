// Banana
/datum/plant/banana
	species = "banana"
	name = "bananas"

	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'
	icon_dead = "banana-dead"

	seed_path = /obj/item/seeds/banana
	product_path = /obj/item/food/grown/banana
	base_harvest_yield = 5

	reagents_per_potency = list(
		/datum/reagent/consumable/banana = 0.1,
		/datum/reagent/potassium = 0.1,
		/datum/reagent/consumable/nutriment/vitamin = 0.04,
		/datum/reagent/consumable/nutriment = 0.02
	)

	possible_mutations = list(/datum/plant_mutation/banana_mime)

/obj/item/seeds/banana
	name = "pack of banana seeds"
	desc = "They're seeds that grow into banana trees. When grown, keep away from clown."
	icon_state = "seed-banana"

	plant_type = /datum/plant/banana

/obj/item/food/grown/banana
	plant_datum = /datum/plant/banana
	name = "banana"
	desc = "It's an excellent prop for a clown."
	icon_state = "banana"
	inhand_icon_state = "banana"
	trash_type = /obj/item/grown/bananapeel
	bite_consumption_mod = 3
	foodtypes = FRUIT
	juice_results = list(/datum/reagent/consumable/banana = 0)
	distill_reagent = /datum/reagent/consumable/ethanol/bananahonk

/obj/item/food/grown/banana/generate_trash(atom/location)
	. = ..()
	var/obj/item/grown/bananapeel/peel = .
	if(istype(peel))
		peel.grind_results = list(/datum/reagent/medicine/coagulant = peel.cached_potency * 0.2)
		peel.juice_results = list(/datum/reagent/medicine/coagulant = peel.cached_potency * 0.2)

/obj/item/food/grown/banana/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] is aiming [src] at [user.p_them()]self! It looks like [user.p_theyre()] trying to commit suicide!"))
	playsound(loc, 'sound/items/bikehorn.ogg', 50, TRUE, -1)
	sleep(25)
	if(!user)
		return (OXYLOSS)
	user.say("BANG!", forced = /datum/reagent/consumable/banana)
	sleep(25)
	if(!user)
		return (OXYLOSS)
	user.visible_message("<B>[user]</B> laughs so hard they begin to suffocate!")
	return (OXYLOSS)

//Banana Peel
/obj/item/grown/bananapeel
	plant_datum = /datum/plant/banana
	name = "banana peel"
	desc = "A peel from a banana."
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	icon_state = "banana_peel"
	inhand_icon_state = "banana_peel"
	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
	throw_range = 7

/obj/item/grown/bananapeel/Initialize(mapload)
	. = ..()
	if(prob(40))
		if(prob(60))
			icon_state = "[icon_state]_2"
		else
			icon_state = "[icon_state]_3"

/obj/item/grown/bananapeel/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] is deliberately slipping on [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
	playsound(loc, 'sound/misc/slip.ogg', 50, TRUE, -1)
	return (BRUTELOSS)


// Mimana - invisible sprites are totally a feature!
/datum/plant_mutation/banana_mime
	plant_type = /datum/plant/banana/mime

	infusion_reagents = list(/datum/reagent/toxin/lexorin)

/datum/plant/banana/mime
	species = "mimana"
	name = "Mimana Tree"

	seed_path = /obj/item/seeds/banana/mime
	product_path = /obj/item/food/grown/banana/mime
	growthstages = 4

	reagents_per_potency = list(
		/datum/reagent/consumable/nothing = 0.1,
		/datum/reagent/toxin/mutetoxin = 0.1,
		/datum/reagent/consumable/nutriment = 0.02
	)

	possible_mutations = null
	rarity = 15

/obj/item/seeds/banana/mime
	name = "pack of mimana seeds"
	desc = "They're seeds that grow into mimana trees. When grown, keep away from mime."
	icon_state = "seed-mimana"
	plant_type = /datum/plant/banana/mime

/obj/item/food/grown/banana/mime
	plant_datum = /datum/plant/banana/mime
	name = "mimana"
	desc = "It's an excellent prop for a mime."
	icon_state = "mimana"
	trash_type = /obj/item/grown/bananapeel/mimanapeel
	distill_reagent = /datum/reagent/consumable/ethanol/silencer

/obj/item/grown/bananapeel/mimanapeel
	plant_datum = /datum/plant/banana/mime
	name = "mimana peel"
	desc = "A mimana peel."
	icon_state = "mimana_peel"
	inhand_icon_state = "mimana_peel"

// Other
/obj/item/grown/bananapeel/specialpeel     //used by /obj/item/clothing/shoes/clown_shoes/banana_shoes
	name = "synthesized banana peel"
	desc = "A synthetic banana peel."

/obj/item/grown/bananapeel/specialpeel/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/slippery, 40)

/obj/item/food/grown/banana/bunch
	name = "banana bunch"
	desc = "Am exquisite bunch of bananas. The almost otherwordly plumpness steers the mind any discening entertainer towards the divine."
	icon_state = "banana_bunch"
	bite_consumption_mod = 4
	var/is_ripening = FALSE

/obj/item/food/grown/banana/bunch/Initialize(mapload, obj/item/seeds/new_seed)
	. = ..()
	reagents.add_reagent(/datum/reagent/consumable/monkey_energy, 10)
	reagents.add_reagent(/datum/reagent/consumable/banana, 10)

/obj/item/food/grown/banana/bunch/proc/start_ripening()
	if(is_ripening)
		return
	playsound(src, 'sound/effects/fuse.ogg', 80)

	animate(src, time = 1, pixel_z = 12, easing = ELASTIC_EASING)
	animate(time = 1, pixel_z = 0, easing = BOUNCE_EASING)
	addtimer(CALLBACK(src, PROC_REF(explosive_ripening)), 3 SECONDS)
	for(var/i in 1 to 32)
		animate(color = (i % 2) ? "#ffffff": "#ff6739", time = 1, easing = QUAD_EASING)

/obj/item/food/grown/banana/bunch/proc/explosive_ripening()
	honkerblast(src, light_range = 3, medium_range = 1)
	for(var/mob/shook_boi in range(6, loc))
		shake_camera(shook_boi, 3, 5)
	var/obj/effect/decal/cleanable/food/plant_smudge/banana_smudge = new(loc)
	banana_smudge.color = "#ffe02f"
	qdel(src)

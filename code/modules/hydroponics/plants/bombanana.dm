//BOMBANANA

/datum/plant/banana/bombanana
	name = "Bombanana Tree"
	product_path = /obj/item/food/grown/banana/bombanana

/obj/item/seeds/banana/bombanana
	name = "pack of bombanana seeds"
	desc = "They're seeds that grow into bombanana trees. When grown, give to the clown."
	plant_type = /datum/plant/banana/bombanana

/obj/item/food/grown/banana/bombanana
	trash_type = /obj/item/grown/bananapeel/bombanana
	plant_datum = /datum/plant/banana/bombanana
	tastes = list("explosives" = 10)
	food_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 1)

/obj/item/grown/bananapeel/bombanana
	desc = "A peel from a banana. Why is it beeping?"
	plant_datum = /datum/plant/banana/bombanana
	var/det_time = 50
	var/obj/item/grenade/syndieminibomb/bomb

/obj/item/grown/bananapeel/bombanana/Initialize(mapload)
	. = ..()
	bomb = new /obj/item/grenade/syndieminibomb(src)
	bomb.det_time = det_time
	if(iscarbon(loc))
		to_chat(loc, span_danger("[src] begins to beep."))
	bomb.arm_grenade(loc, null, FALSE)
	AddComponent(/datum/component/slippery, det_time)

/obj/item/grown/bananapeel/bombanana/Destroy()
	QDEL_NULL(bomb)
	return ..()

/obj/item/grown/bananapeel/bombanana/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] is deliberately slipping on the [src.name]! It looks like \he's trying to commit suicide."))
	playsound(loc, 'sound/misc/slip.ogg', 50, TRUE, -1)
	bomb.arm_grenade(user, 0, FALSE)
	return (BRUTELOSS)

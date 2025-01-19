/obj/machinery/hydroponics/attackby(obj/item/O, mob/user, params)
	//Called when mob user "attacks" it with object O
	if(IS_EDIBLE(O) || istype(O, /obj/item/reagent_containers))  // Syringe stuff (and other reagent containers now too)
		var/obj/item/reagent_containers/reagent_source = O

		if(!reagent_source.reagents.total_volume)
			to_chat(user, span_warning("[reagent_source] is empty!"))
			return 1

		if(reagents.total_volume >= reagents.maximum_volume && !reagent_source.reagents.has_reagent(/datum/reagent/water, 1))
			to_chat(user, span_notice("[src] is full."))
			return

		var/list/trays = list(src)//makes the list just this in cases of syringes and compost etc
		var/target = growing ? growing.name : src
		var/visi_msg = ""
		var/transfer_amount
		var/irrigate = 0	//How am I supposed to irrigate pill contents?

		if(IS_EDIBLE(reagent_source) || istype(reagent_source, /obj/item/reagent_containers/pill))
			visi_msg="[user] composts [reagent_source], spreading it through [target]"
			transfer_amount = reagent_source.reagents.total_volume
			SEND_SIGNAL(reagent_source, COMSIG_ITEM_ON_COMPOSTED, user)
		else
			transfer_amount = reagent_source.amount_per_transfer_from_this
			if(istype(reagent_source, /obj/item/reagent_containers/syringe))
				var/obj/item/reagent_containers/syringe/syr = reagent_source
				visi_msg="[user] injects [target] with [syr]"
			else if(istype(reagent_source, /obj/item/reagent_containers/spray/))
				visi_msg="[user] sprays [target] with [reagent_source]"
				playsound(loc, 'sound/effects/spray3.ogg', 50, TRUE, -6)
				irrigate = 1
			else if(transfer_amount) // Droppers, cans, beakers, what have you.
				visi_msg="[user] uses [reagent_source] on [target]"
				irrigate = 1
			// Beakers, bottles, buckets, etc.
			if(reagent_source.is_drainable())
				playsound(loc, 'sound/effects/slosh.ogg', 25, TRUE)

		if(irrigate && transfer_amount > 30 && reagent_source.reagents.total_volume >= 30 && using_irrigation)
			trays = FindConnected()
			if (trays.len > 1)
				visi_msg += ", setting off the irrigation system"

		if(visi_msg)
			visible_message(span_notice("[visi_msg]."))

		var/split = round(transfer_amount/trays.len)

		for(var/obj/machinery/hydroponics/H in trays)
		//cause I don't want to feel like im juggling 15 tamagotchis and I can get to my real work of ripping flooring apart in hopes of validating my life choices of becoming a space-gardener
			reagent_source.reagents.trans_to(H.reagents, split, transfered_by = user)
			lastuser = WEAKREF(user)

			if(IS_EDIBLE(reagent_source) || istype(reagent_source, /obj/item/reagent_containers/pill))
				qdel(reagent_source)
				H.update_appearance()
				return 1

			H.update_appearance()

		if(reagent_source) // If the source wasn't composted and destroyed
			reagent_source.update_appearance()
		return 1

	else if(istype(O, /obj/item/seeds) && !istype(O, /obj/item/seeds/sample))
		if(!seed)
			if(!user.transferItemToLoc(O, src))
				return
			SEND_SIGNAL(O, COMSIG_SEED_ON_PLANTED, src)
			to_chat(user, span_notice("You plant [O]."))
			plant_seed(O)
			return
		else
			to_chat(user, span_warning("[src] already has seeds in it!"))
			return

	else if(istype(O, /obj/item/cultivator))
		if(weedlevel > 0)
			user.visible_message(span_notice("[user] uproots the weeds."), span_notice("You remove the weeds from [src]."))
			set_weedlevel(0)
			return
		else
			to_chat(user, span_warning("This plot is completely devoid of weeds! It doesn't need uprooting."))
			return

	else if(istype(O, /obj/item/storage/bag/plants))
		attack_hand(user)
		for(var/obj/item/food/grown/G in locate(user.x,user.y,user.z))
			O.atom_storage?.attempt_insert(G, user, TRUE)
		return

	else if(istype(O, /obj/item/shovel/spade))
		if(!seed && !weedlevel)
			to_chat(user, span_warning("[src] doesn't have any plants or weeds!"))
			return

		user.visible_message(span_notice("[user] starts digging out [src]'s plants..."),
			span_notice("You start digging out [src]'s plants..."))

		if(O.use_tool(src, user, 50, volume = 50) || (!seed && !weedlevel))
			user.visible_message(span_notice("[user] digs out the plants in [src]!"), span_notice("You dig out all of [src]'s plants!"))
			if(seed) //Could be that they're just using it as a de-weeder
				clear_plant()

			set_weedlevel(0) //Has a side effect of cleaning up those nasty weeds
			return

	else if(istype(O, /obj/item/storage/part_replacer))
		RefreshParts()
		return

	else if(istype(O, /obj/item/gun/energy/floragun))
		#warn impl somatoray
		return

	else
		return ..()

/obj/machinery/hydroponics/can_be_unfasten_wrench(mob/user, silent)
	if (!unwrenchable)  // case also covered by NODECONSTRUCT checks in default_unfasten_wrench
		return CANT_UNFASTEN
	if (using_irrigation)
		if (!silent)
			to_chat(user, "<span class='warning'>Disconnect the hoses first!</span>")
		return FAILED_UNFASTEN

	return ..()

/obj/machinery/hydroponics/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(issilicon(user)) //How does AI know what plant is?
		return

	if(!growing)
		if(user)
			user.examinate(src)
		return

	switch(growing.plant_status)
		if(HYDROTRAY_PLANT_HARVESTABLE)
			return try_harvest(user)

		if(HYDROTRAY_PLANT_DEAD)
			to_chat(user, span_notice("You remove the dead plant from [src]."))
			clear_plant()

/obj/machinery/hydroponics/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return

	if(!anchored)
		update_appearance()
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	var/warning = tgui_alert(user, "Are you sure you wish to empty the tray's reagent container?","Empty Tray?", list("Yes", "No"))
	if(warning == "Yes" && user.canUseTopic(src, USE_CLOSE|USE_IGNORE_TK))
		reagents.clear_reagents()
		to_chat(user, span_warning("You empty [src]'s reagent container."))

	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/hydroponics/AltClick(mob/user)
	return ..() // This hotkey is BLACKLISTED since it's used by /datum/component/simple_rotation

/obj/machinery/hydroponics/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	default_unfasten_wrench(user, tool)
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/machinery/hydroponics/wirecutter_act(mob/living/user, obj/item/tool)
	. = ..()
	if(!unwrenchable)
		return
	if (!anchored)
		to_chat(user, "<span class='warning'>Anchor the tray first!</span>")
		return TOOL_ACT_TOOLTYPE_SUCCESS

	using_irrigation = !using_irrigation
	tool.play_tool_sound(src)
	user.visible_message("<span class='notice'>[user] [using_irrigation ? "" : "dis"]connects [src]'s irrigation hoses.</span>", \
	"<span class='notice'>You [using_irrigation ? "" : "dis"]connect [src]'s irrigation hoses.</span>")
	for(var/obj/machinery/hydroponics/h in range(1,src))
		h.update_icon_state()
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/machinery/hydroponics/proc/try_harvest(mob/living/user)
	if(!growing)
		return FALSE

	// if(!growing.on_harvest(user))
	// 	return FALSE

	// At this point, harvest will occur.
	growth = growing.get_growth_for_state(PLANT_MATURE)

	var/quality = 1
	var/max_yield = 10
	var/harvest_yield = growing.get_effective_stat(PLANT_STAT_YIELD)
	var/potency = growing.get_scaled_potency()
	var/endurance = growing.get_effective_stat(PLANT_STAT_ENDURANCE)

	// Bonus yield for a healthy plant
	if(plant_health > growing.base_health * 2)
		quality += 5
		var/yield_bonus = rand(1,3)
		max_yield += yield_bonus
		harvest_yield += yield_bonus

	else if (plant_health < growing.base_health * 0.5)
		quality -= 10

	var/product_path = growing.product_path

	if(!product_path)
		return TRUE

	var/bonus_yield_prob = 0
	if(harvest_yield > max_yield)
		bonus_yield_prob = harvest_yield - max_yield
		harvest_yield = max_yield

	harvest_yield = round(max(harvest_yield, 0))

	var/turf/T = user?.drop_location() || drop_location()

	#warn impl quality
	for(var/i in 1 to harvest_yield)
		var/unit_quality = quality
		unit_quality += rand(-2, 2)
		unit_quality += potency / 6
		unit_quality += endurance / 6

		var/atom/movable/product = new product_path(T, growing)
		product.add_fingerprint(user)

	// Healthy plants keep producing.
	if(plant_health >= growing.base_health * 4)
		bonus_yield_prob += 20

		if(prob(bonus_yield_prob))
			to_chat(user, span_notice("The [growing.name] glisten."))
		else
			growing.base_harvest_amt--

	else
		growing.base_harvest_amt--

	if(growing.base_harvest_amt <= 0)
		plant_death()
		return TRUE

	update_appearance()
	return TRUE

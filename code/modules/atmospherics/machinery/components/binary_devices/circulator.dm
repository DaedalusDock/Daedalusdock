//node2, air2, network2 correspond to input
//node1, air1, network1 correspond to output
#define CIRCULATOR_HOT 0
#define CIRCULATOR_COLD 1

/obj/machinery/atmospherics/components/binary/circulator
	name = "TEG circulator"
	desc = "A gas circulator pump and heat exchanger for a thermoelectric generator."
	icon = 'icons/obj/atmospherics/components/teg.dmi'
	icon_state = "circ-off-0"

	var/active = FALSE

	var/last_pressure_delta = 0
	pipe_flags = PIPING_ONE_PER_TURF | PIPING_DEFAULT_LAYER_ONLY

	density = TRUE
	move_resist = MOVE_RESIST_DEFAULT

	var/flipped = 0
	var/mode = CIRCULATOR_HOT
	var/obj/machinery/power/generator/generator

/obj/machinery/atmospherics/components/binary/thermomachine/is_connectable()
	if(!anchored)
		return FALSE
	. = ..()

//default cold circ for mappers
/obj/machinery/atmospherics/components/binary/circulator/cold
	mode = CIRCULATOR_COLD

//for cargo crates
/obj/machinery/atmospherics/components/binary/circulator/unwrenched
	anchored = FALSE

/obj/machinery/atmospherics/components/binary/circulator/Destroy()
	if(generator)
		disconnectFromGenerator()
	return ..()

/obj/machinery/atmospherics/components/binary/circulator/proc/return_transfer_air()

	var/datum/gas_mixture/air1 = airs[1]
	var/datum/gas_mixture/air2 = airs[2]

	var/output_starting_pressure = air1.returnPressure()
	var/input_starting_pressure = air2.returnPressure()

	if(output_starting_pressure >= input_starting_pressure-10)
		//Need at least 10 KPa difference to overcome friction in the mechanism
		last_pressure_delta = 0
		return null

	//Calculate necessary moles to transfer using PV = nRT
	if(air2.temperature>0)
		var/pressure_delta = (input_starting_pressure - output_starting_pressure)/2

		var/transfer_moles = calculate_transfer_moles(air2, air1, pressure_delta)

		last_pressure_delta = pressure_delta

		//Actually transfer the gas
		var/datum/gas_mixture/removed = air2.remove(transfer_moles)

		update_parents()

		return removed

	else
		last_pressure_delta = 0

/obj/machinery/atmospherics/components/binary/circulator/process_atmos()
	..()
	update_appearance()

/obj/machinery/atmospherics/components/binary/circulator/update_icon_state()
	if(!is_operational)
		icon_state = "circ-p-[flipped]"
		return ..()
	if(last_pressure_delta > 0)
		if(last_pressure_delta > ONE_ATMOSPHERE)
			icon_state = "circ-run-[flipped]"
		else
			icon_state = "circ-slow-[flipped]"
		return ..()

	icon_state = "circ-off-[flipped]"
	return ..()

/obj/machinery/atmospherics/components/binary/circulator/wrench_act(mob/living/user, obj/item/I)
	. = ..()
	if(!panel_open)
		to_chat(user, span_notice("Open [src]'s panel first!"))
		return TRUE
	default_change_direction_wrench(user, I)
	reset_connections()
	return TRUE

/obj/machinery/atmospherics/components/binary/circulator/wrench_act_secondary(mob/living/user, obj/item/I)
	. = ..()
	if(!panel_open)
		to_chat(user, span_notice("Open [src]'s panel first!"))
		return TRUE
	set_anchored(!anchored)
	I.play_tool_sound(src)
	if(generator)
		disconnectFromGenerator()
	to_chat(user, span_notice("You [anchored?"secure":"unsecure"] [src]."))
	reset_connections()
	return TRUE

/obj/machinery/atmospherics/components/binary/circulator/proc/reset_connections()
	var/obj/machinery/atmospherics/node1 = nodes[1]
	var/obj/machinery/atmospherics/node2 = nodes[2]

	if(node1)
		node1.disconnect(src)
		nodes[1] = null
		if(parents[1])
			nullify_pipenet(parents[1])

	if(node2)
		node2.disconnect(src)
		nodes[2] = null
		if(parents[2])
			nullify_pipenet(parents[2])

	if(anchored)
		set_init_directions()
		atmos_init()
		node1 = nodes[1]
		if(node1)
			node1.atmos_init()
			node1.add_member(src)
		node2 = nodes[2]
		if(node2)
			node2.atmos_init()
			node2.add_member(src)
		SSairmachines.add_to_rebuild_queue(src)

	return TRUE

/obj/machinery/atmospherics/components/binary/circulator/set_init_directions()
	switch(dir)
		if(NORTH, SOUTH)
			initialize_directions = EAST|WEST
		if(EAST, WEST)
			initialize_directions = NORTH|SOUTH

/obj/machinery/atmospherics/components/binary/circulator/get_node_connects()
	if(flipped)
		return list(turn(dir, 270), turn(dir, 90))
	return list(turn(dir, 90), turn(dir, 270))

/obj/machinery/atmospherics/components/binary/circulator/can_be_node(obj/machinery/atmospherics/target)
	if(anchored)
		return ..(target)
	return FALSE

/obj/machinery/atmospherics/components/binary/circulator/multitool_act(mob/living/user, obj/item/I)
	if(generator)
		disconnectFromGenerator()
	mode = !mode
	to_chat(user, span_notice("You set [src] to [mode?"cold":"hot"] mode."))
	return TRUE

/obj/machinery/atmospherics/components/binary/circulator/screwdriver_act(mob/living/user, obj/item/I)
	if(..())
		return TRUE
	panel_open = !panel_open
	I.play_tool_sound(src)
	to_chat(user, span_notice("You [panel_open?"open":"close"] the panel on [src]."))
	return TRUE

/obj/machinery/atmospherics/components/binary/circulator/welder_act(mob/living/user, obj/item/I)
	if(atom_integrity >= max_integrity)
		to_chat(user, span_notice("The [src] does not need any repairs."))
		return TRUE
	if(!I.use_tool(src, user, 0, volume=50, amount=1))
		return TRUE
	user.visible_message(span_notice("[user] repairs some damage to [src]."), span_notice("You repair some damage to [src]."))
	atom_integrity += min(10, max_integrity-atom_integrity)
	if(atom_integrity == max_integrity)
		to_chat(user, span_notice("The [src] is fully repaired."))
	return TRUE

/obj/machinery/atmospherics/components/binary/circulator/proc/disconnectFromGenerator()
	if(mode)
		generator.cold_circ = null
	else
		generator.hot_circ = null
	generator.update_appearance()
	generator = null

/obj/machinery/atmospherics/components/binary/circulator/set_piping_layer(new_layer)
	..()
	pixel_x = 0
	pixel_y = 0

/obj/machinery/atmospherics/components/binary/circulator/verb/circulator_flip()
	set name = "Flip"
	set category = "Object"
	set src in oview(1)

	if(!ishuman(usr))
		return

	if(anchored)
		to_chat(usr, span_danger("[src] is anchored!"))
		return

	flipped = !flipped
	to_chat(usr, span_notice("You flip [src]."))
	update_appearance()

/obj/machinery/atmospherics/components/binary/circulator/examine(mob/user)
	. = ..()
	. += span_notice("With the panel open:")
	. += span_notice(" -Use a wrench with left-click to rotate [src] and right-click to unanchor it.")
	. += span_notice(" -Use a multitool to toggle hot or cold mode.")
	. += span_notice("Its outlet port is to the [dir2text(flipped?(turn(dir, 270)):(turn(dir, 90)))].")

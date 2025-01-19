/obj/machinery/autolathe
	name = "autolathe"
	desc = "It produces items using iron, glass, plastic and maybe some more."
	icon_state = "autolathe"
	density = TRUE
	active_power_usage = BASE_MACHINE_ACTIVE_CONSUMPTION * 0.5
	circuit = /obj/item/circuitboard/machine/autolathe
	layer = BELOW_OBJ_LAYER
	has_disk_slot = TRUE

	var/operating = FALSE
	var/list/L = list()
	var/list/LL = list()
	var/hacked = FALSE
	var/disabled = FALSE
	var/shocked = FALSE
	var/hack_wire
	var/disable_wire
	var/shock_wire

	var/busy = FALSE

	var/list/categories

	///the multiplier for how much materials the created object takes from this machines stored materials
	var/creation_efficiency = 1.6

	var/datum/design/being_built
	var/list/datum/design/matching_designs
	var/selected_category = "None"
	var/base_price = 25
	var/hacked_price = 50

/obj/machinery/autolathe/Initialize(mapload)
	AddComponent(/datum/component/material_container, SSmaterials.materials_by_category[MAT_CATEGORY_ITEM_MATERIAL], 0, MATCONTAINER_EXAMINE, _after_insert = CALLBACK(src, PROC_REF(AfterMaterialInsert)))
	. = ..()
	wires = new /datum/wires/autolathe(src)
	matching_designs = list()
	compile_categories()

/obj/machinery/autolathe/Destroy()
	QDEL_NULL(wires)
	return ..()

/obj/machinery/autolathe/ui_interact(mob/user, datum/tgui/ui)
	if(!is_operational)
		return

	if(shocked && !(machine_stat & NOPOWER))
		shock(user,50)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Autolathe")
		ui.open()

/obj/machinery/autolathe/ui_data(mob/user)
	var/list/data = list()
	data["materials"] = list()
	var/datum/component/material_container/materials = GetComponent(/datum/component/material_container)
	data["materialtotal"] = materials.total_amount
	data["materialsmax"] = materials.max_amount
	data["categories"] = categories
	data["designs"] = list()
	data["active"] = busy

	for(var/mat_id in materials.materials)
		var/datum/material/M = mat_id
		var/mineral_count = materials.materials[mat_id]
		var/list/material_data = list(
			name = M.name,
			mineral_amount = mineral_count,
			matcolour = M.greyscale_colors,
		)
		data["materials"] += list(material_data)
	if(selected_category != "None" && !length(matching_designs))
		data["designs"] = handle_designs(internal_disk.read(DATA_IDX_DESIGNS), TRUE)
	else
		data["designs"] = handle_designs(matching_designs, FALSE)
	return data

/obj/machinery/autolathe/proc/handle_designs(list/designs, categorycheck)
	var/list/output = list()
	for(var/datum/design/D as anything in designs)
		if(categorycheck && !(selected_category in D.category))
			continue

		var/unbuildable = FALSE // we can't build the design currently
		var/m10 = FALSE // 10x mult
		var/m25 = FALSE // 25x mult
		var/m50 = FALSE // 50x mult
		var/m5 = FALSE // 5x mult
		var/sheets = FALSE // sheets or no?
		if(disabled || !can_build(D))
			unbuildable = TRUE
		var/max_multiplier = unbuildable ? 0 : 1
		if(ispath(D.build_path, /obj/item/stack))
			sheets = TRUE
			if(!unbuildable)
				var/datum/component/material_container/mats = GetComponent(/datum/component/material_container)
				for(var/datum/material/mat in D.materials)
					max_multiplier = min(D.maxstack, round(mats.get_material_amount(mat)/D.materials[mat]))
				if (max_multiplier>10 && !disabled)
					m10 = TRUE
				if (max_multiplier>25 && !disabled)
					m25 = TRUE
		else
			if(!unbuildable)
				if(!disabled && can_build(D, 5))
					m5 = TRUE
				if(!disabled && can_build(D, 10))
					m10 = TRUE
				var/datum/component/material_container/mats = GetComponent(/datum/component/material_container)
				for(var/datum/material/mat in D.materials)
					max_multiplier = min(50, round(mats.get_material_amount(mat)/(D.materials[mat] * creation_efficiency)))

		var/list/design = list(
			name = D.name,
			id = D.id,
			ref = REF(src),
			cost = get_design_cost(D),
			buildable = unbuildable,
			mult5 = m5,
			mult10 = m10,
			mult25 = m25,
			mult50 = m50,
			sheet = sheets,
			maxmult = max_multiplier,
		)
		output += list(design)
	return output

/obj/machinery/autolathe/ui_act(action, params)
	. = ..()
	if(.)
		return
	if(action == "menu")
		selected_category = null
		matching_designs.Cut()
		. = TRUE

	if(action == "category")
		selected_category = params["selectedCategory"]
		matching_designs.Cut()
		. = TRUE

	if(action == "search")
		matching_designs.Cut()

		for(var/datum/design/D as anything in internal_disk.read(DATA_IDX_DESIGNS))
			if(findtext(D.name,params["to_search"]))
				matching_designs.Add(D)
		. = TRUE

	if(action == "make")
		if (!busy)
			/////////////////
			//href protection
			being_built = SStech.designs_by_id[params["id"]]
			if(!being_built || !(being_built in internal_disk.read(DATA_IDX_DESIGNS)))
				return

			var/multiplier = text2num(params["multiplier"])
			if(!multiplier)
				to_chat(usr, span_alert("[src] only accepts a numerical multiplier!"))
				return
			var/is_stack = ispath(being_built.build_path, /obj/item/stack)
			multiplier = clamp(round(multiplier),1,50)

			/////////////////

			var/coeff = (is_stack ? 1 : creation_efficiency) //stacks are unaffected by production coefficient
			var/total_amount = 0

			for(var/MAT in being_built.materials)
				total_amount += being_built.materials[MAT]

			var/power = max(active_power_usage, (total_amount)*multiplier/5) //Change this to use all materials

			var/datum/component/material_container/materials = GetComponent(/datum/component/material_container)

			var/list/materials_used = list()
			var/list/custom_materials = list() //These will apply their material effect, This should usually only be one.

			for(var/MAT in being_built.materials)
				var/datum/material/used_material = MAT
				var/amount_needed = being_built.materials[MAT] * coeff * multiplier
				if(istext(used_material)) //This means its a category
					var/list/list_to_show = list()
					for(var/i in SSmaterials.materials_by_category[used_material])
						if(materials.materials[i] > 0)
							list_to_show += i

					used_material = tgui_input_list(usr, "Choose [used_material]", "Custom Material", sort_list(list_to_show, GLOBAL_PROC_REF(cmp_typepaths_asc)))
					if(isnull(used_material))
						return //Didn't pick any material, so you can't build shit either.
					custom_materials[used_material] += amount_needed

				materials_used[used_material] = amount_needed

			if(materials.has_materials(materials_used))
				busy = TRUE
				to_chat(usr, span_notice("You print [multiplier] item(s) from the [src]"))
				use_power(power)
				icon_state = "autolathe_n"
				var/time = is_stack ? 32 : (32 * coeff * multiplier) ** 0.8
				addtimer(CALLBACK(src, PROC_REF(make_item), power, materials_used, custom_materials, multiplier, coeff, is_stack, usr), time)
				. = TRUE
			else
				to_chat(usr, span_alert("Not enough materials for this operation."))
		else
			to_chat(usr, span_alert("The autolathe is busy. Please wait for completion of previous operation."))

/obj/machinery/autolathe/on_deconstruction()
	var/datum/component/material_container/materials = GetComponent(/datum/component/material_container)
	materials.retrieve_all()

/obj/machinery/autolathe/attackby(obj/item/attacking_item, mob/living/user, params)
	if(busy)
		balloon_alert(user, "it's busy!")
		return TRUE

	if(default_deconstruction_crowbar(attacking_item))
		return TRUE

	if(panel_open && is_wire_tool(attacking_item))
		wires.interact(user)
		return TRUE

	if(user.combat_mode) //so we can hit the machine
		return ..()

	if(machine_stat)
		return TRUE

	if(panel_open)
		balloon_alert(user, "close the panel first!")
		return FALSE

	if(istype(attacking_item, /obj/item/storage/bag/trash))
		for(var/obj/item/content_item in attacking_item.contents)
			if(!do_after(user, src, 0.5 SECONDS))
				return FALSE
			attackby(content_item, user)
		return TRUE

	return ..()

/obj/machinery/autolathe/attackby_secondary(obj/item/weapon, mob/living/user, params)
	. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(busy)
		balloon_alert(user, "it's busy!")
		return

	if(default_deconstruction_screwdriver(user, "autolathe_t", "autolathe", weapon))
		return

	if(machine_stat)
		return SECONDARY_ATTACK_CALL_NORMAL

	if(panel_open)
		balloon_alert(user, "close the panel first!")
		return

	return SECONDARY_ATTACK_CALL_NORMAL

/obj/machinery/autolathe/proc/AfterMaterialInsert(obj/item/item_inserted, id_inserted, amount_inserted)
	if(istype(item_inserted, /obj/item/stack/ore/bluespace_crystal))
		use_power(MINERAL_MATERIAL_AMOUNT / 10)
	else if(item_inserted.has_material_type(/datum/material/glass))
		flick("autolathe_r", src)//plays glass insertion animation by default otherwise
	else
		flick("autolathe_o", src)//plays metal insertion animation

		use_power(min(active_power_usage * 0.25, amount_inserted / 100))

/obj/machinery/autolathe/proc/make_item(power, list/materials_used, list/picked_materials, multiplier, coeff, is_stack, mob/user)
	var/datum/component/material_container/materials = GetComponent(/datum/component/material_container)
	var/atom/A = drop_location()
	use_power(power)

	materials.use_materials(materials_used)

	if(is_stack)
		var/obj/item/stack/N = new being_built.build_path(A, multiplier, FALSE)
		N.update_appearance()
		N.autolathe_crafted(src)
	else
		for(var/i in 1 to multiplier)
			var/obj/item/new_item = new being_built.build_path(A)
			new_item.autolathe_crafted(src)

			if(length(picked_materials))
				new_item.set_custom_materials(picked_materials, 1 / multiplier) //Ensure we get the non multiplied amount

	icon_state = "autolathe"
	busy = FALSE

/obj/machinery/autolathe/RefreshParts()
	. = ..()
	var/mat_capacity = 0
	for(var/obj/item/stock_parts/matter_bin/new_matter_bin in component_parts)
		mat_capacity += new_matter_bin.rating*75000
	var/datum/component/material_container/materials = GetComponent(/datum/component/material_container)
	materials.max_amount = mat_capacity

	var/efficiency=1.8
	for(var/obj/item/stock_parts/manipulator/new_manipulator in component_parts)
		efficiency -= new_manipulator.rating*0.2
	creation_efficiency = max(1,efficiency) // creation_efficiency goes 1.6 -> 1.4 -> 1.2 -> 1 per level of manipulator efficiency

/obj/machinery/autolathe/examine(mob/user)
	. += ..()
	var/datum/component/material_container/materials = GetComponent(/datum/component/material_container)
	if(in_range(user, src) || isobserver(user))
		. += span_notice("The status display reads:")
		. += span_notice("[FOURSPACES]Storing up to <b>[materials.max_amount]</b> material units.")
		. += span_notice("[FOURSPACES]Material consumption at <b>[creation_efficiency*100]%</b>.")

/obj/machinery/autolathe/proc/can_build(datum/design/D, amount = 1)
	if(length(D.make_reagents))
		return FALSE

	var/coeff = (ispath(D.build_path, /obj/item/stack) ? 1 : creation_efficiency)

	var/list/required_materials = list()

	for(var/i in D.materials)
		required_materials[i] = D.materials[i] * coeff * amount

	var/datum/component/material_container/materials = GetComponent(/datum/component/material_container)

	return materials.has_materials(required_materials)


/obj/machinery/autolathe/proc/get_design_cost(datum/design/D)
	var/coeff = (ispath(D.build_path, /obj/item/stack) ? 1 : creation_efficiency)
	var/dat
	for(var/i in D.materials)
		if(istext(i)) //Category handling
			dat += "[D.materials[i] * coeff] [i]"
		else
			var/datum/material/M = i
			dat += "[D.materials[i] * coeff] [M.name] "
	return dat

/obj/machinery/autolathe/proc/compile_categories()
	categories = list()
	for(var/datum/design/D as anything in internal_disk.read(DATA_IDX_DESIGNS))
		if(!isnull(D.category))
			categories |= D.category
	sortTim(categories, GLOBAL_PROC_REF(cmp_text_asc))

/obj/machinery/autolathe/proc/reset(wire)
	switch(wire)
		if(WIRE_HACK)
			if(!wires.is_cut(wire))
				adjust_hacked(FALSE)
		if(WIRE_SHOCK)
			if(!wires.is_cut(wire))
				shocked = FALSE
		if(WIRE_DISABLE)
			if(!wires.is_cut(wire))
				disabled = FALSE

/obj/machinery/autolathe/proc/shock(mob/user, prb)
	if(machine_stat & (BROKEN|NOPOWER)) // unpowered, no shock
		return FALSE
	if(!prob(prb))
		return FALSE
	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(5, 1, src)
	s.start()
	if (electrocute_mob(user, get_area(src), src, 0.7, TRUE))
		return TRUE
	else
		return FALSE

/obj/machinery/autolathe/proc/adjust_hacked(state)
	hacked = state
	var/static/list/datum/design/hacked_designs
	if(!hacked_designs)
		var/list/L = list(
			/datum/design/large_welding_tool,
			/datum/design/handcuffs,
			/datum/design/receiver,
			/datum/design/cleaver,
			/datum/design/toygun,
			/datum/design/capbox,
		)
		hacked_designs = SStech.fetch_designs(L)

	if(hacked)
		internal_disk.write(DATA_IDX_DESIGNS, hacked_designs, TRUE)
	else
		internal_disk.remove(DATA_IDX_DESIGNS, hacked_designs, TRUE)


/obj/machinery/autolathe/hacked/Initialize(mapload)
	. = ..()
	adjust_hacked(TRUE)

//Called when the object is constructed by an autolathe
//Has a reference to the autolathe so you can do !!FUN!! things with hacked lathes
/obj/item/proc/autolathe_crafted(obj/machinery/autolathe/A)
	return

/obj/item/disk/data/hyper/preloaded/autolathe

/obj/item/disk/data/hyper/preloaded/autolathe/compile_designs()
	. = ..()
	. += list(
		/datum/design/bucket,
		/datum/design/mop,
		/datum/design/broom,
		/datum/design/crowbar,
		/datum/design/multitool,
		/datum/design/weldingtool,
		/datum/design/wrench,
		/datum/design/screwdriver,
		/datum/design/wirecutters,
		/datum/design/flashlight,
		/datum/design/extinguisher,
		/datum/design/analyzer,
		/datum/design/tscanner,
		/datum/design/welding_helmet,
		/datum/design/cable_coil,
		/datum/design/apc_board,
		/datum/design/airlock_board,
		/datum/design/firelock_board,
		/datum/design/airalarm_electronics,
		/datum/design/firealarm_electronics,
		/datum/design/airlock_painter,
		/datum/design/airlock_painter/decal,
		/datum/design/airlock_painter/decal/tile,
		/datum/design/paint_sprayer,
		/datum/design/emergency_oxygen,
		/datum/design/iron,
		/datum/design/glass,
		/datum/design/rglass,
		/datum/design/rods,
		/datum/design/plant_analyzer,
		/datum/design/shovel,
		/datum/design/spade,
		/datum/design/blood_filter,
		/datum/design/scalpel,
		/datum/design/circular_saw,
		/datum/design/bonesetter,
		/datum/design/surgicaldrill,
		/datum/design/retractor,
		/datum/design/cautery,
		/datum/design/hemostat,
		/datum/design/beaker,
		/datum/design/large_beaker,
		/datum/design/pillbottle,
		/datum/design/igniter,
		/datum/design/condenser,
		/datum/design/signaler,
		/datum/design/radio_headset,
		/datum/design/bounced_radio,
		/datum/design/intercom_frame,
		/datum/design/infrared_emitter,
		/datum/design/health_sensor,
		/datum/design/timer,
		/datum/design/voice_analyzer,
		/datum/design/light_bulb,
		/datum/design/light_tube,
		/datum/design/camera_assembly,
		/datum/design/newscaster_frame,
		/datum/design/status_display_frame,
		/datum/design/syringe,
		/datum/design/dropper,
		/datum/design/prox_sensor,
		/datum/design/foam_dart,
		/datum/design/spraycan,
		/datum/design/desttagger,
		/datum/design/salestagger,
		/datum/design/handlabeler,
		/datum/design/geiger,
		/datum/design/turret_control_frame,
		/datum/design/conveyor_belt,
		/datum/design/conveyor_switch,
		/datum/design/miniature_power_cell,
		/datum/design/package_wrap,
		/datum/design/holodisk,
		/datum/design/circuit,
		/datum/design/circuitgreen,
		/datum/design/circuitred,
		/datum/design/price_tagger,
		/datum/design/custom_vendor_refill,
		/datum/design/plastic_tree,
		/datum/design/plastic_ring,
		/datum/design/plastic_box,
		/datum/design/sticky_tape,
		/datum/design/chisel,
		/datum/design/control,
		/datum/design/paperroll,
		/datum/design/beacon,
		/datum/design/plasticducky,
		/datum/design/gas_filter,
		/datum/design/oven_tray,
		/datum/design/data,
	)


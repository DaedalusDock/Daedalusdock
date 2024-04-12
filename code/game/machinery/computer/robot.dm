/obj/machinery/computer/robotics
	name = "robotics control console"
	desc = "Used to remotely lockdown linked Cyborgs and Drones."
	icon_screen = "robot"
	icon_keyboard = "rd_key"
	req_access = list(ACCESS_ROBOTICS)
	circuit = /obj/item/circuitboard/computer/robotics
	light_color = LIGHT_COLOR_PINK

/obj/machinery/computer/robotics/proc/can_control(mob/user, mob/living/silicon/robot/R)
	. = FALSE
	if(!istype(R))
		return
	if(isAI(user))
		if(R.connected_ai != user)
			return
	if(iscyborg(user))
		if(R != user)
			return
	if(R.scrambledcodes)
		return
	return TRUE

/obj/machinery/computer/robotics/ui_interact(mob/user, datum/tgui/managed/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "RoboticsControlConsole", name)
		ui.open()

/obj/machinery/computer/robotics/ui_data(mob/user)
	var/list/data = list()

	data["can_hack"] = FALSE
	if(issilicon(user))
		var/mob/living/silicon/S = user
		if(S.hack_software)
			data["can_hack"] = TRUE
	else if(isAdminGhostAI(user))
		data["can_hack"] = TRUE

	data["can_detonate"] = FALSE
	if(isAI(user))
		var/mob/living/silicon/ai/ai = user
		data["can_detonate"] = !isnull(ai.malf_picker)

	data["cyborgs"] = list()
	for(var/mob/living/silicon/robot/R in GLOB.silicon_mobs)
		if(!can_control(user, R))
			continue
		if(z != (get_turf(R)).z)
			continue
		var/list/cyborg_data = list(
			name = R.name,
			locked_down = R.lockcharge,
			status = R.stat,
			charge = R.cell ? round(R.cell.percent()) : null,
			module = R.model ? "[R.model.name] Model" : "No Model Detected",
			synchronization = R.connected_ai,
			emagged = R.emagged,
			ref = REF(R)
		)
		data["cyborgs"] += list(cyborg_data)

	data["drones"] = list()
	for(var/mob/living/simple_animal/drone/D in GLOB.drones_list)
		if(D.hacked)
			continue
		if(z != (get_turf(D)).z)
			continue
		var/list/drone_data = list(
			name = D.name,
			status = D.stat,
			ref = REF(D)
		)
		data["drones"] += list(drone_data)

	return data

/obj/machinery/computer/robotics/ui_act(action, params)
	. = ..()
	if(.)
		return

	switch(action)
		if("stopbot")
			if(allowed(usr))
				var/mob/living/silicon/robot/R = locate(params["ref"]) in GLOB.silicon_mobs
				if(can_control(usr, R) && !..())
					if(isAI(usr) && (R.ai_lockdown && R.lockcharge || !R.lockcharge) || !isAI(usr))
						R.ai_lockdown = FALSE
						if(isAI(usr)&&!R.lockcharge)
							R.ai_lockdown = TRUE
						message_admins(span_notice("[ADMIN_LOOKUPFLW(usr)] [!R.lockcharge ? "locked down" : "released"] [ADMIN_LOOKUPFLW(R)]!"))
						log_silicon("[key_name(usr)] [!R.lockcharge ? "locked down" : "released"] [key_name(R)]!")
						log_combat(usr, R, "[!R.lockcharge ? "locked down" : "released"] cyborg")
						R.SetLockdown(!R.lockcharge)
						to_chat(R, !R.lockcharge ? span_notice("Your lockdown has been lifted!") : span_alert("You have been locked down!"))
						if(R.connected_ai)
							to_chat(R.connected_ai, "[!R.lockcharge ? span_notice("NOTICE - Cyborg lockdown lifted") : span_alert("ALERT - Cyborg lockdown detected")]: <a href='?src=[REF(R.connected_ai)];track=[html_encode(R.name)]'>[R.name]</a><br>")
					else
						to_chat(usr, span_danger("Cyborg locked by an user with superior permissions."))
			else
				to_chat(usr, span_danger("Access Denied."))

		if("killbot") //Malf AIs, and AIs with a combat upgrade, can detonate their cyborgs remotely.
			if(!isAI(usr))
				return
			var/mob/living/silicon/ai/ai = usr
			if(!ai.malf_picker)
				return
			var/mob/living/silicon/robot/target = locate(params["ref"]) in GLOB.silicon_mobs
			if(!istype(target))
				return
			if(target.connected_ai != ai)
				return
			target.self_destruct(usr)

		if("magbot")
			var/mob/living/silicon/S = usr
			if((istype(S) && S.hack_software) || isAdminGhostAI(usr))
				var/mob/living/silicon/robot/R = locate(params["ref"]) in GLOB.silicon_mobs
				if(istype(R) && !R.emagged && (R.connected_ai == usr || isAdminGhostAI(usr)) && !R.scrambledcodes && can_control(usr, R))
					log_silicon("[key_name(usr)] emagged [key_name(R)] using robotic console!")
					message_admins("[ADMIN_LOOKUPFLW(usr)] emagged cyborg [key_name_admin(R)] using robotic console!")
					R.SetEmagged(TRUE)
					R.logevent("WARN: root privleges granted to PID [num2hex(rand(1,65535), -1)][num2hex(rand(1,65535), -1)].") //random eight digit hex value. Two are used because rand(1,4294967295) throws an error

		if("killdrone")
			if(allowed(usr))
				var/mob/living/simple_animal/drone/D = locate(params["ref"]) in GLOB.mob_list
				if(D.hacked)
					to_chat(usr, span_danger("ERROR: [D] is not responding to external commands."))
				else
					var/turf/T = get_turf(D)
					message_admins("[ADMIN_LOOKUPFLW(usr)] detonated [key_name_admin(D)] at [ADMIN_VERBOSEJMP(T)]!")
					log_silicon("[key_name(usr)] detonated [key_name(D)]!")
					var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
					s.set_up(3, TRUE, D)
					s.start()
					D.visible_message(span_danger("\the [D] self-destructs!"))
					D.gib()

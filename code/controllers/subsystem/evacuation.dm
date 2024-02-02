#define CREW_DEATH_MESSAGE "Automatically starting evacuation sequence due to crew death."

SUBSYSTEM_DEF(evacuation)
	name = "Evacuation"
	wait = 1 SECONDS
	init_order = INIT_ORDER_EVACUATION
	flags = SS_KEEP_TIMING
	runlevels = RUNLEVEL_GAME
	/// Controllers that handle the evacuation of the station
	var/list/datum/evacuation_controller/controllers
	/// A list of things blocking evacuation
	var/list/evacuation_blockers = list()
	/// Whether you can cancel evacuation. Used by automatic evacuation
	var/cancel_blocked = FALSE

/datum/controller/subsystem/evacuation/fire(resumed)
	if(!SSticker.HasRoundStarted() || length(evacuation_blockers))
		return

	var/threshold = CONFIG_GET(number/evacuation_autocall_threshold)
	if(!threshold)
		return

	var/alive = 0
	for(var/mob/M as anything in GLOB.player_list)
		if(M.stat != DEAD)
			++alive

	var/total = length(GLOB.joined_player_list)
	if(total <= 0)
		return

	if(alive / total > threshold)
		return

	message_admins(CREW_DEATH_MESSAGE)
	log_evacuation("[CREW_DEATH_MESSAGE] Alive: [alive], Roundstart: [total], Threshold: [threshold]")

	cancel_blocked = TRUE
	trigger_auto_evac(EVACUATION_REASON_CREW_DEATH)

/datum/controller/subsystem/evacuation/proc/trigger_auto_evac(reason)
	for(var/identifier in controllers)
		controllers[identifier].start_automatic_evacuation(reason)

/datum/controller/subsystem/evacuation/proc/can_evac(mob/caller, controller_id)
	var/datum/evacuation_controller/controller = controllers[controller_id]
	if(!controller)
		return "Error 500. Please contact your system administrator."
	return controller.can_evac(caller)

/datum/controller/subsystem/evacuation/proc/request_evacuation(mob/caller, reason, controller_id)
	var/datum/evacuation_controller/controller = controllers[controller_id]
	if(!controller)
		return
	controller.trigger_evacuation(caller, reason)

/datum/controller/subsystem/evacuation/proc/can_cancel(mob/caller, controller_id)
	var/datum/evacuation_controller/controller = controllers[controller_id]
	if(!controller)
		return FALSE
	return controller.can_cancel(caller)

/datum/controller/subsystem/evacuation/proc/request_cancel(mob/caller, controller_id)
	var/datum/evacuation_controller/controller = controllers[controller_id]
	if(!controller)
		return
	controller.trigger_cancel_evacuation(caller)

/datum/controller/subsystem/evacuation/proc/add_evacuation_blocker(datum/bad)
	evacuation_blockers += bad
	if(length(evacuation_blockers) == 1)
		for(var/identifier in controllers)
			controllers[identifier].evacuation_blocked()

/datum/controller/subsystem/evacuation/proc/remove_evacuation_blocker(datum/bad)
	evacuation_blockers -= bad
	if(!length(evacuation_blockers))
		for(var/identifier in controllers)
			controllers[identifier].evacuation_unblocked()

/datum/controller/subsystem/evacuation/proc/disable_evacuation(controller_id)
	if(controllers[controller_id])
		controllers[controller_id].disable_evacuation()

/datum/controller/subsystem/evacuation/proc/enable_evacuation(controller_id)
	if(controllers[controller_id])
		controllers[controller_id].enable_evacuation()

/datum/controller/subsystem/evacuation/proc/block_cancel(controller_id)
	if(controllers[controller_id])
		controllers[controller_id].block_cancel()

/datum/controller/subsystem/evacuation/proc/unblock_cancel(controller_id)
	if(controllers[controller_id])
		controllers[controller_id].unblock_cancel()

/datum/controller/subsystem/evacuation/proc/get_customizable_shuttles()
	var/list/shuttles = list()
	for(var/identifier in controllers)
		shuttles += controllers[identifier].get_customizable_shuttles()
	return shuttles

/datum/controller/subsystem/evacuation/proc/get_endgame_areas()
	var/list/areas = list()
	for(var/identifier in controllers)
		areas += controllers[identifier].get_endgame_areas()
	return areas

/datum/controller/subsystem/evacuation/proc/get_stat_data()
	var/list/data = list()
	for(var/identifier in controllers)
		data += controllers[identifier].get_stat_data()
	return data

/datum/controller/subsystem/evacuation/proc/get_world_topic_status()
	var/list/status = list()
	for(var/identifier in controllers)
		status += controllers[identifier].get_world_topic_status()
	return status

/datum/controller/subsystem/evacuation/Topic(href, list/href_list)
	..()
	if(!check_rights(R_ADMIN))
		message_admins("[usr.key] has attempted to override the evacuation panel!")
		log_admin("[key_name(usr)] tried to use the evacuation panel without authorization.")
		return

/datum/controller/subsystem/evacuation/proc/admin_panel()
	//TODO: Add controllers to the admin panel
	return

#undef CREW_DEATH_MESSAGE

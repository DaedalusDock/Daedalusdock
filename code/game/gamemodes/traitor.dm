///What percentage of the crew can become traitors.
#define TRAITOR_SCALING_COEFF 0.15

/datum/game_mode/traitor
	name = "Traitor"

	weight = GAMEMODE_WEIGHT_NORMAL
	restricted_jobs = list(JOB_CYBORG)
	protected_jobs = list(
		JOB_SECURITY_OFFICER,
		JOB_WARDEN,
		JOB_HEAD_OF_PERSONNEL,
		JOB_HEAD_OF_SECURITY,
		JOB_CAPTAIN,
		JOB_CHIEF_ENGINEER,
		JOB_CHIEF_MEDICAL_OFFICER
	)

	antag_datum = /datum/antagonist/traitor
	antag_flag = ROLE_TRAITOR

/datum/game_mode/traitor/pre_setup()
	..()

	var/num_traitors = 1

	num_traitors = max(1, min(round(length(SSticker.ready_players) / (TRAITOR_SCALING_COEFF * 2)) + 2, round(length(SSticker.ready_players) / TRAITOR_SCALING_COEFF)))

	for (var/i in 1 to num_traitors)
		if(possible_antags.len <= 0)
			break
		var/mob/M = pick_n_take(possible_antags)
		M.mind.special_role = ROLE_TRAITOR
		M.mind.restricted_roles = restricted_jobs
		GLOB.pre_setup_antags += M.mind

	var/enough_tators = length(GLOB.pre_setup_antags)

	if(!enough_tators)
		setup_error = "Not enough traitor candidates"
		return FALSE
	else
		return TRUE

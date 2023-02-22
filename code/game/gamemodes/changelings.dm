///What percentage of the crew can become changelings.
#define CHANGELING_SCALING_COEFF 0.1

/datum/game_mode/changeling
	name = "Changeling"

	weight = GAMEMODE_WEIGHT_RARE
	restricted_jobs = list(JOB_CYBORG, JOB_AI)
	protected_jobs = list(
		JOB_SECURITY_OFFICER,
		JOB_WARDEN,
		JOB_HEAD_OF_PERSONNEL,
		JOB_HEAD_OF_SECURITY,
		JOB_CAPTAIN,
		JOB_CHIEF_ENGINEER,
		JOB_CHIEF_MEDICAL_OFFICER
	)

	antag_datum = /datum/antagonist/changeling
	antag_flag = ROLE_CHANGELING

/datum/game_mode/changeling/pre_setup()
	. = ..()

	var/num_ling = 1

	num_ling = max(1, round(length(SSticker.ready_players) * CHANGELING_SCALING_COEFF))

	for (var/i in 1 to num_ling)
		if(possible_antags.len <= 0)
			break
		var/mob/M = pick_n_take(possible_antags)
		M.mind.special_role = ROLE_CHANGELING
		M.mind.restricted_roles = restricted_jobs
		GLOB.pre_setup_antags += M.mind

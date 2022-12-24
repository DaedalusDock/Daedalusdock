/datum/round_event_control/grid_check
	name = "Grid Check"
	typepath = /datum/round_event/grid_check
	weight = 10
	max_occurrences = 3

/datum/round_event/grid_check
	announceWhen = 1
	startWhen = 6

/datum/round_event/grid_check/announce(fake)
	priority_announce("Abnormal activity detected in [station_name()]'s powernet. As a precautionary measure, the station's power will be shut off for an indeterminate duration.", sound_type = ANNOUNCER_POWEROFF)

/datum/round_event/grid_check/start()
	sound_to_playing_players('sound/machines/grid_check.ogg')
	power_fail(30, 120)

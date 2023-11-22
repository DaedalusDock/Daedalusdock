/mob/dead/observer/up()
	set name = "Move Upwards"
	set category = "IC"

	if(zstep(src, UP, ZMOVE_FEEDBACK))
		to_chat(src, "<span class='notice'>You move upwards.</span>")

/mob/dead/observer/can_z_move(direction, turf/start, z_move_flags = NONE, mob/living/rider)
	z_move_flags |= ZMOVE_IGNORE_OBSTACLES  //observers do not respect these FLOORS you speak so much of.
	return ..()


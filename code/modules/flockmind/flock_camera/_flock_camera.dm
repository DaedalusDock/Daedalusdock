/mob/camera/flock
	name = "BROKEN VERY BAD"
	icon = 'goon/icons/mob/featherzone.dmi'
	icon_state = "flockmind"
	base_icon_state = "flockmind"

	layer = FLY_LAYER
	mouse_opacity = MOUSE_OPACITY_ICON
	invisibility = INVISIBILITY_OBSERVER

	appearance_flags = parent_type::appearance_flags | RESET_COLOR
	blend_mode = BLEND_ADD

	see_invisible = SEE_INVISIBLE_LIVING
	see_in_dark = 100
	lighting_alpha = LIGHTING_PLANE_ALPHA_INVISIBLE
	sight = SEE_TURFS | SEE_MOBS | SEE_OBJS | SEE_SELF
	// faction = list(ROLE_BLOB)
	//hud_type = /datum/hud/blob_overmind

	move_on_shuttle = FALSE
	movement_type = PHASING

	var/datum/flock/flock
	var/list/actions_to_grant = list()

	var/mob/living/simple_animal/flock/drone/controlling_bird

/mob/camera/flock/Initialize(mapload, join_flock)
	. = ..()

	#warn temp
	flock = join_flock || GLOB.debug_flock

	for(var/action_path in actions_to_grant)
		var/datum/action/action = new action_path
		action.Grant(src)

	add_client_colour(/datum/client_colour/flockmind)

GLOBAL_DATUM_INIT(debug_flock, /datum/flock, new)

/mob/camera/flock/Login()
	. = ..()
	if(!. || !client)
		return FALSE

	var/turf/T = get_turf(src)
	if (isturf(T))
		update_z(T.z)

/mob/camera/flock/Logout()
	update_z(null)
	return ..()

/mob/camera/flock/proc/update_z(new_z) // 1+ to register, null to unregister
	if (registered_z != new_z)
		if (registered_z)
			SSmobs.flock_cameras_by_zlevel[registered_z] -= src
		if (client)
			if (new_z)
				SSmobs.flock_cameras_by_zlevel[new_z] += src
			registered_z = new_z
		else
			registered_z = null

/mob/camera/flock/proc/get_flock_data()
	var/list/data = list()
	data["name"] = real_name
	data["area"] = get_area_name(src, TRUE) || "???"
	data["ref"] = REF(src)

	if(controlling_bird)
		data["host"] = controlling_bird.real_name
		data["health"] = controlling_bird.getHealthPercent()
	else
		data["host"] = null
		data["health"] = 100

	return data

/mob/camera/flock/proc/so_very_sad_death()
	if(client)
		to_chat(src, span_alert("You cease to exist."))

	ghostize(FALSE)
	flock?.free_unit(src)

	invisibility = INVISIBLITY_VISIBLE
	notransform = TRUE
	icon_state = "blank"
	flick("[base_icon_state]-death", src)
	addtimer(CALLBACK(src, PROC_REF(cleanup)), 2 SECONDS)

/mob/camera/flock/proc/cleanup(datum/source)
	qdel(src)

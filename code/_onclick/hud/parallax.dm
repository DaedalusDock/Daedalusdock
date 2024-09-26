
#define PARALLAX_ICON_SIZE 672

/datum/hud/proc/create_parallax(mob/viewmob)
	var/mob/screenmob = viewmob || mymob
	var/client/C = screenmob.client
	if (!apply_parallax_pref(viewmob)) //don't want shit computers to crash when specing someone with insane parallax, so use the viewer's pref
		return

	if(isnull(C.parallax_master))
		C.parallax_master = new(null, src)

	C.screen |= C.parallax_master

	if(!length(C.parallax_layers_cached))
		C.parallax_layers_cached = list()
		C.parallax_layers_cached += new /atom/movable/screen/parallax_layer/layer_1(null, src)
		C.parallax_layers_cached += new /atom/movable/screen/parallax_layer/stars(null, src)

	C.parallax_layers = C.parallax_layers_cached.Copy()

	if (length(C.parallax_layers) > C.parallax_layers_max)
		C.parallax_layers.len = C.parallax_layers_max

	C.parallax_master.vis_contents = C.parallax_layers

	var/atom/movable/screen/plane_master/PM = screenmob.hud_used.plane_masters["[PLANE_SPACE]"]
	if(screenmob != mymob)
		C.screen -= locate(/atom/movable/screen/plane_master/parallax_white) in C.screen
		C.screen += PM

	PM.color = list(
		0, 0, 0, 0,
		0, 0, 0, 0,
		0, 0, 0, 0,
		1, 1, 1, 1,
		0, 0, 0, 0
		)


/datum/hud/proc/remove_parallax(mob/viewmob)
	var/mob/screenmob = viewmob || mymob
	var/client/C = screenmob.client
	C.screen -= C.parallax_master

	var/atom/movable/screen/plane_master/PM = screenmob.hud_used.plane_masters["[PLANE_SPACE]"]
	if(screenmob != mymob)
		C.screen -= locate(/atom/movable/screen/plane_master/parallax_white) in C.screen
		C.screen += PM

	PM.color = initial(PM.color)
	C.parallax_layers = null

/datum/hud/proc/apply_parallax_pref(mob/viewmob)
	var/mob/screenmob = viewmob || mymob

	if (SSlag_switch.measures[DISABLE_PARALLAX] && !HAS_TRAIT(viewmob, TRAIT_BYPASS_MEASURES))
		return FALSE

	var/client/C = screenmob.client
	// Default to HIGH
	var/parallax_selection = PARALLAX_HIGH
	if(C.prefs)
		parallax_selection = C.prefs.read_preference(/datum/preference/choiced/parallax)
		if (!parallax_selection)
			parallax_selection = PARALLAX_HIGH

	switch(parallax_selection)
		if (PARALLAX_INSANE)
			C.parallax_layers_max = 5
			C.do_parallax_animations = TRUE
			return TRUE

		if(PARALLAX_HIGH)
			C.parallax_layers_max = 4
			C.do_parallax_animations = TRUE
			return TRUE

		if (PARALLAX_MED)
			C.parallax_layers_max = 3
			C.do_parallax_animations = TRUE
			return TRUE

		if (PARALLAX_LOW)
			C.parallax_layers_max = 1
			C.do_parallax_animations = FALSE
			return TRUE

		if (PARALLAX_DISABLE)
			return FALSE

/datum/hud/proc/update_parallax_pref(mob/viewmob)
	remove_parallax(viewmob)
	create_parallax(viewmob)
	update_parallax(viewmob)

// This sets which way the current shuttle is moving (returns true if the shuttle has stopped moving so the caller can append their animation)
/datum/hud/proc/set_parallax_movedir(new_parallax_movedir = 0, skip_windups, mob/viewmob)
	. = FALSE
	var/mob/screenmob = viewmob || mymob
	var/client/C = screenmob.client
	if(new_parallax_movedir == C.parallax_movedir)
		return

	var/animation_dir = new_parallax_movedir || C.parallax_movedir
	var/matrix/new_transform
	switch(animation_dir)
		if(NORTH)
			new_transform = matrix(1, 0, 0, 0, 1, PARALLAX_ICON_SIZE)
		if(SOUTH)
			new_transform = matrix(1, 0, 0, 0, 1,-PARALLAX_ICON_SIZE)
		if(EAST)
			new_transform = matrix(1, 0, PARALLAX_ICON_SIZE, 0, 1, 0)
		if(WEST)
			new_transform = matrix(1, 0,-PARALLAX_ICON_SIZE, 0, 1, 0)

	var/longest_timer = 0
	for(var/key in C.parallax_animate_timers)
		deltimer(C.parallax_animate_timers[key])
	C.parallax_animate_timers = list()

	for(var/atom/movable/screen/parallax_layer/layer as anything in C.parallax_layers)
		var/scaled_time = PARALLAX_LOOP_TIME / layer.speed
		if(new_parallax_movedir == NONE) // If we're stopping, we need to stop on the same dime, yeah?
			scaled_time = PARALLAX_LOOP_TIME
		longest_timer = max(longest_timer, scaled_time)

		if(skip_windups)
			update_parallax_motionblur(C, layer, new_parallax_movedir, new_transform)
			continue

		layer.transform = new_transform
		animate(layer, transform = matrix(), time = scaled_time, easing = QUAD_EASING | (new_parallax_movedir ? EASE_IN : EASE_OUT))
		if (new_parallax_movedir == NONE)
			continue

		//queue up another animate so lag doesn't create a shutter
		animate(transform = new_transform, time = 0)
		animate(transform = matrix(), time = scaled_time / 2)
		C.parallax_animate_timers[layer] = addtimer(CALLBACK(src, PROC_REF(update_parallax_motionblur), C, layer, new_parallax_movedir, new_transform), scaled_time, TIMER_CLIENT_TIME|TIMER_STOPPABLE)

	C.dont_animate_parallax = world.time + min(longest_timer, PARALLAX_LOOP_TIME)
	C.parallax_movedir = new_parallax_movedir

/datum/hud/proc/update_parallax_motionblur(client/C, atom/movable/screen/parallax_layer/layer, new_parallax_movedir, matrix/new_transform)
	if(!C)
		return

	C.parallax_animate_timers -= layer

	// If we are moving in a direction, we used the QUAD_EASING function with EASE_IN
	// This means our position function is x^2. This is always LESS then the linear we're using here
	// But if we just used the same time delay, our rate of change would mismatch. f'(1) = 2x for quad easing, rather then the 1 we get for linear
	// (This is because of how derivatives work right?)
	// Because of this, while our actual rate of change from before was PARALLAX_LOOP_TIME, our perceived rate of change was PARALLAX_LOOP_TIME / 2 (lower == faster).
	// Let's account for that here
	var/scaled_time = (PARALLAX_LOOP_TIME / layer.speed) / 2
	animate(layer, transform = new_transform, time = 0, loop = -1, flags = ANIMATION_END_NOW)
	animate(transform = matrix(), time = scaled_time)

/datum/hud/proc/update_parallax(mob/viewmob)
	var/mob/screenmob = viewmob || mymob
	var/client/C = screenmob.client
	var/turf/posobj = get_turf(C.eye)
	if(!posobj)
		return

	var/area/areaobj = posobj.loc
	// Update the movement direction of the parallax if necessary (for shuttles)
	set_parallax_movedir(areaobj.parallax_movedir, FALSE, screenmob)

	var/force = FALSE
	if(!C.previous_turf || (C.previous_turf.z != posobj.z))
		C.previous_turf = posobj
		force = TRUE

	//Doing it this way prevents parallax layers from "jumping" when you change Z-Levels.
	var/offset_x = posobj.x - C.previous_turf.x
	var/offset_y = posobj.y - C.previous_turf.y

	if(!offset_x && !offset_y && !force)
		return

	var/glide_rate = round(world.icon_size / screenmob.glide_size * world.tick_lag, world.tick_lag)
	C.previous_turf = posobj

	var/largest_change = max(abs(offset_x), abs(offset_y))
	var/max_allowed_dist = (glide_rate / world.tick_lag) + 1
	// If we aren't already moving/don't allow parallax, have made some movement, and that movement was smaller then our "glide" size, animate
	var/run_parralax = (C.do_parallax_animations && glide_rate && !areaobj.parallax_movedir && C.dont_animate_parallax <= world.time && largest_change <= max_allowed_dist)

	for(var/atom/movable/screen/parallax_layer/parallax_layer as anything in C.parallax_layers)
		var/our_speed = parallax_layer.speed
		var/change_x
		var/change_y
		var/old_x = parallax_layer.offset_x
		var/old_y = parallax_layer.offset_y

		if(parallax_layer.absolute)
			// We use change here so the typically large absolute objects don't jitter so much
			change_x = (posobj.x - SSparallax.planet_x_offset) * our_speed + old_x
			change_y = (posobj.y - SSparallax.planet_y_offset) * our_speed + old_y
		else
			change_x = offset_x * our_speed
			change_y = offset_y * our_speed

			// This is how we tile parralax sprites
			// It doesn't use change because we really don't want to animate this
			if(old_x - change_x > PARALLAX_ICON_SIZE/2)
				parallax_layer.offset_x -= PARALLAX_ICON_SIZE
			else if(old_x - change_x < -(PARALLAX_ICON_SIZE/2))
				parallax_layer.offset_x += PARALLAX_ICON_SIZE
			if(old_y - change_y > PARALLAX_ICON_SIZE/2)
				parallax_layer.offset_y -= PARALLAX_ICON_SIZE
			else if(old_y - change_y < -(PARALLAX_ICON_SIZE/2))
				parallax_layer.offset_y += PARALLAX_ICON_SIZE

		parallax_layer.offset_x -= change_x
		parallax_layer.offset_y -= change_y

		// Now that we have our offsets, let's do our positioning
		// We're going to use an animate to "glide" that last movement out, so it looks nicer
		// Don't do any animates if we're not actually moving enough distance yeah? thanks lad
		if(run_parralax && (largest_change * our_speed > 1))
			animate(parallax_layer, pixel_x = round(parallax_layer.offset_x, 1), pixel_y = round(parallax_layer.offset_y, 1), time = glide_rate)
		else
			parallax_layer.pixel_x = round(parallax_layer.offset_x, 1)
			parallax_layer.pixel_y = round(parallax_layer.offset_y, 1)

/atom/movable/proc/update_parallax_contents()
	for(var/mob/client_mob as anything in client_mobs_in_contents)
		if(length(client_mob?.client?.parallax_layers) && client_mob.hud_used)
			client_mob.hud_used.update_parallax()

/mob/proc/update_parallax_teleport() //used for arrivals shuttle
	if(client?.eye && hud_used && length(client.parallax_layers))
		var/area/areaobj = get_area(client.eye)
		hud_used.set_parallax_movedir(areaobj.parallax_movedir, TRUE)

// Root object for parallax, all parallax layers are drawn onto this
INITIALIZE_IMMEDIATE(/atom/movable/screen/parallax_root)
/atom/movable/screen/parallax_root
	icon = null
	blend_mode = BLEND_ADD
	plane = PLANE_SPACE_PARALLAX
	screen_loc = "CENTER-7,CENTER-7"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

// We need parallax to always pass its args down into initialize, so we immediate init it
INITIALIZE_IMMEDIATE(/atom/movable/screen/parallax_layer)
/atom/movable/screen/parallax_layer
	icon = 'icons/effects/parallax/skybox.dmi'
	var/speed = 1
	var/offset_x = 0
	var/offset_y = 0
	var/view_sized
	var/absolute = FALSE
	appearance_flags = APPEARANCE_UI | TILE_BOUND | KEEP_TOGETHER
	blend_mode = BLEND_ADD
	plane = PLANE_SPACE_PARALLAX
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/atom/movable/screen/parallax_layer/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	// Parallax layers are independant of hud, they care about client
	// Not doing this will just create a bunch of hard deletes
	set_new_hud(null)

	var/client/boss = hud_owner?.mymob?.canon_client

	if(!boss) // If this typepath all starts to harddel your culprit is likely this
		return INITIALIZE_HINT_QDEL

	// I do not want to know bestie
	var/view = boss.view || world.view
	update_o(view)
	RegisterSignal(boss, COMSIG_VIEW_SET, PROC_REF(on_view_change))

/atom/movable/screen/parallax_layer/proc/on_view_change(datum/source, new_size)
	SIGNAL_HANDLER
	update_o(new_size)

/atom/movable/screen/parallax_layer/proc/update_o(view)
	if (!view)
		view = world.view

	var/static/parallax_scaler = world.icon_size / PARALLAX_ICON_SIZE

	// Turn the view size into a grid of correctly scaled overlays
	var/list/viewscales = getviewsize(view)
	// This could be half the size but we need to provide space for parallax movement on mob movement, and movement on scroll from shuttles, so like this instead
	var/countx = CEILING((viewscales[1] / 2) * parallax_scaler, 1) + 1
	var/county = CEILING((viewscales[2] / 2) * parallax_scaler, 1) + 1
	var/list/new_overlays = new
	for(var/x in -countx to countx)
		for(var/y in -county to county)
			if(x == 0 && y == 0)
				continue

			var/mutable_appearance/texture_overlay = mutable_appearance(icon, icon_state)
			texture_overlay.transform = matrix(1, 0, x*PARALLAX_ICON_SIZE, 0, 1, y*PARALLAX_ICON_SIZE)
			texture_overlay.pixel_x += PARALLAX_ICON_SIZE * x
			texture_overlay.pixel_y += PARALLAX_ICON_SIZE * y
			new_overlays += texture_overlay

	cut_overlays()
	add_overlay(new_overlays)
	view_sized = view

/atom/movable/screen/parallax_layer/layer_1
	icon_state = "dyable"
	blend_mode = BLEND_OVERLAY
	speed = 0.5
	layer = 1

/atom/movable/screen/parallax_layer/layer_1/Initialize(mapload, mob/owner)
	. = ..()
	src.add_atom_colour(global.starlight_color, ADMIN_COLOUR_PRIORITY)

/atom/movable/screen/parallax_layer/stars
	icon_state = "stars"
	blend_mode = BLEND_OVERLAY
	layer = 1
	speed = 0.5

/*
/atom/movable/screen/parallax_layer/planet
	icon_state = "planet"
	blend_mode = BLEND_OVERLAY
	absolute = TRUE //Status of seperation
	speed = 3
	layer = 30

/atom/movable/screen/parallax_layer/planet/Initialize(mapload, mob/owner)
	. = ..()
	if(!owner?.client)
		return
	var/static/list/connections = list(
		COMSIG_MOVABLE_Z_CHANGED = PROC_REF(on_z_change),
		COMSIG_MOB_LOGOUT = PROC_REF(on_mob_logout),
	)
	AddComponent(/datum/component/connect_mob_behalf, owner.client, connections)
	on_z_change(owner)

/atom/movable/screen/parallax_layer/planet/proc/on_mob_logout(mob/source)
	SIGNAL_HANDLER
	var/client/boss = source.canon_client
	on_z_change(boss.mob)

/atom/movable/screen/parallax_layer/planet/proc/on_z_change(mob/source)
	SIGNAL_HANDLER
	var/client/boss = source.client
	var/turf/posobj = get_turf(boss?.eye)
	if(!posobj)
		return
	invisibility = is_station_level(posobj.z) ? 0 : INVISIBILITY_ABSTRACT

/atom/movable/screen/parallax_layer/planet/update_o()
	return //Shit won't move
*/

#undef PARALLAX_ICON_SIZE

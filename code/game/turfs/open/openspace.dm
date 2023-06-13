/turf/open/openspace
	name = "open space"
	desc = "Watch your step!"
	icon_state = "invisible"
	baseturfs = /turf/open/openspace
	overfloor_placed = FALSE
	underfloor_accessibility = UNDERFLOOR_INTERACTABLE
	#ifndef ZASDBG //Multi-Z zone debugging
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	#endif
	pathing_pass_method = TURF_PATHING_PASS_PROC

	z_flags = Z_ATMOS_IN_DOWN|Z_ATMOS_IN_UP|Z_ATMOS_OUT_DOWN|Z_ATMOS_OUT_UP | Z_MIMIC_BELOW|Z_MIMIC_OVERWRITE|Z_MIMIC_NO_AO

	var/can_cover_up = TRUE
	var/can_build_on = TRUE

/turf/open/openspace/airless
	initial_gas = AIRLESS_ATMOS

/turf/open/openspace/airless/planetary
	simulated = FALSE

/turf/open/openspace/Initialize(mapload) // handle plane and layer here so that they don't cover other obs/turfs in Dream Maker
	. = ..()
	var/area/our_area = loc
	if(istype(our_area, /area/space))
		force_no_gravity = TRUE

/turf/open/openspace/examine(mob/user)
	SHOULD_CALL_PARENT(FALSE)
	return below.examine(user)

/**
 * Prepares a moving movable to be precipitated if Move() is successful.
 * This is done in Enter() and not Entered() because there's no easy way to tell
 * if the latter was called by Move() or forceMove() while the former is only called by Move().
 */
/turf/open/openspace/Enter(atom/movable/movable, atom/oldloc)
	. = ..()
	if(.)
		//higher priority than CURRENTLY_Z_FALLING so the movable doesn't fall on Entered()
		movable.set_currently_z_moving(CURRENTLY_Z_FALLING_FROM_MOVE)

///Makes movables fall when forceMove()'d to this turf.
/turf/open/openspace/Entered(atom/movable/movable)
	. = ..()
	if(movable.set_currently_z_moving(CURRENTLY_Z_FALLING))
		movable.zFall(falling_from_move = TRUE)

/turf/open/openspace/proc/zfall_if_on_turf(atom/movable/movable)
	if(QDELETED(movable) || movable.loc != src)
		return
	movable.zFall()

/turf/open/openspace/can_have_cabling()
	if(locate(/obj/structure/lattice/catwalk, src))
		return TRUE
	return FALSE

/turf/open/openspace/CanZPass(atom/movable/A, direction, z_move_flags)
	if(z == A.z) //moving FROM this turf
		//Check contents
		for(var/obj/O in contents)
			if(direction == UP)
				if(O.obj_flags & BLOCK_Z_OUT_UP)
					return FALSE
			else if(O.obj_flags & BLOCK_Z_OUT_DOWN)
				return FALSE

	else
		for(var/obj/O in contents)
			if(direction == UP)
				if(O.obj_flags & BLOCK_Z_IN_DOWN)
					return FALSE
			else if(O.obj_flags & BLOCK_Z_IN_UP)
				return FALSE

	return TRUE

/turf/open/openspace/proc/CanCoverUp()
	return can_cover_up

/turf/open/openspace/proc/CanBuildHere()
	return can_build_on

/turf/open/openspace/attackby(obj/item/C, mob/user, params)
	..()
	if(!CanBuildHere())
		return
	if(istype(C, /obj/item/stack/rods))
		build_with_rods(C, user)
	else if(istype(C, /obj/item/stack/tile/iron))
		build_with_floor_tiles(C, user)

/turf/open/openspace/build_with_floor_tiles(obj/item/stack/tile/iron/used_tiles)
	if(!CanCoverUp())
		return
	return ..()

/turf/open/openspace/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	if(!CanBuildHere())
		return FALSE

	switch(the_rcd.mode)
		if(RCD_FLOORWALL)
			var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
			if(L)
				return list("mode" = RCD_FLOORWALL, "delay" = 0, "cost" = 1)
			else
				return list("mode" = RCD_FLOORWALL, "delay" = 0, "cost" = 3)
	return FALSE

/turf/open/openspace/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, passed_mode)
	switch(passed_mode)
		if(RCD_FLOORWALL)
			to_chat(user, span_notice("You build a floor."))
			PlaceOnTop(/turf/open/floor/plating, flags = CHANGETURF_INHERIT_AIR)
			return TRUE
	return FALSE

/turf/open/openspace/rust_heretic_act()
	return FALSE

/turf/open/openspace/CanAStarPass(obj/item/card/id/ID, to_dir, atom/movable/caller)
	if(caller && !caller.can_z_move(DOWN, src, ZMOVE_FALL_FLAGS)) //If we can't fall here (flying/lattice), it's fine to path through
		return TRUE
	return FALSE

/turf/open/openspace/icemoon
	name = "ice chasm"
	baseturfs = /turf/open/openspace/icemoon
	initial_gas = ICEMOON_DEFAULT_ATMOS
	simulated = FALSE

	var/replacement_turf = /turf/open/misc/asteroid/snow/icemoon
	/// Replaces itself with replacement_turf if the turf below this one is in a no ruins allowed area (usually ruins themselves)
	var/protect_ruin = TRUE
	/// If true mineral turfs below this openspace turf will be mined automatically
	var/drill_below = TRUE

/turf/open/openspace/icemoon/Initialize(mapload)
	. = ..()
	var/turf/T = GetBelow(src)
	//I wonder if I should error here
	if(!T)
		return
	if(T.turf_flags & NO_RUINS && protect_ruin)
		ChangeTurf(replacement_turf, null, CHANGETURF_IGNORE_AIR)
		return
	if(!ismineralturf(T) || !drill_below)
		return
	var/turf/closed/mineral/M = T
	M.mineralAmt = 0
	M.gets_drilled()
	baseturfs = /turf/open/openspace/icemoon //This is to ensure that IF random turf generation produces a openturf, there won't be other turfs assigned other than openspace.

/turf/open/openspace/icemoon/keep_below
	drill_below = FALSE

/turf/open/openspace/icemoon/ruins
	protect_ruin = FALSE
	drill_below = FALSE

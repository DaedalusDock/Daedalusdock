
GLOBAL_REAL_VAR(mutable_appearance/fullbright_overlay) = create_fullbright_overlay()
GLOBAL_REAL_VAR(mutable_appearance/starlight_overlay) = create_fullbright_overlay(global.starlight_color)

/proc/create_fullbright_overlay(color)
	var/mutable_appearance/lighting_effect = mutable_appearance('icons/effects/alphacolors.dmi', "white")
	lighting_effect.plane = LIGHTING_PLANE
	lighting_effect.layer = LIGHTING_PRIMARY_LAYER
	lighting_effect.blend_mode = BLEND_ADD
	if(color)
		lighting_effect.color = color
	return lighting_effect

/area
	///Whether this area allows static lighting and thus loads the lighting objects
	var/static_lighting = TRUE

//Non static lighting areas.
//Any lighting area that wont support static lights.
//These areas will NOT have corners generated.

///regenerates lighting objects for turfs in this area, primary use is VV changes
/area/proc/create_area_lighting_objects()
	for(var/turf/T in src)
		if(T.always_lit)
			continue
		T.lighting_build_overlay()
		CHECK_TICK

///Removes lighting objects from turfs in this area if we have them, primary use is VV changes
/area/proc/remove_area_lighting_objects()
	for(var/turf/T in src)
		if(T.always_lit)
			continue
		T.lighting_clear_overlay()
		CHECK_TICK

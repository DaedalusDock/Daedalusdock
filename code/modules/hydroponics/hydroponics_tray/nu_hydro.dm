/obj/machinery/hydroponics
	name = "hydroponics tray"
	icon = 'icons/obj/hydroponics/equipment.dmi'
	icon_state = "hydrotray"
	density = TRUE
	pass_flags_self = PASSMACHINE | LETPASSTHROW
	pixel_z = 8
	obj_flags = CAN_BE_HIT | UNIQUE_RENAME
	circuit = /obj/item/circuitboard/machine/hydroponics
	use_power = NO_POWER_USE

	subsystem_type = /datum/controller/subsystem/processing/hydroponics

	var/datum/weakref/lastuser

	///Its health
	var/plant_health
	var/max_plant_health
	var/growth = 0

	var/weedlevel = 0

	///Last time it was harvested
	var/lastproduce = 0

	/// Plant datum that is occupying this tray.
	var/datum/plant/growing
	/// Seed growing in the tray
	var/obj/item/seeds/seed
	/// A container to hold variable deltas to change between ticks.
	var/datum/plant_tick/current_tick

	///Can it be unwrenched to move?
	var/unwrenchable = TRUE
	/// If TRUE, automatically generate water.
	var/self_sustaining = FALSE
	///The icon state for the overlay used to represent that this tray is self-sustaining.
	var/self_sustaining_overlay_icon_state = "gaia_blessing"

	///Have we been visited by a bee recently, so bees dont overpollinate one plant
	var/recent_bee_visit = FALSE
	/// Are we using an irrigation system.
	var/using_irrigation = FALSE

/obj/machinery/hydroponics/Initialize(mapload)
	create_reagents(100)
	. = ..()
	var/static/list/hovering_item_typechecks = list(
		/obj/item/plant_analyzer = list(
			SCREENTIP_CONTEXT_LMB = "Scan tray stats",
			SCREENTIP_CONTEXT_RMB = "Scan tray chemicals"
		),
		/obj/item/cultivator = list(
			SCREENTIP_CONTEXT_LMB = "Remove weeds",
		),
		/obj/item/shovel = list(
			SCREENTIP_CONTEXT_LMB = "Clear tray",
		),
	)

	AddElement(/datum/element/contextual_screentip_item_typechecks, hovering_item_typechecks)
	register_context()

/obj/machinery/hydroponics/Destroy()
	QDEL_NULL(growing)
	QDEL_NULL(seed)
	QDEL_NULL(current_tick)
	return ..()

/obj/machinery/hydroponics/add_context(
	atom/source,
	list/context,
	obj/item/held_item,
	mob/living/user,
)

	// If we don't have a seed, we can't do much.

	// The only option is to plant a new seed.
	if(!seed)
		if(istype(held_item, /obj/item/seeds))
			context[SCREENTIP_CONTEXT_LMB] = "Plant seed"
			return CONTEXTUAL_SCREENTIP_SET
		return NONE

	// If we DO have a seed, we can do a few things!

	// With a hand we can harvest or remove dead plants
	// If the plant's not in either state, we can't do much else, so early return.
	if(isnull(held_item))
		// Silicons can't interact with trays :frown:
		if(issilicon(user))
			return NONE

		switch(growing.plant_status)
			if(HYDROTRAY_PLANT_DEAD)
				context[SCREENTIP_CONTEXT_LMB] = "Remove dead plant"
				return CONTEXTUAL_SCREENTIP_SET

			if(HYDROTRAY_PLANT_HARVESTABLE)
				context[SCREENTIP_CONTEXT_LMB] = "Harvest plant"
				return CONTEXTUAL_SCREENTIP_SET

		return NONE

	// If the plant is harvestable, we can graft it with secateurs or harvest it with a plant bag.
	if(growing.plant_status == HYDROTRAY_PLANT_HARVESTABLE)
		if(istype(held_item, /obj/item/storage/bag/plants))
			context[SCREENTIP_CONTEXT_LMB] = "Harvest plant"
			return CONTEXTUAL_SCREENTIP_SET

	// Edibles and pills can be composted.
	if(IS_EDIBLE(held_item) || istype(held_item, /obj/item/reagent_containers/pill))
		context[SCREENTIP_CONTEXT_LMB] = "Compost"
		return CONTEXTUAL_SCREENTIP_SET

	// Aand if a reagent container has water or plant fertilizer in it, we can use it on the plant.
	if(is_reagent_container(held_item) && length(held_item.reagents.reagent_list))
		var/datum/reagent/most_common_reagent = held_item.reagents.get_master_reagent()
		context[SCREENTIP_CONTEXT_LMB] = "[istype(most_common_reagent, /datum/reagent/water) ? "Water" : "Feed"] plant"
		return CONTEXTUAL_SCREENTIP_SET

	return NONE

/obj/machinery/hydroponics/Exited(atom/movable/gone)
	. = ..()
	if(!QDELETED(src) && gone == seed)
		clear_plant()

/obj/machinery/hydroponics/examine(user)
	. = ..()
	if(seed)
		. += span_info("It has [span_name("[growing.name]")] planted.")
		if (growing.plant_status == PLANT_DEAD)
			. += span_alert("It's dead!")
		else if (growing.plant_status == PLANT_HARVESTABLE)
			. += span_info("It's ready to harvest.")
		else if (plant_health <= (growing.base_health / 2))
			. += span_alert("It looks unhealthy.")
	else
		. += span_info("It's empty.")

	. += span_info("Reagent Level: [reagents.total_volume]/[reagents.maximum_volume].")


/obj/machinery/hydroponics/proc/FindConnected()
	var/list/connected = list()
	var/list/processing_atoms = list(src)

	while(processing_atoms.len)
		var/atom/a = processing_atoms[1]
		for(var/step_dir in GLOB.cardinals)
			var/obj/machinery/hydroponics/h = locate() in get_step(a, step_dir)
			// Soil plots aren't dense
			if(h && h.using_irrigation && h.density && !(h in connected) && !(h in processing_atoms))
				processing_atoms += h

		processing_atoms -= a
		connected += a

	return connected

/obj/machinery/hydroponics/update_appearance(updates)
	. = ..()
	if(self_sustaining)
		set_light(3)
		return

	var/datum/plant_gene/product_trait/glow/G = growing?.gene_holder.has_active_gene_of_type(/datum/plant_gene/product_trait/glow)
	if(G)
		var/potency = growing.get_effective_stat(PLANT_STAT_POTENCY)
		set_light(l_outer_range = G.glow_range(potency), l_power = G.glow_power(potency), l_color = G.glow_color)
		return

	set_light(0)

/obj/machinery/hydroponics/update_overlays()
	. = ..()
	if(growing)
		. += update_plant_overlay()
		. += update_status_light_overlays()

	if(self_sustaining && self_sustaining_overlay_icon_state)
		. += mutable_appearance(icon, self_sustaining_overlay_icon_state)

/obj/machinery/hydroponics/update_name(updates)
	name = seed ? "[initial(name)] ([growing.name])" : initial(name)
	return ..()

/obj/machinery/hydroponics/update_icon_state()
	. = ..()
	update_hoses()

/obj/machinery/hydroponics/proc/update_hoses()
	var/n = 0
	for(var/Dir in GLOB.cardinals)
		var/obj/machinery/hydroponics/t = locate() in get_step(src,Dir)
		if(t && t.using_irrigation && using_irrigation)
			n += Dir

	icon_state = "hoses-[n]"

/obj/machinery/hydroponics/proc/update_plant_overlay()
	var/mutable_appearance/plant_overlay = mutable_appearance(growing.growing_icon, layer = OBJ_LAYER + 0.01)
	switch(growing.plant_status)
		if(PLANT_DEAD)
			plant_overlay.icon_state = growing.icon_dead

		if(PLANT_HARVESTABLE)
			if(!growing.icon_harvest)
				plant_overlay.icon_state = "[growing.icon_grow][growing.growthstages]"
			else
				plant_overlay.icon_state = growing.icon_harvest

		else
			var/t_growthstate = clamp(round((growth / growing.get_effective_stat(PLANT_STAT_MATURATION)) * growing.growthstages), 1, growing.growthstages)
			plant_overlay.icon_state = "[growing.icon_grow][t_growthstate]"

	return plant_overlay

/obj/machinery/hydroponics/proc/update_status_light_overlays()
	. = list()
	if(reagents.total_volume <= 10)
		. += mutable_appearance('icons/obj/hydroponics/equipment.dmi', "over_lowwater3")

	if(growing.plant_status == PLANT_DEAD)
		. += mutable_appearance('icons/obj/hydroponics/equipment.dmi', "over_alert3")

	else if (plant_health <= growing.base_health / 2)
		. += mutable_appearance('icons/obj/hydroponics/equipment.dmi', "over_lowhealth3")

	if(growing.plant_status == PLANT_HARVESTABLE)
		. += mutable_appearance('icons/obj/hydroponics/equipment.dmi', "over_harvest3")

/// Plant a new plant using a given seed.
/obj/machinery/hydroponics/proc/plant_seed(obj/item/seeds/seed, mob/living/user)
	if(src.seed)
		clear_plant()

	if(seed.loc != src)
		seed.forceMove(src)

	src.seed = seed
	growing = seed.plant_datum
	growth = 1

	set_plant_health(growing.base_health + growing.get_effective_stat(PLANT_STAT_ENDURANCE))

	current_tick = new(src)
	update_appearance()
	return TRUE

/obj/machinery/hydroponics/proc/clear_plant(no_del = FALSE)
	if(!seed)
		return

	if(no_del)
		seed = null
	else if(!QDELING(seed))
		QDEL_NULL(seed)

	QDEL_NULL(current_tick)
	growing = null
	seed = null
	plant_health = 0
	growth = 0
	lastproduce = 0
	update_appearance()

/obj/machinery/hydroponics/process(delta_time)
	if(self_sustaining && powered())
		reagents.add_reagent(/datum/reagent/water, 1)

	if(!growing || growing.plant_status == PLANT_DEAD)
		return

	var/datum/plant_gene_holder/plant_dna = growing.gene_holder

	apply_chemicals(lastuser?.resolve())

	if(length(plant_dna.gene_list))
		for(var/datum/plant_gene/gene as anything in plant_dna.gene_list)
			gene.tick(delta_time, src, growing, current_tick)

	// Cycle the tick
	cycle_plant_tick()
	if(!growing || growing.plant_status == PLANT_DEAD)
		return

	// Update plant status
	var/new_growth_status = growing.get_growth_status(growth)
	if(growing.plant_status != new_growth_status)
		growing.plant_status = new_growth_status

	update_appearance()


/obj/machinery/hydroponics/proc/cycle_plant_tick()
	var/datum/plant_gene_holder/plant_dna = growing.gene_holder

	var/tick_multiplier = current_tick.overall_multiplier

	var/final_growth_delta = current_tick.plant_growth_delta
	var/final_health_delta = current_tick.plant_health_delta
	var/final_mutation_power = psbr(current_tick.mutation_power * tick_multiplier)

	var/water_level = get_water_level()

	//Growth and health deltas
	if(water_level)
		if(water_level < HYDRO_WATER_DROWNING_LIMIT)
			final_health_delta += current_tick.water_level_bonus_health
			final_growth_delta += current_tick.water_level_bonus_growth

	else
		adjust_plant_health(psbr(-HYDRO_NO_WATER_DAMAGE * tick_multiplier), damage_type = PLANT_DAMAGE_NO_WATER)

	final_growth_delta = psbr(final_growth_delta * tick_multiplier)
	final_health_delta = psbr(final_health_delta * tick_multiplier)

	// Apply health and growth deltas
	if(final_health_delta)
		adjust_plant_health(final_health_delta)
		if(plant_health == 0)
			return

	growth = max(growth + final_growth_delta, 0)

	// Stat mods
	plant_dna.set_stat(PLANT_STAT_MATURATION, plant_dna.maturation + psbr(current_tick.maturation_mod * tick_multiplier))
	plant_dna.set_stat(PLANT_STAT_PRODUCTION, plant_dna.production + psbr(current_tick.production_mod * tick_multiplier))
	plant_dna.set_stat(PLANT_STAT_YIELD, plant_dna.harvest_yield + psbr(current_tick.yield_mod * tick_multiplier))
	plant_dna.set_stat(PLANT_STAT_HARVEST_AMT, plant_dna.harvest_amt + psbr(current_tick.harvest_amt_mod * tick_multiplier))
	plant_dna.set_stat(PLANT_STAT_ENDURANCE, plant_dna.endurance + psbr(current_tick.endurance_mod * tick_multiplier))
	plant_dna.set_stat(PLANT_STAT_POTENCY, plant_dna.potency + psbr(current_tick.potency_mod * tick_multiplier))

	// Take reagents.
	reagents.remove_all(current_tick.water_need * tick_multiplier)

	if(final_mutation_power >= 1)
		growing.gene_holder.multi_mutate(final_mutation_power, final_mutation_power, final_mutation_power)

	// Swap out the tick datum
	QDEL_NULL(current_tick)
	current_tick = new(src)

/obj/machinery/hydroponics/proc/apply_chemicals(mob/user)
	for(var/datum/reagent/chem as anything in reagents.reagent_list)
		chem.on_hydroponics_apply(current_tick, reagents, chem.volume, src, user)

/obj/machinery/hydroponics/proc/plant_death()
	if(!growing)
		return

	clear_plant()
	update_appearance()

/obj/machinery/hydroponics/proc/get_water_level()
	return reagents.get_reagent_amount(/datum/reagent/water)

/**
 * Adjust Health.
 * Raises the tray's plant_health stat by a given amount, with total health determined by the seed's endurance.
 * * adjustamt - Determines how much the plant_health will be adjusted upwards or downwards.
 */
/obj/machinery/hydroponics/proc/adjust_plant_health(amt, ignore_endurance = FALSE, damage_type)
	if(!growing || amt == 0)
		return

	switch(damage_type)
		if(PLANT_DAMAGE_NO_WATER)
			if(growing.gene_holder.has_active_gene_of_type(/datum/plant_gene/metabolism_fast))
				amt *= 2

			if(growing.gene_holder.has_active_gene_of_type(/datum/plant_gene/metabolism_slow))
				amt /= 2

	if(amt > 0 && !ignore_endurance)
		if(prob(growing.get_effective_stat(PLANT_STAT_ENDURANCE)))
			return

	var/max_health = growing.base_health + growing.get_effective_stat(PLANT_STAT_ENDURANCE)
	set_plant_health(clamp(plant_health + amt, 0, max_health), FALSE)

/obj/machinery/hydroponics/proc/set_plant_health(new_plant_health, update_icon = TRUE, forced = FALSE)
	if(plant_health == new_plant_health || ((!growing || growing.plant_status == PLANT_DEAD) && !forced))
		return

	plant_health = max(new_plant_health, 0)

	if(plant_health == 0)
		plant_death()

	if(update_icon)
		update_appearance()

/obj/machinery/hydroponics/proc/set_weedlevel(new_weed_level)
	#warn impliment set_weed_level
/**
 * Spawn Plant.
 * Upon using strange reagent on a tray, it will spawn a killer tomato or killer tree at random.
 */
/obj/machinery/hydroponics/proc/spawnplant() // why would you put strange reagent in a hydro tray you monster I bet you also feed them blood
	var/list/livingplants = list(/mob/living/simple_animal/hostile/tree, /mob/living/simple_animal/hostile/killertomato)
	var/chosen = pick(livingplants)
	var/mob/living/simple_animal/hostile/C = new chosen
	C.faction = list("plants")

///////////////////////////////////////////////////////////////////////////////
/obj/machinery/hydroponics/constructable
	name = "hydroponics tray"
	icon = 'icons/obj/hydroponics/equipment.dmi'
	icon_state = "hydrotray3"

/obj/machinery/hydroponics/constructable/attackby(obj/item/I, mob/living/user, params)
	if (!user.combat_mode)
		// handle opening the panel
		if(default_deconstruction_screwdriver(user, icon_state, icon_state, I))
			return
	// handle deconstructing the machine, if permissible
		if(I.tool_behaviour == TOOL_CROWBAR && using_irrigation)
			to_chat(user, "<span class='warning'>Disconnect the hoses first!</span>")
			return
		else if(default_deconstruction_crowbar(I))
			return

	return ..()


///////////////////////////////////////////////////////////////////////////////
/obj/machinery/hydroponics/soil //Not actually hydroponics at all! Honk!
	name = "soil"
	desc = "A patch of dirt."
	icon = 'icons/obj/hydroponics/equipment.dmi'
	icon_state = "soil"
	gender = PLURAL
	circuit = null
	density = FALSE
	use_power = NO_POWER_USE
	flags_1 = NODECONSTRUCT_1
	unwrenchable = FALSE
	self_sustaining_overlay_icon_state = null

/obj/machinery/hydroponics/soil/update_icon(updates=ALL)
	. = ..()
	if(self_sustaining)
		add_atom_colour(rgb(255, 175, 0), FIXED_COLOUR_PRIORITY)

/obj/machinery/hydroponics/soil/update_status_light_overlays()
	return // Has no lights

/obj/machinery/hydroponics/soil/attackby_secondary(obj/item/weapon, mob/user, params)
	if(weapon.tool_behaviour != TOOL_SHOVEL) //Spades can still uproot plants on left click
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	balloon_alert(user, "clearing up soil...")
	if(weapon.use_tool(src, user, 1 SECONDS, volume=50))
		balloon_alert(user, "cleared")
		qdel(src)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

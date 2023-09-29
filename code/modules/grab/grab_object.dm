/obj/item/hand_item/grab
	name = "grab"
	item_flags = DROPDEL | ABSTRACT | HAND_ITEM | NOBLUDGEON

	/// The initiator of the grab
	var/mob/living/assailant = null
	/// The thing being grabbed
	var/atom/movable/affecting = null

	/// The grab datum currently being used
	var/datum/grab/current_grab

	/// world.time of the last action
	var/last_action
	/// world.time of the last upgrade
	var/last_upgrade
	/// Indicates if the current grab has special interactions applied to the target organ (eyes and mouth at time of writing)
	var/special_target_functional = TRUE
	/// Used to avoid stacking interactions that sleep during /decl/grab/proc/on_hit_foo() (ie. do_after() is used)
	var/is_currently_resolving_hit = FALSE
	/// Records a specific bodypart that was targetted by this grab.
	var/target_zone
	/// Used by struggle grab datum to keep track of state.
	var/done_struggle = FALSE
/*
	This section is for overrides of existing procs.
*/
/obj/item/hand_item/grab/Initialize(mapload, atom/movable/target, datum/grab/grab_type, defer_hand)
	. = ..()
	current_grab = GLOB.all_grabstates[grab_type]

	assailant = loc
	if(!istype(assailant))
		return INITIALIZE_HINT_QDEL

	affecting = target
	if(!istype(assailant) || !assailant.add_grab(src, defer_hand = defer_hand))
		return INITIALIZE_HINT_QDEL
	target_zone = assailant.zone_selected

	if(!setup())
		return INITIALIZE_HINT_QDEL

	update_appearance(UPDATE_ICON_STATE)

	var/obj/item/bodypart/BP = get_targeted_bodypart()
	if(BP)
		name = "[initial(name)] ([BP.plaintext_zone])"
		RegisterSignal(affecting, COMSIG_CARBON_REMOVED_LIMB, PROC_REF(on_limb_loss))

	RegisterSignal(assailant, COMSIG_PARENT_QDELETING, PROC_REF(target_or_owner_del))
	RegisterSignal(affecting, COMSIG_PARENT_QDELETING, PROC_REF(target_or_owner_del))
	RegisterSignal(affecting, COMSIG_MOVABLE_PRE_THROW, PROC_REF(target_thrown))

	RegisterSignal(assailant, COMSIG_MOB_SELECTED_ZONE_SET, PROC_REF(on_target_change))

/obj/item/hand_item/grab/Destroy()
	current_grab?.let_go(src)
	if(assailant)
		assailant.after_grab_release(affecting)
	assailant = null
	affecting = null
	return ..()

/obj/item/hand_item/grab/examine(mob/user)
	. = ..()
	var/mob/living/L = get_affecting_mob()
	var/obj/item/bodypart/BP = get_targeted_bodypart()
	if(L && BP)
		to_chat(user, "A grab on \the [L]'s [BP.plaintext_zone].")

/obj/item/hand_item/grab/update_icon_state()
	. = ..()
	icon = current_grab.icon
	if(current_grab.icon_state)
		icon_state = current_grab.icon_state

/obj/item/hand_item/grab/attack_self(mob/user)
	if (!assailant)
		return

	if(assailant.combat_mode)
		upgrade()
	else
		downgrade()


/obj/item/hand_item/grab/pre_attack(atom/A, mob/living/user, params)
	// End workaround
	if (QDELETED(src) || !assailant || !current_grab)
		return TRUE
	if(A.attack_grab(assailant, affecting, src, params2list(params)) || current_grab.hit_with_grab(src, A, params2list(params))) //If there is no use_grab override or if it returns FALSE; then will behave according to intent.
		return TRUE
	return ..()

/obj/item/hand_item/grab/Destroy()
	if(affecting)
		LAZYREMOVE(affecting.grabbed_by, src)
		affecting.update_offsets()
	if(affecting && assailant)
		current_grab.let_go(src)
	affecting = null
	assailant = null
	return ..()

/*
	This section is for newly defined useful procs.
*/

/obj/item/hand_item/grab/proc/on_target_change(datum/source, new_sel)
	SIGNAL_HANDLER

	if(src != assailant.get_active_held_item())
		return // Note that because of this condition, there's no guarantee that target_zone = old_sel
	if(target_zone == new_sel)
		return

	var/old_zone = target_zone
	target_zone = new_sel
	var/obj/item/bodypart/BP = get_targeted_bodypart()

	if (!BP)
		to_chat(assailant, span_warning("You fail to grab \the [affecting] there as they do not have that bodypart!"))
		return

	name = "[initial(name)] ([BP.plaintext_zone])"
	to_chat(assailant, span_notice("You are now holding \the [affecting] by \the [BP.plaintext_zone]."))

	if(!isbodypart(get_targeted_bodypart()))
		current_grab.let_go(src)
		return

	current_grab.on_target_change(src, old_zone, target_zone)

/obj/item/hand_item/grab/proc/on_limb_loss(mob/victim, obj/item/bodypart/lost)
	SIGNAL_HANDLER

	if(affecting != victim)
		stack_trace("A grab switched affecting targets without properly re-registering for dismemberment updates.")
		return
	var/obj/item/bodypart/BP = get_targeted_bodypart()
	if(!istype(BP))
		current_grab.let_go(src)
		return // Sanity check in case the lost organ was improperly removed elsewhere in the code.
	if(lost != BP)
		return
	current_grab.let_go(src)

// This will run from Initialize, after can_grab and other checks have succeeded. Must call parent; returning FALSE means failure and qdels the grab.
/obj/item/hand_item/grab/proc/setup()
	if(!current_grab.setup(src))
		return FALSE

	assailant.update_pull_hud_icon()

	LAZYADD(affecting.grabbed_by, src) // This is how we handle affecting being deleted.

	adjust_position()
	action_used()

	assailant.animate_interact(affecting, INTERACT_GRAB)

	var/sound = 'sound/weapons/thudswoosh.ogg'
	if(iscarbon(assailant))
		var/mob/living/carbon/C = assailant
		if(C.dna.species.grab_sound)
			sound = C.dna.species.grab_sound

	if(isliving(affecting))
		var/mob/living/affecting_mob = affecting
		for(var/datum/disease/D as anything in assailant.diseases)
			if(D.spread_flags & DISEASE_SPREAD_CONTACT_SKIN)
				affecting_mob.ContactContractDisease(D)

		for(var/datum/disease/D as anything in affecting_mob.diseases)
			if(D.spread_flags & DISEASE_SPREAD_CONTACT_SKIN)
				assailant.ContactContractDisease(D)

	playsound(affecting.loc, sound, 50, 1, -1)
	update_appearance()
	current_grab.update_stage_effects(src, null)
	return TRUE

// Returns the bodypart of the grabbed person that the grabber is targeting
/obj/item/hand_item/grab/proc/get_targeted_bodypart()
	var/mob/living/L = get_affecting_mob()
	return (L?.get_bodypart(deprecise_zone(target_zone)))

/obj/item/hand_item/grab/proc/resolve_item_attack(mob/living/M, obj/item/I, target_zone)
	if((M && ishuman(M)) && I)
		return current_grab.resolve_item_attack(src, M, I, target_zone)
	else
		return 0

/obj/item/hand_item/grab/proc/action_used()
	last_action = world.time
	leave_forensic_traces()

/obj/item/hand_item/grab/proc/check_action_cooldown()
	return (world.time >= last_action + current_grab.action_cooldown)

/obj/item/hand_item/grab/proc/check_upgrade_cooldown()
	return (world.time >= last_upgrade + current_grab.upgrade_cooldown)

/obj/item/hand_item/grab/proc/leave_forensic_traces()
	if (!affecting)
		return
	var/mob/living/carbon/carbo = get_affecting_mob()
	if(istype(carbo))
		var/obj/item/clothing/C = carbo.get_item_covering_zone(target_zone)
		if(istype(C))
			C.add_fingerprint(assailant)
			return

	affecting.add_fingerprint(assailant) //If no clothing; add fingerprint to mob proper.

/obj/item/hand_item/grab/proc/upgrade(bypass_cooldown = FALSE)
	if(!check_upgrade_cooldown() && !bypass_cooldown)
		to_chat(assailant, span_warning("It's too soon to upgrade."))
		return

	var/datum/grab/upgrab = current_grab.upgrade(src)
	if(upgrab)
		if(is_grab_unique(current_grab))
			current_grab.remove_grab_effects(src)
		var/apply_effects = is_grab_unique(upgrab)

		current_grab = upgrab

		if(apply_effects)
			current_grab.apply_grab_effects(src)

		last_upgrade = world.time
		adjust_position()
		update_appearance()
		leave_forensic_traces()
		current_grab.enter_as_up(src)

/obj/item/hand_item/grab/proc/downgrade()
	var/datum/grab/downgrab = current_grab.downgrade(src)
	if(downgrab)
		if(is_grab_unique(current_grab))
			current_grab.remove_grab_effects(src)
		var/apply_effects = is_grab_unique(downgrab)

		current_grab = downgrab

		if(apply_effects)
			current_grab.apply_grab_effects(src)

		current_grab.enter_as_down(src)
		adjust_position()
		update_appearance()

/// Used to prevent repeated effect application or early effect removal
/obj/item/hand_item/grab/proc/is_grab_unique 	(datum/grab/grab_datum)
	var/count = 0
	for(var/obj/item/hand_item/grab/other as anything in affecting.grabbed_by)
		if(other.current_grab == grab_datum)
			count++

	if(count >= 2)
		return FALSE
	return TRUE

/obj/item/hand_item/grab/proc/draw_affecting_over()
	affecting.plane = assailant.plane
	affecting.layer = assailant.layer + 0.01

/obj/item/hand_item/grab/proc/draw_affecting_under()
	affecting.plane = assailant.plane
	affecting.layer = assailant.layer - 0.01


/obj/item/hand_item/grab/proc/throw_held()
	return current_grab.throw_held(src)

/obj/item/hand_item/grab/proc/handle_resist()
	current_grab.handle_resist(src)

/obj/item/hand_item/grab/proc/has_hold_on_bodypart(obj/item/bodypart/BP)
	if (!BP)
		return FALSE

	if (get_targeted_bodypart() == BP)
		return TRUE

	return FALSE

/obj/item/hand_item/grab/proc/get_affecting_mob()
	RETURN_TYPE(/mob/living)
	if(isobj(affecting))
		return affecting.buckled_mobs?[1]

	if(isliving(affecting))
		return affecting

/// Primarily used for do_after() callbacks, checks if the grab item is still holding onto something
/obj/item/hand_item/grab/proc/is_grabbing(atom/movable/AM)
	return affecting == AM
/*
 * This section is for component signal relays/hooks
*/

/// Target deleted, ABORT
/obj/item/hand_item/grab/proc/target_or_owner_del(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/// If something tries to throw the target.
/obj/item/hand_item/grab/proc/target_thrown(atom/movable/source, list/arguments)
	SIGNAL_HANDLER

	if(!current_grab.stop_move)
		return
	if(arguments[4] == assailant && current_grab.can_throw)
		return

	return COMPONENT_CANCEL_THROW

/obj/item/hand_item/grab/attackby(obj/W, mob/user)
	if(user == assailant)
		current_grab.item_attack(src, W)

/obj/item/hand_item/grab/proc/resolve_openhand_attack()
	return current_grab.resolve_openhand_attack(src)

/obj/item/hand_item/grab/proc/adjust_position()
	if(QDELETED(assailant) || QDELETED(affecting) || !assailant.Adjacent(affecting))
		qdel(src)
		return FALSE

	if(assailant)
		assailant.setDir(get_dir(assailant, affecting))

	if(current_grab.same_tile)
		affecting.move_from_pull(assailant, get_turf(assailant))
		affecting.setDir(assailant.dir)

	affecting.update_offsets()
	affecting.reset_plane_and_layer()

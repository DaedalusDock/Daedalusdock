GLOBAL_DATUM_INIT(fire_overlay, /mutable_appearance, mutable_appearance('icons/effects/fire.dmi', "fire"))
GLOBAL_DATUM_INIT(welding_sparks, /mutable_appearance, mutable_appearance('icons/effects/welding_effect.dmi', "welding_sparks", GASFIRE_LAYER, ABOVE_LIGHTING_PLANE))

DEFINE_INTERACTABLE(/obj/item)
/// Anything you can pick up and hold.
/obj/item
	name = "item"
	icon = 'icons/obj/items_and_weapons.dmi'
	blocks_emissive = EMISSIVE_BLOCK_GENERIC
	pass_flags_self = PASSITEM

	/// This item can be dropped into other things
	mouse_drop_pointer = MOUSE_ACTIVE_POINTER
	///the icon to indicate this object is being dragged
	mouse_drag_pointer = MOUSE_ACTIVE_POINTER

	max_integrity = 200
	obj_flags = NONE
	pass_flags = PASSTABLE

	///How large is the object, used for stuff like whether it can fit in backpacks or not
	w_class = WEIGHT_CLASS_SMALL

	///Items can by default thrown up to 10 tiles by TK users
	tk_throw_range = 10

	/// The mob this item is being worn or held by.
	var/tmp/mob/living/equipped_to

	/// This var exists as a weird proxy "owner" ref
	/// It's used in a few places. Stop using it, and optimially replace all uses please
	var/tmp/obj/item/master = null

	///list of /datum/action's that this item has.
	var/tmp/list/actions
	///list of paths of action datums to give to the item on New().
	var/list/actions_types

	///A weakref to the mob who threw the item
	var/tmp/datum/weakref/thrownby = null

	///Reference to the datum that determines whether dogs can wear the item: Needs to be in /obj/item because corgis can wear a lot of non-clothing items
	var/tmp/datum/dog_fashion/dog_fashion = null

	/* !!!!!!!!!!!!!!! IMPORTANT !!!!!!!!!!!!!!
		IF YOU ADD MORE ICON CRAP TO THIS
		ENSURE YOU ALSO ADD THE NEW VARS TO CHAMELEON ITEM_ACTION'S update_item() PROC (/datum/action/item_action/chameleon/change/proc/update_item())
		WASHING MASHINE'S dye_item() PROC (/obj/item/proc/dye_item())
		AND ALSO TO THE CHANGELING PROFILE DISGUISE SYSTEMS (/datum/changeling_profile / /datum/antagonist/changeling/proc/create_profile() / /proc/changeling_transform())
		!!!!!!!!!!!!!!! IMPORTANT !!!!!!!!!!!!!! */

	///icon state for inhand overlays, if null the normal icon_state will be used.
	var/inhand_icon_state = null
	///Icon file for left hand inhand overlays
	var/lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	///Icon file for right inhand overlays
	var/righthand_file = 'icons/mob/inhands/items_righthand.dmi'

	///Icon file for mob worn overlays.
	var/icon/worn_icon
	///Icon state for mob worn overlays, if null the normal icon_state will be used.
	var/worn_icon_state
	///Icon state for the belt overlay, if null the normal icon_state will be used.
	var/belt_icon_state
	///Forced mob worn layer instead of the standard preferred size.
	var/alternate_worn_layer
	///The config type to use for greyscaled worn sprites. Both this and greyscale_colors must be assigned to work.
	var/greyscale_config_worn
	///The config type to use for greyscaled left inhand sprites. Both this and greyscale_colors must be assigned to work.
	var/greyscale_config_inhand_left
	///The config type to use for greyscaled right inhand sprites. Both this and greyscale_colors must be assigned to work.
	var/greyscale_config_inhand_right
	///The config type to use for greyscaled belt overlays. Both this and greyscale_colors must be assigned to work.
	var/greyscale_config_belt

	/// A url-encoded string that is the center pixel of an icon (or close enough). Use get_icon_center().
	var/icon_center = "x=16&y=16"

	/* !!!!!!!!!!!!!!! IMPORTANT !!!!!!!!!!!!!!
		IF YOU ADD MORE ICON CRAP TO THIS
		ENSURE YOU ALSO ADD THE NEW VARS TO CHAMELEON ITEM_ACTION'S update_item() PROC (/datum/action/item_action/chameleon/change/proc/update_item())
		WASHING MASHINE'S dye_item() PROC (/obj/item/proc/dye_item())
		AND ALSO TO THE CHANGELING PROFILE DISGUISE SYSTEMS (/datum/changeling_profile / /datum/antagonist/changeling/proc/create_profile() / /proc/changeling_transform())
		!!!!!!!!!!!!!!! IMPORTANT !!!!!!!!!!!!!! */

	///Dimensions of the icon file used when this item is worn, eg: hats.dmi (32x32 sprite, 64x64 sprite, etc.). Allows inhands/worn sprites to be of any size, but still centered on a mob properly
	var/worn_x_dimension = 32
	///Dimensions of the icon file used when this item is worn, eg: hats.dmi (32x32 sprite, 64x64 sprite, etc.). Allows inhands/worn sprites to be of any size, but still centered on a mob properly
	var/worn_y_dimension = 32
	///Same as for [worn_x_dimension][/obj/item/var/worn_x_dimension] but for inhands, uses the lefthand_ and righthand_ file vars
	var/inhand_x_dimension = 32
	///Same as for [worn_y_dimension][/obj/item/var/worn_y_dimension] but for inhands, uses the lefthand_ and righthand_ file vars
	var/inhand_y_dimension = 32
	/// Worn overlay will be shifted by this along y axis
	var/worn_y_offset = 0

	///Item flags for the item
	var/item_flags = NONE

	///Sound played when you hit something with the item
	var/hitsound
	var/wielded_hitsound

	///Played when the item is used, for example tools
	var/usesound
	///Used when yate into a mob
	var/mob_throw_hit_sound
	///Sound used when equipping the item into a valid slot
	var/equip_sound
	///Sound used when picking the item up (into your hands)
	var/pickup_sound = 'sound/items/handling/generic_pickup.ogg'
	///Sound used when dropping the item, or when its thrown.
	var/drop_sound = 'sound/items/handling/book_drop.ogg'
	///Sound used when successfully blocking an attack. Can be a list!
	var/block_sound
	///Sound used when used as a weapon, but the attacked missed. Can be a list!
	var/miss_sound

	///Whether or not we use stealthy audio levels for this item's attack sounds
	var/stealthy_audio = FALSE

	///This is used to determine on which slots an item can fit.
	var/slot_flags = 0

	///Price of an item in a vending machine, overriding the base vending machine price. Define in terms of paycheck defines as opposed to raw numbers.
	var/custom_price
	///Price of an item in a vending machine, overriding the premium vending machine price. Define in terms of paycheck defines as opposed to raw numbers.
	var/custom_premium_price
	///Whether spessmen with an ID with an age below AGE_MINOR (20 by default) can buy this item
	var/age_restricted = FALSE

	///flags which determine which body parts are protected from heat. [See here][HEAD]
	var/heat_protection = 0
	///flags which determine which body parts are protected from cold. [See here][HEAD]
	var/cold_protection = 0
	///Set this variable to determine up to which temperature (IN KELVIN) the item protects against heat damage. Keep at null to disable protection. Only protects areas set by heat_protection flags
	var/max_heat_protection_temperature
	///Set this variable to determine down to which temperature (IN KELVIN) the item protects against cold damage. 0 is NOT an acceptable number due to if(varname) tests!! Keep at null to disable protection. Only protects areas set by cold_protection flags
	var/min_cold_protection_temperature

	//Since any item can now be a piece of clothing, this has to be put here so all items share it.
	///This flag is used to determine when items in someone's inventory cover others. IE helmets making it so you can't see glasses, etc.
	var/flags_inv
	///you can see someone's mask through their transparent visor, but you can't reach it
	var/transparent_protection = NONE

	///flags for what should be done when you click on the item, default is picking it up
	var/interaction_flags_item = INTERACT_ITEM_ATTACK_HAND_PICKUP

	///What body parts are covered by the clothing when you wear it
	var/body_parts_covered = 0
	/// How likely a disease or chemical is to get through a piece of clothing
	var/permeability_coefficient = 1
	/// for electrical admittance/conductance (electrocution checks and shit)
	var/siemens_coefficient = 1
	/// How much clothing is slowing you down. Negative values speeds you up
	var/slowdown = 0
	///percentage of armour effectiveness to remove
	var/armor_penetration = 0
	/// A multiplier applied to the target's armor. "2" means that their armor is twice as effective against this item.
	var/weak_against_armor = null
	///What objects the suit storage can store
	var/list/allowed = null
	/// Flags for equipping/unequipping items, only applies to self manipulation.
	var/equip_self_flags = EQUIP_ALLOW_MOVEMENT | EQUIP_SLOWDOWN
	///In deciseconds, how long an item takes to equip; counts only for normal clothing slots, not pockets etc.
	var/equip_delay_self = 0
	///In deciseconds, how long an item takes to put on another person
	var/equip_delay_other = 20
	///In deciseconds, how long an item takes to remove from another person
	var/strip_delay = 40
	///How long it takes to resist out of the item (cuffs and such)
	var/breakouttime = 0

	///Used in [atom/proc/attackby] to say how something was attacked `"[x] has been [z.attack_verb] by [y] with [z]"`
	var/list/attack_verb_continuous
	var/list/attack_verb_simple
	///list() of species types, if a species cannot put items in a certain slot, but species type is in list, it will be able to wear that item
	var/list/species_exception = null
	///This is a bitfield that defines what variations exist for bodyparts like Digi legs. See: code\_DEFINES\inventory.dm
	var/supports_variations_flags = NONE
	///A blacklist of bodytypes that aren't allowed to equip this item
	var/restricted_bodytypes = NONE

	///Does it embed and if yes, what kind of embed
	var/list/embedding

	///for flags such as [GLASSESCOVERSEYES]
	var/flags_cover = 0
	var/heat = 0
	///All items with sharpness of SHARP_EDGED or higher will automatically get the butchering component.
	var/sharpness = NONE

	///How a tool acts when you use it on something, such as wirecutfters cutting wires while multitools measure power
	var/tool_behaviour = NONE
	///How fast does the tool work
	var/toolspeed = 1

	///In tiles, how far this weapon can reach; 1 for adjacent, which is default
	var/reach = 1

	///The list of slots by priority. equip_to_appropriate_slot() uses this list. Doesn't matter if a mob type doesn't have a slot. For default list, see [/mob/proc/equip_to_appropriate_slot]
	var/list/slot_equipment_priority = null

	//Tooltip vars
	///string form of an item's force. Edit this var only to set a custom force string
	var/force_string
	var/tmp/last_force_string_check = 0
	var/tmp/tip_timer

	///Determines who can shoot this
	var/trigger_guard = TRIGGER_GUARD_NONE

	///Used as the dye color source in the washing machine only (at the moment). Can be a hex color or a key corresponding to a registry entry, see washing_machine.dm
	var/dye_color
	///Whether the item is unaffected by standard dying.
	var/undyeable = FALSE
	///What dye registry should be looked at when dying this item; see washing_machine.dm
	var/dying_key

	///Grinder var:A reagent list containing the reagents this item produces when ground up in a grinder - this can be an empty list to allow for reagent transferring only
	var/list/grind_results
	//Grinder var:A reagent list containing blah blah... but when JUICED in a grinder!
	var/list/juice_results

	var/canMouseDown = FALSE

	/// Used in obj/item/examine to give additional notes on what the weapon does, separate from the predetermined output variables
	var/offensive_notes
	/// Used in obj/item/examine to determines whether or not to detail an item's statistics even if it does not meet the force requirements
	var/override_notes = FALSE

	/*___________*/
	/*Goon Combat*/
	/*‾‾‾‾‾‾‾‾‾‾‾*/
	var/stamina_cost = STAMINA_SWING_COST_ITEM
	var/stamina_damage = STAMINA_DAMAGE_ITEM
	var/stamina_critical_chance = STAMINA_CRITICAL_RATE_ITEM
	var/stamina_critical_modifier = STAMINA_CRITICAL_MODIFIER

	var/combat_click_delay = CLICK_CD_MELEE

	/// The baseline chance to block **ANY** attack, projectiles included
	var/block_chance = 0
	/// The angle infront of the defender that is a valid block range.
	var/block_angle = 45 // Infront and infront + sides, but not direct sides

	/// The type of effect to create on a successful block
	var/obj/effect/temp_visual/block_effect = /obj/effect/temp_visual/block

	/*________*/
	/*Wielding*/
	/*‾‾‾‾‾‾‾‾*/
	/// Is the item being held in two hands?
	var/tmp/wielded = FALSE

	/// The force of the item when wielded. If null, will be force * 1.5.
	var/force_wielded = null
	/// A var to hold the old, unwielded force value.
	VAR_PRIVATE/tmp/force_unwielded = null
	/// The icon_state to use when wielded, if any.
	var/icon_state_wielded = null
	/// The sound to play on wield.
	var/wield_sound = null
	/// The wound to play on unwield.
	var/unwield_sound = null

/obj/item/Initialize(mapload)

	if(attack_verb_continuous)
		attack_verb_continuous = string_list(attack_verb_continuous)
	if(attack_verb_simple)
		attack_verb_simple = string_list(attack_verb_simple)
	if(species_exception)
		species_exception = string_list(species_exception)

	. = ..()

	// Handle adding item associated actions
	for(var/path in actions_types)
		add_item_action(path)

	actions_types = null

	if(force_string)
		item_flags |= FORCE_STRING_OVERRIDE

	if(!hitsound)
		if(damtype == BURN)
			hitsound = 'sound/items/welder.ogg'
		if(damtype == BRUTE)
			hitsound = SFX_SWING_HIT

	if(sharpness && force > 5) //give sharp objects butchering functionality, for consistency
		AddComponent(/datum/component/butchering, 80 * toolspeed)

	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_NEW_ITEM, src)

	if(LAZYLEN(embedding))
		updateEmbedding()

	if(mapload && !GLOB.steal_item_handler.generated_items)
		add_stealing_item_objective()

/obj/item/Destroy(force)
	// This var exists as a weird proxy "owner" ref
	// It's used in a few places. Stop using it, and optimially replace all uses please
	master = null

	if(equipped_to)
		equipped_to.temporarilyRemoveItemFromInventory(src, TRUE)

	// Handle cleaning up our actions list
	for(var/datum/action/action as anything in actions)
		remove_item_action(action)

	return ..()

/obj/item/Topic(href, list/href_list)
	. = ..()
	if(.)
		return
	if(href_list["look_at_id"])
		var/obj/item/card/id/id = GetID()
		if(isdead(usr))
			id.show(usr)
		else if(usr.canUseTopic(src, USE_CLOSE|USE_DEXTERITY|USE_IGNORE_TK|USE_RESTING))
			id.show(usr)
		return TRUE

	if(href_list["examine"])
		var/atom_to_view_check = src
		if(equipped_to)
			atom_to_view_check = equipped_to

		if(!atom_to_view_check && isidcard(src) && istype(loc, /obj/item/storage/wallet))
			var/obj/item/storage/wallet/W = loc
			if(W.is_open)
				atom_to_view_check = W
				if(ismob(W.loc))
					atom_to_view_check = W.loc

		var/list/user_view = view(usr)
		if(!(atom_to_view_check in user_view))
			to_chat(usr, span_warning("I can no longer see that item."))
			return TRUE

		usr.run_examinate(src, TRUE)
		return TRUE

/obj/item/update_icon_state()
	if(wielded && icon_state_wielded)
		icon_state = icon_state_wielded
	return ..()

/obj/item/add_blood_DNA(list/dna)
	. = ..()
	update_slot_icon()

/obj/item/examine_properties(mob/user)
	. = ..()

	switch(w_class)
		if(WEIGHT_CLASS_TINY)
			. += PROPERTY_TINY
		if(WEIGHT_CLASS_SMALL)
			. += PROPERTY_SMALL
		if(WEIGHT_CLASS_BULKY)
			. += PROPERTY_BULKY
		if(WEIGHT_CLASS_HUGE)
			. += PROPERTY_HUGE
		if(WEIGHT_CLASS_GIGANTIC)
			. += PROPERTY_GIGANTIC

	if(slot_flags)
		. += PROPERTY_WEARABLE

/obj/item/get_mechanics_info()
	. = ..()
	var/pronoun = gender == PLURAL ? "They" : "It"
	var/pronoun_is = gender == PLURAL ? "They are" : "It is"

	. += "- [pronoun_is] a [weight_class_to_text(w_class)] object."

	if(atom_storage)
		. += "- [pronoun] can store items."
		if(!length(atom_storage.can_hold))
			. += "- [pronoun] can store [atom_storage.max_slots] item\s that are [weight_class_to_text(atom_storage.max_specific_storage)] or smaller."

	var/static/list/string_part_flags = list(
		"head" = HEAD,
		"torso" = CHEST,
		"legs" = LEGS,
		"feet" = FEET,
		"arms" = ARMS,
		"hands" = HANDS
	)

	// Strings which corraspond to slot flags, useful for outputting what slot something is.
	var/static/list/string_slot_flags = list(
		"back" = ITEM_SLOT_BACK,
		"face" = ITEM_SLOT_MASK,
		"waist" = ITEM_SLOT_BELT,
		"ID slot" = ITEM_SLOT_ID,
		"ears" = ITEM_SLOT_EARS,
		"eyes" = ITEM_SLOT_EYES,
		"hands" = ITEM_SLOT_GLOVES,
		"head" = ITEM_SLOT_HEAD,
		"feet" = ITEM_SLOT_FEET,
		"over body" = ITEM_SLOT_OCLOTHING,
		"body" = ITEM_SLOT_ICLOTHING,
		"neck" = ITEM_SLOT_NECK,
	)

	var/list/covers = list()
	var/list/slots = list()
	for(var/name in string_part_flags)
		if(body_parts_covered & string_part_flags[name])
			covers += name

	for(var/name in string_slot_flags)
		if(slot_flags & string_slot_flags[name])
			slots += name

	if(length(covers))
		. += "- [pronoun] cover[p_s()] the [english_list(covers)]."

	if(length(slots))
		. += "- [pronoun] can be worn on your [english_list(slots)]."

	if(siemens_coefficient == 0)
		. += "- [gender == PLURAL ? "They do not" : "It does not"] conduct electricity."

/// Called when an action associated with our item is deleted
/obj/item/proc/on_action_deleted(datum/source)
	SIGNAL_HANDLER

	if(!(source in actions))
		CRASH("An action ([source.type]) was deleted that was associated with an item ([src]), but was not found in the item's actions list.")

	LAZYREMOVE(actions, source)

/// Adds an item action to our list of item actions.
/// Item actions are actions linked to our item, that are granted to mobs who equip us.
/// This also ensures that the actions are properly tracked in the actions list and removed if they're deleted.
/// Can be be passed a typepath of an action or an instance of an action.
/obj/item/proc/add_item_action(action_or_action_type)

	var/datum/action/action
	if(ispath(action_or_action_type, /datum/action))
		action = new action_or_action_type(src)
	else if(istype(action_or_action_type, /datum/action))
		action = action_or_action_type
	else
		CRASH("item add_item_action got a type or instance of something that wasn't an action.")

	LAZYADD(actions, action)
	RegisterSignal(action, COMSIG_PARENT_QDELETING, PROC_REF(on_action_deleted))
	if(equipped_to)
		// We're being held or are equipped by someone while adding an action?
		// Then they should also probably be granted the action, given it's in a correct slot
		give_item_action(action, equipped_to, equipped_to.get_slot_by_item(src))

	return action

/// Removes an instance of an action from our list of item actions.
/obj/item/proc/remove_item_action(datum/action/action)
	if(!action)
		return

	UnregisterSignal(action, COMSIG_PARENT_QDELETING)
	LAZYREMOVE(actions, action)
	qdel(action)

/// Called if this item is supposed to be a steal objective item objective. Only done at mapload
/obj/item/proc/add_stealing_item_objective()
	return

/obj/item/proc/check_allowed_items(atom/target, not_inside, target_self)
	if(((src in target) && !target_self) || (!isturf(target.loc) && !isturf(target) && not_inside))
		return 0
	else
		return 1

/obj/item/blob_act(obj/structure/blob/B)
	if(B && B.loc == loc)
		atom_destruction(BLUNT)


/**Makes cool stuff happen when you suicide with an item
 *
 *Outputs a creative message and then return the damagetype done
 * Arguments:
 * * user: The mob that is suiciding
 */
/obj/item/proc/suicide_act(mob/user)
	return

/obj/item/set_greyscale(list/colors, new_config, queue, new_worn_config, new_inhand_left, new_inhand_right)
	if(new_worn_config)
		greyscale_config_worn = new_worn_config
	if(new_inhand_left)
		greyscale_config_inhand_left = new_inhand_left
	if(new_inhand_right)
		greyscale_config_inhand_right = new_inhand_right
	return ..()

/// Checks if this atom uses the GAGS system and if so updates the worn and inhand icons
/obj/item/update_greyscale()
	. = ..()
	if(!greyscale_colors)
		return
	if(greyscale_config_worn)
		worn_icon = SSgreyscale.GetColoredIconByType(greyscale_config_worn, greyscale_colors)
	if(greyscale_config_worn_digitigrade)
		worn_icon_digitigrade = SSgreyscale.GetColoredIconByType(greyscale_config_worn_digitigrade, greyscale_colors)
	if(greyscale_config_worn_vox)
		worn_icon_vox = SSgreyscale.GetColoredIconByType(greyscale_config_worn_vox, greyscale_colors)
	if(greyscale_config_inhand_left)
		lefthand_file = SSgreyscale.GetColoredIconByType(greyscale_config_inhand_left, greyscale_colors)
	if(greyscale_config_inhand_right)
		righthand_file = SSgreyscale.GetColoredIconByType(greyscale_config_inhand_right, greyscale_colors)

/obj/item/verb/move_to_top()
	set name = "Move To Top"
	set category = "Object"
	set src in oview(1)

	if(!isturf(loc) || usr.stat != CONSCIOUS || HAS_TRAIT(usr, TRAIT_HANDS_BLOCKED))
		return

	if(isliving(usr))
		var/mob/living/L = usr
		if(!(L.mobility_flags & MOBILITY_PICKUP))
			return

	var/turf/T = loc
	abstract_move(null)
	forceMove(T)

/obj/item/interact(mob/user)
	add_fingerprint(user)
	ui_interact(user)

/obj/item/ui_act(action, list/params)
	add_fingerprint(usr)
	return ..()

/obj/item/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION(VV_HK_ADD_FANTASY_AFFIX, "Add Fantasy Affix")

/obj/item/vv_do_topic(list/href_list)
	. = ..()

	if(!.)
		return

	if(href_list[VV_HK_ADD_FANTASY_AFFIX] && check_rights(R_FUN))

		//gathering all affixes that make sense for this item
		var/list/prefixes = list()
		var/list/suffixes = list()
		for(var/datum/fantasy_affix/affix_choice as anything in subtypesof(/datum/fantasy_affix))
			affix_choice = new affix_choice()
			if(!affix_choice.validate(src))
				qdel(affix_choice)
			else
				if(affix_choice.placement & AFFIX_PREFIX)
					prefixes[affix_choice.name] = affix_choice
				else
					suffixes[affix_choice.name] = affix_choice

		//making it more presentable here
		var/list/affixes = list("---PREFIXES---")
		affixes.Add(prefixes)
		affixes.Add("---SUFFIXES---")
		affixes.Add(suffixes)

		//admin picks, cleanup the ones we didn't do and handle chosen
		var/picked_affix_name = tgui_input_list(usr, "Affix to add to [src]", "Enchant [src]", affixes)
		if(isnull(picked_affix_name))
			return
		if(!affixes[picked_affix_name] || QDELETED(src))
			return
		var/datum/fantasy_affix/affix = affixes[picked_affix_name]
		affixes.Remove(affix)
		QDEL_LIST_ASSOC(affixes) //remove the rest, we didn't use them
		var/fantasy_quality = 0
		if(affix.alignment & AFFIX_GOOD)
			fantasy_quality++
		else
			fantasy_quality--

		//name gets changed by the component so i want to store it for feedback later
		var/before_name = name
		//naming these vars that i'm putting into the fantasy component to make it more readable
		var/canFail = FALSE
		var/announce = FALSE
		//Apply fantasy with affix. failing this should never happen, but if it does it should not be silent.
		if(AddComponent(/datum/component/fantasy, fantasy_quality, list(affix), canFail, announce) == COMPONENT_INCOMPATIBLE)
			to_chat(usr, span_warning("Fantasy component not compatible with [src]."))
			CRASH("fantasy component incompatible with object of type: [type]")

		to_chat(usr, span_notice("[before_name] now has [picked_affix_name]!"))
		log_admin("[key_name(usr)] has added [picked_affix_name] fantasy affix to [before_name]")
		message_admins(span_notice("[key_name(usr)] has added [picked_affix_name] fantasy affix to [before_name]"))

/obj/item/vv_edit_var(vname, vval)
	. = ..()
	if(vname == NAMEOF(src, flags_inv) && iscarbon(loc))
		var/mob/living/carbon/C = loc
		var/slot = C.get_slot_by_item(src)
		if(slot)
			C.update_slots_for_item(src, slot, TRUE)

/obj/item/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(!user)
		return
	if(anchored)
		return

	. = TRUE

	if(resistance_flags & ON_FIRE)
		var/mob/living/carbon/C = user
		var/can_handle_hot = FALSE
		if(!istype(C))
			can_handle_hot = TRUE
		else if(C.gloves && (C.gloves.max_heat_protection_temperature > 360))
			can_handle_hot = TRUE
		else if(HAS_TRAIT(C, TRAIT_RESISTHEAT) || HAS_TRAIT(C, TRAIT_RESISTHEATHANDS))
			can_handle_hot = TRUE

		if(can_handle_hot)
			extinguish()
			to_chat(user, span_notice("You put out the fire on [src]."))
		else
			to_chat(user, span_warning("You burn your hand on [src]!"))
			var/obj/item/bodypart/affecting = C.get_bodypart("[(user.active_hand_index % 2 == 0) ? "r" : "l" ]_arm")
			affecting?.receive_damage( 0, 5 ) // 5 burn damage
			return

	if(!(interaction_flags_item & INTERACT_ITEM_ATTACK_HAND_PICKUP))
		return

	//Heavy gravity makes picking up things very slow.
	var/grav = user.has_gravity()
	if(grav > STANDARD_GRAVITY)
		var/grav_power = min(3, grav - STANDARD_GRAVITY)
		to_chat(user, span_notice("You start picking up [src]..."))
		if(!do_after(user, src, 30*grav_power))
			return

	// Return FALSE if the item is picked up.
	return !user.pickup_item(src)

/obj/item/proc/allow_attack_hand_drop(mob/user)
	return TRUE

/obj/item/attack_paw(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(!user)
		return
	if(anchored)
		return

	. = TRUE

	if(!(interaction_flags_item & INTERACT_ITEM_ATTACK_HAND_PICKUP)) //See if we're supposed to auto pickup.
		return

	//If the item is in a storage item, take it out
	loc.atom_storage?.attempt_remove(src, user.loc, silent = TRUE, user = src)
	if(QDELETED(src)) //moving it out of the storage to the floor destroyed it.
		return

	if(throwing)
		throwing.finalize(FALSE)
	if(loc == user)
		if(!allow_attack_hand_drop(user) || !user.temporarilyRemoveItemFromInventory(src))
			return

	. = FALSE
	pickup(user)
	add_fingerprint(user)
	if(!user.put_in_active_hand(src, FALSE, FALSE))
		user.dropItemToGround(src)
		return TRUE

/obj/item/attack_alien(mob/user, list/modifiers)
	var/mob/living/carbon/alien/ayy = user

	if(!user.can_hold_items(src))
		if(src in ayy.contents) // To stop Aliens having items stuck in their pockets
			ayy.dropItemToGround(src)
		to_chat(user, span_warning("Your claws aren't capable of such fine manipulation!"))
		return
	attack_paw(ayy, modifiers)

/obj/item/attack_ai(mob/user)
	if(istype(src.loc, /obj/item/robot_model))
		//If the item is part of a cyborg module, equip it
		if(!iscyborg(user))
			return
		var/mob/living/silicon/robot/R = user
		if(!R.low_power_mode) //can't equip modules with an empty cell.
			R.activate_module(src)
			R.hud_used.update_robot_modules_display()

/obj/item/attackby(obj/item/item, mob/living/user, params)
	if(user?.try_slapcraft(src, item))
		return TRUE
	return ..()

/obj/item/proc/GetDeconstructableContents()
	return get_all_contents() - src

/// A helper for calling can_block_attack() and hit_reaction() together.
/obj/item/proc/try_block_attack(mob/living/carbon/human/wielder, atom/movable/hitby, attack_text = "the attack", damage = 0, attack_type = MELEE_ATTACK)
	var/sig_return = SEND_SIGNAL(src, COMSIG_ITEM_CHECK_BLOCK)
	var/block_result = sig_return & COMPONENT_CHECK_BLOCK_BLOCKED

	var/attack_armor_pen = 0
	if(isitem(hitby))
		var/obj/item/hitby_item = hitby
		attack_armor_pen = hitby_item.armor_penetration

	if(!block_result && can_block_attack(wielder, hitby, attack_type))
		block_result = prob(get_block_chance(wielder, hitby, damage, attack_type, attack_armor_pen))

	var/list/reaction_args = args.Copy()
	if(block_result)
		reaction_args["block_success"] = TRUE
	else
		reaction_args["block_success"] = FALSE

	if(!(sig_return & COMPONENT_CHECK_BLOCK_SKIP_REACTION))
		if(hit_reaction(arglist(reaction_args)))
			block_result = TRUE

	if(block_result)
		block_feedback(wielder, attack_text, attack_type, do_message = TRUE, do_sound = TRUE)

	return block_result

/// Checks if this item can block an incoming attack.
/obj/item/proc/can_block_attack(mob/living/carbon/human/wielder, atom/movable/hitby, attack_type)
	if(wielder.body_position == LYING_DOWN)
		return TRUE

	var/angle = get_relative_attack_angle(wielder, hitby)
	if(angle <= block_angle)
		return TRUE

	return FALSE

/// Returns a number to feed into prob() to determine if the attack was blocked.
/obj/item/proc/get_block_chance(mob/living/carbon/human/wielder, atom/movable/hitby, damage, attack_type, armor_penetration)
	var/block_chance_modifier = round(damage / -3)
	var/final_block_chance = block_chance - (clamp((armor_penetration - src.armor_penetration)/2,0,100)) + block_chance_modifier
	return final_block_chance

/// Called when the wearer is being hit by an attack while wearing/wielding this item.
/// Returning TRUE will eat the attack, but this should be done by can_block_attack() instead.
/obj/item/proc/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", damage = 0, attack_type = MELEE_ATTACK, block_success = TRUE)
	SEND_SIGNAL(src, COMSIG_ITEM_HIT_REACT, owner, hitby, attack_text, damage, attack_type, block_success)

	return block_success

/// Called by try_block_attack on a successful block
/obj/item/proc/block_feedback(mob/living/carbon/human/wielder, attack_text, attack_type, do_message = TRUE, do_sound = TRUE)
	if(do_message)
		wielder.visible_message(span_danger("[wielder] blocks [attack_text] with [src]!"))

	if(do_sound && block_sound)
		play_block_sound(wielder, attack_type)

	if(block_effect)
		var/obj/effect/effect = new block_effect()
		wielder.add_viscontents(effect)

/// Plays the block sound effect
/obj/item/proc/play_block_sound(mob/living/carbon/human/wielder, attack_type)
	var/block_sound = src.block_sound

	if(islist(block_sound))
		block_sound = pick(block_sound)
	else if(isnull(block_sound))
		block_sound = pick('sound/weapons/block/block1.ogg', 'sound/weapons/block/block2.ogg', 'sound/weapons/block/block3.ogg')
	playsound(wielder, block_sound, 70, TRUE)

/obj/item/proc/talk_into(mob/M, input, channel, spans, datum/language/language, list/message_mods)
	if(isnull(language))
		language = M?.get_selected_language()

	if(istype(language, /datum/language/visual))
		return

	return ITALICS | REDUCE_RANGE

/// Called when a mob drops an item.
/obj/item/proc/unequipped(mob/user, silent = FALSE)
	SHOULD_CALL_PARENT(TRUE)

	if(wielded)
		unwield(user, FALSE, TRUE)

	// Remove any item actions we temporary gave out.
	for(var/datum/action/action_item_has as anything in actions)
		action_item_has.Remove(user)

	if((item_flags & DROPDEL) && !QDELETED(src))
		qdel(src)

	item_flags &= ~IN_INVENTORY
	equipped_to = null
	SEND_SIGNAL(src, COMSIG_ITEM_UNEQUIPPED, user)

	if(!silent)
		playsound(src, drop_sound, DROP_SOUND_VOLUME, ignore_walls = FALSE)

	if(!QDELETED(user))
		if(slowdown)
			user.update_equipment_speed_mods()
		user.update_mouse_pointer()

/// called just as an item is picked up (loc is not yet changed)
/obj/item/proc/pickup(mob/user)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ITEM_PICKUP, user)
	item_flags |= IN_INVENTORY

/// called when "found" in pockets and storage items. Returns 1 if the search should end.
/obj/item/proc/on_found(mob/finder)
	return

/**
 * To be overwritten to only perform visual tasks;
 * this is directly called instead of `equipped` on visual-only features like human dummies equipping outfits.
 *
 * This separation exists to prevent things like the monkey sentience helmet from
 * polling ghosts while it's just being equipped as a visual preview for a dummy.
 */
/obj/item/proc/visual_equipped(mob/living/user, slot, initial = FALSE)
	SHOULD_CALL_PARENT(TRUE)
	user.update_slots_for_item(src, slot)

/**
 * Called after an item is placed in an equipment slot.
 *
 * Note that hands count as slots.
 *
 * Arguments:
 * * user is mob that equipped it
 * * slot uses the slot_X defines found in setup.dm for items that can be placed in multiple slots
 * * initial is used to indicate whether or not this is the initial equipment (job datums etc) or just a player doing it
 */
/obj/item/proc/equipped(mob/user, slot, initial = FALSE)
	SHOULD_CALL_PARENT(TRUE)

	SEND_SIGNAL(src, COMSIG_ITEM_EQUIPPED, user, slot)
	SEND_SIGNAL(user, COMSIG_MOB_EQUIPPED_ITEM, src, slot)

	if(slot == ITEM_SLOT_HANDS)
		if(HAS_TRAIT(src, TRAIT_NEEDS_TWO_HANDS))
			if(!wield(user))
				stack_trace("[user] failed to wield a twohanded item.")
				spawn(0)
					user.dropItemToGround(src)

	else if(wielded)
		unwield(user, FALSE)

	// Give out actions our item has to people who equip it.
	for(var/datum/action/action as anything in actions)
		give_item_action(action, user, slot)

	item_flags |= IN_INVENTORY
	equipped_to = user

	if(!initial)
		if(equip_sound && (slot_flags & slot))
			playsound(src, equip_sound, EQUIP_SOUND_VOLUME, TRUE, ignore_walls = FALSE)
		else if(slot == ITEM_SLOT_HANDS)
			playsound(src, pickup_sound, PICKUP_SOUND_VOLUME, ignore_walls = FALSE)

	if(slowdown)
		user.update_equipment_speed_mods()
	visual_equipped(user, slot, initial)

/// Gives one of our item actions to a mob, when equipped to a certain slot
/obj/item/proc/give_item_action(datum/action/action, mob/to_who, slot)
	// Some items only give their actions buttons when in a specific slot.
	if(!item_action_slot_check(slot, to_who))
		// There is a chance we still have our item action currently,
		// and are moving it from a "valid slot" to an "invalid slot".
		// So call Remove() here regardless, even if excessive.
		action.Remove(to_who)
		return

	action.Grant(to_who)

/// Sometimes we only want to grant the item's action if it's equipped in a specific slot.
/obj/item/proc/item_action_slot_check(slot, mob/user)
	if(slot == ITEM_SLOT_BACKPACK || slot == ITEM_SLOT_LEGCUFFED) //these aren't true slots, so avoid granting actions there
		return FALSE
	return TRUE

/// Attempt to wield this item with two hands. Can fail.
/obj/item/proc/wield(mob/living/user)
	if(wielded)
		return FALSE

	// No free hands.
	if(!length(user.get_empty_held_indexes()))
		to_chat(user, span_warning("You need two hands to wield [src]."))
		return FALSE

	if(SEND_SIGNAL(src, COMSIG_ITEM_WIELD, user) & COMPONENT_ITEM_BLOCK_WIELD)
		return FALSE

	wielded = TRUE

	// Let's reserve the other hand.
	var/obj/item/offhand/offhand_item = new(user, src)
	if(!user.put_in_inactive_hand(offhand_item)) // This should be impossible
		stack_trace("[user] somehow failed to wield an item despite having a free hand.")
		wielded = FALSE
		qdel(offhand_item)
		return FALSE

	// Setup force values.
	force_unwielded = force
	if(!isnull(force_wielded))
		force = force_wielded
	else
		force = force * 1.5

	if(!HAS_TRAIT(src, TRAIT_NEEDS_TWO_HANDS))
		to_chat(user, span_notice("You grip [src] with your other hand."))

	// Feedback
	if(wield_sound)
		playsound(user, wield_sound, 50, TRUE)

	// Change appearance
	name = "[name] (Wielded)"
	update_appearance()
	user.update_held_items()
	return TRUE

/obj/item/proc/unwield(mob/living/user, show_message = TRUE, dropping = FALSE)
	if(!wielded)
		return FALSE

	wielded = FALSE

	// Reset force
	force = force_unwielded
	force_unwielded = null

	// Reset appearance
	var/sf = findtext(name, " (Wielded)", -10) // 10 == length(" (Wielded)")
	if(sf)
		name = copytext(name, 1, sf)
	else
		name = "[initial(name)]"

	update_appearance()

	if(istype(user)) // tk showed that we might not have a mob here
		if(!dropping)
			var/slot = user.get_slot_by_item(src)
			if(slot == ITEM_SLOT_HANDS)
				user.update_held_items()
			else if(slot)
				user.update_clothing(slot)

		// if the item requires two handed, drop the item on unwield
		if(HAS_TRAIT(src, TRAIT_NEEDS_TWO_HANDS))
			user.dropItemToGround(src, force=TRUE)

		// Show message if requested
		if(show_message)
			to_chat(user, span_notice("You are now carrying [src] with one hand."))

	if(unwield_sound)
		playsound(user, unwield_sound, 50, TRUE)

	SEND_SIGNAL(src, COMSIG_ITEM_UNWIELD, user)

	return FALSE

/**
 *the mob M is attempting to equip this item into the slot passed through as 'slot'. Return 1 if it can do this and 0 if it can't.
 *if this is being done by a mob other than M, it will include the mob equipper, who is trying to equip the item to mob M. equipper will be null otherwise.
 *If you are making custom procs but would like to retain partial or complete functionality of this one, include a 'return ..()' to where you want this to happen.
 * Arguments:
 * * disable_warning to TRUE if you wish it to not give you text outputs.
 * * slot is the slot we are trying to equip to
 * * equipper is the mob trying to equip the item
 * * bypass_equip_delay_self for whether we want to bypass the equip delay
 */
/obj/item/proc/mob_can_equip(mob/living/M, mob/living/equipper, slot, disable_warning = FALSE, bypass_equip_delay_self = FALSE)
	if(!M)
		return FALSE
	if((item_flags & HAND_ITEM) && slot != ITEM_SLOT_HANDS)
		return FALSE
	return M.can_equip(src, slot, disable_warning, bypass_equip_delay_self)

/obj/item/verb/verb_pickup()
	set src in oview(1)
	set category = "Object"
	set name = "Pick up"

	if(usr.incapacitated() || !Adjacent(usr))
		return

	if(isliving(usr))
		var/mob/living/L = usr
		if(!(L.mobility_flags & MOBILITY_PICKUP))
			return

	if(usr.get_active_held_item() == null) // Let me know if this has any problems -Yota
		usr.UnarmedAttack(src)

/**
 *This proc is executed when someone clicks the on-screen UI button.
 *The default action is attack_self().
 *Checks before we get to here are: mob is alive, mob is not restrained, stunned, asleep, resting, laying, item is on the mob.
 */
/obj/item/proc/ui_action_click(mob/user, actiontype)
	if(SEND_SIGNAL(src, COMSIG_ITEM_UI_ACTION_CLICK, user, actiontype) & COMPONENT_ACTION_HANDLED)
		return

	attack_self(user)

/// Returns an armor flag to check against for dealing damage.
/obj/item/proc/get_attack_flag()
	if(sharpness & SHARP_POINTY)
		return PUNCTURE
	if(sharpness & SHARP_EDGED)
		return SLASH

	return BLUNT

///This proc determines if and at what an object will reflect energy projectiles if it's in l_hand,r_hand or wear_suit
/obj/item/proc/IsReflect(def_zone)
	return FALSE

/obj/item/singularity_pull(S, current_size)
	..()
	if(current_size >= STAGE_FOUR)
		throw_at(S,14,3, spin=0)
	else
		return

/obj/item/on_exit_storage(datum/storage/master_storage)
	. = ..()
	do_drop_animation(master_storage.parent)

/obj/item/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(hit_atom && !QDELETED(hit_atom))
		SEND_SIGNAL(src, COMSIG_MOVABLE_IMPACT, hit_atom, throwingdatum)
		if(get_temperature() && isliving(hit_atom))
			var/mob/living/L = hit_atom
			L.ignite_mob()
		var/itempush = 1
		if(w_class < 4)
			itempush = 0 //too light to push anything
		if(istype(hit_atom, /mob/living)) //Living mobs handle hit sounds differently.
			var/volume = get_volume_by_throwforce_and_or_w_class()
			if (throwforce > 0)
				if (mob_throw_hit_sound)
					playsound(hit_atom, mob_throw_hit_sound, volume, TRUE, -1)
				else if(hitsound)
					playsound(hit_atom, hitsound, volume, TRUE, -1)
				else
					playsound(hit_atom, 'sound/weapons/genhit.ogg',volume, TRUE, -1)
			else
				playsound(hit_atom, 'sound/weapons/throwtap.ogg', 1, volume, -1)

		else
			playsound(src, drop_sound, YEET_SOUND_VOLUME, ignore_walls = FALSE)
		return hit_atom.hitby(src, 0, itempush, throwingdatum=throwingdatum)

/obj/item/throw_at(atom/target, range, speed, mob/thrower, spin=1, diagonals_first = 0, datum/callback/callback, force, gentle = FALSE, quickstart = TRUE)
	if(HAS_TRAIT(src, TRAIT_NODROP))
		return
	thrownby = WEAKREF(thrower)
	callback = CALLBACK(src, PROC_REF(after_throw), callback) //replace their callback with our own
	. = ..(target, range, speed, thrower, spin, diagonals_first, callback, force, gentle, quickstart = quickstart)

/obj/item/proc/after_throw(datum/callback/callback)
	if (callback) //call the original callback
		. = callback.Invoke()
	item_flags &= ~IN_INVENTORY
	if(!pixel_y && !pixel_x && !(item_flags & NO_PIXEL_RANDOM_DROP))
		pixel_x = rand(-8,8)
		pixel_y = rand(-8,8)


/obj/item/proc/remove_item_from_storage(atom/newLoc) //please use this if you're going to snowflake an item out of a obj/item/storage
	if(!newLoc)
		return FALSE
	if(loc.atom_storage)
		return loc.atom_storage.attempt_remove(src, newLoc, silent = TRUE)
	return FALSE

/// Returns the icon used for overlaying the object on a belt
/obj/item/proc/get_belt_overlay()
	var/icon_state_to_use = belt_icon_state || icon_state
	if(greyscale_config_belt && greyscale_colors)
		return mutable_appearance(SSgreyscale.GetColoredIconByType(greyscale_config_belt, greyscale_colors), icon_state_to_use)
	return mutable_appearance('icons/obj/clothing/belt_overlays.dmi', icon_state_to_use)

/obj/item/proc/update_slot_icon()
	if(!equipped_to)
		return

	equipped_to.update_clothing(slot_flags | ITEM_SLOT_HANDS)

///Returns the temperature of src. If you want to know if an item is hot use this proc.
/obj/item/proc/get_temperature()
	return heat

/obj/item/proc/get_dismember_sound()
	if(damtype == BURN)
		. = 'sound/weapons/sear.ogg'
	else
		. = SFX_DESECRATION

/obj/item/proc/open_flame(flame_heat=700)
	var/turf/location = loc
	if(isliving(location))
		var/mob/living/M = location
		var/success = FALSE
		if(M.body_position == LYING_DOWN && (src == M.get_item_by_slot(ITEM_SLOT_MASK) || M.is_holding(src)))
			success = TRUE
		if(success)
			location = get_turf(M)

	if(isturf(location))
		location.hotspot_expose(flame_heat, 5)

/obj/item/proc/ignition_effect(atom/A, mob/user)
	if(get_temperature())
		. = span_notice("[user] lights [A] with [src].")
	else
		. = ""

/obj/item/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	return SEND_SIGNAL(src, COMSIG_ATOM_HITBY, AM, skipcatch, hitpush, blocked, throwingdatum)

/obj/item/attack_hulk(mob/living/carbon/human/user)
	return FALSE

/obj/item/attack_animal(mob/living/simple_animal/user, list/modifiers)
	if (obj_flags & CAN_BE_HIT)
		return ..()
	return 0

/obj/item/attack_basic_mob(mob/living/basic/user, list/modifiers)
	if (obj_flags & CAN_BE_HIT)
		return ..()
	return 0

/obj/item/burn()
	if(!QDELETED(src))
		var/turf/T = get_turf(src)
		var/ash_type = /obj/effect/decal/cleanable/ash
		if(w_class == WEIGHT_CLASS_HUGE || w_class == WEIGHT_CLASS_GIGANTIC)
			ash_type = /obj/effect/decal/cleanable/ash/large
		var/obj/effect/decal/cleanable/ash/A = new ash_type(T)
		A.desc += "\nLooks like this used to be \an [name] some time ago."
		..()

/obj/item/acid_melt()
	if(!QDELETED(src))
		var/turf/T = get_turf(src)
		var/obj/effect/decal/cleanable/molten_object/MO = new(T)
		MO.pixel_x = rand(-16,16)
		MO.pixel_y = rand(-16,16)
		MO.desc = "Looks like this was \an [src] some time ago."
		..()

/obj/item/proc/microwave_act(obj/machinery/microwave/M)
	if(SEND_SIGNAL(src, COMSIG_ITEM_MICROWAVE_ACT, M) & COMPONENT_SUCCESFUL_MICROWAVE)
		return TRUE
	if(istype(M) && M.dirty < 100)
		M.dirty++

/obj/item/proc/grind_requirements(obj/machinery/reagentgrinder/R) //Used to check for extra requirements for grinding an object
	return TRUE
///Grind item, adding grind_results to item's reagents and transfering to target_holder if specified
/obj/item/proc/grind(datum/reagents/target_holder, mob/user, atom/movable/grinder = loc)
	SHOULD_NOT_OVERRIDE(TRUE)

	SEND_SIGNAL(src, COMSIG_ITEM_PRE_GRIND)

	. = FALSE
	if(!can_be_ground() || target_holder.holder_full())
		return

	return do_grind(target_holder, user)

///Called BEFORE the object is ground up - use this to change grind results based on conditions. Use "return -1" to prevent the grinding from occurring
/obj/item/proc/can_be_ground()
	if(!length(grind_results))
		return FALSE

	return TRUE

///Subtypes override his proc for custom grinding
/obj/item/proc/do_grind(datum/reagents/target_holder, mob/user)
	PROTECTED_PROC(TRUE)

	. = FALSE
	if(length(grind_results))
		target_holder.add_reagent_list(grind_results)
		. = TRUE

	if(reagents?.trans_to(target_holder, reagents.total_volume, transfered_by = user))
		. = TRUE

///Juice item, converting nutriments into juice_typepath and transfering to target_holder if specified
/obj/item/proc/juice(datum/reagents/target_holder, mob/user, atom/movable/juicer = loc)
	SHOULD_NOT_OVERRIDE(TRUE)

	SEND_SIGNAL(src, COMSIG_ITEM_PRE_JUICE)

	. = FALSE
	if(!can_be_juiced() || !reagents?.total_volume)
		return

	return do_juice(target_holder, user)


/obj/item/proc/can_be_juiced()
	if(!length(juice_results))
		return FALSE

	return TRUE

/// Subtypes override his proc for custom juicing
/obj/item/proc/do_juice(datum/reagents/target_holder, mob/user)
	PROTECTED_PROC(TRUE)

	. = FALSE

	var/mult = round(1 / length(juice_results), CHEMICAL_QUANTISATION_LEVEL)

	for(var/reagent_type in juice_results)
		reagents.convert_reagent(/datum/reagent/consumable/nutriment, reagent_type, mult, include_source_subtypes = FALSE)
		reagents.convert_reagent(/datum/reagent/consumable/nutriment/vitamin, reagent_type, mult, include_source_subtypes = FALSE)
		. = TRUE

	if(!QDELETED(target_holder))
		reagents.trans_to(target_holder, reagents.total_volume, transfered_by = user)

/obj/item/proc/damagetype2text()
	. += list()
	if(damtype == BURN)
		. += "BURN"
	if(damtype == BRUTE)
		. += "BRUTE"
	if(damtype == TOX)
		. += "TOXIN"
	if(sharpness & SHARP_EDGED)
		. += "CUT"
	if(sharpness & SHARP_POINTY)
		. += "PUNCTURE"
	if(!sharpness && damtype == BRUTE)
		. += "CRUSH"
	return english_list(., "NONE")

/obj/item/proc/force2text()
	switch(force)
		if(-INFINITY to 0)
			return "Harmless"
		if(0 to 2)
			return "Very Low"
		if(2 to 6)
			return "Low"
		if(6 to 12)
			return "Average"
		if(12 to 16)
			return "High"
		if(16 to 30)
			return "Very High"
		if(30 to INFINITY)
			return "You could really hurt somebody with this thing!"

/obj/item/proc/staminadamage2text()
	switch(stamina_damage)
		if(-INFINITY to 0)
			return "Harmless"
		if(0 to 5)
			return "Very Low"
		if(5 to 10)
			return "Low"
		if(10 to 20)
			return "Average"
		if(20 to 25)
			return "High"
		if(25 to 35)
			return "Very High"
		if(35 to INFINITY)
			return "This will take the wind out of your sails."

/obj/item/proc/staminacost2text()
	switch(stamina_cost)
		if(-INFINITY to 0)
			return "None"
		if(0 to 5)
			return "Very Low"
		if(5 to 10)
			return "Low"
		if(10 to 15)
			return "Average"
		if(15 to 25)
			return "High"
		if(25 to 35)
			return "Very High"
		if(35 to INFINITY)
			return "This will take the wind out of your sails."

/obj/item/proc/tooltipContent()
	RETURN_TYPE(/list)
	. = list()
	. += desc
	if(!stamina_damage && !force)
		return
	. += "<hr>"
	if(item_flags & FORCE_STRING_OVERRIDE)
		. += "<img src='attack.png'>Lethality: [force_string]<br>"
	else
		. += "<img src='attack.png'>Lethality: [force2text()], type: [damagetype2text()]<br>"
	. += "<img src='stamina.png'>Stamina: [staminadamage2text()]<br>"
	. += "<img src='stamcost.png'>Stamina Cost: [staminacost2text()]<br>"

/obj/item/proc/openTip(location, control, params, user)
	var/content = jointext(tooltipContent(), "")
	openToolTip(user,src,params,title = name,content = content,theme = "")

/obj/item/MouseEntered(location, control, params)
	. = ..()
	var/mob/in_contents_of = get(src, /mob)
	var/in_our_inventory = (in_contents_of == usr)
	if(!in_our_inventory && isobserver(usr))
		var/mob/dead/observer/O = usr
		in_our_inventory = (O.observetarget == in_contents_of)

	if((in_our_inventory || loc?.atom_storage || (src.item_flags & IN_STORAGE)) && !QDELETED(src))
		var/mob/living/L = usr
		if(usr.client.prefs.read_preference(/datum/preference/toggle/enable_tooltips))
			var/timedelay = usr.client.prefs.read_preference(/datum/preference/numeric/tooltip_delay) / 100
			tip_timer = addtimer(CALLBACK(src, PROC_REF(openTip), location, control, params, usr), timedelay, TIMER_STOPPABLE)//timer takes delay in deciseconds, but the pref is in milliseconds. dividing by 100 converts it.
		if(usr.client.prefs.read_preference(/datum/preference/toggle/item_outlines))
			if(istype(L) && L.incapacitated())
				apply_outline(COLOR_RED_GRAY) //if they're dead or handcuffed, let's show the outline as red to indicate that they can't interact with that right now
			else
				apply_outline() //if the player's alive and well we send the command with no color set, so it uses the theme's color

/obj/item/MouseDrag(over_object, src_location, over_location, src_control, over_control, params)
	. = ..()
	deltimer(tip_timer)
	closeToolTip(usr)

/obj/item/MouseDrop(atom/over, src_location, over_location, src_control, over_control, params)
	. = ..()
	remove_filter("hover_outline") //get rid of the hover effect in case the mouse exit isn't called if someone drags and drops an item and somthing goes wrong

/obj/item/MouseExited()
	. = ..()
	deltimer(tip_timer) //delete any in-progress timer if the mouse is moved off the item before it finishes
	closeToolTip(usr)
	remove_filter("hover_outline")

/obj/item/proc/apply_outline(outline_color = null)
	if(((get(src, /mob) != usr) && !src.loc.atom_storage && !(src.item_flags & IN_STORAGE)) || QDELETED(src) || isobserver(usr)) //cancel if the item isn't in an inventory, is being deleted, or if the person hovering is a ghost (so that people spectating you don't randomly make your items glow)
		return FALSE
	var/theme = lowertext(usr.client?.prefs?.read_preference(/datum/preference/choiced/ui_style))
	if(!outline_color) //if we weren't provided with a color, take the theme's color
		switch(theme) //yeah it kinda has to be this way
			if("midnight")
				outline_color = COLOR_THEME_MIDNIGHT
			if("plasmafire")
				outline_color = COLOR_THEME_PLASMAFIRE
			if("retro")
				outline_color = COLOR_THEME_RETRO //just as garish as the rest of this theme
			if("slimecore")
				outline_color = COLOR_THEME_SLIMECORE
			if("operative")
				outline_color = COLOR_THEME_OPERATIVE
			if("clockwork")
				outline_color = COLOR_THEME_CLOCKWORK //if you want free gbp go fix the fact that clockwork's tooltip css is glass'
			if("glass")
				outline_color = COLOR_THEME_GLASS
			else //this should never happen, hopefully
				outline_color = COLOR_WHITE
	if(color)
		outline_color = COLOR_WHITE //if the item is recolored then the outline will be too, let's make the outline white so it becomes the same color instead of some ugly mix of the theme and the tint

	add_filter("hover_outline", 1, list("type" = "outline", "size" = 1, "color" = outline_color))

/// Called when a mob tries to use the item as a tool. Handles most checks.
/obj/item/proc/use_tool(atom/target, mob/living/user, delay, amount=0, volume=0, datum/callback/extra_checks, interaction_key)
	// No delay means there is no start message, and no reason to call tool_start_check before use_tool.
	// Run the start check here so we wouldn't have to call it manually.
	if(!delay && !tool_start_check(user, amount))
		return

	var/skill_modifier = 1

	delay *= toolspeed * skill_modifier

	if(delay && iscarbon(user) && user.stats.cooldown_finished("use_tool")) // Fuck borgs!!!
		var/datum/roll_result/result = user.stat_roll(7, /datum/rpg_skill/handicraft)
		switch(result.outcome)
			if(CRIT_SUCCESS)
				result.do_skill_sound(user)
				to_chat(user, result.create_tooltip("A swift execution. A job well done."))
				delay = delay * 0.25


		user.stats.set_cooldown("use_tool", max(delay, 10 SECONDS))

	// Play tool sound at the beginning of tool usage.
	play_tool_sound(target, volume)

	if(delay)
		// Create a callback with checks that would be called every tick by do_after.
		var/datum/callback/tool_check = CALLBACK(src, PROC_REF(tool_check_callback), user, amount, extra_checks)

		if(!do_after(user, target, delay, DO_PUBLIC, extra_checks=tool_check, interaction_key = interaction_key, display = src))
			return

	else
		// Invoke the extra checks once, just in case.
		if(extra_checks && !extra_checks.Invoke())
			return

	// Use tool's fuel, stack sheets or charges if amount is set.
	if(amount && !use(amount))
		return

	// Play tool sound at the end of tool usage,
	// but only if the delay between the beginning and the end is not too small
	if(delay >= MIN_TOOL_SOUND_DELAY)
		play_tool_sound(target, volume)

	return TRUE

/// Called before [obj/item/proc/use_tool] if there is a delay, or by [obj/item/proc/use_tool] if there isn't. Only ever used by welding tools and stacks, so it's not added on any other [obj/item/proc/use_tool] checks.
/obj/item/proc/tool_start_check(mob/living/user, amount=0)
	. = tool_use_check(user, amount)
	if(.)
		SEND_SIGNAL(src, COMSIG_TOOL_START_USE, user)

/// A check called by [/obj/item/proc/tool_start_check] once, and by use_tool on every tick of delay.
/obj/item/proc/tool_use_check(mob/living/user, amount)
	return TRUE

/// Generic use proc. Depending on the item, it uses up fuel, charges, sheets, etc. Returns TRUE on success, FALSE on failure.
/obj/item/proc/use(used)
	return TRUE

/// Plays item's usesound, if any.
/obj/item/proc/play_tool_sound(atom/target, volume=50)
	if(target && usesound && volume)
		var/played_sound = usesound

		if(islist(usesound))
			played_sound = pick(usesound)

		playsound(target, played_sound, volume, TRUE)

/// Used in a callback that is passed by use_tool into do_after call. Do not override, do not call manually.
/obj/item/proc/tool_check_callback(mob/living/user, amount, datum/callback/extra_checks)
	SHOULD_NOT_OVERRIDE(TRUE)
	. = tool_use_check(user, amount) && (!extra_checks || extra_checks.Invoke())
	if(.)
		SEND_SIGNAL(src, COMSIG_TOOL_IN_USE, user)

/// Returns a numeric value for sorting items used as parts in machines, so they can be replaced by the rped
/obj/item/proc/get_part_rating()
	return 0

/obj/item/doMove(atom/destination)
	if (equipped_to)
		equipped_to.temporarilyRemoveItemFromInventory(src, TRUE)
	return ..()

/obj/item/proc/embedded(obj/item/bodypart/part)
	return

/obj/item/proc/unembedded()
	if(item_flags & DROPDEL && !QDELETED(src))
		qdel(src)
		return TRUE

/obj/item/proc/canStrip(mob/stripper, mob/owner)
	SHOULD_BE_PURE(TRUE)
	return !HAS_TRAIT(src, TRAIT_NODROP) && !(item_flags & ABSTRACT)

/obj/item/proc/doStrip(mob/stripper, mob/owner)
	return owner.dropItemToGround(src)

///Does the current embedding var meet the criteria for being harmless? Namely, does it have a pain multiplier and jostle pain mult of 0? If so, return true.
/obj/item/proc/isEmbedHarmless()
	if(embedding)
		return !isnull(embedding["pain_mult"]) && !isnull(embedding["jostle_pain_mult"]) && embedding["pain_mult"] == 0 && embedding["jostle_pain_mult"] == 0

///In case we want to do something special (like self delete) upon failing to embed in something.
/obj/item/proc/failedEmbed()
	if(item_flags & DROPDEL && !QDELETED(src))
		qdel(src)

///Called by the carbon throw_item() proc. Returns null if the item negates the throw, or a reference to the thing to suffer the throw else.
/obj/item/proc/on_thrown(mob/living/carbon/user, atom/target)
	if((item_flags & ABSTRACT))
		return

	if(!user.dropItemToGround(src, silent = TRUE, animate = FALSE))
		return

	if(throwforce && HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, span_notice("You set [src] down gently on the ground."))
		return

	return src

/**
 * tryEmbed() is for when you want to try embedding something without dealing with the damage + hit messages of calling hitby() on the item while targetting the target.
 *
 * Really, this is used mostly with projectiles with shrapnel payloads, from [/datum/element/embed/proc/checkEmbedProjectile], and called on said shrapnel. Mostly acts as an intermediate between different embed elements.
 *
 * Returns TRUE if it embedded successfully, nothing otherwise
 *
 * Arguments:
 * * target- Either a body part or a carbon. What are we hitting?
 * * forced- Do we want this to go through 100%?
 */
/obj/item/proc/tryEmbed(atom/target, forced=FALSE, silent=FALSE)
	if(!isbodypart(target) && !iscarbon(target))
		return NONE
	if(!forced && !LAZYLEN(embedding))
		return NONE

	if(SEND_SIGNAL(src, COMSIG_EMBED_TRY_FORCE, target, forced, silent))
		return COMPONENT_EMBED_SUCCESS
	failedEmbed()

///For when you want to disable an item's embedding capabilities (like transforming weapons and such), this proc will detach any active embed elements from it.
/obj/item/proc/disableEmbedding()
	SEND_SIGNAL(src, COMSIG_ITEM_DISABLE_EMBED)
	return

///For when you want to add/update the embedding on an item. Uses the vars in [/obj/item/var/embedding], and defaults to config values for values that aren't set. Will automatically detach previous embed elements on this item.
/obj/item/proc/updateEmbedding()
	SHOULD_CALL_PARENT(TRUE)

	SEND_SIGNAL(src, COMSIG_ITEM_EMBEDDING_UPDATE)
	if(!LAZYLEN(embedding))
		disableEmbedding()
		return

	AddElement(/datum/element/embed,\
		embed_chance = (!isnull(embedding["embed_chance"]) ? embedding["embed_chance"] : EMBED_CHANCE),\
		fall_chance = (!isnull(embedding["fall_chance"]) ? embedding["fall_chance"] : EMBEDDED_ITEM_FALLOUT),\
		pain_chance = (!isnull(embedding["pain_chance"]) ? embedding["pain_chance"] : EMBEDDED_PAIN_CHANCE),\
		pain_mult = (!isnull(embedding["pain_mult"]) ? embedding["pain_mult"] : EMBEDDED_PAIN_MULTIPLIER),\
		remove_pain_mult = (!isnull(embedding["remove_pain_mult"]) ? embedding["remove_pain_mult"] : EMBEDDED_UNSAFE_REMOVAL_PAIN_MULTIPLIER),\
		rip_time = (!isnull(embedding["rip_time"]) ? embedding["rip_time"] : EMBEDDED_UNSAFE_REMOVAL_TIME),\
		ignore_throwspeed_threshold = (!isnull(embedding["ignore_throwspeed_threshold"]) ? embedding["ignore_throwspeed_threshold"] : FALSE),\
		impact_pain_mult = (!isnull(embedding["impact_pain_mult"]) ? embedding["impact_pain_mult"] : EMBEDDED_IMPACT_PAIN_MULTIPLIER),\
		jostle_chance = (!isnull(embedding["jostle_chance"]) ? embedding["jostle_chance"] : EMBEDDED_JOSTLE_CHANCE),\
		jostle_pain_mult = (!isnull(embedding["jostle_pain_mult"]) ? embedding["jostle_pain_mult"] : EMBEDDED_JOSTLE_PAIN_MULTIPLIER),\
		pain_stam_pct = (!isnull(embedding["pain_stam_pct"]) ? embedding["pain_stam_pct"] : EMBEDDED_PAIN_STAM_PCT))
	return TRUE

/// How many different types of mats will be counted in a bite?
#define MAX_MATS_PER_BITE 2

/*
 * On accidental consumption: when you somehow end up eating an item accidentally (currently, this is used for when items are hidden in food like bread or cake)
 *
 * The base proc will check if the item is sharp and has a decent force.
 * Then, it checks the item's mat datums for the effects it applies afterwards.
 * Then, it checks tiny items.
 * After all that, it returns TRUE if the item is set to be discovered. Otherwise, it returns FALSE.
 *
 * This works similarily to /suicide_act: if you want an item to have a unique interaction, go to that item
 * and give it an /on_accidental_consumption proc override. For a simple example of this, check out the nuke disk.
 *
 * Arguments
 * * M - the mob accidentally consuming the item
 * * user - the mob feeding M the item - usually, it's the same as M
 * * source_item - the item that held the item being consumed - bread, cake, etc
 * * discover_after - if the item will be discovered after being chomped (FALSE will usually mean it was swallowed, TRUE will usually mean it was bitten into and discovered)
 */
/obj/item/proc/on_accidental_consumption(mob/living/carbon/victim, mob/living/carbon/user, obj/item/source_item, discover_after = TRUE)
	if(sharpness && force >= 5) //if we've got something sharp with a decent force (ie, not plastic)
		INVOKE_ASYNC(victim, TYPE_PROC_REF(/mob, emote), "scream")
		victim.visible_message(span_warning("[victim] looks like [victim.p_theyve()] just bit something they shouldn't have!"), \
							span_boldwarning("OH GOD! Was that a crunch? That didn't feel good at all!!"))

		victim.apply_damage(max(15, force), BRUTE, BODY_ZONE_HEAD, sharpness = TRUE)
		victim.losebreath += 2
		if(tryEmbed(victim.get_bodypart(BODY_ZONE_CHEST), TRUE, TRUE)) //and if it embeds successfully in their chest, cause a lot of pain
			victim.apply_damage(max(25, force*1.5), BRUTE, BODY_ZONE_CHEST, sharpness = TRUE)
			victim.losebreath += 6
			discover_after = FALSE
		if(QDELETED(src)) // in case trying to embed it caused its deletion (say, if it's DROPDEL)
			return
		source_item?.reagents?.add_reagent(/datum/reagent/blood, 2)

	else if(custom_materials?.len) //if we've got materials, lets see whats in it
		/// How many mats have we found? You can only be affected by two material datums by default
		var/found_mats = 0
		/// How much of each material is in it? Used to determine if the glass should break
		var/total_material_amount = 0

		for(var/mats in custom_materials)
			total_material_amount += custom_materials[mats]
			if(found_mats >= MAX_MATS_PER_BITE)
				continue //continue instead of break so we can finish adding up all the mats to the total

			var/datum/material/discovered_mat = mats
			if(discovered_mat.on_accidental_mat_consumption(victim, source_item))
				found_mats++

		//if there's glass in it and the glass is more than 60% of the item, then we can shatter it
		if(custom_materials[GET_MATERIAL_REF(/datum/material/glass)] >= total_material_amount * 0.60)
			if(prob(66)) //66% chance to break it
				/// The glass shard that is spawned into the source item
				var/obj/item/shard/broken_glass = new /obj/item/shard(loc)
				broken_glass.name = "broken [name]"
				broken_glass.desc = "This used to be \a [name], but it sure isn't anymore."
				playsound(victim, SFX_SHATTER, 25, TRUE)
				qdel(src)
				if(QDELETED(source_item))
					broken_glass.on_accidental_consumption(victim, user)
			else //33% chance to just "crack" it (play a sound) and leave it in the bread
				playsound(victim, SFX_SHATTER, 15, TRUE)
			discover_after = FALSE

		victim.adjust_disgust(33)
		victim.visible_message(span_warning("[victim] looks like [victim.p_theyve()] just bitten into something hard."), \
						span_warning("Eugh! Did I just bite into something?"))

	else if(w_class == WEIGHT_CLASS_TINY) //small items like soap or toys that don't have mat datums
		/// victim's chest (for cavity implanting the item)
		var/obj/item/bodypart/chest/victim_cavity = victim.get_bodypart(BODY_ZONE_CHEST)
		if(length(victim_cavity.cavity_items))
			victim.vomit(5, FALSE, FALSE, distance = 0)
			forceMove(drop_location())
			to_chat(victim, span_warning("You vomit up a [name]! [source_item? "Was that in \the [source_item]?" : ""]"))
		else
			victim.transferItemToLoc(src, victim, TRUE)
			victim.losebreath += 2
			victim_cavity.add_cavity_item(src)
			to_chat(victim, span_warning("You swallow hard. [source_item? "Something small was in \the [source_item]..." : ""]"))
		discover_after = FALSE

	else
		to_chat(victim, span_warning("[source_item? "Something strange was in the \the [source_item]..." : "I just bit something strange..."] "))

	return discover_after

#undef MAX_MATS_PER_BITE

/**
 * Updates all action buttons associated with this item
 *
 * Arguments:
 * * flags - Update flags passed to build_all_button_icons()
 * * force - Force buttons update even if the given button icon state has not changed
 */
/obj/item/proc/update_action_buttons(flags = null, force = FALSE)
	for(var/datum/action/current_action as anything in actions)
		current_action.build_all_button_icons(flags, force)

// Update icons if this is being carried by a mob
/obj/item/wash(clean_types)
	. = ..()

	if(equipped_to)
		if(equipped_to.is_holding(src))
			equipped_to.update_held_items()
		else
			equipped_to.update_clothing()

/// Called on [/datum/element/openspace_item_click_handler/proc/on_afterattack]. Check the relative file for information.
/obj/item/proc/handle_openspace_click(turf/target, mob/user, proximity_flag, click_parameters)
	stack_trace("Undefined handle_openspace_click() behaviour. Ascertain the openspace_item_click_handler element has been attached to the right item and that its proc override doesn't call parent.")

/**
 * * An interrupt for offering an item to other people, called mainly from [/mob/living/carbon/proc/give], in case you want to run your own offer behavior instead.
 *
 * * Return TRUE if you want to interrupt the offer.
 *
 * * Arguments:
 * * offerer - the person offering the item
 */
/obj/item/proc/on_offered(mob/living/carbon/offerer)
	if(SEND_SIGNAL(src, COMSIG_ITEM_OFFERING, offerer) & COMPONENT_OFFER_INTERRUPT)
		return TRUE

/**
 * * An interrupt for someone trying to accept an offered item, called mainly from [/mob/living/carbon/proc/take], in case you want to run your own take behavior instead.
 *
 * * Return TRUE if you want to interrupt the taking.
 *
 * * Arguments:
 * * offerer - the person offering the item
 * * taker - the person trying to accept the offer
 */
/obj/item/proc/on_offer_taken(mob/living/carbon/offerer, mob/living/carbon/taker)
	if(SEND_SIGNAL(src, COMSIG_ITEM_OFFER_TAKEN, offerer, taker) & COMPONENT_OFFER_INTERRUPT)
		return TRUE

/// Special stuff you want to do when an outfit equips this item.
/obj/item/proc/on_outfit_equip(mob/living/carbon/human/outfit_wearer, visuals_only, item_slot)
	return

/// Whether or not this item can be put into a storage item through attackby
/obj/item/proc/attackby_storage_insert(datum/storage, atom/storage_holder, mob/user)
	return TRUE

/obj/item/proc/do_pickup_animation(atom/target)
	if(!istype(loc, /turf))
		return
	var/image/pickup_animation = image(icon = src, loc = loc, layer = layer + 0.1)
	pickup_animation.plane = GAME_PLANE
	pickup_animation.transform.Scale(0.75)
	pickup_animation.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA

	var/turf/current_turf = get_turf(src)
	var/direction = get_dir(current_turf, target)
	var/to_x = target.base_pixel_x
	var/to_y = target.base_pixel_y

	if(direction & NORTH)
		to_y += 32
	else if(direction & SOUTH)
		to_y -= 32
	if(direction & EAST)
		to_x += 32
	else if(direction & WEST)
		to_x -= 32
	if(!direction)
		to_y += 10
		pickup_animation.pixel_x += 6 * (prob(50) ? 1 : -1) //6 to the right or left, helps break up the straight upward move

	flick_overlay(pickup_animation, GLOB.clients, 4)
	var/matrix/animation_matrix = new(pickup_animation.transform)
	animation_matrix.Turn(pick(-30, 30))
	animation_matrix.Scale(0.65)

	animate(pickup_animation, alpha = 175, pixel_x = to_x, pixel_y = to_y, time = 3, transform = animation_matrix, easing = CUBIC_EASING)
	animate(alpha = 0, transform = matrix().Scale(0.7), time = 1)

/obj/item/proc/do_drop_animation(atom/moving_from)
	if(!istype(loc, /turf))
		return

	if(!istype(moving_from))
		return

	var/turf/current_turf = get_turf(src)
	var/direction = get_dir(moving_from, current_turf)
	var/from_x = moving_from.base_pixel_x
	var/from_y = moving_from.base_pixel_y

	if(direction & NORTH)
		from_y -= 32
	else if(direction & SOUTH)
		from_y += 32
	if(direction & EAST)
		from_x -= 32
	else if(direction & WEST)
		from_x += 32
	if(!direction)
		from_y += 10
		from_x += 6 * (prob(50) ? 1 : -1) //6 to the right or left, helps break up the straight upward move

	//We're moving from these chords to our current ones
	var/old_x = pixel_x
	var/old_y = pixel_y
	var/old_alpha = alpha
	var/matrix/old_transform = transform
	var/matrix/animation_matrix = new(old_transform)
	animation_matrix.Turn(pick(-30, 30))
	animation_matrix.Scale(0.7) // Shrink to start, end up normal sized

	pixel_x = from_x
	pixel_y = from_y
	alpha = 0
	transform = animation_matrix

	SEND_SIGNAL(src, COMSIG_ATOM_TEMPORARY_ANIMATION_START, 3)

	animate(src, alpha = old_alpha, pixel_x = old_x, pixel_y = old_y, transform = old_transform, time = 3, easing = CUBIC_EASING)

/atom/movable/proc/do_item_attack_animation(atom/attacked_atom, visual_effect_icon, obj/item/used_item)
	var/image/attack_image
	if(visual_effect_icon)
		attack_image = image('icons/effects/effects.dmi', attacked_atom, visual_effect_icon, attacked_atom.layer + 0.1)

	else if(used_item)
		attack_image = image(icon = used_item, loc = attacked_atom, layer = attacked_atom.layer + 0.1)
		attack_image.plane = attacked_atom.plane

		// Scale the icon.
		attack_image.transform *= 0.4
		// The icon should not rotate.
		attack_image.appearance_flags = APPEARANCE_UI|KEEP_APART

		// Set the direction of the icon animation.
		var/direction = get_dir(src, attacked_atom)
		if(direction & NORTH)
			attack_image.pixel_y = -12
		else if(direction & SOUTH)
			attack_image.pixel_y = 12

		if(direction & EAST)
			attack_image.pixel_x = -14
		else if(direction & WEST)
			attack_image.pixel_x = 14

		if(!direction) // Attacked self?!
			attack_image.pixel_y = 12
			attack_image.pixel_x = 5 * (prob(50) ? 1 : -1)

	if(!attack_image)
		return

	flick_overlay(attack_image, GLOB.clients, 10)
	var/matrix/copy_transform = new(transform)
	// And animate the attack!
	animate(attack_image, alpha = 175, transform = copy_transform.Scale(0.75), pixel_x = 0, pixel_y = 0, pixel_z = 0, time = 3)
	animate(time = 1)
	animate(alpha = 0, time = 3, easing = CIRCULAR_EASING|EASE_OUT)

/mob/do_item_attack_animation(atom/attacked_atom, visual_effect_icon, obj/item/used_item)
	if(used_item)
		animate_interact(attacked_atom, INTERACT_GENERIC, used_item)
		return
	return ..()

/// Common proc used by painting tools like spraycans and palettes that can access the entire 24 bits color space.
/obj/item/proc/pick_painting_tool_color(mob/user, default_color)
	var/chosen_color = input(user,"Pick new color", "[src]", default_color) as color|null
	if(!chosen_color || QDELETED(src) || IS_DEAD_OR_INCAP(user) || !user.is_holding(src))
		return
	set_painting_tool_color(chosen_color)

/obj/item/proc/set_painting_tool_color(chosen_color)
	SEND_SIGNAL(src, COMSIG_PAINTING_TOOL_SET_COLOR, chosen_color)

/obj/item/speaker_location()
	var/locthing = loc
	if(isitem(locthing))
		var/obj/item/I = loc
		return I.speaker_location()
	if(isturf(locthing))
		return src
	return loc

/obj/item/onZImpact(turf/impacted_turf, levels, message)
	. = ..()
	playsound(impacted_turf, hitsound, 50)

	if(!force)
		return

	var/atom/highest
	for(var/atom/movable/hurt_atom as anything in impacted_turf)
		if(hurt_atom == src)
			continue
		if(!hurt_atom.density)
			continue
		if(isobj(hurt_atom) || ismob(hurt_atom))
			if(hurt_atom.layer > highest?.layer)
				highest = hurt_atom

	if(!highest)
		return

	if(isobj(highest))
		var/obj/O = highest
		if(!O.uses_integrity)
			return

		O.take_damage((w_class * 5) * levels)

	if(ismob(highest))
		var/mob/living/L = highest
		var/armor = L.run_armor_check(BODY_ZONE_HEAD, BLUNT)
		L.apply_damage((w_class * 5) * levels, blocked = armor, spread_damage = TRUE)
		L.Paralyze(10 SECONDS)

	visible_message(span_warning("[src] slams into [highest] from above!"))

/obj/item/proc/on_disarm_attempt(mob/living/user, mob/living/attacker)
	if(force < 1)
		return FALSE
	if(!istype(attacker))
		return FALSE
	if(sharpness)
		return FALSE

	var/obj/item/bodypart/BP = attacker.get_active_hand()

	attacker.apply_damage(force, damtype, BP, attacker.run_armor_check(BP, get_attack_flag(), silent = TRUE), sharpness = sharpness)

	attacker.visible_message(span_danger("[attacker] hurts \his hand on [src]!"))
	log_combat(attacker, user, "Attempted to disarm but was blocked by", src)
	playsound(user, get_hitsound(), 50, 1, -1)
	return TRUE

/// Returns the sound the item makes when hitting something
/obj/item/proc/get_hitsound()
	if(wielded)
		. = wielded_hitsound
	. ||= hitsound

/// Leave evidence of a user on a target
/obj/item/proc/leave_evidence(mob/user, atom/target)
	if(!(item_flags & NO_EVIDENCE_ON_ATTACK))
		target.add_fingerprint(user)
	else
		target.log_touch(user)

/// Returns the sound the item makes when used as a weapon, but missing.
/obj/item/proc/get_misssound()
	. = src.miss_sound
	if(islist(.))
		. = pick(miss_sound)
	else if(isnull(.))
		. = pick('sound/weapons/swing/swing_01.ogg', 'sound/weapons/swing/swing_02.ogg', 'sound/weapons/swing/swing_03.ogg')
	return .

/// Returns [obj/item/var/icon_center] as a list.
/obj/item/proc/get_icon_center()
	var/list/center = params2list(icon_center)
	center["x"] = text2num(center["x"])
	center["y"] = text2num(center["y"])
	return center

/// Returns TRUE if the passed mob can interact with this item's storage via pickpocketing.
/obj/item/proc/can_pickpocket(mob/living/user)
	return FALSE

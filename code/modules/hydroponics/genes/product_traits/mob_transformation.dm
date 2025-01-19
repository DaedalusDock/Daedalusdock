/datum/plant_gene/product_trait/mob_transformation
	name = "Dormant Ferocity"
	trait_ids = ATTACK_SELF_ID
	/// Whether mobs spawned by this trait are dangerous or not.
	var/dangerous = FALSE
	/// The typepath to what mob spawns from this plant.
	var/killer_plant
	/// Whether our attatched plant is currently waking up or not.
	var/awakening = FALSE
	/// Spawned mob's health = this multiplier * seed endurance.
	var/mob_health_multiplier = 1
	/// Spawned mob's melee damage = this multiplier * seed potency.
	var/mob_melee_multiplier = 1
	/// Spawned mob's move delay = this multiplier * seed potency.
	var/mob_speed_multiplier = 1

/datum/plant_gene/product_trait/mob_transformation/on_new_product(obj/item/product, newloc, datum/plant/plant_datum)
	. = ..()
	if(!.)
		return

	if(dangerous)
		product.AddElement(/datum/element/plant_backfire, TRUE)
		RegisterSignal(product, COMSIG_PLANT_ON_BACKFIRE, PROC_REF(early_awakening))

	RegisterSignal(product, COMSIG_ITEM_ATTACK_SELF, PROC_REF(manual_awakening))
	RegisterSignal(product, COMSIG_ITEM_PRE_ATTACK, PROC_REF(pre_consumption_check))

/*
 * Before we can eat our plant, check to see if it's waking up. Don't eat it if it is.
 *
 * our_plant - signal source, the plant we're eating
 * target - the mob eating the plant
 * user - the mob feeding someone the plant (generally, target == user)
 */
/datum/plant_gene/product_trait/mob_transformation/proc/pre_consumption_check(obj/item/our_plant, atom/target, mob/user)
	SIGNAL_HANDLER

	if(!awakening)
		return

	if(!ismob(target))
		return

	if(target != user)
		to_chat(user, span_warning("[our_plant] is twitching and shaking, preventing you from feeding it to [target]."))
	to_chat(target, span_warning("[our_plant] is twitching and shaking, preventing you from eating it."))
	return COMPONENT_CANCEL_ATTACK_CHAIN

/*
 * Called when a user manually activates the plant.
 * Checks if the critera is met to spawn it, and spawns it in 3 seconds if it is.
 *
 * our_plant - our plant that we're waking up
 * user - the mob activating the plant
 */
/datum/plant_gene/product_trait/mob_transformation/proc/manual_awakening(obj/item/our_plant, mob/user)
	SIGNAL_HANDLER

	if(awakening || isspaceturf(user.loc))
		return

	if(dangerous && HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, span_notice("You decide not to awaken [our_plant]. It may be very dangerous!"))
		return

	to_chat(user, span_notice("You begin to awaken [our_plant]..."))
	begin_awaken(our_plant, 3 SECONDS)
	our_plant.investigate_log("was awakened by [key_name(user)] at [AREACOORD(user)].", INVESTIGATE_BOTANY)

/*
 * Called when a user accidentally activates the plant via backfire effect.
 *
 * our_plant - our plant, which is waking up
 * user - the mob handling the plant
 */
/datum/plant_gene/product_trait/mob_transformation/proc/early_awakening(obj/item/our_plant, mob/living/carbon/user)
	SIGNAL_HANDLER

	if(!awakening && !isspaceturf(user.loc) && prob(25))
		our_plant.visible_message(span_danger("[our_plant] begins to growl and shake!"))
		begin_awaken(our_plant, 1 SECONDS)
		our_plant.investigate_log("was awakened (via plant backfire) by [key_name(user)] at [AREACOORD(user)].", INVESTIGATE_BOTANY)

/*
 * Actually begin the process of awakening the plant.
 *
 * awaken_time - the time, in seconds, it will take for the plant to spawn.
 */
/datum/plant_gene/product_trait/mob_transformation/proc/begin_awaken(obj/item/our_plant, awaken_time)
	awakening = TRUE
	addtimer(CALLBACK(src, PROC_REF(awaken), our_plant), awaken_time)

/*
 * Actually awaken the plant, spawning the mob designated by the [killer_plant] typepath.
 *
 * product - the plant that's waking up
 */
/datum/plant_gene/product_trait/mob_transformation/proc/awaken(obj/item/product)
	if(QDELETED(product))
		return
	if(!ispath(killer_plant))
		return

	var/datum/plant/our_plant = product.get_plant_datum()
	var/mob/living/spawned_mob = new killer_plant(product.drop_location())

	spawned_mob.maxHealth += round(our_plant.get_effective_stat(PLANT_STAT_ENDURANCE) * mob_health_multiplier)
	spawned_mob.health = spawned_mob.maxHealth

	var/potency = our_plant.get_effective_stat(PLANT_STAT_POTENCY)

	if(ishostile(spawned_mob))
		var/mob/living/simple_animal/hostile/spawned_simplemob = spawned_mob
		spawned_simplemob.melee_damage_lower += round(potency * mob_melee_multiplier)
		spawned_simplemob.melee_damage_upper += round(potency * mob_melee_multiplier)
		//spawned_simplemob.move_to_delay -= round(our_seed.production * mob_speed_multiplier)

	product.forceMove(product.drop_location())
	spawned_mob.visible_message(span_notice("[product] growls as it suddenly awakens!"))
	qdel(product)

/// Killer Tomato's transformation gene.
/datum/plant_gene/product_trait/mob_transformation/tomato
	dangerous = TRUE
	killer_plant = /mob/living/simple_animal/hostile/killertomato
	mob_health_multiplier = 0.33
	mob_melee_multiplier = 0.1
	mob_speed_multiplier = 0.02

/// Walking Mushroom's transformation gene
/datum/plant_gene/product_trait/mob_transformation/shroom
	killer_plant = /mob/living/simple_animal/hostile/mushroom
	mob_health_multiplier = 0.25
	mob_melee_multiplier = 0.05
	mob_speed_multiplier = 0.02

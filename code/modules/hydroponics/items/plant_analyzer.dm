// Plant analyzer
/obj/item/plant_analyzer
	name = "plant analyzer"
	desc = "A scanner used to evaluate a plant's various areas of growth, and genetic traits. Comes with a growth scanning mode and a chemical scanning mode."
	icon = 'icons/obj/device.dmi'
	icon_state = "hydro"
	inhand_icon_state = "analyzer"
	worn_icon_state = "plantanalyzer"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_BELT
	custom_materials = list(/datum/material/iron = 30, /datum/material/glass = 20)

/// When we attack something, first - try to scan something we hit with left click. Left-clicking uses scans for stats
/obj/item/plant_analyzer/pre_attack(atom/target, mob/living/user)
	. = ..()
	if(user.combat_mode)
		return

	return do_plant_stats_scan(target, user)

/// Same as above, but with right click. Right-clicking scans for chemicals.
/obj/item/plant_analyzer/pre_attack_secondary(atom/target, mob/living/user)
	if(user.combat_mode)
		return SECONDARY_ATTACK_CONTINUE_CHAIN

	return do_plant_chem_scan(target, user) ? SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN : SECONDARY_ATTACK_CONTINUE_CHAIN

/*
 * Scan the target on plant scan mode. This prints traits and stats to the user.
 *
 * scan_target - the atom we're scanning
 * user - the user doing the scanning.
 *
 * returns FALSE if it's not an object or item that does something when we scan it.
 * returns TRUE if we can scan the object, and outputs the message to the USER.
 */
/obj/item/plant_analyzer/proc/do_plant_stats_scan(atom/scan_target, mob/user)
	if(istype(scan_target, /obj/machinery/hydroponics))
		to_chat(user, scan_tray_stats(scan_target))
		return TRUE

	if(istype(scan_target, /obj/structure/glowshroom))
		var/obj/structure/glowshroom/shroom_plant = scan_target
		to_chat(user, scan_plant_stats(shroom_plant.myseed.plant_datum))
		return TRUE

	if(isitem(scan_target))
		var/obj/item/scanned_object = scan_target
		if(scanned_object.get_plant_datum())
			to_chat(user, scan_plant_stats(scanned_object))
			return TRUE

	if(isliving(scan_target))
		var/mob/living/L = scan_target
		if(L.mob_biotypes & MOB_PLANT)
			plant_biotype_health_scan(scan_target, user)
			return TRUE

	return FALSE

/*
 * Scan the target on chemical scan mode. This prints chemical genes and reagents to the user.
 *
 * scan_target - the atom we're scanning
 * user - the user doing the scanning.
 *
 * returns FALSE if it's not an object or item that does something when we scan it.
 * returns TRUE if we can scan the object, and outputs the message to the USER.
 */
/obj/item/plant_analyzer/proc/do_plant_chem_scan(atom/scan_target, mob/user)
	if(istype(scan_target, /obj/machinery/hydroponics))
		to_chat(user, scan_tray_chems(scan_target))
		return TRUE

	if(istype(scan_target, /obj/structure/glowshroom))
		var/obj/structure/glowshroom/shroom_plant = scan_target
		to_chat(user, scan_plant_chems(shroom_plant.myseed))
		return TRUE

	if(isitem(scan_target))
		var/obj/item/scanned_object = scan_target
		if(scanned_object.get_plant_datum())
			to_chat(user, scan_plant_chems(scanned_object))
			return TRUE

	if(isliving(scan_target))
		var/mob/living/L = scan_target
		if(L.mob_biotypes & MOB_PLANT)
			plant_biotype_chem_scan(scan_target, user)
			return TRUE

	return FALSE

/*
 * Scan a living mob's (with MOB_PLANT biotype) health with the plant analyzer. No wound scanning, though.
 *
 * scanned_mob - the living mob being scanned
 * user - the person doing the scanning
 */
/obj/item/plant_analyzer/proc/plant_biotype_health_scan(mob/living/scanned_mob, mob/living/carbon/human/user)
	user.visible_message(
		span_notice("[user] analyzes [scanned_mob]'s vitals."),
		span_notice("You analyze [scanned_mob]'s vitals.")
		)

	healthscan(user, scanned_mob, advanced = TRUE)
	add_fingerprint(user)

/*
 * Scan a living mob's (with MOB_PLANT biotype) chemical contents with the plant analyzer.
 *
 * scanned_mob - the living mob being scanned
 * user - the person doing the scanning
 */
/obj/item/plant_analyzer/proc/plant_biotype_chem_scan(mob/living/scanned_mob, mob/living/carbon/human/user)
	user.visible_message(
		span_notice("[user] analyzes [scanned_mob]'s bloodstream."),
		span_notice("You analyze [scanned_mob]'s bloodstream.")
		)
	chemscan(user, scanned_mob)
	add_fingerprint(user)
/**
 * This proc is called when we scan a hydroponics tray or soil on left click (stats mode)
 * It formats the plant name, it's age, the plant's stats, and the tray's stats.
 *
 * - scanned_tray - the tray or soil we are scanning.
 *
 * Returns the formatted message as text.
 */
/obj/item/plant_analyzer/proc/scan_tray_stats(obj/machinery/hydroponics/scanned_tray)
	var/list/returned_message = list("*---------*")
	if(scanned_tray.growing)
		returned_message += "*** [span_bold("[scanned_tray.growing.name]")] ***"
		returned_message += "- Plant Health: [span_notice("[scanned_tray.plant_health]")]"
		returned_message += scan_plant_stats(scanned_tray.growing)
	else
		returned_message += span_bold("No plant found.")

	returned_message += "- Reagent level: [span_notice("[scanned_tray.get_water_level()] / [scanned_tray.reagents.maximum_volume]")]"
	returned_message += "*---------*"
	return span_info(jointext(returned_message, "<br>"))

/**
 * This proc is called when we scan a hydroponics tray or soil on right click (chemicals mode)
 * It formats the plant name and age, as well as the plant's chemical genes and the tray's contents.
 *
 * - scanned_tray - the tray or soil we are scanning.
 *
 * Returns the formatted message as text.
 */
/obj/item/plant_analyzer/proc/scan_tray_chems(obj/machinery/hydroponics/scanned_tray)
	var/list/returned_message = list("*---------*")
	if(scanned_tray.growing)
		returned_message += "*** [span_bold("[scanned_tray.growing.name]")] ***"
		returned_message += scan_plant_chems(scanned_tray.growing)
	else
		returned_message += span_bold("No plant found.")

	returned_message += "- Tray contains:"
	if(scanned_tray.reagents.reagent_list.len)
		for(var/datum/reagent/reagent_id in scanned_tray.reagents.reagent_list)
			returned_message += "- [span_notice("[reagent_id.volume] units of [reagent_id]")]"
	else
		returned_message += "[span_notice("No reagents found.")]"

	returned_message += "*---------*"
	return span_info(jointext(returned_message, "<br>"))

/**
 * This proc is called when a seed or any grown plant is scanned on left click (stats mode).
 * It formats the plant name as well as either its traits and stats.
 *
 * - scanned_object - the source objecte for what we are scanning. This can be a grown food, a grown inedible, or a seed.
 *
 * Returns the formatted output as text.
 */
/obj/item/plant_analyzer/proc/scan_plant_stats(obj/item/scanned_object)
	var/returned_message = "*---------*\nThis is [span_name("\a [scanned_object]")].\n"
	var/datum/plant/plant_datum = scanned_object
	if(!istype(plant_datum)) //if we weren't passed a seed, we were passed a plant with a seed
		plant_datum = scanned_object.get_plant_datum()

	if(istype(plant_datum))
		returned_message += get_analyzer_text_traits(plant_datum)
	else
		returned_message += "*---------*\nNo genes found.\n*---------*"

	returned_message += "\n"
	return span_info(returned_message)

/**
 * This proc is called when a seed or any grown plant is scanned on right click (chemical mode).
 * It formats the plant name as well as its chemical contents.
 *
 * - scanned_object - the source objecte for what we are scanning. This can be a grown food, a grown inedible, or a seed.
 *
 * Returns the formatted output as text.
 */
/obj/item/plant_analyzer/proc/scan_plant_chems(obj/item/scanned_object)
	var/returned_message = "*---------*\nThis is [span_name("\a [scanned_object]")].\n"
	var/datum/plant/plant_datum = scanned_object
	if(!istype(plant_datum)) //if we weren't passed a seed, we were passed a plant with a seed
		plant_datum = scanned_object.get_plant_datum()

	if(scanned_object.reagents) //we have reagents contents
		returned_message += get_analyzer_text_chem_contents(scanned_object)
	else if(length(plant_datum.reagents_per_potency)) //we have a seed with reagent genes
		returned_message += get_analyzer_text_chem_genes(plant_datum)
	else
		returned_message += "*---------*\nNo reagents found.\n*---------*"

	returned_message += "\n"
	return span_info(returned_message)

/**
 * This proc is formats the traits and stats of a seed into a message.
 *
 * - scanned - the source seed for what we are scanning for traits.
 *
 * Returns the formatted output as text.
 */
/obj/item/plant_analyzer/proc/get_analyzer_text_traits(datum/plant/plant_datum)
	var/datum/plant_gene_holder/dna = plant_datum.gene_holder
	var/list/text = list()

	if(plant_datum.gene_holder.has_active_gene_of_type(/datum/plant_gene/product_trait/plant_type/weed_hardy))
		text += "- Plant type: [span_info("Weed. Can grow in nutrient-poor soil.")]"

	else if(plant_datum.gene_holder.has_active_gene_of_type(/datum/plant_gene/product_trait/plant_type/fungal_metabolism))
		text += "- Plant type: [span_info("Mushroom. Can grow in dry soil.")]"

	else if(plant_datum.gene_holder.has_active_gene_of_type(/datum/plant_gene/product_trait/plant_type/alien_properties))
		text += "- Plant type: [span_warning("UNKNOWN")]"

	text += "- Generation: [span_info("[plant_datum.generation]")]"
	text += "- Endurance ([dna.endurance_dominance ? span_info("D") : span_alert("R")]): [span_info("[dna.get_effective_stat(PLANT_STAT_ENDURANCE)]")]"
	text += "- Potency ([dna.potency_dominance ? span_info("D") : span_alert("R")]): [span_info("[dna.get_effective_stat(PLANT_STAT_POTENCY)]")]"
	text += "- Maturation ([dna.growth_time_dominance ? span_info("D") : span_alert("R")]): [span_info("[dna.get_effective_stat(PLANT_STAT_MATURATION)]")]"
	text += "- Production ([dna.produce_time_dominance ? span_info("D") : span_alert("R")]): [span_info("[dna.get_effective_stat(PLANT_STAT_PRODUCTION)]")]"
	text += "- Harvest Count ([dna.harvest_amt_dominance ? span_info("D") : span_alert("R")]): [span_info("[dna.get_effective_stat(PLANT_STAT_HARVEST_AMT)]")]"
	text += "- Harvest Yield ([dna.yield_dominance ? span_info("D") : span_alert("R")]): [span_info("[dna.get_effective_stat(PLANT_STAT_YIELD)]")]"
	text += ""

	if(plant_datum.rarity)
		text += "- Species Discovery Value: [span_info("[plant_datum.rarity]")]"

	var/list/traits = list()
	for(var/datum/plant_gene/product_trait/trait in plant_datum.gene_holder.gene_list)
		if(isabstract(trait))
			continue

		traits += "<a href='?src=\ref[SScodex];show_examined_info=\ref[trait];show_to=\ref[usr]'>[trait.get_name()]</a>"

	text += "- Plant Traits: [span_info("[length(traits) ? english_list(traits) : "None."]")]"
	text += "*---------*"
	return jointext(text, "<br>")

/**
 * This proc is formats the chemical GENES of a seed into a message.
 *
 * - plant_datum - the source seed for what we are scanning for chemical genes.
 *
 * Returns the formatted output as text.
 */
/obj/item/plant_analyzer/proc/get_analyzer_text_chem_genes(datum/plant/plant_datum)
	var/list/text = list()
	text += "- Plant Reagent Genes -"
	text += "*---------*"
	for(var/datum/plant_gene/reagent/gene in plant_datum.gene_holder.gene_list)
		text += "- [gene.get_name()] -"
	text += "*---------*"
	return jointext(text, "<br>")

/**
 * This proc is formats the chemical CONTENTS of a plant into a message.
 *
 * - scanned_plant - the source plant we are reading out its reagents contents.
 *
 * Returns the formatted output as text.
 */
/obj/item/plant_analyzer/proc/get_analyzer_text_chem_contents(obj/item/scanned_plant)
	var/list/text = list()
	var/reagents_text = ""
	text += "- Plant Reagents -"
	text += "Maximum reagent capacity: [scanned_plant.reagents.maximum_volume]"

	var/chem_cap = 0
	for(var/_reagent in scanned_plant.reagents.reagent_list)
		var/datum/reagent/reagent = _reagent
		var/amount = reagent.volume
		chem_cap += reagent.volume
		reagents_text += "<br>- [reagent.name]: [amount]"

	if(chem_cap > 100)
		text += "- [span_danger("Reagent Traits Over 100% Production")]"

	if(reagents_text)
		text += "*---------*"
		text += reagents_text

	text += "*---------*"

	return jointext(text, "<br>")


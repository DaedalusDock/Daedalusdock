/*
 * Allows a plant to be turned into a battery when cabling is applied.
 * 100 potency plants are made into 2 mj batteries.
 * Plants with electrical activity has their capacities massively increased (up to 40 mj at 100 potency)
 */
/datum/plant_gene/product_trait/battery
	name = "Capacitive Cell Production"
	gene_flags = PLANT_GENE_MUTATABLE
	/// The number of cables needed to make a battery.
	var/cables_needed_per_battery = 5

/datum/plant_gene/product_trait/battery/on_new_product(obj/item/product, newloc, datum/plant/plant_datum)
	. = ..()
	if(!.)
		return

	product.flags_1 |= HAS_CONTEXTUAL_SCREENTIPS_1
	RegisterSignal(product, COMSIG_ATOM_REQUESTING_CONTEXT_FROM_ITEM, PROC_REF(on_requesting_context_from_item))
	RegisterSignal(product, COMSIG_PARENT_ATTACKBY, PROC_REF(make_battery))

/*
 * Signal proc for [COMSIG_ATOM_REQUESTING_CONTEXT_FROM_ITEM] to add context to plant batteries.
 */
/datum/plant_gene/product_trait/battery/proc/on_requesting_context_from_item(
	obj/item/source,
	list/context,
	obj/item/held_item,
	mob/living/user,
)
	SIGNAL_HANDLER

	if(!istype(held_item, /obj/item/stack/cable_coil))
		return NONE

	var/obj/item/stack/cable_coil/cabling = held_item
	if(cabling.amount < cables_needed_per_battery)
		return NONE

	context[SCREENTIP_CONTEXT_LMB] = "Make [source.name] battery"
	return CONTEXTUAL_SCREENTIP_SET

/*
 * When a plant with this gene is hit (attackby) with cables, we turn it into a battery.
 *
 * our_plant - our plant being hit
 * hit_item - the item we're hitting the plant with
 * user - the person hitting the plant with an item
 */
/datum/plant_gene/product_trait/battery/proc/make_battery(obj/item/product, obj/item/hit_item, mob/user)
	SIGNAL_HANDLER

	if(!istype(hit_item, /obj/item/stack/cable_coil))
		return

	var/datum/plant/our_plant = product.get_plant_datum()
	var/obj/item/stack/cable_coil/cabling = hit_item

	if(!cabling.use(cables_needed_per_battery))
		to_chat(user, span_warning("You need five lengths of cable to make a [product] battery!"))
		return

	to_chat(user, span_notice("You add some cable to [product] and slide it inside the battery encasing."))
	var/obj/item/stock_parts/cell/potato/pocell = new /obj/item/stock_parts/cell/potato(user.loc)
	pocell.icon_state = product.icon_state
	pocell.maxcharge = our_plant.get_effective_stat(PLANT_STAT_ENDURANCE) * 20

	// The secret of potato supercells!
	var/datum/plant_gene/product_trait/cell_charge/electrical_gene = our_plant.gene_holder.has_active_gene_of_type(/datum/plant_gene/product_trait/cell_charge)
	if(electrical_gene) // Cell charge max is now 40MJ or otherwise known as 400KJ (Same as bluespace power cells)
		pocell.maxcharge *= (electrical_gene.rate * 100)
	pocell.charge = pocell.maxcharge
	pocell.name = "[product.name] battery"
	pocell.desc = "A rechargeable plant-based power cell. This one has a rating of [display_energy(pocell.maxcharge)], and you should not swallow it."

	if(product.reagents.has_reagent(/datum/reagent/toxin/plasma, 2))
		pocell.rigged = TRUE

	qdel(product)

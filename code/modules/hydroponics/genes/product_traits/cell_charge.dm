/*
 * Cell recharging trait. Charges all mob's power cells to (potency*rate)% mark when eaten.
 * Generates sparks on squash.
 * Small (potency * rate) chance to shock squish or slip target for (potency * rate) damage.
 * Also affects plant batteries see capatative cell production datum
 */
/datum/plant_gene/product_trait/cell_charge
	name = "Electrical Activity"
	rate = 0.2
	gene_flags = PLANT_GENE_MUTATABLE

/datum/plant_gene/product_trait/cell_charge/on_new_product(obj/item/product, newloc, datum/plant/plant_datum)
	. = ..()
	if(!.)
		return

	var/datum/plant/our_plant = product.get_plant_datum()
	if(our_plant.gene_holder.has_active_gene_of_type(/datum/plant_gene/product_trait/squash))
		// If we have the squash gene, let that handle slipping
		RegisterSignal(product, COMSIG_PLANT_ON_SQUASH, PROC_REF(zap_target))
	else
		RegisterSignal(product, COMSIG_PLANT_ON_SLIP, PROC_REF(zap_target))

	RegisterSignal(product, COMSIG_FOOD_EATEN, PROC_REF(recharge_cells))

/*
 * Zaps the target with a stunning shock.
 *
 * our_plant - our source plant, shocking the target
 * target - the atom being zapped by our plant
 */
/datum/plant_gene/product_trait/cell_charge/proc/zap_target(obj/item/product, atom/target)
	SIGNAL_HANDLER

	if(!iscarbon(target))
		return

	product.investigate_log("zapped [key_name(target)] at [AREACOORD(target)]. Last touched by: [product.fingerprintslast].", INVESTIGATE_BOTANY)
	var/mob/living/carbon/target_carbon = target
	var/datum/plant/our_plant = product.get_plant_datum()
	var/power = our_plant.get_effective_stat(PLANT_STAT_POTENCY) * rate

	if(prob(power))
		target_carbon.electrocute_act(round(power), 1, NONE)

/*
 * Recharges every cell the person is holding for a bit based on plant potency.
 *
 * product - our source plant, that we consumed to charge the cells
 * eater - the mob that bit the plant
 * feeder - the mob that feed the eater the plant
 */
/datum/plant_gene/product_trait/cell_charge/proc/recharge_cells(obj/item/product, mob/living/eater, mob/feeder)
	SIGNAL_HANDLER

	to_chat(eater, span_notice("You feel energized as you bite into [product]."))
	var/batteries_recharged = FALSE
	var/datum/plant/our_plant = product.get_plant_datum()
	var/potency = our_plant.get_effective_stat(PLANT_STAT_POTENCY)

	for(var/obj/item/stock_parts/cell/found_cell in eater.get_all_contents())
		var/newcharge = min(potency * 0.01 * found_cell.maxcharge, found_cell.maxcharge)
		if(found_cell.charge < newcharge)
			found_cell.charge = newcharge
			if(isobj(found_cell.loc))
				var/obj/cell_location = found_cell.loc
				cell_location.update_appearance() //update power meters and such
			found_cell.update_appearance()
			batteries_recharged = TRUE

	if(batteries_recharged)
		to_chat(eater, span_notice("Your batteries are recharged!"))

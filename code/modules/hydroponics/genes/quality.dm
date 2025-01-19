/datum/plant_gene/quality
	name = "ERR"
	abstract_type = /datum/plant_gene/quality
	gene_flags = PLANT_GENE_MUTATABLE

/datum/plant_gene/quality/on_add(datum/plant_gene_holder/gene_holder)
	. = ..()
	RegisterSignal(gene_holder, COMSIG_PLANT_GENE_HOLDER_GET_STAT, PROC_REF(on_stat_request))

/datum/plant_gene/quality/on_remove(datum/plant_gene_holder/gene_holder)
	. = ..()
	UnregisterSignal(gene_holder, COMSIG_PLANT_GENE_HOLDER_GET_STAT)

/datum/plant_gene/quality/proc/on_stat_request(datum/source, stat, base_val, list/out)
	SIGNAL_HANDLER
	return

/datum/plant_gene/quality/superior
	name = "Superior Quality"
	desc = "Produce harvested from this plant will be of a greater quality than usual."

/datum/plant_gene/quality/superior/on_stat_request(datum/source, stat, base_val, list/out)
	if(stat != PLANT_STAT_POTENCY)
		return

	out += base_val * 0.2

/datum/plant_gene/quality/inferior
	name = "Inferior Quality"
	desc = "Produce harvested from this plant will be of much worse quality than usual."

/datum/plant_gene/quality/inferior/on_stat_request(datum/source, stat, base_val, list/out)
	if(stat != PLANT_STAT_POTENCY)
		return

	out += base_val * -0.2

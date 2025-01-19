/datum/plant_gene/unstable
	name = "Unstable"
	desc = "Weakening of the genetic structure will cause this plant to mutate by itself."

/datum/plant_gene/unstable/tick(delta_time, obj/machinery/hydroponics/tray, datum/plant/plant, datum/plant_tick/plant_tick)
	. = ..()
	if(.)
		return

	plant_tick.mutation_power += 0.2

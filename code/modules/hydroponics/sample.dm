/datum/plant/sample
	name = "plant sample"
	species = "ambrosiavulgaris"
	icon_dead = "ambrosia-dead"

	seed_path = /obj/item/seeds/sample

/obj/item/seeds/sample
	name = "plant sample"
	icon_state = "sample-empty"

	plant_type = /datum/plant/sample

	var/sample_color = "#FFFFFF"

/obj/item/seeds/sample/Initialize(mapload)
	. = ..()

	if(sample_color)
		var/mutable_appearance/filling = mutable_appearance(icon, "sample-filling")
		filling.color = sample_color
		add_overlay(filling)

/obj/item/seeds/sample/alienweed
	name = "alien weed sample"
	icon_state = "alienweed"
	sample_color = null

/datum/plant_gene/mutations
	name = "Mutagenic"
	desc = "Quirks in the plant's genetic structure cause mutations to occur more easily than usual."

	var/mutation_chance_modifier = 15

/datum/plant_gene/mutations/bad
	name = "Anti-Mutagenic"
	desc = "This plant's genetic structure makes mutations less likely to occur."
	is_negative = TRUE

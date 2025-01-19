/*
 * Makes the plant glow. Makes the plant in tray glow, too.
 * Adds (1.4 + potency * rate) light range and (potency * (rate + 0.01)) light_power to products.
 */
/datum/plant_gene/product_trait/glow
	name = "Bioluminescence"
	rate = 0.03
	examine_line = "<span class='info'>It emits a soft glow.</span>"
	trait_ids = GLOW_ID
	/// The color of our bioluminesence.
	var/glow_color = "#C3E381"

/datum/plant_gene/product_trait/glow/proc/glow_range(potency)
	return 1.4 + potency * rate

/datum/plant_gene/product_trait/glow/proc/glow_power(potency)
	return max(potency * (rate + 0.01), 0.1)

/datum/plant_gene/product_trait/glow/on_new_product(obj/item/product, newloc, datum/plant/plant_datum)
	. = ..()
	if(!.)
		return

	var/datum/plant/our_plant = product.get_plant_datum()
	var/potency = our_plant.get_effective_stat(PLANT_STAT_POTENCY)
	product.light_system = OVERLAY_LIGHT
	product.AddComponent(/datum/component/overlay_lighting, glow_range(potency), glow_power(potency), glow_color)

/*
 * Makes plant emit darkness. (Purple-ish shadows)
 * Adds - (potency * (rate * 0.2)) light power to products.
 */
/datum/plant_gene/product_trait/glow/shadow
	name = "Shadow Emission"
	rate = 0.04
	glow_color = "#AAD84B"

/datum/plant_gene/product_trait/glow/shadow/glow_power(potency)
	return -max(potency * (rate * 0.2), 0.2)

/// Colored versions of bioluminescence.

/// White
/datum/plant_gene/product_trait/glow/white
	name = "White Bioluminescence"
	glow_color = "#FFFFFF"

/// Red
/datum/plant_gene/product_trait/glow/red
	name = "Red Bioluminescence"
	glow_color = "#FF3333"

/// Yellow (not the disgusting glowshroom yellow hopefully)
/datum/plant_gene/product_trait/glow/yellow
	name = "Yellow Bioluminescence"
	glow_color = "#FFFF66"

/// Green (oh no, now i'm radioactive)
/datum/plant_gene/product_trait/glow/green
	name = "Green Bioluminescence"
	glow_color = "#99FF99"

/// Blue (the best one)
/datum/plant_gene/product_trait/glow/blue
	name = "Blue Bioluminescence"
	glow_color = "#6699FF"

/// Purple (did you know that notepad++ doesnt think bioluminescence is a word) (was the person who wrote this using notepad++ for dm?)
/datum/plant_gene/product_trait/glow/purple
	name = "Purple Bioluminescence"
	glow_color = "#D966FF"

// Pink (gay tide station pride)
/datum/plant_gene/product_trait/glow/pink
	name = "Pink Bioluminescence"
	glow_color = "#FFB3DA"

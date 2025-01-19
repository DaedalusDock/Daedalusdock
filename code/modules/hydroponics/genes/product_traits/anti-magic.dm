/// Holymelon's anti-magic trait. Charges based on potency.
/datum/plant_gene/product_trait/anti_magic
	name = "Anti-Magic Vacuoles"
	/// The amount of anti-magic blocking uses we have.
	var/shield_uses = 1

/datum/plant_gene/product_trait/anti_magic/on_new_product(obj/item/product, newloc, datum/plant/plant_datum)
	. = ..()
	if(!.)
		return

	var/datum/plant/our_plant = product.get_plant_datum()
	shield_uses = round(our_plant.get_effective_stat(PLANT_STAT_POTENCY) / 20)

	//deliver us from evil o melon god
	product.AddComponent(/datum/component/anti_magic, \
		antimagic_flags = MAGIC_RESISTANCE|MAGIC_RESISTANCE_HOLY, \
		inventory_flags = ITEM_SLOT_HANDS, \
		charges = shield_uses, \
		drain_antimagic = CALLBACK(src, PROC_REF(drain_antimagic)), \
		expiration = CALLBACK(src, PROC_REF(expire)), \
	)

/// When the plant our gene is hosted in is drained of an anti-magic charge.
/datum/plant_gene/product_trait/anti_magic/proc/drain_antimagic(mob/user, obj/item/our_plant)
	to_chat(user, span_warning("[our_plant] hums slightly, and seems to decay a bit."))

/// When the plant our gene is hosted in is drained of all of its anti-magic charges.
/datum/plant_gene/product_trait/anti_magic/proc/expire(mob/user, obj/item/our_plant)
	to_chat(user, span_warning("[our_plant] rapidly turns into ash!"))
	new /obj/effect/decal/cleanable/ash(our_plant.drop_location())
	qdel(our_plant)

/datum/reagent/aluminium
	name = "Aluminium"
	taste_description = "metal"
	taste_mult = 1.1
	description = "A silvery white and ductile member of the boron group of chemical elements."
	reagent_state = SOLID
	color = "#a8a8a8"
	value = DISPENSER_REAGENT_VALUE

/datum/reagent/ammonia
	name = "Ammonia"
	taste_description = "mordant"
	taste_mult = 2
	description = "A caustic substance commonly used in fertilizer or household cleaners."
	reagent_state = LIQUID
	color = "#404030"
	metabolization_rate = 0.1
	overdose_threshold = 5
	value = DISPENSER_REAGENT_VALUE

/datum/reagent/ammonia/affect_blood(mob/living/carbon/C, removed)
	C.adjustToxLoss(removed * 1.5, FALSE, cause_of_death = "Ingesting ammonia")
	return TRUE

/datum/reagent/ammonia/overdose_process(mob/living/carbon/C)
	C.adjustToxLoss(0.5, FALSE, cause_of_death = "Ingesting ALOT of ammonia")
	return TRUE

/datum/reagent/ammonia/infuse_plant(datum/plant/plant_datum, datum/plant_gene_holder/plant_dna, list/damage_ref)
	. = ..()
	plant_dna.maturation += rand(5, 10)
	plant_dna.production += rand(2, 5)
	damage_ref += rand(10, 20)

/datum/reagent/carbon
	name = "Carbon"
	description = "A chemical element, the building block of life."
	taste_description = "sour chalk"
	taste_mult = 1.5
	reagent_state = SOLID
	color = "#1c1300"
	ingest_met = 2
	value = DISPENSER_REAGENT_VALUE

/datum/reagent/carbon/affect_ingest(mob/living/carbon/C, removed)
	var/datum/reagents/ingested = C.get_ingested_reagents()
	if (ingested && length(ingested.reagent_list) > 1) // Need to have at least 2 reagents - cabon and something to remove
		var/effect = 1 / (length(ingested.reagent_list) - 1)
		for(var/datum/reagent/R in ingested.reagent_list)
			if(R == src)
				continue
			ingested.remove_reagent(R.type, removed * effect)
	return ..()

/datum/reagent/carbon/expose_turf(turf/exposed_turf, reac_volume, exposed_temperature)
	. = ..()
	if(isspaceturf(exposed_turf))
		return

	var/obj/effect/decal/cleanable/dirt/dirtoverlay = locate(/obj/effect/decal/cleanable/dirt, exposed_turf)
	if (!dirtoverlay)
		dirtoverlay = new/obj/effect/decal/cleanable/dirt(exposed_turf)
		dirtoverlay.alpha = reac_volume * 30
	else
		dirtoverlay.alpha = min(dirtoverlay.alpha + reac_volume * 30, 255)

/datum/reagent/copper
	name = "Copper"
	description = "A highly ductile metal."
	taste_description = "copper"
	color = "#6e3b08"
	value = DISPENSER_REAGENT_VALUE

/datum/reagent/iron
	name = "Iron"
	description = "Pure iron is a metal."
	taste_description = "metal"
	reagent_state = SOLID
	color = "#353535"
	value = DISPENSER_REAGENT_VALUE

/datum/reagent/iron/affect_blood(mob/living/carbon/C, removed)
	. = ..()
	C.adjustBloodVolume(2 * removed)

/datum/reagent/lithium
	name = "Lithium"
	description = "A chemical element, used as antidepressant."
	taste_description = "metal"
	reagent_state = SOLID
	color = "#808080"
	value = DISPENSER_REAGENT_VALUE

/datum/reagent/lithium/affect_blood(mob/living/carbon/C, removed)
	if(!isspaceturf(C.loc))
		step(C, GLOB.cardinals)

	if(prob(5))
		spawn(-1)
			C.emote(pick("twitch", "drool", "moan"))

/datum/reagent/mercury
	name = "Mercury"
	description = "A chemical element."
	taste_mult = 0 //mercury apparently is tasteless. IDK
	reagent_state = LIQUID
	color = "#484848"
	value = DISPENSER_REAGENT_VALUE

/datum/reagent/mercury/affect_blood(mob/living/carbon/C, removed)
	if(!isspaceturf(C.loc))
		step(C, pick(GLOB.cardinals))
	if(prob(5))
		spawn(-1)
			C.emote(pick("twitch", "drool", "moan"))
	C.adjustOrganLoss(ORGAN_SLOT_BRAIN, 0.1 * removed, updating_health = FALSE)
	return TRUE

/datum/reagent/phosphorus
	name = "Phosphorus"
	description = "A chemical element, the backbone of biological energy carriers."
	taste_description = "vinegar"
	reagent_state = SOLID
	color = "#832828"
	value = DISPENSER_REAGENT_VALUE

/datum/reagent/potassium
	name = "Potassium"
	description = "A soft, low-melting solid that can easily be cut with a knife. Reacts violently with water."
	taste_description = "sweetness" //potassium is bitter in higher doses but sweet in lower ones.
	reagent_state = SOLID
	color = "#a0a0a0"
	value = DISPENSER_REAGENT_VALUE

/datum/reagent/potassium/affect_blood(mob/living/carbon/C, removed)
	if(volume > 10)
		APPLY_CHEM_EFFECT(C, CE_PULSE, 2)
	else if(volume > 3)
		APPLY_CHEM_EFFECT(C, CE_PULSE, 1)

/datum/reagent/toxin/acid
	name = "Sulphuric Acid"
	description = "A very corrosive mineral acid with the molecular formula H2SO4."
	taste_description = "acid"
	reagent_state = LIQUID
	color = "#db5008"
	metabolization_rate = 0.4
	touch_met = 1
	var/acidpwr = 10
	var/meltdose = 20 // How much is needed to melt
	var/max_damage = 40
	value = DISPENSER_REAGENT_VALUE

/datum/reagent/toxin/acid/affect_blood(mob/living/carbon/C, removed)
	C.adjustFireLoss(removed * acidpwr, FALSE)
	return TRUE

/datum/reagent/toxin/acid/affect_touch(mob/living/carbon/C, removed)
	C.acid_act(acidpwr, removed, affect_clothing = FALSE)

/datum/reagent/toxin/acid/expose_mob(mob/living/exposed_mob, reac_volume, exposed_temperature = T20C, datum/reagents/source, methods=TOUCH, show_message = TRUE, touch_protection = 0)
	. = ..()
	reac_volume = round(reac_volume,0.1)
	if(!iscarbon(exposed_mob))
		if(methods & INGEST)
			exposed_mob.adjustBruteLoss(min(6*toxpwr, reac_volume * toxpwr))
			return
		if(methods & INJECT)
			exposed_mob.adjustBruteLoss(1.5 * min(6*toxpwr, reac_volume * toxpwr))
			return
		exposed_mob.acid_act(acidpwr, reac_volume, affect_clothing = (methods & TOUCH), affect_body = (methods & INJECT|INGEST))
	else
		if(methods & TOUCH)
			// Body is handled by affect_touch()
			exposed_mob.acid_act(acidpwr, reac_volume, affect_body = FALSE)
		spawn(-1)
			exposed_mob.emote("agony")

/datum/reagent/toxin/acid/expose_obj(obj/exposed_obj, reac_volume)
	. = ..()
	if(ismob(exposed_obj.loc)) //handled in human acid_act()
		return
	reac_volume = round(reac_volume,0.1)
	exposed_obj.acid_act(acidpwr, reac_volume)

/datum/reagent/toxin/acid/expose_turf(turf/exposed_turf, reac_volume, exposed_temperature)
	. = ..()
	if (!istype(exposed_turf))
		return
	reac_volume = round(reac_volume,0.1)
	exposed_turf.acid_act(acidpwr, reac_volume)

/datum/reagent/toxin/acid/infuse_plant(datum/plant/plant_datum, datum/plant_gene_holder/plant_dna, list/damage_ref)
	. = ..()
	damage_ref[1] = rand(40, 50)

/datum/reagent/toxin/acid/hydrochloric //Like sulfuric, but less toxic and more acidic.
	name = "Hydrochloric Acid"
	description = "A very corrosive mineral acid with the molecular formula HCl."
	taste_description = "stomach acid"
	reagent_state = LIQUID
	color = "#808080"
	toxpwr = 3
	meltdose = 8
	max_damage = 30
	value = DISPENSER_REAGENT_VALUE * 2

/datum/reagent/silicon
	name = "Silicon"
	description = "A tetravalent metalloid, silicon is less reactive than its chemical analog carbon."
	reagent_state = SOLID
	color = "#a8a8a8"
	value = DISPENSER_REAGENT_VALUE

/datum/reagent/sodium
	name = "Sodium"
	description = "A chemical element, readily reacts with water."
	taste_description = "salty metal"
	reagent_state = SOLID
	color = "#808080"
	value = DISPENSER_REAGENT_VALUE

/datum/reagent/sulfur
	name = "Sulfur"
	description = "A chemical element with a pungent smell."
	taste_description = "old eggs"
	reagent_state = SOLID
	color = "#bf8c00"
	value = DISPENSER_REAGENT_VALUE

/datum/reagent/tungsten
	name = "Tungsten"
	description = "A chemical element, and a strong oxidising agent."
	taste_mult = 0 //no taste
	reagent_state = SOLID
	color = "#dcdcdc"
	value = DISPENSER_REAGENT_VALUE

/datum/reagent/oxygen
	name = "Oxygen"
	description = "A colorless, odorless gas. Grows on trees but is still pretty valuable."
	reagent_state = GAS
	color = "#808080" // rgb: 128, 128, 128
	taste_mult = 0 // oderless and tasteless


/datum/reagent/oxygen/expose_turf(turf/exposed_turf, reac_volume, exposed_temperature)
	. = ..()
	if(isopenturf(exposed_turf))
		exposed_turf.atmos_spawn_air(GAS_OXYGEN, reac_volume/20, exposed_temperature || T20C)


/datum/reagent/nitrogen
	name = "Nitrogen"
	description = "A colorless, odorless, tasteless gas. A simple asphyxiant that can silently displace vital oxygen."
	reagent_state = GAS
	color = "#808080" // rgb: 128, 128, 128
	taste_mult = 0


/datum/reagent/nitrogen/expose_turf(turf/open/exposed_turf, reac_volume)
	. = ..()
	if(istype(exposed_turf))
		var/temp = holder ? holder.chem_temp : T20C
		exposed_turf.atmos_spawn_air(GAS_NITROGEN, reac_volume / REAGENT_GAS_EXCHANGE_FACTOR, temp)

/datum/reagent/hydrogen
	name = "Hydrogen"
	description = "A colorless, odorless, nonmetallic, tasteless, highly combustible diatomic gas."
	reagent_state = GAS
	color = "#808080" // rgb: 128, 128, 128
	taste_mult = 0


/datum/reagent/fluorine
	name = "Fluorine"
	description = "A comically-reactive chemical element. The universe does not want this stuff to exist in this form in the slightest."
	reagent_state = GAS
	color = "#808080" // rgb: 128, 128, 128
	taste_description = "acid"


// You're an idiot for thinking that one of the most corrosive and deadly gasses would be beneficial
/datum/reagent/fluorine/on_hydroponics_apply(datum/plant_tick/plant_tick, datum/reagents/chems, volume, obj/machinery/hydroponics/mytray, mob/user)
	if(volume >= 1)
		plant_tick.tox_damage += 5

/datum/reagent/fluorine/affect_blood(mob/living/carbon/C, removed)
	C.adjustToxLoss(0.5*removed, 0, cause_of_death = "Ammonia poisoning")
	. = TRUE

//This is intended to a be a scarce reagent to gate certain drugs and toxins with. Do not put in a synthesizer. Renewable sources of this reagent should be inefficient.
/datum/reagent/lead
	name = "Lead"
	description = "A dull metalltic element with a low melting point."
	taste_description = "metal"
	reagent_state = SOLID
	color = "#80919d"
	metabolization_rate = 0.15

/datum/reagent/lead/affect_blood(mob/living/carbon/C, removed)
	C.adjustOrganLoss(ORGAN_SLOT_BRAIN, 0.5)

/datum/reagent/iodine
	name = "Iodine"
	description = "Commonly added to table salt as a nutrient. On its own it tastes far less pleasing."
	reagent_state = LIQUID
	color = "#BC8A00"
	taste_description = "metal"


/datum/reagent/carbondioxide
	name = "Carbon Dioxide"
	reagent_state = GAS
	description = "A gas commonly produced by burning carbon fuels. You're constantly producing this in your lungs."
	color = "#B0B0B0" // rgb : 192, 192, 192
	taste_description = "something unknowable"


/datum/reagent/carbondioxide/expose_turf(turf/open/exposed_turf, reac_volume)
	if(istype(exposed_turf))
		var/temp = holder ? holder.chem_temp : T20C
		exposed_turf.atmos_spawn_air(GAS_CO2, reac_volume / REAGENT_GAS_EXCHANGE_FACTOR, temp)
	return ..()

/datum/reagent/chlorine
	name = "Chlorine"
	description = "A pale yellow gas that's well known as an oxidizer. While it forms many harmless molecules in its elemental form it is far from harmless."
	reagent_state = GAS
	color = "#FFFB89" //pale yellow? let's make it light gray
	taste_description = "chlorine"



// You're an idiot for thinking that one of the most corrosive and deadly gasses would be beneficial
/datum/reagent/chlorine/on_hydroponics_apply(datum/plant_tick/plant_tick, datum/reagents/chems, volume, obj/machinery/hydroponics/mytray, mob/user)
	if(volume >= 1)
		plant_tick.tox_damage += 5

/datum/reagent/chlorine/affect_blood(mob/living/carbon/C, removed)
	C.adjustToxLoss(3 * removed, FALSE, cause_of_death = "Chlorine poisoning")
	. = TRUE

/datum/reagent/calcium
	name = "Calcium"
	description = "A white metallic element."
	color = "#FFFFFF"
	reagent_state = SOLID

/datum/reagent/helium
	name = "Helium"
	description = "Does not make any sound."
	reagent_state = GAS
	color = "#ffffa099"

/datum/reagent/nickel
	name = "Nickel"
	description = "Contrary to popular belief, this is not a currency."
	reagent_state = SOLID
	color = "#dcdcdc"

/datum/reagent/copper
	name = "Copper"
	description = "A highly ductile metal. Things made out of copper aren't very durable, but it makes a decent material for electrical wiring."
	reagent_state = SOLID
	color = "#6E3B08" // rgb: 110, 59, 8
	taste_description = "metal"


/datum/reagent/copper/expose_obj(obj/exposed_obj, reac_volume, exposed_temperature)
	. = ..()
	if(!istype(exposed_obj, /obj/item/stack/sheet/iron))
		return

	var/obj/item/stack/sheet/iron/M = exposed_obj
	reac_volume = min(reac_volume, M.amount)
	new/obj/item/stack/sheet/bronze(get_turf(M), reac_volume)
	M.use(reac_volume)

/datum/reagent/silver
	name = "Silver"
	description = "A soft, white, lustrous transition metal, it has the highest electrical conductivity of any element and the highest thermal conductivity of any metal."
	reagent_state = SOLID
	color = "#D0D0D0" // rgb: 208, 208, 208
	taste_description = "expensive yet reasonable metal"
	material = /datum/material/silver

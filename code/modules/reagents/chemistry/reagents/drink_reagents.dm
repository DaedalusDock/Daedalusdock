

/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////// DRINKS BELOW, Beer is up there though, along with cola. Cap'n Pete's Cuban Spiced Rum////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/reagent/consumable/orangejuice
	name = "Orange Juice"
	description = "Both delicious AND rich in Vitamin C, what more do you need?"
	color = "#E78108" // rgb: 231, 129, 8
	taste_description = "oranges"
	glass_icon_state = "glass_orange"
	glass_name = "glass of orange juice"
	glass_desc = "Vitamins! Yay!"


/datum/reagent/consumable/orangejuice/affect_blood(mob/living/carbon/C, removed)
	if(prob(30) && C.getOxyLoss())
		C.adjustOxyLoss(-2 * removed, 0)
		. = TRUE

/datum/reagent/consumable/tomatojuice
	name = "Tomato Juice"
	description = "Tomatoes made into juice. What a waste of big, juicy tomatoes, huh?"
	color = "#731008" // rgb: 115, 16, 8
	taste_description = "tomatoes"
	glass_icon_state = "glass_red"
	glass_name = "glass of tomato juice"
	glass_desc = "Are you sure this is tomato juice?"


/datum/reagent/consumable/tomatojuice/affect_blood(mob/living/carbon/C, removed)
	if(prob(20) && C.getFireLoss())
		C.heal_bodypart_damage(0, 1 * removed, 0)
		. = TRUE

/datum/reagent/consumable/limejuice
	name = "Lime Juice"
	description = "The sweet-sour juice of limes."
	color = "#365E30" // rgb: 54, 94, 48
	taste_description = "unbearable sourness"
	glass_icon_state = "glass_green"
	glass_name = "glass of lime juice"
	glass_desc = "A glass of sweet-sour lime juice."


/datum/reagent/consumable/limejuice/affect_blood(mob/living/carbon/C, removed)
	if(prob(20) && C.getToxLoss())
		C.adjustToxLoss(-1 * removed, 0)
		. = TRUE

/datum/reagent/consumable/carrotjuice
	name = "Carrot Juice"
	description = "It is just like a carrot but without crunching."
	color = "#973800" // rgb: 151, 56, 0
	taste_description = "carrots"
	glass_icon_state = "carrotjuice"
	glass_name = "glass of  carrot juice"
	glass_desc = "It's just like a carrot but without crunching."


/datum/reagent/consumable/carrotjuice/affect_blood(mob/living/carbon/C, removed)
	C.adjust_blurriness(-1 * removed)
	C.adjust_blindness(-1 * removed)
	switch(current_cycle)
		if(1 to 20)
			//nothing
		if(21 to 110)
			if(prob(100 * (1 - (sqrt(110 - current_cycle) / 10))))
				C.cure_nearsighted(list(EYE_DAMAGE))
		if(110 to INFINITY)
			C.cure_nearsighted(list(EYE_DAMAGE))

/datum/reagent/consumable/berryjuice
	name = "Berry Juice"
	description = "A delicious blend of several different kinds of berries."
	color = "#863333" // rgb: 134, 51, 51
	taste_description = "berries"
	glass_icon_state = "berryjuice"
	glass_name = "glass of berry juice"
	glass_desc = "Berry juice. Or maybe it's jaC. Who cares?"


/datum/reagent/consumable/applejuice
	name = "Apple Juice"
	description = "The sweet juice of an apple, fit for all ages."
	color = "#ECFF56" // rgb: 236, 255, 86
	taste_description = "apples"

/datum/reagent/consumable/poisonberryjuice
	name = "Poison Berry Juice"
	description = "A tasty juice blended from various kinds of very deadly and toxic berries."
	color = "#863353" // rgb: 134, 51, 83
	taste_description = "berries"
	glass_icon_state = "poisonberryjuice"
	glass_name = "glass of berry juice"
	glass_desc = "Berry juice. Or maybe it's poison. Who cares?"


/datum/reagent/consumable/poisonberryjuice/affect_blood(mob/living/carbon/C, removed)
	C.adjustToxLoss(1 * removed, 0, cause_of_death = "Poison berry juice")
	. = TRUE

/datum/reagent/consumable/watermelonjuice
	name = "Watermelon Juice"
	description = "Delicious juice made from watermelon."
	color = "#863333" // rgb: 134, 51, 51
	taste_description = "juicy watermelon"
	glass_icon_state = "glass_red"
	glass_name = "glass of watermelon juice"
	glass_desc = "A glass of watermelon juice."


/datum/reagent/consumable/lemonjuice
	name = "Lemon Juice"
	description = "This juice is VERY sour."
	color = "#863333" // rgb: 175, 175, 0
	taste_description = "sourness"
	glass_icon_state = "lemonglass"
	glass_name = "glass of lemon juice"
	glass_desc = "Sour..."


/datum/reagent/consumable/banana
	name = "Banana Juice"
	description = "The raw essence of a banana. HONK"
	color = "#863333" // rgb: 175, 175, 0
	taste_description = "banana"
	glass_icon_state = "banana"
	glass_name = "glass of banana juice"
	glass_desc = "The raw essence of a banana. HONK."


/datum/reagent/consumable/banana/affect_blood(mob/living/carbon/C, removed)
	var/obj/item/organ/liver/liver = C.getorganslot(ORGAN_SLOT_LIVER)
	if((liver && HAS_TRAIT(liver, TRAIT_COMEDY_METABOLISM)) || ismonkey(C))
		C.heal_bodypart_damage(1 * removed, 1 * removed, 0)
		. = TRUE

/datum/reagent/consumable/nothing
	name = "Nothing"
	description = "Absolutely nothing."
	taste_description = "nothing"
	glass_icon_state = "nothing"
	glass_name = "nothing"
	glass_desc = "Absolutely nothing."
	shot_glass_icon_state = "shotglass"


/datum/reagent/consumable/nothing/affect_blood(mob/living/carbon/C, removed)
	if(ishuman(C) && C.mind?.miming)
		C.silent = max(C.silent, MIMEDRINK_SILENCE_DURATION)
		C.heal_bodypart_damage(1 * removed, 1 * removed)
		. = TRUE

/datum/reagent/consumable/laughter
	name = "Laughter"
	description = "Some say that this is the best medicine, but recent studies have proven that to be untrue."
	metabolization_rate = INFINITY
	color = "#FF4DD2"
	taste_description = "laughter"
	ingest_met = INFINITY

/datum/reagent/consumable/laughter/affect_blood(mob/living/carbon/C, removed)
	spawn(-1)
		C.emote("laugh")

/datum/reagent/consumable/superlaughter
	name = "Super Laughter"
	description = "Funny until you're the one laughing."
	metabolization_rate = 0.3
	color = "#FF4DD2"
	taste_description = "laughter"

/datum/reagent/consumable/superlaughter/affect_blood(mob/living/carbon/C, removed)
	if(prob(10))
		C.visible_message(span_danger("[C] bursts out into a fit of uncontrollable laughter!"), span_userdanger("You burst out in a fit of uncontrollable laughter!"))
		C.Stun(5)

/datum/reagent/consumable/potato_juice
	name = "Potato Juice"
	description = "Juice of the potato. Bleh."
	nutriment_factor = 2 * REAGENTS_METABOLISM
	color = "#302000" // rgb: 48, 32, 0
	taste_description = "irish sadness"
	glass_icon_state = "glass_brown"
	glass_name = "glass of potato juice"
	glass_desc = "Bleh..."


/datum/reagent/consumable/grapejuice
	name = "Grape Juice"
	description = "The juice of a bunch of grapes. Guaranteed non-alcoholic."
	color = "#290029" // dark purple
	taste_description = "grape soda"


/datum/reagent/consumable/milk
	name = "Milk"
	description = "An opaque white liquid produced by the mammary glands of mammals."
	color = "#DFDFDF" // rgb: 223, 223, 223
	taste_description = "milk"
	glass_icon_state = "glass_white"
	glass_name = "glass of milk"
	glass_desc = "White and nutritious goodness!"


	// Milk is good for humans, but bad for plants. The sugars cannot be used by plants, and the milk fat harms growth. Not shrooms though. I can't deal with this now...
/datum/reagent/consumable/milk/on_hydroponics_apply(datum/plant_tick/plant_tick, datum/reagents/chems, volume, obj/machinery/hydroponics/mytray, mob/user)
	if(volume >= 1)
		plant_tick.potency_mod -= 0.2

/datum/reagent/consumable/milk/affect_ingest(mob/living/carbon/C, removed)
	if(C.getBruteLoss() && prob(20))
		C.heal_bodypart_damage(1 * removed,0, 0)
		. = TRUE

	if(holder.has_reagent(/datum/reagent/consumable/capsaicin))
		holder.remove_reagent(/datum/reagent/consumable/capsaicin, 1 * removed)

	return ..() || .

/datum/reagent/consumable/soymilk
	name = "Soy Milk"
	description = "An opaque white liquid made from soybeans."
	color = "#DFDFC7" // rgb: 223, 223, 199
	taste_description = "soy milk"
	glass_icon_state = "glass_white"
	glass_name = "glass of soy milk"
	glass_desc = "White and nutritious soy goodness!"


/datum/reagent/consumable/soymilk/affect_ingest(mob/living/carbon/C, removed)
	if(C.getBruteLoss() && prob(10))
		C.heal_bodypart_damage(0.5, 0, 0)
		. = TRUE

	return ..() || .
/datum/reagent/consumable/cream
	name = "Cream"
	description = "The fatty, still liquid part of milk. Why don't you mix this with sum scotch, eh?"
	color = "#DFD7AF" // rgb: 223, 215, 175
	taste_description = "creamy milk"
	glass_icon_state = "glass_white"
	glass_name = "glass of cream"
	glass_desc = "Ewwww..."


/datum/reagent/consumable/cream/affect_ingest(mob/living/carbon/C, removed)
	if(C.getBruteLoss() && prob(20))
		C.heal_bodypart_damage(0.5 * removed, 0, 0)
		. = TRUE
	return ..() || .

/datum/reagent/consumable/coffee
	name = "Coffee"
	description = "Coffee is a brewed drink prepared from roasted seeds, commonly called coffee beans, of the coffee plant."
	color = "#482000" // rgb: 72, 32, 0
	nutriment_factor = 0
	overdose_threshold = 80
	taste_description = "bitterness"
	glass_icon_state = "glass_brown"
	glass_name = "glass of coffee"
	glass_desc = "Don't drop it, or you'll send scalding liquid and glass shards everywhere."

	glass_price = DRINK_PRICE_STOCK

/datum/reagent/consumable/coffee/overdose_process(mob/living/carbon/C)
	C.set_timed_status_effect(10 SECONDS, /datum/status_effect/jitter, only_if_higher = TRUE)

/datum/reagent/consumable/coffee/affect_ingest(mob/living/carbon/C, removed)
	C.adjust_timed_status_effect(-10 SECONDS * removed, /datum/status_effect/dizziness)
	C.adjust_drowsyness(-3 * removed)
	C.AdjustSleeping(-40 * removed)
	//310.15 is the normal bodytemp.
	C.adjust_bodytemperature(25 * TEMPERATURE_DAMAGE_COEFFICIENT * removed, 0, C.get_body_temp_normal())
	if(holder.has_reagent(/datum/reagent/consumable/frostoil))
		holder.remove_reagent(/datum/reagent/consumable/frostoil, 5 * removed)
	return ..() || TRUE

/datum/reagent/consumable/tea
	name = "Tea"
	description = "Tasty black tea, it has antioxidants, it's good for you!"
	color = "#101000" // rgb: 16, 16, 0
	nutriment_factor = 0
	taste_description = "tart black tea"
	glass_icon_state = "teaglass"
	glass_name = "glass of tea"
	glass_desc = "Drinking it from here would not seem right."

	glass_price = DRINK_PRICE_STOCK

/datum/reagent/consumable/tea/affect_ingest(mob/living/carbon/C, removed)
	C.adjust_timed_status_effect(-4 SECONDS * removed, /datum/status_effect/dizziness)
	C.adjust_drowsyness(-1 * removed)
	C.adjust_timed_status_effect(-6 SECONDS * removed, /datum/status_effect/jitter)
	C.AdjustSleeping(-20 * removed)
	if(C.getToxLoss() && prob(20))
		C.adjustToxLoss(-1, 0)
		. = TRUE
	C.adjust_bodytemperature(20  * TEMPERATURE_DAMAGE_COEFFICIENT * removed, 0, C.get_body_temp_normal())
	return ..() || .

/datum/reagent/consumable/lemonade
	name = "Lemonade"
	description = "Sweet, tangy lemonade. Good for the soul."
	color = "#FFE978"
	quality = DRINK_NICE
	taste_description = "sunshine and summertime"
	glass_icon_state = "lemonpitcher"
	glass_name = "pitcher of lemonade"
	glass_desc = "This drink leaves you feeling nostalgic for some reason."

	glass_price = DRINK_PRICE_EASY

/datum/reagent/consumable/tea/arnold_palmer
	name = "Arnold Palmer"
	description = "Encourages the patient to go golfing."
	color = "#FFB766"
	quality = DRINK_NICE
	nutriment_factor = 10 * REAGENTS_METABOLISM
	taste_description = "bitter tea"
	glass_icon_state = "arnold_palmer"
	glass_name = "Arnold Palmer"
	glass_desc = "You feel like taking a few golf swings after a few swigs of this."


/datum/reagent/consumable/tea/arnold_palmer/affect_blood(mob/living/carbon/C, removed)
	if(prob(5))
		to_chat(C, span_notice("[pick("You remember to square your shoulders.","You remember to keep your head down.","You can't decide between squaring your shoulders and keeping your head down.","You remember to relax.","You think about how someday you'll get two strokes off your golf game.")]"))

/datum/reagent/consumable/icecoffee
	name = "Iced Coffee"
	description = "Coffee and ice, refreshing and cool."
	color = "#102838" // rgb: 16, 40, 56
	nutriment_factor = 0
	taste_description = "bitter coldness"
	glass_icon_state = "icedcoffeeglass"
	glass_name = "iced coffee"
	glass_desc = "A drink to perk you up and refresh you!"


/datum/reagent/consumable/icecoffee/affect_ingest(mob/living/carbon/C, removed)
	C.adjust_timed_status_effect(-10 SECONDS * removed, /datum/status_effect/dizziness)
	C.adjust_drowsyness(-3 * removed)
	C.AdjustSleeping(-40 * removed)
	C.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT * removed, C.get_body_temp_normal())
	C.set_timed_status_effect(10 SECONDS * removed, /datum/status_effect/jitter, only_if_higher = TRUE)
	return ..()

/datum/reagent/consumable/icetea
	name = "Iced Tea"
	description = "No relation to a certain rap artist/actor."
	color = "#104038" // rgb: 16, 64, 56
	nutriment_factor = 0
	taste_description = "sweet tea"
	glass_icon_state = "icedteaglass"
	glass_name = "iced tea"
	glass_desc = "All natural, antioxidant-rich flavour sensation."


/datum/reagent/consumable/icetea/affect_blood(mob/living/carbon/C, removed)
	C.adjust_timed_status_effect(-4 SECONDS * removed, /datum/status_effect/dizziness)
	C.adjust_drowsyness(-1 * removed)
	C.AdjustSleeping(-40 * removed)
	if(C.getToxLoss() && prob(10))
		C.adjustToxLoss(-1, 0)
		. = TRUE
	C.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT * removed, C.get_body_temp_normal())

/datum/reagent/consumable/space_cola
	name = "Cola"
	description = "A refreshing beverage."
	color = "#100800" // rgb: 16, 8, 0
	taste_description = "cola"
	glass_icon_state = "spacecola"
	glass_name = "glass of Space Cola"
	glass_desc = "A glass of refreshing Space Cola."


/datum/reagent/consumable/space_cola/affect_ingest(mob/living/carbon/C, removed)
	C.adjust_drowsyness(-5 * removed)
	C.adjust_bodytemperature(-5 * removed * TEMPERATURE_DAMAGE_COEFFICIENT, C.get_body_temp_normal())
	return ..()

/datum/reagent/consumable/roy_rogers
	name = "Roy Rogers"
	description = "A sweet fizzy drink."
	color = "#53090B"
	quality = DRINK_GOOD
	taste_description = "fruity overlysweet cola"
	glass_icon_state = "royrogers"
	glass_name = "Roy Rogers"
	glass_desc = "90% sugar in a glass."


/datum/reagent/consumable/roy_rogers/affect_ingest(mob/living/carbon/C, removed)
	C.set_timed_status_effect(12 SECONDS * removed, /datum/status_effect/jitter, only_if_higher = TRUE)
	C.adjust_drowsyness(-5 * removed)
	C.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT * removed, C.get_body_temp_normal())
	return ..()

/datum/reagent/consumable/nuka_cola
	name = "Nuka Cola"
	description = "Cola, cola never changes."
	color = "#100800" // rgb: 16, 8, 0
	quality = DRINK_VERYGOOD
	taste_description = "the future"
	glass_icon_state = "nuka_colaglass"
	glass_name = "glass of Nuka Cola"
	glass_desc = "Don't cry, Don't raise your eye, It's only nuclear wasteland."


/datum/reagent/consumable/nuka_cola/on_mob_metabolize(mob/living/carbon/C, class)
	if(class != CHEM_TOUCH)
		C.add_movespeed_modifier(/datum/movespeed_modifier/reagent/nuka_cola)

/datum/reagent/consumable/nuka_cola/on_mob_end_metabolize(mob/living/carbon/C, class)
	if(class != CHEM_TOUCH)
		C.remove_movespeed_modifier(/datum/movespeed_modifier/reagent/nuka_cola)

/datum/reagent/consumable/nuka_cola/affect_ingest(mob/living/carbon/C, removed)
	C.set_timed_status_effect(40 SECONDS * removed, /datum/status_effect/jitter, only_if_higher = TRUE)
	C.set_timed_status_effect(1 MINUTES * removed, /datum/status_effect/drugginess)
	C.adjust_timed_status_effect(3 SECONDS * removed, /datum/status_effect/dizziness)
	C.set_drowsyness(0)
	C.AdjustSleeping(-40 * removed)
	C.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT * removed, C.get_body_temp_normal())
	return ..()

/datum/reagent/consumable/rootbeer
	name = "root beer"
	description = "A delightfully bubbly root beer, filled with so much sugar that it can actually speed up the user's trigger finger."
	color = "#181008" // rgb: 24, 16, 8
	quality = DRINK_VERYGOOD
	nutriment_factor = 10 * REAGENTS_METABOLISM
	ingest_met = 0.4
	taste_description = "a monstrous sugar rush"
	glass_icon_state = "spacecola"
	glass_name = "glass of root beer"
	glass_desc = "A glass of highly potent, incredibly sugary root beer."

	/// If we activated the effect
	var/effect_enabled = FALSE


/datum/reagent/consumable/rootbeer/on_mob_end_metabolize(mob/living/carbon/C, class)
	if(class != CHEM_INGEST)
		return

	REMOVE_TRAIT(C, TRAIT_DOUBLE_TAP, type)
	if(current_cycle > 10)
		to_chat(C, span_warning("You feel kinda tired as your sugar rush wears off..."))
		C.stamina.adjust(-1 * min(80, current_cycle * 3))
		C.adjust_drowsyness(current_cycle)

/datum/reagent/consumable/rootbeer/affect_ingest(mob/living/carbon/C, removed)
	if(current_cycle >= 3 && !effect_enabled) // takes a few seconds for the bonus to kick in to prevent microdosing
		to_chat(C, span_notice("You feel your trigger finger getting itchy..."))
		ADD_TRAIT(C, TRAIT_DOUBLE_TAP, type)
		effect_enabled = TRUE

	C.set_timed_status_effect(4 SECONDS * removed, /datum/status_effect/jitter, only_if_higher = TRUE)
	if(prob(50))
		C.adjust_timed_status_effect(2 SECONDS * removed, /datum/status_effect/dizziness)
	if(current_cycle > 10)
		C.adjust_timed_status_effect(3 SECONDS * removed, /datum/status_effect/dizziness)
	return..()

/datum/reagent/consumable/grey_bull
	name = "Grey Bull"
	description = "Grey Bull, it gives you gloves!"
	color = "#EEFF00" // rgb: 238, 255, 0
	quality = DRINK_VERYGOOD
	taste_description = "carbonated oil"
	glass_icon_state = "grey_bull_glass"
	glass_name = "glass of Grey Bull"
	glass_desc = "Surprisingly it isn't grey."


/datum/reagent/consumable/grey_bull/on_mob_metabolize(mob/living/carbon/C, class)
	ADD_TRAIT(C, TRAIT_SHOCKIMMUNE, CHEM_TRAIT_SOURCE(class))

/datum/reagent/consumable/grey_bull/on_mob_end_metabolize(mob/living/carbon/C, class)
	REMOVE_TRAIT(C, TRAIT_SHOCKIMMUNE, CHEM_TRAIT_SOURCE(class))

/datum/reagent/consumable/grey_bull/affect_ingest(mob/living/carbon/C, removed)
	C.set_timed_status_effect(40 SECONDS * removed, /datum/status_effect/jitter, only_if_higher = TRUE)
	C.adjust_timed_status_effect(2 SECONDS * removed, /datum/status_effect/dizziness)
	C.set_drowsyness(0)
	C.AdjustSleeping(-40 * removed)
	C.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT * removed, C.get_body_temp_normal())
	return ..()

/datum/reagent/consumable/spacemountainwind
	name = "SM Wind"
	description = "Blows right through you like a space wind."
	color = "#102000" // rgb: 16, 32, 0
	taste_description = "sweet citrus soda"
	glass_icon_state = "Space_mountain_wind_glass"
	glass_name = "glass of Space Mountain Wind"
	glass_desc = "Space Mountain Wind. As you know, there are no mountains in space, only wind."


/datum/reagent/consumable/spacemountainwind/affect_ingest(mob/living/carbon/C, removed)
	C.adjust_drowsyness(-7 * removed)
	C.AdjustSleeping(-20 * removed)
	C.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT * removed, C.get_body_temp_normal())
	C.set_timed_status_effect(10 SECONDS * removed, /datum/status_effect/jitter, only_if_higher = TRUE)
	return ..()

/datum/reagent/consumable/dr_gibb
	name = "Dr. Gibb"
	description = "A delicious blend of 42 different flavours."
	color = "#102000" // rgb: 16, 32, 0
	taste_description = "cherry soda" // FALSE ADVERTISING
	glass_icon_state = "dr_gibb_glass"
	glass_name = "glass of Dr. Gibb"
	glass_desc = "Dr. Gibb. Not as dangerous as the glass_name might imply."


/datum/reagent/consumable/dr_gibb/affect_ingest(mob/living/carbon/C, removed)
	C.adjust_drowsyness(-6 * removed)
	C.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT * removed, C.get_body_temp_normal())
	return ..()
/datum/reagent/consumable/space_up
	name = "Space-Up"
	description = "Tastes like a hull breach in your mouth."
	color = "#00FF00" // rgb: 0, 255, 0
	taste_description = "cherry soda"
	glass_icon_state = "space-up_glass"
	glass_name = "glass of Space-Up"
	glass_desc = "Space-up. It helps you keep your cool."



/datum/reagent/consumable/space_up/affect_ingest(mob/living/carbon/C, removed)
	C.adjust_bodytemperature(-8 * removed * TEMPERATURE_DAMAGE_COEFFICIENT, C.get_body_temp_normal())
	return ..()

/datum/reagent/consumable/lemon_lime
	name = "Lemon Lime"
	description = "A tangy substance made of 0.5% natural citrus!"
	color = "#8CFF00" // rgb: 135, 255, 0
	taste_description = "tangy lime and lemon soda"
	glass_icon_state = "lemonlime"
	glass_name = "glass of lemon-lime"
	glass_desc = "You're pretty certain a real fruit has never actually touched this."


/datum/reagent/consumable/lemon_lime/affect_ingest(mob/living/carbon/C, removed)
	C.adjust_bodytemperature(-8 * removed * TEMPERATURE_DAMAGE_COEFFICIENT, C.get_body_temp_normal())
	return ..()

/datum/reagent/consumable/shamblers
	name = "Shambler's Juice"
	description = "~Shake me up some of that Shambler's Juice!~"
	color = "#f00060" // rgb: 94, 0, 38
	taste_description = "carbonated metallic soda"
	glass_icon_state = "shamblerjuice"
	glass_name = "glass of Shambler's juice"
	glass_desc = "Mmm mm, shambly."


/datum/reagent/consumable/shamblers/affect_ingest(mob/living/carbon/C, removed)
	C.adjust_bodytemperature(-8 * TEMPERATURE_DAMAGE_COEFFICIENT * removed, C.get_body_temp_normal())
	return ..()

/datum/reagent/consumable/sodawater
	name = "Soda Water"
	description = "A can of club soda. Why not make a scotch and soda?"
	color = "#619494" // rgb: 97, 148, 148
	taste_description = "carbonated water"
	glass_icon_state = "glass_clearcarb"
	glass_name = "glass of soda water"
	glass_desc = "Soda water. Why not make a scotch and soda?"



// A variety of nutrients are dissolved in club soda, without sugar.
// These nutrients include carbon, oxygen, hydrogen, phosphorous, potassium, sulfur and sodium, all of which are needed for healthy plant growth.
/datum/reagent/consumable/sodawater/on_hydroponics_apply(datum/plant_tick/plant_tick, datum/reagents/chems, volume, obj/machinery/hydroponics/mytray, mob/user)
	if(volume >= 1)
		plant_tick.plant_health_delta += 0.2

/datum/reagent/consumable/sodawater/affect_ingest(mob/living/carbon/C, removed)
	C.adjust_timed_status_effect(-10 SECONDS * removed, /datum/status_effect/dizziness)
	C.adjust_drowsyness(-3 * removed)
	C.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT * removed, C.get_body_temp_normal())
	return ..()

/datum/reagent/consumable/tonic
	name = "Tonic Water"
	description = "It tastes strange but at least the quinine keeps the Space Malaria at bay."
	color = "#0064C8" // rgb: 0, 100, 200
	taste_description = "tart and fresh"
	glass_icon_state = "glass_clearcarb"
	glass_name = "glass of tonic water"
	glass_desc = "Quinine tastes funny, but at least it'll keep that Space Malaria away."


/datum/reagent/consumable/tonic/affect_ingest(mob/living/carbon/C, removed)
	C.adjust_timed_status_effect(-10 SECONDS * removed, /datum/status_effect/dizziness)
	C.adjust_drowsyness(-3 * removed)
	C.AdjustSleeping(-40 * removed)
	C.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT * removed, C.get_body_temp_normal())
	return ..()

/datum/reagent/consumable/monkey_energy
	name = "Monkey Energy"
	description = "The only drink that will make you unleash the ape."
	color = "#f39b03" // rgb: 243, 155, 3
	overdose_threshold = 60
	taste_description = "barbecue and nostalgia"
	glass_icon_state = "monkey_energy_glass"
	glass_name = "glass of Monkey Energy"
	glass_desc = "You can unleash the ape, but without the pop of the can?"


/datum/reagent/consumable/monkey_energy/affect_ingest(mob/living/carbon/C, removed)
	C.set_timed_status_effect(80 SECONDS * removed, /datum/status_effect/jitter, only_if_higher = TRUE)
	C.adjust_timed_status_effect(2 SECONDS * removed, /datum/status_effect/dizziness)
	C.set_drowsyness(0)
	C.AdjustSleeping(-40 * removed)
	C.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT * removed, C.get_body_temp_normal())
	return ..()

/datum/reagent/consumable/monkey_energy/on_mob_metabolize(mob/living/carbon/C, class)
	if(class == CHEM_TOUCH)
		return
	if(ismonkey(C))
		C.add_movespeed_modifier(/datum/movespeed_modifier/reagent/monkey_energy)

/datum/reagent/consumable/monkey_energy/on_mob_end_metabolize(mob/living/carbon/C, class)
	if(class == CHEM_TOUCH)
		return
	C.remove_movespeed_modifier(/datum/movespeed_modifier/reagent/monkey_energy)

/datum/reagent/consumable/monkey_energy/overdose_process(mob/living/carbon/C)
	if(prob(15))
		spawn(-1)
			C.say(pick_list_replacements(BOOMER_FILE, "boomer"), forced = /datum/reagent/consumable/monkey_energy)

/datum/reagent/consumable/ice
	name = "Ice"
	description = "Frozen water, your dentist wouldn't like you chewing this."
	reagent_state = SOLID
	color = "#619494" // rgb: 97, 148, 148
	taste_description = "ice"
	glass_icon_state = "iceglass"
	glass_name = "glass of ice"
	glass_desc = "Generally, you're supposed to put something else in there too..."


/datum/reagent/consumable/ice/affect_ingest(mob/living/carbon/C, removed)
	C.adjust_bodytemperature(-3  * TEMPERATURE_DAMAGE_COEFFICIENT * removed, C.get_body_temp_normal())
	return ..()

/datum/reagent/consumable/ice/affect_blood(mob/living/carbon/C, removed)
	C.adjust_bodytemperature(-3  * TEMPERATURE_DAMAGE_COEFFICIENT * removed, C.get_body_temp_normal())

/datum/reagent/consumable/ice/affect_touch(mob/living/carbon/C, removed)
	C.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT * removed, C.get_body_temp_normal())
/datum/reagent/consumable/soy_latte
	name = "Soy Latte"
	description = "A nice and tasty beverage while you are reading your hippie books."
	color = "#cc6404" // rgb: 204,100,4
	quality = DRINK_NICE
	taste_description = "creamy coffee"
	glass_icon_state = "soy_latte"
	glass_name = "soy latte"
	glass_desc = "A nice and refreshing beverage while you're reading."

	glass_price = DRINK_PRICE_EASY

/datum/reagent/consumable/soy_latte/affect_ingest(mob/living/carbon/C, removed)
	C.adjust_timed_status_effect(-10 SECONDS * removed, /datum/status_effect/dizziness)
	C.adjust_drowsyness(-3 * removed)
	C.SetSleeping(0)
	C.adjust_bodytemperature(5 * TEMPERATURE_DAMAGE_COEFFICIENT * removed, 0, C.get_body_temp_normal())
	C.set_timed_status_effect(10 SECONDS * removed, /datum/status_effect/jitter, only_if_higher = TRUE)
	return ..() || TRUE
/datum/reagent/consumable/cafe_latte
	name = "Cafe Latte"
	description = "A nice, strong and tasty beverage while you are reading."
	color = "#cc6404" // rgb: 204,100,4
	quality = DRINK_NICE
	taste_description = "bitter cream"
	glass_icon_state = "cafe_latte"
	glass_name = "cafe latte"
	glass_desc = "A nice, strong and refreshing beverage while you're reading."

	glass_price = DRINK_PRICE_EASY

/datum/reagent/consumable/cafe_latte/affect_ingest(mob/living/carbon/C, removed)
	C.adjust_timed_status_effect(-10 SECONDS * removed, /datum/status_effect/dizziness)
	C.adjust_drowsyness(-6 * removed)
	C.SetSleeping(0)
	C.adjust_bodytemperature(5 * TEMPERATURE_DAMAGE_COEFFICIENT * removed, 0, C.get_body_temp_normal())
	C.set_timed_status_effect(10 SECONDS * removed, /datum/status_effect/jitter, only_if_higher = TRUE)
	return ..()

/datum/reagent/consumable/doctor_delight
	name = "The Doctor's Delight"
	description = "A gulp a day keeps the Medibot away! A mixture of juices that heals most damage types fairly quickly at the cost of hunger."
	color = "#FF8CFF" // rgb: 255, 140, 255
	quality = DRINK_VERYGOOD
	taste_description = "homely fruit"
	glass_icon_state = "doctorsdelightglass"
	glass_name = "Doctor's Delight"
	glass_desc = "The space doctor's favorite. Guaranteed to restore bodily injury; side effects include cravings and hunger."


/datum/reagent/consumable/doctor_delight/affect_blood(mob/living/carbon/C, removed)
	C.adjustBruteLoss(-0.5 * removed, 0)
	C.adjustFireLoss(-0.5 * removed, 0)
	C.adjustToxLoss(-0.5 * removed, 0)
	C.adjustOxyLoss(-0.5 * removed, 0)
	if(C.nutrition && (C.nutrition - 2 > 0))
		var/obj/item/organ/liver/liver = C.getorganslot(ORGAN_SLOT_LIVER)
		if(!(HAS_TRAIT(liver, TRAIT_MEDICAL_METABOLISM)))
			// Drains the nutrition of the holder. Not medical doctors though, since it's the Doctor's Delight!
			C.adjust_nutrition(-2 * removed)
	return TRUE

/datum/reagent/consumable/cinderella
	name = "Cinderella"
	description = "Most definitely a fruity alcohol cocktail to have while partying with your friends."
	color = "#FF6A50"
	quality = DRINK_VERYGOOD
	taste_description = "sweet tangy fruit"
	glass_icon_state = "cinderella"
	glass_name = "Cinderella"
	glass_desc = "There is not a single drop of alcohol in this thing."


/datum/reagent/consumable/cinderella/affect_ingest(mob/living/carbon/C, removed)
	C.adjust_disgust(-5 * removed)
	return ..()

/datum/reagent/consumable/cherryshake
	name = "Cherry Shake"
	description = "A cherry flavored milkshake."
	color = "#FFB6C1"
	quality = DRINK_VERYGOOD
	nutriment_factor = 8 * REAGENTS_METABOLISM
	taste_description = "creamy tart cherry"
	glass_icon_state = "cherryshake"
	glass_name = "cherry shake"
	glass_desc = "A cherry flavored milkshake."

	glass_price = DRINK_PRICE_MEDIUM

/datum/reagent/consumable/bluecherryshake
	name = "Blue Cherry Shake"
	description = "An exotic milkshake."
	color = "#00F1FF"
	quality = DRINK_VERYGOOD
	nutriment_factor = 8 * REAGENTS_METABOLISM
	taste_description = "creamy blue cherry"
	glass_icon_state = "bluecherryshake"
	glass_name = "blue cherry shake"
	glass_desc = "An exotic blue milkshake."


/datum/reagent/consumable/vanillashake
	name = "Vanilla Shake"
	description = "A vanilla flavored milkshake. The basics are still good."
	color = "#E9D2B2"
	quality = DRINK_VERYGOOD
	nutriment_factor = 8 * REAGENTS_METABOLISM
	taste_description = "sweet creamy vanilla"
	glass_icon_state = "vanillashake"
	glass_name = "vanilla shake"
	glass_desc = "A vanilla flavored milkshake."

	glass_price = DRINK_PRICE_MEDIUM

/datum/reagent/consumable/caramelshake
	name = "Caramel Shake"
	description = "A caramel flavored milkshake. Your teeth hurt looking at it."
	color = "#E17C00"
	quality = DRINK_GOOD
	nutriment_factor = 10 * REAGENTS_METABOLISM
	taste_description = "sweet rich creamy caramel"
	glass_icon_state = "caramelshake"
	glass_name = "caramel shake"
	glass_desc = "A caramel flavored milkshake."

	glass_price = DRINK_PRICE_MEDIUM

/datum/reagent/consumable/choccyshake
	name = "Chocolate Shake"
	description = "A frosty chocolate milkshake."
	color = "#541B00"
	quality = DRINK_VERYGOOD
	nutriment_factor = 8 * REAGENTS_METABOLISM
	taste_description = "sweet creamy chocolate"
	glass_icon_state = "choccyshake"
	glass_name = "chocolate shake"
	glass_desc = "A chocolate flavored milkshake."

	glass_price = DRINK_PRICE_MEDIUM

/datum/reagent/consumable/pumpkin_latte
	name = "Pumpkin Latte"
	description = "A mix of pumpkin juice and coffee."
	color = "#F4A460"
	quality = DRINK_VERYGOOD
	nutriment_factor = 3 * REAGENTS_METABOLISM
	taste_description = "creamy pumpkin"
	glass_icon_state = "pumpkin_latte"
	glass_name = "pumpkin latte"
	glass_desc = "A mix of coffee and pumpkin juice."


/datum/reagent/consumable/gibbfloats
	name = "Gibb Floats"
	description = "Ice cream on top of a Dr. Gibb glass."
	color = "#B22222"
	quality = DRINK_NICE
	nutriment_factor = 3 * REAGENTS_METABOLISM
	taste_description = "creamy cherry"
	glass_icon_state = "gibbfloats"
	glass_name = "Gibbfloat"
	glass_desc = "Dr. Gibb with ice cream on top."


/datum/reagent/consumable/pumpkinjuice
	name = "Pumpkin Juice"
	description = "Juiced from real pumpkin."
	color = "#FFA500"
	taste_description = "pumpkin"


/datum/reagent/consumable/blumpkinjuice
	name = "Blumpkin Juice"
	description = "Juiced from real blumpkin."
	color = "#00BFFF"
	taste_description = "a mouthful of pool water"


/datum/reagent/consumable/triple_citrus
	name = "Triple Citrus"
	description = "A solution."
	color = "#EEFF00"
	quality = DRINK_NICE
	taste_description = "extreme bitterness"
	glass_icon_state = "triplecitrus" //needs own sprite mine are trash //your sprite is great tho
	glass_name = "glass of triple citrus"
	glass_desc = "A mixture of citrus juices. Tangy, yet smooth."


/datum/reagent/consumable/grape_soda
	name = "Grape Soda"
	description = "Beloved by children and teetotalers."
	color = "#E6CDFF"
	taste_description = "grape soda"
	glass_name = "glass of grape juice"
	glass_desc = "It's grape (soda)!"


/datum/reagent/consumable/grape_soda/affect_ingest(mob/living/carbon/C, removed)
	C.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT * removed, C.get_body_temp_normal())
	return ..()

/datum/reagent/consumable/milk/chocolate_milk
	name = "Chocolate Milk"
	description = "Milk for cool kids."
	color = "#7D4E29"
	quality = DRINK_NICE
	taste_description = "chocolate milk"


/datum/reagent/consumable/hot_coco
	name = "Hot Coco"
	description = "Made with love! And coco beans."
	nutriment_factor = 4 * REAGENTS_METABOLISM
	color = "#403010" // rgb: 64, 48, 16
	taste_description = "creamy chocolate"
	glass_icon_state = "chocolateglass"
	glass_name = "glass of hot coco"
	glass_desc = "A favorite winter drink to warm you up."


/datum/reagent/consumable/hot_coco/affect_ingest(mob/living/carbon/C, removed)
	C.adjust_bodytemperature(5 * TEMPERATURE_DAMAGE_COEFFICIENT * removed, 0, C.get_body_temp_normal())
	if(C.getBruteLoss() && prob(20))
		C.heal_bodypart_damage(1, 0, 0)
		. = TRUE
	if(holder.has_reagent(/datum/reagent/consumable/capsaicin))
		holder.remove_reagent(/datum/reagent/consumable/capsaicin, 2 * removed)
	return ..() || .

/datum/reagent/consumable/italian_coco
	name = "Italian Hot Chocolate"
	description = "Made with love! You can just imagine a happy Nonna from the smell."
	nutriment_factor = 8 * REAGENTS_METABOLISM
	color = "#57372A"
	quality = DRINK_VERYGOOD
	taste_description = "thick creamy chocolate"
	glass_icon_state = "italiancoco"
	glass_name = "glass of italian coco"
	glass_desc = "A spin on a winter favourite, made to please."


/datum/reagent/consumable/italian_coco/affect_ingest(mob/living/carbon/C, removed)
	C.adjust_bodytemperature(5 * TEMPERATURE_DAMAGE_COEFFICIENT * removed, 0, C.get_body_temp_normal())
	return ..()

/datum/reagent/consumable/menthol
	name = "Menthol"
	description = "Alleviates coughing symptoms one might have."
	color = "#80AF9C"
	taste_description = "mint"
	glass_icon_state = "glass_green"
	glass_name = "glass of menthol"
	glass_desc = "Tastes naturally minty, and imparts a very mild numbing sensation."


/datum/reagent/consumable/menthol/affect_ingest(mob/living/carbon/C, removed)
	C.apply_status_effect(/datum/status_effect/throat_soothed)
	return ..()

/datum/reagent/consumable/grenadine
	name = "Grenadine"
	description = "Not cherry flavored!"
	color = "#EA1D26"
	taste_description = "sweet pomegranates"
	glass_name = "glass of grenadine"
	glass_desc = "Delicious flavored syrup."


/datum/reagent/consumable/parsnipjuice
	name = "Parsnip Juice"
	description = "Why..."
	color = "#FFA500"
	taste_description = "parsnip"
	glass_name = "glass of parsnip juice"


/datum/reagent/consumable/pineapplejuice
	name = "Pineapple Juice"
	description = "Tart, tropical, and hotly debated."
	color = "#F7D435"
	taste_description = "pineapple"
	glass_name = "glass of pineapple juice"
	glass_desc = "Tart, tropical, and hotly debated."


/datum/reagent/consumable/peachjuice //Intended to be extremely rare due to being the limiting ingredients in the blazaam drink
	name = "Peach Juice"
	description = "Just peachy."
	color = "#E78108"
	taste_description = "peaches"
	glass_name = "glass of peach juice"


/datum/reagent/consumable/cream_soda
	name = "Cream Soda"
	description = "A classic space-American vanilla flavored soft drink."
	color = "#dcb137"
	quality = DRINK_VERYGOOD
	taste_description = "fizzy vanilla"
	glass_icon_state = "cream_soda"
	glass_name = "Cream Soda"
	glass_desc = "A classic space-American vanilla flavored soft drink."


/datum/reagent/consumable/cream_soda/affect_blood(mob/living/carbon/C, removed)
	C.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT * removed, C.get_body_temp_normal())
	..()

/datum/reagent/consumable/sol_dry
	name = "Sol Dry"
	description = "A soothing, mellow drink made from ginger."
	color = "#f7d26a"
	quality = DRINK_NICE
	taste_description = "sweet ginger spice"
	glass_icon_state = "soldry"
	glass_name = "Sol Dry"
	glass_desc = "A soothing, mellow drink made from ginger."


/datum/reagent/consumable/sol_dry/affect_ingest(mob/living/carbon/C, removed)
	C.adjust_disgust(-5 * removed)
	return ..()

/datum/reagent/consumable/shirley_temple
	name = "Shirley Temple"
	description = "Here you go little girl, now you can drink like the adults."
	color = "#F43724"
	quality = DRINK_GOOD
	taste_description = "sweet cherry syrup and ginger spice"
	glass_icon_state = "shirleytemple"
	glass_name = "Shirley Temple"
	glass_desc = "Ginger ale with processed grenadine. "


/datum/reagent/consumable/shirley_temple/affect_ingest(mob/living/carbon/C, removed)
	C.adjust_disgust(-3 * removed)
	return ..()

/datum/reagent/consumable/red_queen
	name = "Red Queen"
	description = "DRINK ME."
	color = "#e6ddc3"
	quality = DRINK_GOOD
	taste_description = "wonder"
	glass_icon_state = "red_queen"
	glass_name = "Red Queen"
	glass_desc = "DRINK ME."
	var/current_size = RESIZE_DEFAULT_SIZE


/datum/reagent/consumable/red_queen/affect_blood(mob/living/carbon/C, removed)
	. = ..()
	if(prob(50))
		return

	var/newsize = pick(0.5, 0.75, 1, 1.50, 2)
	newsize *= RESIZE_DEFAULT_SIZE
	C.update_transform(newsize/current_size)
	current_size = newsize

	if(prob(35))
		spawn(-1)
			C.emote("sneeze")

/datum/reagent/consumable/red_queen/on_mob_end_metabolize(mob/living/carbon/C, class)
	if(class == CHEM_TOUCH)
		return

	C.update_transform(RESIZE_DEFAULT_SIZE/current_size)
	current_size = RESIZE_DEFAULT_SIZE

/datum/reagent/consumable/bungojuice
	name = "Bungo Juice"
	color = "#F9E43D"
	description = "Exotic! You feel like you are on vacation already."
	taste_description = "succulent bungo"
	glass_icon_state = "glass_yellow"
	glass_name = "glass of bungo juice"
	glass_desc = "Exotic! You feel like you are on vacation already."


/datum/reagent/consumable/prunomix
	name = "Pruno Mixture"
	color = "#E78108"
	description = "Fruit, sugar, yeast, and water pulped together into a pungent slurry."
	taste_description = "garbage"
	glass_icon_state = "glass_orange"
	glass_name = "glass of pruno mixture"
	glass_desc = "Fruit, sugar, yeast, and water pulped together into a pungent slurry."


/datum/reagent/consumable/aloejuice
	name = "Aloe Juice"
	color = "#A3C48B"
	description = "A healthy and refreshing juice."
	taste_description = "vegetable"
	glass_icon_state = "glass_yellow"
	glass_name = "glass of aloe juice"
	glass_desc = "A healthy and refreshing juice."


/datum/reagent/consumable/aloejuice/affect_ingest(mob/living/carbon/C, removed)
	if(C.getToxLoss() && prob(25))
		C.adjustToxLoss(-1, 0)
		. = TRUE
	return ..() || .
/datum/reagent/consumable/agua_fresca
	name = "Agua Fresca"
	description = "A refreshing watermelon agua fresca. Perfect on a day at the holodeck."
	color = "#D25B66"
	quality = DRINK_VERYGOOD
	taste_description = "cool refreshing watermelon"
	glass_icon_state = "aguafresca"
	glass_name = "Agua Fresca"
	glass_desc = "90% water, but still refreshing."


/datum/reagent/consumable/agua_fresca/affect_ingest(mob/living/carbon/C, removed)
	C.adjust_bodytemperature(-8 * TEMPERATURE_DAMAGE_COEFFICIENT * removed, C.get_body_temp_normal())
	if(C.getToxLoss() && prob(20))
		C.adjustToxLoss(-0.5, 0)
		. = TRUE
	return ..() || .


/datum/reagent/consumable/mushroom_tea
	name = "Mushroom Tea"
	description = "A savoury glass of tea made from polypore mushroom shavings."
	color = "#674945" // rgb: 16, 16, 0
	nutriment_factor = 0
	taste_description = "mushrooms"
	glass_icon_state = "mushroom_tea_glass"
	glass_name = "glass of mushroom tea"
	glass_desc = "Oddly savoury for a drink."


/datum/reagent/consumable/mushroom_tea/affect_ingest(mob/living/carbon/C, removed)
	if(islizard(C))
		C.adjustOxyLoss(-0.5 * removed, 0)
		. = TRUE
	return ..() || .

//Moth Stuff
/datum/reagent/consumable/toechtauese_juice
	name = "Töchtaüse Juice"
	description = "An unpleasant juice made from töchtaüse berries. Best made into a syrup, unless you enjoy pain."
	color = "#554862"
	nutriment_factor = 0
	taste_description = "fiery itchy pain"
	glass_icon_state = "toechtauese_syrup"
	glass_name = "glass of töchtaüse juice"
	glass_desc = "Raw, unadulterated töchtaüse juice. One swig will fill you with regrets."


/datum/reagent/consumable/toechtauese_syrup
	name = "Töchtaüse Syrup"
	description = "A harsh spicy and bitter syrup, made from töchtaüse berries. Useful as an ingredient, both for food and cocktails."
	color = "#554862"
	nutriment_factor = 0
	taste_description = "sugar, spice, and nothing nice"
	glass_icon_state = "toechtauese_syrup"
	glass_name = "glass of töchtaüse syrup"
	glass_desc = "Not for drinking on its own."


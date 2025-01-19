/datum/plant_tick
	/// An overall multiplier applied to everything occuring this tick.
	var/overall_multiplier = 1

	/// How much the plant is growing (or reversing) this tick.
	var/plant_growth_delta = HYDRO_BASE_GROWTH_RATE
	/// How much the plant's health is changing this tick.
	var/plant_health_delta = 0

	/// How many units of reagent to remove from the tray this tick.
	var/water_need = 0.4
	/// Plant health delta if the plant is not drowning.
	var/water_level_bonus_health = 0
	/// Plant growth delta if the plant is not drowning.
	var/water_level_bonus_growth = 1

	/// Magic number to describe how aggressive the mutation outcome is this tick.
	var/mutation_power = 0

	var/maturation_mod = 0
	var/production_mod = 0
	var/yield_mod = 0
	var/harvest_amt_mod = 0
	var/endurance_mod = 0
	var/potency_mod = 0

	var/tox_damage = 0
	var/fire_damage = 0
	var/radiation_damage = 0

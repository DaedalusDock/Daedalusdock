// Plant states
#define PLANT_DEAD "dead"
#define PLANT_PLANTED "planted"
#define PLANT_GROWING "growing"
#define PLANT_MATURE "mature"
#define PLANT_HARVESTABLE "harvestable"

// Plant stats
#define PLANT_STAT_MATURATION "maturation"
#define PLANT_STAT_PRODUCTION "production"
#define PLANT_STAT_YIELD "yield"
#define PLANT_STAT_HARVEST_AMT "harvest_amt"
#define PLANT_STAT_ENDURANCE "endurance"
#define PLANT_STAT_POTENCY "potency"

#define PLANT_STAT_PROB_ROUND(num) (trunc(num) + prob(fract(num) * 100) * SIGN(num))
#warn undo this
/proc/psbr(num)
	return PLANT_STAT_PROB_ROUND(num)

/// The functional maximum value from SCALE_PLANT_POTENCY
#define POTENCY_SCALE_FUNCTIONAL_MAXIMUM 200
/// The value returned by SCALE_PLANT_POTENCY when given 100 potency
#define POTENCY_SCALE_AT_100 100

#define POTENCY_SCALE_FACTOR (((100 * POTENCY_SCALE_FUNCTIONAL_MAXIMUM) / POTENCY_SCALE_AT_100) - 100)
/// Scales a potency value according to the above values.
#define SCALE_PLANT_POTENCY(given_potency) round((POTENCY_SCALE_FUNCTIONAL_MAXIMUM / (given_potency + POTENCY_SCALE_FACTOR)) * given_potency)

/// Water level above this is considered drowning the plant.
#define HYDRO_WATER_DROWNING_LIMIT 50

/// Growth per process tick (1 second) base
#define HYDRO_BASE_GROWTH_RATE 1
/// Damage per process tick (1 second) if the plant has no water.
#define HYDRO_NO_WATER_DAMAGE 1

// Plant damage types
/// Lack of water during process tick
#define PLANT_DAMAGE_NO_WATER "no_water"

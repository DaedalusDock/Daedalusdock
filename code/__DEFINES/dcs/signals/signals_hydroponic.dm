//Plants / Plant Traits

///called when a plant with slippery skin is slipped on (mob/victim)
#define COMSIG_PLANT_ON_SLIP "plant_on_slip"
///called when a plant with liquid contents is squashed on (atom/target)
#define COMSIG_PLANT_ON_SQUASH "plant_on_squash"
///called when a plant backfires via the backfire element (mob/victim)
#define COMSIG_PLANT_ON_BACKFIRE "plant_on_backfire"
///called when a seed grows in a tray (obj/machinery/hydroponics)
#define COMSIG_SEED_ON_GROW "plant_on_grow"
///called when a seed is planted in a tray (obj/machinery/hydroponics)
#define COMSIG_SEED_ON_PLANTED "plant_on_plant"

/// Called by plant gene holders when getting a stat's value. (stat, base_val)
#define COMSIG_PLANT_GENE_HOLDER_GET_STAT "pgh_get_stat"

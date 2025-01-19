#define SOLID 1
#define LIQUID 2
#define GAS 3

#define INJECTABLE (1<<0) // Makes it possible to add reagents through droppers and syringes.
#define DRAWABLE (1<<1) // Makes it possible to remove reagents through syringes.

#define REFILLABLE (1<<2) // Makes it possible to add reagents through any reagent container.
#define DRAINABLE (1<<3) // Makes it possible to remove reagents through any reagent container.
#define DUNKABLE (1<<4) // Allows items to be dunked into this container for transfering reagents. Used in conjunction with the dunkable component.

#define TRANSPARENT (1<<5) // Used on containers which you want to be able to see the reagents off.
#define AMOUNT_VISIBLE (1<<6) // For non-transparent containers that still have the general amount of reagents in them visible.
#define NO_REACT (1<<7) // Applied to a reagent holder, the contents will not react with each other.
#define REAGENT_HOLDER_INSTANT_REACT (1<<8)  // Applied to a reagent holder, all of the reactions in the reagents datum will be instant. Meant to be used for things like smoke effects where reactions aren't meant to occur

// Is an open container for all intents and purposes.
#define OPENCONTAINER (REFILLABLE | DRAINABLE | TRANSPARENT)

// Reagent exposure methods.
/// Used for splashing.
#define TOUCH (1<<0)
/// Used for vapors
#define VAPOR (1<<1)
/// When you be eating da reagent
#define INGEST (1<<2)
/// Direct into the blood stream
#define INJECT (1<<3)

#define CHEM_BLOOD 1
#define CHEM_INGEST 2
#define CHEM_TOUCH 3

#define MIMEDRINK_SILENCE_DURATION 30  //ends up being 60 seconds given 1 tick every 2 seconds
///Health threshold for synthflesh and rezadone to unhusk someone
#define UNHUSK_DAMAGE_THRESHOLD 50
///Amount of synthflesh required to unhusk someone
#define SYNTHFLESH_UNHUSK_AMOUNT 100

//used by chem masters and pill presses
#define PILL_STYLE_COUNT 22 //Update this if you add more pill icons or you die
#define RANDOM_PILL_STYLE 22 //Dont change this one though

//used by chem masters and pill presses
//update this if you add more patch icons
#define PATCH_STYLE_LIST list("bandaid", "bandaid_brute", "bandaid_burn", "bandaid_both") //icon_state list
#define DEFAULT_PATCH_STYLE "bandaid"

//used by chem master
#define CONDIMASTER_STYLE_AUTO "auto"
#define CONDIMASTER_STYLE_FALLBACK "_"

#define ALLERGIC_REMOVAL_SKIP "Allergy"

/// the default temperature at which chemicals are added to reagent holders at
#define DEFAULT_REAGENT_TEMPERATURE 300

//Used in holder.dm/equlibrium.dm to set values and volume limits
///stops floating point errors causing issues with checking reagent amounts
#define CHEMICAL_QUANTISATION_LEVEL 0.0001
///The smallest amount of volume allowed - prevents tiny numbers
#define CHEMICAL_VOLUME_MINIMUM 0.001
//Sanity check limit to clamp chems to sane amounts and prevent rounding errors during transfer.
#define CHEMICAL_VOLUME_ROUNDING 0.01
///Default pH for reagents datum
#define CHEMICAL_NORMAL_PH 7.000
///The maximum temperature a reagent holder can attain
#define CHEMICAL_MAXIMUM_TEMPERATURE 99999

///The default purity of all non reacted reagents
#define REAGENT_STANDARD_PURITY 0.75

//reagent bitflags, used for altering how they works
///Can process in dead mobs.
#define REAGENT_DEAD_PROCESS (1<<0)
///Do not split the chem at all during processing - ignores all purity effects
#define REAGENT_DONOTSPLIT (1<<1)
///Doesn't appear on handheld health analyzers.
#define REAGENT_INVISIBLE (1<<2)
///When inverted, the inverted chem uses the name of the original chem
#define REAGENT_SNEAKYNAME (1<<3)
///Retains initial volume of chem when splitting for purity effects
#define REAGENT_SPLITRETAINVOL (1<<4)
///Any reagent marked with this cannot be put in random objects like eggs
#define REAGENT_SPECIAL (1<<5)
///This reagent won't be used in most randomized recipes. Meant for reagents that could be synthetized but are normally inaccessible or TOO hard to get.
#define REAGENT_NO_RANDOM_RECIPE (1<<6)
///Does this reagent clean things?
#define REAGENT_CLEANS (1<<7)
///Uses a fixed metabolization rate that isn't reliant on mob size
#define REAGENT_IGNORE_MOB_SIZE (1<<8)
//Chemical reaction flags, for determining reaction specialties
///Used to create instant reactions
#define REACTION_INSTANT (1<<1)
///Used to force reactions to create a specific amount of heat per 1u created. So if thermic_constant = 5, for 1u of reagent produced, the heat will be forced up arbitarily by 5 irresepective of other reagents. If you use this, keep in mind standard thermic_constant values are 100x what it should be with this enabled.
#define REACTION_HEAT_ARBITARY (1<<2)
///Used to bypass the chem_master transfer block (This is needed for competitive reactions unless you have an end state programmed). More stuff might be added later. When defining this, please add in the comments the associated reactions that it competes with
#define REACTION_COMPETITIVE (1<<3)
///If a reaction will generate it's impure/inverse reagents in the middle of a reaction, as apposed to being determined on ingestion/on reaction completion
#define REACTION_REAL_TIME_SPLIT (1<<4)

///Used for overheat_temp - This sets the overheat so high it effectively has no overheat temperature.
#define NO_OVERHEAT 99999
////Used to force an equlibrium to end a reaction in reaction_step() (i.e. in a reaction_step() proc return END_REACTION to end it)
#define END_REACTION "end_reaction"

//flags used by holder.dm to locate an reagent
///Direct type
#define REAGENT_STRICT_TYPE 1
///Parent type but not sub types for e.g. if param is obj/item it will look for obj/item/stack but not obj/item/stack/sheet
#define REAGENT_PARENT_TYPE 2
///same as istype() check
#define REAGENT_SUB_TYPE 3

/// Helper for converting realtime seconds into reagent cycles.
#define SECONDS_TO_REAGENT_CYCLES(seconds) round(seconds / (/datum/controller/subsystem/mobs::wait / 10))

///Minimum requirement for addiction buzz to be met. Addiction code only checks this once every two seconds, so this should generally be low
#define MIN_ADDICTION_REAGENT_AMOUNT 1
///Nicotine requires much less in your system to be happy
#define MIN_NICOTINE_ADDICTION_REAGENT_AMOUNT 0.01
#define MAX_ADDICTION_POINTS 1000

///Addiction start/ends
#define WITHDRAWAL_STAGE1_START_CYCLE 600 //10 minutes
#define WITHDRAWAL_STAGE1_END_CYCLE 1200
#define WITHDRAWAL_STAGE2_START_CYCLE 1201 // 20 minutes
#define WITHDRAWAL_STAGE2_END_CYCLE 2400
#define WITHDRAWAL_STAGE3_START_CYCLE 2400 //40 minutes

#define GOLDSCHLAGER_VODKA (10)
#define GOLDSCHLAGER_GOLD (1)

#define GOLDSCHLAGER_GOLD_RATIO (GOLDSCHLAGER_GOLD/(GOLDSCHLAGER_VODKA+GOLDSCHLAGER_GOLD))

#define BLASTOFF_DANCE_MOVE_CHANCE_PER_UNIT 6
#define BLASTOFF_DANCE_MOVES_PER_SUPER_MOVE 3

///This is the center of a 1 degree deadband in which water will neither freeze to ice nor melt to liquid
#define WATER_MATTERSTATE_CHANGE_TEMP 274.5

//chem grenades defines
/// Grenade is empty
#define GRENADE_EMPTY 1
/// Grenade has a activation trigger
#define GRENADE_WIRED 2
/// Grenade is ready to be finished
#define GRENADE_READY 3

#define DISPENSER_REAGENT_VALUE 0.2

// Chem cartridge defines
#define CARTRIDGE_VOLUME_LARGE  500
#define CARTRIDGE_VOLUME_MEDIUM 250
#define CARTRIDGE_VOLUME_SMALL  100

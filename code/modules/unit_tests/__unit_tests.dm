//include unit test files in this module in this ifdef
//Keep this sorted alphabetically

#if defined(UNIT_TESTS) || defined(SPACEMAN_DMM)

/// For advanced cases, fail unconditionally but don't return (so a test can return multiple results)
#define TEST_FAIL(reason) (Fail(reason || "No reason", __FILE__, __LINE__))

/// Mark the test as skipped.
#define TEST_SKIP(reason) (return Skip(reason || "No reason"))

/// Asserts that a condition is true
/// If the condition is not true, fails the test
#define TEST_ASSERT(assertion, reason) if (!(assertion)) { return Fail("Assertion failed: [reason || "No reason"]", __FILE__, __LINE__) }

/// Asserts that a parameter is not null
#define TEST_ASSERT_NOTNULL(a, reason) if (isnull(a)) { return Fail("Expected non-null value: [reason || "No reason"]", __FILE__, __LINE__) }

/// Asserts that a parameter is null
#define TEST_ASSERT_NULL(a, reason) if (!isnull(a)) { return Fail("Expected null value but received [a]: [reason || "No reason"]", __FILE__, __LINE__) }

/// Asserts that the two parameters passed are equal, fails otherwise
/// Optionally allows an additional message in the case of a failure
#define TEST_ASSERT_EQUAL(a, b, message) do { \
	var/lhs = ##a; \
	var/rhs = ##b; \
	if (lhs != rhs) { \
		return Fail("Expected [isnull(lhs) ? "null" : lhs] to be equal to [isnull(rhs) ? "null" : rhs].[message ? " [message]" : ""]", __FILE__, __LINE__); \
	} \
} while (FALSE)

/// Asserts that the two parameters passed are not equal, fails otherwise
/// Optionally allows an additional message in the case of a failure
#define TEST_ASSERT_NOTEQUAL(a, b, message) do { \
	var/lhs = ##a; \
	var/rhs = ##b; \
	if (lhs == rhs) { \
		return Fail("Expected [isnull(lhs) ? "null" : lhs] to not be equal to [isnull(rhs) ? "null" : rhs].[message ? " [message]" : ""]", __FILE__, __LINE__); \
	} \
} while (FALSE)

/// *Only* run the test provided within the parentheses
/// This is useful for debugging when you want to reduce noise, but should never be pushed
/// Intended to be used in the manner of `TEST_FOCUS(/datum/unit_test/math)`
#define TEST_FOCUS(test_path) ##test_path { focus = TRUE; }

/// Constants indicating unit test completion status
#define UNIT_TEST_PASSED 0
#define UNIT_TEST_FAILED 1
#define UNIT_TEST_SKIPPED 2

/// Capture pre-unit test mapping error reports. Maybe one day we can take this out back and shoot it.
#define TEST_PRE 0
/// Ensures map standards. Runs before standard unit tests as for production maps, these are more important.
#define TEST_MAP_STANDARDS 1
/// Standard unit test priority
#define TEST_DEFAULT 2
/// After most test steps, used for tests that run long so shorter issues can be noticed faster
#define TEST_LONGER 10
/// This must be the last test to run due to the inherent nature of the test iterating every single tangible atom in the game
/// and qdeleting all of them (while taking long sleeps to make sure the garbage collector fires properly) taking a large amount of time.
#define TEST_DEL_WORLD INFINITY

#ifdef ANSICOLORS
/// Change color to red on ANSI terminal output, if enabled with -DANSICOLORS.
#define TEST_OUTPUT_RED(text) "\x1B\x5B1;31m[text]\x1B\x5B0m"
/// Change color to green on ANSI terminal output, if enabled with -DANSICOLORS.
#define TEST_OUTPUT_GREEN(text) "\x1B\x5B1;32m[text]\x1B\x5B0m"
/// Change color to yellow on ANSI terminal output, if enabled with -DANSICOLORS.
#define TEST_OUTPUT_YELLOW(text) "\x1B\x5B1;33m[text]\x1B\x5B0m"
/// Change color to blue on ANSI terminal output, if enabled with -DANSICOLORS.
#define TEST_OUTPUT_BLUE(text) "\x1B\x5B1;34m[text]\x1B\x5B0m"
/// Change color to magenta on ANSI terminal output, if enabled with -DANSICOLORS.
#define TEST_OUTPUT_MAGENTA(text) "\x1B\x5B1;35m[text]\x1B\x5B0m"
#else
#define TEST_OUTPUT_RED(text) (text)
#define TEST_OUTPUT_GREEN(text) (text)
#define TEST_OUTPUT_YELLOW(text) (text)
#define TEST_OUTPUT_BLUE(text) (text)
#define TEST_OUTPUT_MAGENTA(text) (text)
#endif

/// A trait source when adding traits through unit tests
#define TRAIT_SOURCE_UNIT_TESTS "unit_tests"

/// Helper to allocate a new object with the implied type (the type of the variable it's assigned to) in the corner of the test room
#define ALLOCATE_BOTTOM_LEFT(arguments...) allocate(__IMPLIED_TYPE__, run_loc_floor_bottom_left, ##arguments)

// Include unit test base definition
#include "_unit_test.dm"

// Category Includes
#include "atmospherics\__include.dm"
#include "combat\__include.dm"
#include "mapping_standards\__include.dm"
#include "reagents\__include.dm"
#include "screenshots\__include.dm"

// Single File Includes
#include "achievements.dm"
#include "adenosine.dm"
#include "anchored_mobs.dm"
#include "anonymous_themes.dm"
#include "area_contents.dm"
#include "autowiki.dm"
#include "baseturfs.dm"
#include "bespoke_id.dm"
#include "binary_insert.dm"
#include "bloody_footprints.dm"
#include "bodypart_organ_sanity.dm"
#include "breath.dm"
#include "card_mismatch.dm"
#include "chain_pull_through_space.dm"
#include "chat_filter.dm"
#include "circuit_component_category.dm"
#include "closets.dm"
#include "codex.dm"
#include "component_tests.dm"
#include "confusion.dm"
#include "connect_loc.dm"
#include "crayons.dm"
#include "create_and_destroy.dm"
#include "canreach.dm"
#include "dcs_get_id_from_elements.dm"
#include "designs.dm"
#include "dummy_spawn.dm"
#include "dynamic_ruleset_sanity.dm"
#include "egg_glands.dm"
#include "emoting.dm"
#include "food_edibility_check.dm"
#include "get_turf_pixel.dm"
#include "grabbing.dm"
#include "greyscale_config.dm"
#include "heretic_knowledge.dm"
#include "heretic_rituals.dm"
#include "holidays.dm"
#include "hulk.dm"
#include "hydroponics_extractor_storage.dm"
#include "hydroponics_harvest.dm"
#include "hydroponics_sanity.dm"
#include "hydroponics_self_mutations.dm"
#include "interaction_structures.dm"
#include "interaction_syringe_gun_load.dm"
#include "keybinding_init.dm"
#include "knockoff_component.dm"
#include "load_map_security.dm"
#include "machine_disassembly.dm"
#include "mapping.dm"
#include "merge_type.dm"
#include "metabolizing.dm"
#include "mindbound_actions.dm"
#include "mob_spawn.dm"
#include "modsuit.dm"
#include "modular_map_loader.dm"
#include "movement_order_sanity.dm"
#include "novaflower_burn.dm"
#include "objectives.dm"
#include "outfit_sanity.dm"
#include "paintings.dm"
#include "preferences.dm"
#include "projectiles.dm"
#include "quirks.dm"
#include "rcd.dm"
#include "resist.dm"
#include "say.dm"
#include "serving_tray.dm"
#include "siunit.dm"
#include "slapcraft_sanity.dm"
#include "snapback_sanity.dm"
#include "spawn_humans.dm"
#include "spawn_mobs.dm"
#include "species_config_sanity.dm"
#include "species_unique_id.dm"
#include "species_whitelists.dm"
#include "stack_singular_name.dm"
#include "stomach.dm"
#include "strippable.dm"
#include "subsystem_init.dm"
#include "subsystem_sanity.dm"
#include "surgeries.dm"
#include "tape_sanity.dm"
#include "teleporters.dm"
#include "tgui_create_message.dm"
#include "timer_sanity.dm"
#include "traitor.dm"

#include "wizard_loadout.dm"
#include "wounds.dm"
#ifdef REFERENCE_TRACKING_DEBUG //Don't try and parse this file if ref tracking isn't turned on. IE: don't parse ref tracking please mr linter
#include "find_reference_sanity.dm"
#endif

#undef TEST_ASSERT
#undef TEST_ASSERT_EQUAL
#undef TEST_ASSERT_NOTEQUAL
//#undef TEST_FOCUS - This define is used by vscode unit test extension to pick specific unit tests to run and appended later so needs to be used out of scope here
#endif

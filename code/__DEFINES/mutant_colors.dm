//These must always come in groups of 3.
#define MUTCOLORS_KEY_GENERIC "generic"
	#define MUTCOLORS_GENERIC_1 "generic_1"
	#define MUTCOLORS_GENERIC_2 "generic_2"
	#define MUTCOLORS_GENERIC_3 "generic_3"

#define MUTCOLORS_KEY_TESHARI_TAIL "teshari_tail"
	#define MUTCOLORS_TESHARI_TAIL_1 "teshari_tail_1"
	#define MUTCOLORS_TESHARI_TAIL_2 "teshari_tail_2"
	#define MUTCOLORS_TESHARI_TAIL_3 "teshari_tail_3"

#define MUTCOLORS_KEY_TESHARI_BODY_FEATHERS "teshari_bodyfeathers"
	#define MUTCOLORS_TESHARI_BODY_FEATHERS_1 "teshari_bodyfeathers_1"
	#define MUTCOLORS_TESHARI_BODY_FEATHERS_2 "teshari_bodyfeathers_2"
	#define MUTCOLORS_TESHARI_BODY_FEATHERS_3 "teshari_bodyfeathers_3"

///ADD NEW ONES TO THIS OR SHIT DOESNT WORK
GLOBAL_LIST_INIT(all_mutant_colors_keys, list(
	MUTCOLORS_KEY_GENERIC,
	MUTCOLORS_KEY_TESHARI_TAIL,
	MUTCOLORS_KEY_TESHARI_BODY_FEATHERS
))

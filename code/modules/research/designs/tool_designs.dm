
/////////////////////////////////////////
/////////////////Tools///////////////////
/////////////////////////////////////////

/datum/design/handdrill
	name = "Hand Drill"
	desc = "A small electric hand drill with an interchangeable screwdriver and bolt bit"
	id = "handdrill"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 3500, /datum/material/silver = 1500, /datum/material/titanium = 2500)
	build_path = /obj/item/screwdriver/power
	category = list(DCAT_BASIC_TOOL)
	mapload_design_flags = DESIGN_FAB_ENGINEERING

/datum/design/jawsoflife
	name = "Jaws of Life"
	desc = "A small, compact Jaws of Life with an interchangeable pry jaws and cutting jaws"
	id = "jawsoflife" // added one more requirment since the Jaws of Life are a bit OP
	build_path = /obj/item/crowbar/power
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 4500, /datum/material/silver = 2500, /datum/material/titanium = 3500)
	category = list(DCAT_BASIC_TOOL)
	mapload_design_flags = DESIGN_FAB_ENGINEERING

/datum/design/exwelder
	name = "Experimental Welding Tool"
	desc = "An experimental welder capable of self-fuel generation."
	id = "exwelder"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 1000, /datum/material/glass = 500, /datum/material/plasma = 1500, /datum/material/uranium = 200)
	build_path = /obj/item/weldingtool/experimental
	category = list(DCAT_BASIC_TOOL)
	mapload_design_flags = DESIGN_FAB_ENGINEERING

/datum/design/rpd
	name = "Rapid Pipe Dispenser (RPD)"
	id = "rpd_loaded"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 75000, /datum/material/glass = 37500)
	build_path = /obj/item/pipe_dispenser
	category = list(DCAT_CONSTRUCTION)
	mapload_design_flags = DESIGN_FAB_ENGINEERING

/datum/design/wirebrush
	name = "Wirebrush"
	desc = "A tool to remove rust from walls."
	id = "wirebrush"
	build_type = AUTOLATHE | FABRICATOR
	category = list(DCAT_MISC_TOOL)
	materials = list(/datum/material/iron = 200, /datum/material/glass = 200)
	build_path = /obj/item/wirebrush
	mapload_design_flags = DESIGN_FAB_SERVICE | DESIGN_FAB_ENGINEERING | DESIGN_FAB_OMNI

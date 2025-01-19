///////////////////////////////////
//////////Autolathe Designs ///////
///////////////////////////////////

/datum/design/bucket
	name = "Bucket"
	id = "bucket"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 200)
	build_path = /obj/item/reagent_containers/glass/bucket
	category = list(DCAT_JANITORIAL, DCAT_MISC_TOOL)
	mapload_design_flags = DESIGN_FAB_SERVICE | DESIGN_FAB_OMNI

/datum/design/mop
	name = "Mop"
	id = "mop"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 1000)
	build_path = /obj/item/mop
	category = list(DCAT_JANITORIAL)
	mapload_design_flags = DESIGN_FAB_SERVICE | DESIGN_FAB_OMNI

/datum/design/broom
	name="Push Broom"
	id="pushbroom"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 2000)
	build_path = /obj/item/pushbroom
	category = list(DCAT_JANITORIAL)
	mapload_design_flags = DESIGN_FAB_SERVICE | DESIGN_FAB_OMNI

/datum/design/crowbar
	name = "Pocket Crowbar"
	id = "crowbar"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 50)
	build_path = /obj/item/crowbar
	category = list(DCAT_BASIC_TOOL)
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_OMNI

/datum/design/flashlight
	name = "Flashlight"
	id = "flashlight"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 50, /datum/material/glass = 20)
	build_path = /obj/item/flashlight
	category = list(DCAT_BASIC_TOOL)
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_OMNI

/datum/design/extinguisher
	name = "Fire Extinguisher"
	id = "extinguisher"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 90)
	build_path = /obj/item/extinguisher
	category = list(DCAT_BASIC_TOOL)
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_OMNI

/datum/design/multitool
	name = "Multitool"
	id = "multitool"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 50, /datum/material/glass = 20)
	build_path = /obj/item/multitool
	category = list(DCAT_BASIC_TOOL)
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_OMNI

/datum/design/analyzer
	name = "Gas Analyzer"
	id = "analyzer"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 30, /datum/material/glass = 20)
	build_path = /obj/item/analyzer
	category = list(DCAT_BASIC_TOOL, DCAT_ATMOS)
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_OMNI

/datum/design/tscanner
	name = "T-Ray Scanner"
	id = "tscanner"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 150)
	build_path = /obj/item/t_scanner
	category = list(DCAT_BASIC_TOOL)
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_OMNI

/datum/design/weldingtool
	name = "Welding Tool"
	id = "welding_tool"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 70, /datum/material/glass = 20)
	build_path = /obj/item/weldingtool
	category = list(DCAT_BASIC_TOOL)
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_OMNI

/datum/design/screwdriver
	name = "Screwdriver"
	id = "screwdriver"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 75)
	build_path = /obj/item/screwdriver
	category = list(DCAT_BASIC_TOOL)
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_OMNI

/datum/design/wirecutters
	name = "Wirecutters"
	id = "wirecutters"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 80)
	build_path = /obj/item/wirecutters
	category = list(DCAT_BASIC_TOOL)
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_OMNI

/datum/design/wrench
	name = "Wrench"
	id = "wrench"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 150)
	build_path = /obj/item/wrench
	category = list(DCAT_BASIC_TOOL)
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_OMNI

/datum/design/plunger
	name = "Plunger"
	id = "plunger"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 150)
	build_path = /obj/item/plunger
	category = list(DCAT_JANITORIAL)
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_OMNI

/datum/design/welding_helmet
	name = "Welding Helmet"
	id = "welding_helmet"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 1750, /datum/material/glass = 400)
	build_path = /obj/item/clothing/head/welding
	category = list(DCAT_WEARABLE)
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_OMNI

/datum/design/cable_coil
	name = "Cable Coil"
	id = "cable_coil"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 10, /datum/material/glass = 5)
	build_path = /obj/item/stack/cable_coil
	category = list(DCAT_BASIC_TOOL)
	maxstack = MAXCOIL
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_OMNI

/datum/design/toolbox
	name = "Toolbox"
	id = "tool_box"
	build_type = AUTOLATHE
	materials = list(MAT_CATEGORY_ITEM_MATERIAL = 500)
	build_path = /obj/item/storage/toolbox
	category = list(DCAT_BASIC_TOOL)


/datum/design/apc_board
	name = "APC Module"
	id = "power control"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 100, /datum/material/glass = 100)
	build_path = /obj/item/electronics/apc
	category = list( "Electronics")
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_OMNI

/datum/design/airlock_board
	name = "Airlock Electronics"
	id = "airlock_board"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 50, /datum/material/glass = 50)
	build_path = /obj/item/electronics/airlock
	category = list( "Electronics")
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_OMNI

/datum/design/firelock_board
	name = "Firelock Circuitry"
	id = "firelock_board"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 50, /datum/material/glass = 50)
	build_path = /obj/item/electronics/firelock
	category = list( "Electronics")
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_OMNI

/datum/design/airalarm_electronics
	name = "Air Alarm Electronics"
	id = "airalarm_electronics"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 50, /datum/material/glass = 50)
	build_path = /obj/item/electronics/airalarm
	category = list( "Electronics")
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_OMNI

/datum/design/firealarm_electronics
	name = "Fire Alarm Electronics"
	id = "firealarm_electronics"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 50, /datum/material/glass = 50)
	build_path = /obj/item/electronics/firealarm
	category = list( "Electronics")
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_OMNI

/datum/design/airlock_painter
	name = "Airlock Painter"
	id = "airlock_painter"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 50, /datum/material/glass = 50)
	build_path = /obj/item/airlock_painter
	category = list(DCAT_PAINTER)
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_SERVICE | DESIGN_FAB_OMNI

/datum/design/airlock_painter/decal
	name = "Decal Painter"
	id = "decal_painter"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 50, /datum/material/glass = 50)
	build_path = /obj/item/airlock_painter/decal
	category = list(DCAT_PAINTER)
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_SERVICE | DESIGN_FAB_OMNI

/datum/design/airlock_painter/decal/tile
	name = "Tile Sprayer"
	id = "tile_sprayer"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 50, /datum/material/glass = 50)
	build_path = /obj/item/airlock_painter/decal/tile
	category = list(DCAT_PAINTER)
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_SERVICE | DESIGN_FAB_OMNI

/datum/design/paint_sprayer
	name = "Paint Sprayer"
	id = "paint_sprayer"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 50, /datum/material/glass = 50)
	build_path = /obj/item/paint_sprayer
	category = list(DCAT_PAINTER)
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_SERVICE | DESIGN_FAB_OMNI


/datum/design/emergency_oxygen
	name = "Emergency Oxygen Tank"
	id = "emergency_oxygen"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 500)
	build_path = /obj/item/tank/internals/emergency_oxygen/empty
	category = list(DCAT_ATMOS)

/datum/design/generic_gas_tank
	name = "Generic Gas Tank"
	id = "generic_tank"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 1000)
	build_path = /obj/item/tank/internals/generic
	category = list(DCAT_ATMOS)
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_SUPPLY

/datum/design/iron
	name = "Iron"
	id = "iron"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = MINERAL_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/sheet/iron
	category = list(DCAT_MATERIAL)
	maxstack = 50

/datum/design/glass
	name = "Glass"
	id = "glass"
	build_type = AUTOLATHE
	materials = list(/datum/material/glass = MINERAL_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/sheet/glass
	category = list(DCAT_MATERIAL)
	maxstack = 50

/datum/design/rglass
	name = "Reinforced Glass"
	id = "rglass"
	build_type = AUTOLATHE | SMELTER | FABRICATOR
	materials = list(/datum/material/iron = 1000, /datum/material/glass = MINERAL_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/sheet/rglass
	category = list(DCAT_MATERIAL)
	maxstack = 50

/datum/design/rods
	name = "Iron Rod"
	id = "rods"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 1000)
	build_path = /obj/item/stack/rods
	category = list(DCAT_CONSTRUCTION)
	maxstack = 50

/datum/design/kitchen_knife
	name = "Kitchen Knife"
	id = "kitchen_knife"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 12000)
	build_path = /obj/item/knife/kitchen
	category = list( DCAT_DINNERWARE)
	mapload_design_flags = DESIGN_FAB_SERVICE | DESIGN_FAB_OMNI

/datum/design/plastic_knife
	name = "Plastic Knife"
	id = "plastic_knife"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/plastic = 100)
	build_path = /obj/item/knife/plastic
	category = list( DCAT_DINNERWARE)
	mapload_design_flags = DESIGN_FAB_SERVICE | DESIGN_FAB_OMNI

/datum/design/fork
	name = "Fork"
	id = "fork"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 80)
	build_path = /obj/item/kitchen/fork
	category = list( DCAT_DINNERWARE)
	mapload_design_flags = DESIGN_FAB_SERVICE | DESIGN_FAB_OMNI

/datum/design/spatula
	name = "Spatula"
	id = "spatula"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 80, /datum/material/plastic = 40)
	build_path = /obj/item/kitchen/spatula
	category = list(DCAT_DINNERWARE)
	mapload_design_flags = DESIGN_FAB_SERVICE | DESIGN_FAB_OMNI

/datum/design/plastic_fork
	name = "Plastic Fork"
	id = "plastic_fork"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/plastic = 80)
	build_path = /obj/item/kitchen/fork/plastic
	category = list( DCAT_DINNERWARE)
	mapload_design_flags = DESIGN_FAB_SERVICE | DESIGN_FAB_OMNI

/datum/design/spoon
	name = "Spoon"
	id = "spoon"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 120)
	build_path = /obj/item/kitchen/spoon
	category = list( DCAT_DINNERWARE)
	mapload_design_flags = DESIGN_FAB_SERVICE | DESIGN_FAB_OMNI

/datum/design/plastic_spoon
	name = "Plastic Spoon"
	id = "plastic_spoon"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/plastic = 120)
	build_path = /obj/item/kitchen/spoon/plastic
	category = list( DCAT_DINNERWARE)
	mapload_design_flags = DESIGN_FAB_SERVICE | DESIGN_FAB_OMNI

/datum/design/tray
	name = "Serving Tray"
	id = "servingtray"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 3000)
	build_path = /obj/item/storage/bag/tray
	category = list(DCAT_DINNERWARE)
	mapload_design_flags = DESIGN_FAB_SERVICE | DESIGN_FAB_OMNI

/datum/design/plate
	name = "Plate"
	id = "plate"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 3500)
	build_path = /obj/item/plate
	category = list(DCAT_DINNERWARE)
	mapload_design_flags = DESIGN_FAB_SERVICE | DESIGN_FAB_OMNI

/datum/design/cafeteria_tray
	name = "Cafeteria Tray"
	id = "foodtray"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 3000)
	build_path = /obj/item/storage/bag/tray/cafeteria
	category = list(DCAT_DINNERWARE)
	mapload_design_flags = DESIGN_FAB_SERVICE | DESIGN_FAB_OMNI

/datum/design/bowl
	name = "Bowl"
	id = "bowl"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/glass = 500)
	build_path = /obj/item/reagent_containers/glass/bowl
	category = list(DCAT_DINNERWARE)
	mapload_design_flags = DESIGN_FAB_SERVICE | DESIGN_FAB_OMNI

/datum/design/drinking_glass
	name = "Drinking Glass"
	id = "drinking_glass"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/glass = 500)
	build_path = /obj/item/reagent_containers/food/drinks/drinkingglass
	category = list(DCAT_DINNERWARE)
	mapload_design_flags = DESIGN_FAB_SERVICE | DESIGN_FAB_OMNI

/datum/design/shot_glass
	name = "Shot Glass"
	id = "shot_glass"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/glass = 100)
	build_path = /obj/item/reagent_containers/food/drinks/drinkingglass/shotglass
	category = list(DCAT_DINNERWARE)
	mapload_design_flags = DESIGN_FAB_SERVICE | DESIGN_FAB_OMNI

/datum/design/shaker
	name = "Shaker"
	id = "shaker"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 1500)
	build_path = /obj/item/reagent_containers/food/drinks/shaker
	category = list(DCAT_DINNERWARE)
	mapload_design_flags = DESIGN_FAB_SERVICE | DESIGN_FAB_OMNI

/datum/design/cultivator
	name = "Cultivator"
	id = "cultivator"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron=50)
	build_path = /obj/item/cultivator
	category = list(DCAT_BOTANICAL)
	mapload_design_flags = DESIGN_FAB_SERVICE | DESIGN_FAB_OMNI

/datum/design/plant_analyzer
	name = "Plant Analyzer"
	id = "plant_analyzer"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 30, /datum/material/glass = 20)
	build_path = /obj/item/plant_analyzer
	category = list(DCAT_BOTANICAL)
	mapload_design_flags = DESIGN_FAB_SERVICE | DESIGN_FAB_OMNI

/datum/design/shovel
	name = "Shovel"
	id = "shovel"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 50)
	build_path = /obj/item/shovel
	category = list(DCAT_MISC_TOOL, DCAT_BOTANICAL)
	mapload_design_flags = DESIGN_FAB_SUPPLY | DESIGN_FAB_OMNI

/datum/design/spade
	name = "Spade"
	id = "spade"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 50)
	build_path = /obj/item/shovel/spade
	category = list(DCAT_MISC_TOOL, DCAT_BOTANICAL)
	mapload_design_flags = DESIGN_FAB_SERVICE | DESIGN_FAB_OMNI

/datum/design/hatchet
	name = "Hatchet"
	id = "hatchet"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 15000)
	build_path = /obj/item/hatchet
	category = list(DCAT_MISC_TOOL, DCAT_BOTANICAL)
	mapload_design_flags = DESIGN_FAB_SERVICE | DESIGN_FAB_OMNI

/datum/design/blood_filter
	name = "Blood Filter"
	id = "blood_filter"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 4000, /datum/material/glass = 1500, /datum/material/silver = 500)
	build_path = /obj/item/blood_filter
	category = list(DCAT_MEDICAL)
	mapload_design_flags = DESIGN_FAB_MEDICAL | DESIGN_FAB_OMNI

/datum/design/scalpel
	name = "Scalpel"
	id = "scalpel"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 4000, /datum/material/glass = 1000)
	build_path = /obj/item/scalpel
	category = list(DCAT_MEDICAL)
	mapload_design_flags = DESIGN_FAB_MEDICAL | DESIGN_FAB_OMNI

/datum/design/fixovein
	name = "Vascular Recoupler"
	id = "vascroup"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 4000, /datum/material/glass = 1500, /datum/material/silver = 500)
	build_path = /obj/item/fixovein
	category = list(DCAT_MEDICAL)
	mapload_design_flags = DESIGN_FAB_MEDICAL | DESIGN_FAB_OMNI

/datum/design/circular_saw
	name = "Circular Saw"
	id = "circular_saw"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 10000, /datum/material/glass = 6000)
	build_path = /obj/item/circular_saw
	category = list(DCAT_MEDICAL)
	mapload_design_flags = DESIGN_FAB_MEDICAL | DESIGN_FAB_OMNI

/datum/design/bonesetter
	name = "Bonesetter"
	id = "bonesetter"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 5000,  /datum/material/glass = 2500)
	build_path = /obj/item/bonesetter
	category = list(DCAT_MEDICAL)
	mapload_design_flags = DESIGN_FAB_MEDICAL | DESIGN_FAB_OMNI

/datum/design/surgicaldrill
	name = "Surgical Drill"
	id = "surgicaldrill"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 10000, /datum/material/glass = 6000)
	build_path = /obj/item/surgicaldrill
	category = list(DCAT_MEDICAL)
	mapload_design_flags = DESIGN_FAB_MEDICAL | DESIGN_FAB_OMNI

/datum/design/retractor
	name = "Retractor"
	id = "retractor"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 6000, /datum/material/glass = 3000)
	build_path = /obj/item/retractor
	category = list(DCAT_MEDICAL)
	mapload_design_flags = DESIGN_FAB_MEDICAL | DESIGN_FAB_OMNI

/datum/design/cautery
	name = "Cautery"
	id = "cautery"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 2500, /datum/material/glass = 750)
	build_path = /obj/item/cautery
	category = list(DCAT_MEDICAL)
	mapload_design_flags = DESIGN_FAB_MEDICAL | DESIGN_FAB_OMNI

/datum/design/hemostat
	name = "Hemostat"
	id = "hemostat"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 5000, /datum/material/glass = 2500)
	build_path = /obj/item/hemostat
	category = list(DCAT_MEDICAL)
	mapload_design_flags = DESIGN_FAB_MEDICAL | DESIGN_FAB_OMNI

/datum/design/beaker
	name = "Beaker"
	id = "beaker"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/glass = 500)
	build_path = /obj/item/reagent_containers/glass/beaker
	category = list(DCAT_REAGENTS)
	mapload_design_flags = DESIGN_FAB_MEDICAL | DESIGN_FAB_SERVICE

/datum/design/large_beaker
	name = "Large Beaker"
	id = "large_beaker"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/glass = 2500)
	build_path = /obj/item/reagent_containers/glass/beaker/large
	category = list(DCAT_REAGENTS)
	mapload_design_flags = DESIGN_FAB_MEDICAL | DESIGN_FAB_SERVICE

/datum/design/pillbottle
	name = "Pill Bottle"
	id = "pillbottle"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/plastic = 20, /datum/material/glass = 100)
	build_path = /obj/item/storage/pill_bottle
	category = list(DCAT_MEDICAL, DCAT_REAGENTS)
	mapload_design_flags = DESIGN_FAB_MEDICAL | DESIGN_FAB_OMNI

/datum/design/recorder
	name = "Universal Recorder"
	id = "recorder"
	build_type = FABRICATOR | AUTOLATHE
	materials = list(/datum/material/iron = 60, /datum/material/glass = 30)
	build_path = /obj/item/taperecorder/empty
	category = list(DCAT_MISC)
	mapload_design_flags = DESIGN_FAB_CIV

/datum/design/tape
	name = "Cassette Tape"
	id = "tape"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 20, /datum/material/glass = 5)
	build_path = /obj/item/tape/random
	category = list(DCAT_MISC)
	mapload_design_flags = DESIGN_FAB_CIV

/datum/design/igniter
	name = "Igniter"
	id = "igniter"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 500, /datum/material/glass = 50)
	build_path = /obj/item/assembly/igniter
	category = list(DCAT_ASSEMBLY)

/datum/design/condenser
	name = "Condenser"
	id = "condenser"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron=250, /datum/material/glass=300)
	build_path = /obj/item/assembly/igniter/condenser
	category = list(DCAT_ASSEMBLY)

/datum/design/signaler
	name = "Remote Signaling Device"
	id = "signaler"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 400, /datum/material/glass = 120)
	build_path = /obj/item/assembly/signaler
	category = list(DCAT_ASSEMBLY, DCAT_RADIO)

/datum/design/radio_headset
	name = "Radio Headset"
	id = "radio_headset"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 75)
	build_path = /obj/item/radio/headset
	category = list(DCAT_RADIO)

/datum/design/bounced_radio
	name = "Station Bounced Radio"
	id = "bounced_radio"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 75, /datum/material/glass = 25)
	build_path = /obj/item/radio/off
	category = list(DCAT_RADIO)

/datum/design/intercom_frame
	name = "Intercom Frame"
	id = "intercom_frame"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 75, /datum/material/glass = 25)
	build_path = /obj/item/wallframe/intercom
	category = list(DCAT_FRAME)
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_OMNI

/datum/design/infrared_emitter
	name = "Infrared Emitter"
	id = "infrared_emitter"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 1000, /datum/material/glass = 500)
	build_path = /obj/item/assembly/infra
	category = list(DCAT_ASSEMBLY)

/datum/design/health_sensor
	name = "Health Sensor"
	id = "health_sensor"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 800, /datum/material/glass = 200)
	build_path = /obj/item/assembly/health
	category = list(DCAT_ASSEMBLY)

/datum/design/timer
	name = "Timer"
	id = "timer"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 500, /datum/material/glass = 50)
	build_path = /obj/item/assembly/timer
	category = list(DCAT_ASSEMBLY)

/datum/design/voice_analyzer
	name = "Voice Analyzer"
	id = "voice_analyzer"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 500, /datum/material/glass = 50)
	build_path = /obj/item/assembly/voice
	category = list(DCAT_ASSEMBLY)

/datum/design/light_tube
	name = "Light Tube"
	id = "light_tube"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/glass = 100)
	build_path = /obj/item/light/tube
	category = list(DCAT_CONSTRUCTION)

/datum/design/light_bulb
	name = "Light Bulb"
	id = "light_bulb"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/glass = 50)
	build_path = /obj/item/light/bulb
	category = list(DCAT_CONSTRUCTION)

/datum/design/camera_assembly
	name = "Camera Assembly"
	id = "camera_assembly"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 400, /datum/material/glass = 250)
	build_path = /obj/item/wallframe/camera
	category = list(DCAT_FRAME)
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_OMNI

/datum/design/newscaster_frame
	name = "Newscaster Frame"
	id = "newscaster_frame"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 14000, /datum/material/glass = 8000)
	build_path = /obj/item/wallframe/newscaster
	category = list(DCAT_FRAME)
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_OMNI

/datum/design/status_display_frame
	name = "Status Display Frame"
	id = "status_display_frame"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 14000, /datum/material/glass = 8000)
	build_path = /obj/item/wallframe/status_display
	category = list(DCAT_FRAME)
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_OMNI

/datum/design/syringe
	name = "Syringe"
	id = "syringe"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 10, /datum/material/glass = 20)
	build_path = /obj/item/reagent_containers/syringe
	category = list(DCAT_MEDICAL, DCAT_REAGENTS)
	mapload_design_flags = DESIGN_FAB_MEDICAL | DESIGN_FAB_OMNI

/datum/design/dropper
	name = "Dropper"
	id = "dropper"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/glass = 10, /datum/material/plastic = 30)
	build_path = /obj/item/reagent_containers/dropper
	category = list(DCAT_MEDICAL, DCAT_REAGENTS)
	mapload_design_flags = DESIGN_FAB_MEDICAL | DESIGN_FAB_OMNI

/datum/design/prox_sensor
	name = "Proximity Sensor"
	id = "prox_sensor"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 800, /datum/material/glass = 200)
	build_path = /obj/item/assembly/prox_sensor
	category = list(DCAT_ASSEMBLY)

/datum/design/foam_dart
	name = "Box of Foam Darts"
	id = "foam_dart"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 500)
	build_path = /obj/item/ammo_box/foambox
	category = list(DCAT_AMMO)

//hacked autolathe recipes

/datum/design/large_welding_tool
	name = "Industrial Welding Tool"
	id = "large_welding_tool"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 70, /datum/material/glass = 60)
	build_path = /obj/item/weldingtool/largetank
	category = list(DCAT_BASIC_TOOL)

/datum/design/handcuffs
	name = "Handcuffs"
	id = "handcuffs"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 500)
	build_path = /obj/item/restraints/handcuffs
	category = list(DCAT_SECURITY)

/datum/design/receiver
	name = "Modular Receiver"
	id = "receiver"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 15000)
	build_path = /obj/item/weaponcrafting/receiver
	category = list(DCAT_SECURITY)

/datum/design/cleaver
	name = "Butcher's Cleaver"
	id = "cleaver"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 18000)
	build_path = /obj/item/knife/butcher
	category = list(DCAT_DINNERWARE)

/datum/design/spraycan
	name = "Spraycan"
	id = "spraycan"
	build_type = AUTOLATHE |FABRICATOR
	materials = list(/datum/material/iron = 100, /datum/material/glass = 100)
	build_path = /obj/item/toy/crayon/spraycan
	category = list(DCAT_MISC_TOOL)
	mapload_design_flags = DESIGN_FAB_CIV | DESIGN_FAB_OMNI

/datum/design/desttagger
	name = "Destination Tagger"
	id = "desttagger"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 250, /datum/material/glass = 125)
	build_path = /obj/item/dest_tagger
	category = list(DCAT_SUPPLY)
	mapload_design_flags = DESIGN_FAB_SUPPLY | DESIGN_FAB_OMNI

/datum/design/salestagger
	name = "Sales Tagger"
	id = "salestagger"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 700, /datum/material/glass = 200)
	build_path = /obj/item/sales_tagger
	category = list(DCAT_SUPPLY)
	mapload_design_flags = DESIGN_FAB_SUPPLY | DESIGN_FAB_OMNI

/datum/design/handlabeler
	name = "Hand Labeler"
	id = "handlabel"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 150, /datum/material/glass = 125)
	build_path = /obj/item/hand_labeler
	category = list(DCAT_MISC_TOOL)
	mapload_design_flags = DESIGN_FAB_CIV | DESIGN_FAB_OMNI

/datum/design/geiger
	name = "Geiger Counter"
	id = "geigercounter"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 150, /datum/material/glass = 150)
	build_path = /obj/item/geiger_counter
	category = list(DCAT_MISC_TOOL)
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_OMNI

/datum/design/turret_control_frame
	name = "Turret Control Frame"
	id = "turret_control"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 12000)
	build_path = /obj/item/wallframe/turret_control
	category = list(DCAT_FRAME)
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_OMNI

/datum/design/conveyor_belt
	name = "Conveyor Belt"
	id = "conveyor_belt"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 3000)
	build_path = /obj/item/stack/conveyor
	category = list(DCAT_CONSTRUCTION)
	maxstack = 30
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_OMNI

/datum/design/conveyor_switch
	name = "Conveyor Belt Switch"
	id = "conveyor_switch"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 450, /datum/material/glass = 190)
	build_path = /obj/item/conveyor_switch_construct
	category = list(DCAT_CONSTRUCTION)
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_OMNI

/datum/design/modcomp
	id = DESIGN_ID_IGNORE
	build_type = FABRICATOR
	mapload_design_flags = DESIGN_FAB_OMNI
	category = list(DCAT_COMPUTER_PART)

/datum/design/modcomp/laptop
	name = "Laptop Frame"
	id = "laptop"
	materials = list(/datum/material/iron = 10000, /datum/material/glass = 1000)
	build_path = /obj/item/modular_computer/laptop/buildable

/datum/design/modcomp/tablet
	name = "Tablet Frame"
	id = "tablet"
	materials = list(/datum/material/iron = 2000, /datum/material/glass = 1000)
	build_path = /obj/item/modular_computer/tablet

/datum/design/miniature_power_cell
	name = "Miniature Power Cell"
	id = "miniature_power_cell"
	build_type = AUTOLATHE
	materials = list(/datum/material/glass = 20)
	build_path = /obj/item/stock_parts/cell/emergency_light
	category = list(DCAT_STOCK_PART)

/datum/design/package_wrap
	name = "Package Wrapping"
	id = "packagewrap"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 200, /datum/material/glass = 200)
	build_path = /obj/item/stack/package_wrap
	category = list(DCAT_SUPPLY)
	maxstack = 30

/datum/design/holodisk
	name = "Holodisk"
	id = "holodisk"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 100, /datum/material/glass = 100)
	build_path = /obj/item/disk/holodisk
	category = list(DCAT_MISC)
	mapload_design_flags = DESIGN_FAB_CIV

/datum/design/circuit
	name = "Blue Circuit Tile"
	id = "circuit"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 500, /datum/material/glass = 500)
	build_path = /obj/item/stack/tile/circuit
	category = list( "Misc")
	maxstack = 50
	mapload_design_flags = DESIGN_FAB_CIV

/datum/design/circuitgreen
	name = "Green Circuit Tile"
	id = "circuitgreen"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 500, /datum/material/glass = 500)
	build_path = /obj/item/stack/tile/circuit/green
	category = list( "Misc")
	maxstack = 50
	mapload_design_flags = DESIGN_FAB_CIV

/datum/design/circuitred
	name = "Red Circuit Tile"
	id = "circuitred"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 500, /datum/material/glass = 500)
	build_path = /obj/item/stack/tile/circuit/red
	category = list( "Misc")
	maxstack = 50
	mapload_design_flags = DESIGN_FAB_CIV

/datum/design/price_tagger
	name = "Price Tagger"
	id = "price_tagger"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 1500, /datum/material/glass = 500)
	build_path = /obj/item/price_tagger
	category = list(DCAT_SUPPLY)
	mapload_design_flags = DESIGN_FAB_SUPPLY | DESIGN_FAB_OMNI

/datum/design/custom_vendor_refill
	name = "Custom Vendor Refill"
	id = "custom_vendor_refill"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 5000, /datum/material/glass = 2000)
	build_path = /obj/item/vending_refill/custom
	category = list( "Misc")
	mapload_design_flags = DESIGN_FAB_CIV

/datum/design/toygun
	name = "Cap Gun"
	id = "toygun"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 100, /datum/material/glass = 50)
	build_path = /obj/item/toy/gun
	category = list(DCAT_WEAPON)

/datum/design/capbox
	name = "Box of Cap Gun Shots"
	id = "capbox"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 20, /datum/material/glass = 5)
	build_path = /obj/item/toy/ammo/gun
	category = list(DCAT_AMMO)

/datum/design/plastic_tree
	name = "Plastic Potted Plant"
	id = "plastic_trees"
	build_type = FABRICATOR
	materials = list(/datum/material/plastic = 8000)
	build_path = /obj/item/kirbyplants/fullysynthetic
	category = list(DCAT_MISC)
	mapload_design_flags = DESIGN_FAB_CIV

/datum/design/plastic_ring
	name = "Plastic Can Rings"
	id = "ring_holder"
	build_type = FABRICATOR
	materials = list(/datum/material/plastic = 1200)
	build_path = /obj/item/storage/cans
	category = list( DCAT_DINNERWARE)
	mapload_design_flags = DESIGN_FAB_SERVICE | DESIGN_FAB_OMNI

/datum/design/plastic_box
	name = "Plastic Box"
	id = "plastic_box"
	build_type = AUTOLATHE
	materials = list(/datum/material/plastic = 1000)
	build_path = /obj/item/storage/box/plastic
	category = list(DCAT_MISC)

/datum/design/sticky_tape
	name = "Sticky Tape"
	id = "sticky_tape"
	build_type = FABRICATOR
	materials = list(/datum/material/plastic = 500)
	build_path = /obj/item/stack/sticky_tape
	category = list(DCAT_MISC_TOOL)
	maxstack = 5
	mapload_design_flags = DESIGN_FAB_CIV

/datum/design/chisel
	name = "Chisel"
	id = "chisel"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 75)
	build_path = /obj/item/chisel
	category = list(DCAT_MISC_TOOL)

/datum/design/control
	name = "Blast Door Controller"
	id = "blast"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 100, /datum/material/glass = 50)
	build_path = /obj/item/assembly/control
	category = list(DCAT_ASSEMBLY)

/datum/design/razor
	name = "Electric Razor"
	id = "razor"
	build_type = FABRICATOR  | AUTOLATHE
	materials = list(/datum/material/iron = 75)
	build_path = /obj/item/razor
	category = list(DCAT_MISC_TOOL)
	mapload_design_flags = DESIGN_FAB_SERVICE

/datum/design/paperroll
	name = "Hand Labeler Paper Roll"
	id = "roll"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 50, /datum/material/glass = 25)
	build_path = /obj/item/hand_labeler_refill
	category = list(DCAT_MISC)
	mapload_design_flags = DESIGN_FAB_OMNI | DESIGN_FAB_CIV

/datum/design/beacon
	name = "Tracking Beacon"
	desc = "A tracking beacon."
	id = "beacon"
	build_type = FABRICATOR | AUTOLATHE
	materials = list(/datum/material/iron = 150, /datum/material/glass = 100)
	build_path = /obj/item/beacon
	category = list(DCAT_RADIO)
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_OMNI

/datum/design/plasticducky
	name = "Rubber Ducky"
	desc = "We needed to give you a way to waste all that plastic you have."
	id = "plasticducky"
	build_type = FABRICATOR
	materials = list(/datum/material/plastic = 1000)
	build_path = /obj/item/bikehorn/rubberducky/plasticducky
	category = list(DCAT_MISC)
	mapload_design_flags = DESIGN_FAB_CIV


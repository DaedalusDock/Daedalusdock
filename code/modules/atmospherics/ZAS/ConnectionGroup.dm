/*

Overview:
	These are what handle gas transfers between zones and into space.
	They are found in a zone's edges list and in SSzas.edges.
	Each edge updates every air tick due to their role in gas transfer.
	They come in two flavors, /connection_edge/zone and /connection_edge/unsimulated.
	As the type names might suggest, they handle inter-zone and spacelike connections respectively.

Class Vars:

	A - This always holds a zone. In unsimulated edges, it holds the only zone.

	connecting_turfs - This holds a list of connected turfs, mainly for the sake of airflow.

	coefficent - This is a marker for how many connections are on this edge. Used to determine the ratio of flow.

	connection_edge/zone

		B - This holds the second zone with which the first zone equalizes.

		direct - This counts the number of direct (i.e. with no doors) connections on this edge.
		         Any value of this is sufficient to make the zones mergeable.

	connection_edge/unsimulated

		B - This holds an unsimulated turf which has the gas values this edge is mimicing.

		air - Retrieved from B on creation and used as an argument for the legacy ShareSpace() proc.

Class Procs:

	add_connection(connection/c)
		Adds a connection to this edge. Usually increments the coefficient and adds a turf to connecting_turfs.

	remove_connection(connection/c)
		Removes a connection from this edge. This works even if c is not in the edge, so be careful.
		If the coefficient reaches zero as a result, the edge is erased.

	contains_zone(zone/Z)
		Returns true if either A or B is equal to Z. Unsimulated connections return true only on A.

	erase()
		Removes this connection from processing and zone edge lists.

	tick()
		Called every air tick on edges in the processing list. Equalizes gas.

	flow(list/movable, differential, repelled)
		Airflow proc causing all objects in movable to be checked against a pressure differential.
		If repelled is true, the objects move away from any turf in connecting_turfs, otherwise they approach.
		A check against zas_settings.lightest_airflow_pressure should generally be performed before calling this.

	get_connected_zone(zone/from)
		Helper proc that allows getting the other zone of an edge given one of them.
		Only on /connection_edge/zone, otherwise use A.

*/


/connection_edge
	var/zone/A

	///An associative list of {turf = TRUE}, containing all the the turfs that make up the connection
	var/list/connecting_turfs = list()
	var/direct = 0
	var/sleeping = 1
	var/coefficient = 0

	///The last time the "woosh" airflow sound played, world.time
	var/last_woosh

	#ifdef ZASDBG
	///Set this to TRUE during testing to get verbose debug information.
	var/tmp/verbose = FALSE
	#endif

/connection_edge/New()
	CRASH("Cannot make connection edge without specifications.")

///Adds a connection to this edge. Usually increments the coefficient and adds a turf to connecting_turfs.
/connection_edge/proc/add_connection(connection/c)
	coefficient++
	if(c.direct())
		direct++

	#ifdef ZASDBG
	if(verbose)
		zas_log("Connection added: [type] Coefficient: [coefficient]")
	#endif

///Removes a connection from this edge. This works even if c is not in the edge, so be careful.
/connection_edge/proc/remove_connection(connection/c)
	coefficient--
	if(coefficient <= 0)
		erase()
	if(c.direct())
		direct--

	#ifdef ZASDBG
	if(verbose)
		zas_log("Connection removed: [type] Coefficient: [coefficient-1]")
	#endif

///Returns true if either A or B is equal to Z. Unsimulated connections return true only on A.
/connection_edge/proc/contains_zone(zone/Z)
	return

///Removes this connection from processing and zone edge lists.
/connection_edge/proc/erase()
	SSzas.remove_edge(src)
	#ifdef ZASDBG
	if(verbose)
		zas_log("[type] Erased.")
	#endif

///Called every air tick on edges in the processing list. Equalizes gas.
/connection_edge/proc/tick()
	return

///Checks both connection ends to see if they need to process.
/connection_edge/proc/recheck()
	return

///Airflow proc causing all objects in movable to be checked against a pressure differential. See file header for more info.
/connection_edge/proc/flow(list/movable, differential, repelled)
	set waitfor = FALSE
	for(var/atom/movable/M as anything in movable)
		//Non simulated objects dont get tossed
		if(!M.simulated) continue

		//If they're already being tossed, don't do it again.
		if(M.last_airflow > world.time - zas_settings.airflow_delay) continue
		if(M.airflow_speed) continue

		//Check for knocking people over
		if(ismob(M) && differential > zas_settings.airflow_stun_pressure)
			if(M:status_flags & GODMODE) continue
			if(!M:airflow_stun())
				to_chat(M, "<span class='danger'>Air suddenly rushes past you!</span>")

		if(M.check_airflow_movable(differential))
			//Check for things that are in range of the midpoint turfs.
			var/list/close_turfs = list()
			for(var/turf/T as anything in RANGE_TURFS(world.view, M))
				if(connecting_turfs[T])
					close_turfs += T
			if(!close_turfs.len) continue

			M.airflow_dest = pick(close_turfs) //Pick a random midpoint to fly towards.

			//Soul code im too scared to touch - Edit, I am no longer too scared to touch it. This used to cause an OOM if an admin bussed too hard.
			if(M)
				if(repelled) INVOKE_ASYNC(M, /atom/movable/proc/RepelAirflowDest, differential/5)
				else INVOKE_ASYNC(M, /atom/movable/proc/GotoAirflowDest, differential/10)

			CHECK_TICK

/connection_edge/zone
	var/zone/B

/connection_edge/zone/New(zone/A, zone/B)

	src.A = A
	src.B = B
	A.edges.Add(src)
	B.edges.Add(src)
	//id = edge_id(A,B)
	#ifdef ZASDBG
	if(verbose)
		zas_log("New edge between [A] and [B]")
	#endif

/connection_edge/zone/add_connection(connection/c)
	. = ..()
	connecting_turfs[c.A] = TRUE

/connection_edge/zone/remove_connection(connection/c)
	connecting_turfs.Remove(c.A)
	return ..()

/connection_edge/zone/contains_zone(zone/Z)
	return A == Z || B == Z

/connection_edge/zone/erase()
	A.edges.Remove(src)
	B.edges.Remove(src)
	return ..()

/connection_edge/zone/tick()
	if(A.invalid || B.invalid)
		erase()
		return

	var/equiv = A.air.shareRatio(B.air, coefficient)

	queue_spacewind()

	if(equiv)
		if(direct)
			erase()
			SSzas.merge(A, B)
			return
		else
			A.air.equalize(B.air)
			SSzas.mark_edge_sleeping(src)

	SSzas.mark_zone_update(A)
	SSzas.mark_zone_update(B)

/connection_edge/zone/recheck()
	if(!A.air.compare(B.air, vacuum_exception = 1))
	// Edges with only one side being vacuum need processing no matter how close.
		SSzas.mark_edge_active(src)

/connection_edge/zone/queue_spacewind()
	var/differential = A.air.returnPressure() - B.air.returnPressure()
	if(abs(differential) >= zas_settings.airflow_lightest_pressure)
		var/list/attracted
		var/list/repelled
		if(differential > 0)
			attracted = A.movables()
			repelled = B.movables()
		else
			attracted = B.movables()
			repelled = A.movables()

		WOOSH

		flow(attracted, abs(differential), 0)
		flow(repelled, abs(differential), 1)

///Helper proc to get connections for a zone.
/connection_edge/zone/proc/get_connected_zone(zone/from)
	if(A == from)
		return B
	else
		return A

/connection_edge/unsimulated
	var/turf/B
	var/datum/gas_mixture/air

/connection_edge/unsimulated/New(zone/A, turf/B)
	src.A = A
	src.B = B
	A.edges.Add(src)
	air = B.return_air()
	#ifdef ZASDBG
	if(verbose)
		log_admin("New edge from [A] to [B] ([B.x], [B.y], [B.z]).")
	#endif


/connection_edge/unsimulated/add_connection(connection/c)
	. = ..()
	connecting_turfs[c.B] = TRUE
	air.group_multiplier = coefficient

/connection_edge/unsimulated/remove_connection(connection/c)
	connecting_turfs.Remove(c.B)
	air.group_multiplier = coefficient
	return ..()

/connection_edge/unsimulated/erase()
	A.edges.Remove(src)
	return ..()

/connection_edge/unsimulated/contains_zone(zone/Z)
	return A == Z

/connection_edge/unsimulated/tick()
	if(A.invalid)
		erase()
		return

	var/equiv = A.air.shareSpace(air)

	queue_spacewind()

	if(equiv)
		A.air.copyFrom(air)
		SSzas.mark_edge_sleeping(src)

	SSzas.mark_zone_update(A)

/connection_edge/unsimulated/recheck()
	// Edges with only one side being vacuum need processing no matter how close.
	// Note: This handles the glaring flaw of a room holding pressure while exposed to space, but
	// does not specially handle the less common case of a simulated room exposed to an unsimulated pressurized turf.
	if(!A.air.compare(air, vacuum_exception = 1))
		SSzas.mark_edge_active(src)

/connection_edge/unsimulated/queue_spacewind()
	var/differential = A.air.returnPressure() - air.returnPressure()
	if(abs(differential) >= zas_settings.airflow_lightest_pressure)
		var/list/attracted = A.movables()

		WOOSH

		flow(attracted, abs(differential), differential < 0)

/proc/ShareHeat(datum/gas_mixture/A, datum/gas_mixture/B, connecting_tiles)
	//This implements a simplistic version of the Stefan-Boltzmann law.
	var/energy_delta = ((A.temperature - B.temperature) ** 4) * STEFAN_BOLTZMANN_CONSTANT * connecting_tiles * 2.5
	var/maximum_energy_delta = max(0, min(A.temperature * A.getHeatCapacity() * A.group_multiplier, B.temperature * B.getHeatCapacity() * B.group_multiplier))
	if(maximum_energy_delta > abs(energy_delta))
		if(energy_delta < 0)
			maximum_energy_delta *= -1
		energy_delta = maximum_energy_delta

	A.temperature -= energy_delta / (A.getHeatCapacity() * A.group_multiplier)
	B.temperature += energy_delta / (B.getHeatCapacity() * B.group_multiplier)

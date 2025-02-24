// Air update stages
#define SSAIR_TURFS 1
#define SSAIR_EDGES 2
#define SSAIR_FIREZONES 3
#define SSAIR_HOTSPOTS 4
#define SSAIR_ZONES 5
#define SSAIR_DONE 6

SUBSYSTEM_DEF(air)
	name = "Air"
	init_order = INIT_ORDER_AIR
	priority = FIRE_PRIORITY_AIR
	wait = 2 SECONDS // seconds (We probably can speed this up actually)
	subsystem_flags = SS_BACKGROUND // TODO - Should this really be background? It might be important.
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	var/static/list/part_names = list("turfs", "edges", "fire zones", "hotspots", "zones")

	/// Associative id = datum list of generated /datum/atmosphere's.
	var/list/generated_atmospheres

	var/cost_turfs = 0
	var/cost_edges = 0
	var/cost_firezones = 0
	var/cost_hotspots = 0
	var/cost_zones = 0

	var/list/currentrun = null
	var/current_step = null

	// Updating zone tiles requires temporary storage location of self-zone-blocked turfs across resumes. Used only by process_tiles_to_update.
	var/list/selfblock_deferred = list()

	// This is used to tell Travis WHERE the edges are.
	var/list/startup_active_edge_log = list()

/datum/controller/subsystem/air/PreInit()
	air_master = src

/datum/controller/subsystem/air/Initialize(timeofday)
	report_progress("Processing Geometry...")

	current_cycle = 0
	var/simulated_turf_count = 0
	for(var/turf/simulated/S in world)
		simulated_turf_count++
		S.update_air_properties()
		CHECK_TICK

	var/to_send = "<blockquote class ='info'>"
	to_send += SPAN_DEBUG("<b>Geometry initialized in [round(0.1*(REALTIMEOFDAY-timeofday),0.1)] seconds.</b><hr>")
	to_send += SPAN_DEBUGINFO("Total Simulated Turfs: [simulated_turf_count]")
	to_send += SPAN_DEBUGINFO("\nTotal Zones: [zones.len]")
	to_send += SPAN_DEBUGINFO("\nTotal Edges: [edges.len]")
	to_send += SPAN_DEBUGINFO("\nTotal Active Edges: [active_edges.len ? SPAN_DANGER("[active_edges.len]") : "None"]")
	to_send += SPAN_DEBUGINFO("\nTotal Unsimulated Turfs: [world.maxx*world.maxy*world.maxz - simulated_turf_count]")
	to_send += SPAN_DEBUGINFO("</blockquote>")

	admin_notice(to_send, R_DEBUG)

	// Note - Baystation settles the air by running for one tick.  We prefer to not have active edges.
	// Maps should not have active edges on boot.  If we've got some, log it so it can get fixed.
	if(active_edges.len)
		var/list/edge_log = list()
		for(var/datum/zas_edge/E in active_edges)
			edge_log += "Active Edge [E] ([E.type])"
			for(var/turf/T in E.connecting_turfs)
				edge_log += "+--- Connecting Turf [T] ([T.type]) @ [T.x], [T.y], [T.z] ([T.loc])"
		subsystem_log("Active Edges on ZAS Startup\n" + edge_log.Join("\n"))
		startup_active_edge_log = edge_log.Copy()

	..()

/datum/controller/subsystem/air/fire(resumed = 0)
	var/timer
	if(!resumed)
		if(LAZYLEN(currentrun) != 0)
			stack_trace("Currentrun not empty before processing cycle when it should be. [english_list(currentrun)]")
		currentrun = list()
		if(current_step != null)
			stack_trace("current_step before processing cycle was [current_step] instead of null")
		current_step = SSAIR_TURFS
		current_cycle++

	INTERNAL_PROCESS_STEP(SSAIR_TURFS, TRUE, process_tiles_to_update, cost_turfs, SSAIR_EDGES)
	INTERNAL_PROCESS_STEP(SSAIR_EDGES, FALSE, process_active_edges, cost_edges, SSAIR_FIREZONES)
	INTERNAL_PROCESS_STEP(SSAIR_FIREZONES, FALSE, process_active_fire_zones, cost_firezones, SSAIR_HOTSPOTS)
	INTERNAL_PROCESS_STEP(SSAIR_HOTSPOTS, FALSE, process_active_hotspots, cost_hotspots, SSAIR_ZONES)
	INTERNAL_PROCESS_STEP(SSAIR_ZONES, FALSE, process_zones_to_update, cost_zones, SSAIR_DONE)

	// Okay, we're done! Woo! Got thru a whole air_master cycle!
	if(LAZYLEN(currentrun) != 0)
		stack_trace("Currentrun not empty after processing cycle when it should be. [english_list(currentrun.Copy(1, min(currentrun.len, 5)))]")
	currentrun = null
	if(current_step != SSAIR_DONE)
		stack_trace("current_step after processing cycle was [current_step] instead of [SSAIR_DONE]")
	current_step = null

/datum/controller/subsystem/air/proc/process_tiles_to_update(resumed = 0)
	if (!resumed)
		// NOT a copy, because we are supposed to drain active turfs each cycle anyway, so just replace with empty list.
		// We still use a separate list tho, to ensure we don't process a turf twice during a single cycle!
		src.currentrun = tiles_to_update
		tiles_to_update = list()

		//defer updating of self-zone-blocked turfs until after all other turfs have been updated.
		//this hopefully ensures that non-self-zone-blocked turfs adjacent to self-zone-blocked ones
		//have valid zones when the self-zone-blocked turfs update.
		//This ensures that doorways don't form their own single-turf zones, since doorways are self-zone-blocked and
		//can merge with an adjacent zone, whereas zones that are formed on adjacent turfs cannot merge with the doorway.
		if(src.selfblock_deferred.len) // Sanity check to make sure it was not remaining from last cycle somehow.
			stack_trace("WARNING: SELFBLOCK_DEFFERED WAS NOT EMPTY. Something went wrong.")
		src.selfblock_deferred = list()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun
	var/list/selfblock_deferred = src.selfblock_deferred

	// Run thru the list, processing non-self-zone-blocked and deferring self-zone-blocked
	while(currentrun.len)
		var/turf/T = currentrun[currentrun.len]
		currentrun.len--
		//check if the turf is self-zone-blocked
		if(T.CheckAirBlock(T) == ATMOS_PASS_ZONE_BLOCKED)
			selfblock_deferred += T
			if(MC_TICK_CHECK)
				return
			else
				continue
		T.update_air_properties()
		T.post_update_air_properties()
		T.turf_flags &= ~TURF_ZONE_REBUILD_QUEUED
		#ifdef ZAS_DEBUG_GRAPHICS
		T.overlays -= mark
		#endif
		if(MC_TICK_CHECK)
			return

	if(LAZYLEN(currentrun) != 0)
		stack_trace("WARNING: Currentrun was not empty after tiles process when it should be.")
		currentrun = list()

	// Run thru the deferred list and processing them
	while(selfblock_deferred.len)
		var/turf/T = selfblock_deferred[selfblock_deferred.len]
		selfblock_deferred.len--
		T.update_air_properties()
		T.post_update_air_properties()
		T.turf_flags &= ~TURF_ZONE_REBUILD_QUEUED
		#ifdef ZAS_DEBUG_GRAPHICS
		T.overlays -= mark
		#endif
		if(MC_TICK_CHECK)
			return

	if(selfblock_deferred.len != 0)
		stack_trace("WARNING: selfblock_defered was not empty after selfblock tiles process (length [LAZYLEN(selfblock_deferred)])")

/datum/controller/subsystem/air/proc/process_active_edges(resumed = 0)
	if (!resumed)
		src.currentrun = active_edges.Copy()
	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun
	while(currentrun.len)
		var/datum/zas_edge/edge = currentrun[currentrun.len]
		currentrun.len--
		if(edge) // TODO - Do we need to check this? Old one didn't, but old one was single-threaded.
			edge.tick()
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/air/proc/process_active_fire_zones(resumed = 0)
	if (!resumed)
		src.currentrun = active_fire_zones.Copy()
	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun
	while(currentrun.len)
		var/datum/zas_zone/Z = currentrun[currentrun.len]
		currentrun.len--
		if(Z) // TODO - Do we need to check this? Old one didn't, but old one was single-threaded.
			Z.process_fire()
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/air/proc/process_active_hotspots(resumed = 0)
	if (!resumed)
		src.currentrun = active_hotspots.Copy()
	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun
	var/dt = (subsystem_flags & SS_TICKER)? (wait * world.tick_lag * 0.1) : (wait * 0.1)
	while(currentrun.len)
		var/atom/movable/fire/fire = currentrun[currentrun.len]
		currentrun.len--
		if(fire) // TODO - Do we need to check this? Old one didn't, but old one was single-threaded.
			fire.process(dt)
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/air/proc/process_zones_to_update(resumed = 0)
	if (!resumed)
		active_zones = zones_to_update.len // Save how many zones there were to update this cycle (used by some debugging stuff)
		if(!zones_to_update.len)
			return // Nothing to do here this cycle!
		// NOT a copy, because we are supposed to drain active turfs each cycle anyway, so just replace with empty list.
		// Blanking the public list means we actually are removing processed ones from the list! Maybe we could we use zones_for_update directly?
		// But if we dom any zones added to zones_to_update DURING this step will get processed again during this step.
		// I don't know if that actually happens?  But if it does, it could lead to an infinate loop.  Better preserve original semantics.
		src.currentrun = zones_to_update
		zones_to_update = list()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun
	while(currentrun.len)
		var/datum/zas_zone/zone = currentrun[currentrun.len]
		currentrun.len--
		if(zone) // TODO - Do we need to check this? Old one didn't, but old one was single-threaded.
			zone.tick()
			zone.needs_update = 0
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/air/stat_entry(msg_prefix)
	var/list/msg = list(msg_prefix)
	msg += "S:[current_step ? part_names[current_step] : ""] "
	msg += "C:{"
	msg += "T [round(cost_turfs, 1)] | "
	msg += "E [round(cost_edges, 1)] | "
	msg += "F [round(cost_firezones, 1)] | "
	msg += "H [round(cost_hotspots, 1)] | "
	msg += "Z [round(cost_zones, 1)] "
	msg += "}"
	msg += "Z: [zones.len] "
	msg += "E: [edges.len] "
	msg += "Cycle: [current_cycle] {"
	msg += "T [tiles_to_update.len] | "
	msg += "E [active_edges.len] | "
	msg += "F [active_fire_zones.len] | "
	msg += "H [active_hotspots.len] | "
	msg += "Z [zones_to_update.len] "
	msg += "}"
	..(msg.Join())

// ZAS might displace objects as the map loads if an air tick is processed mid-load.
/datum/controller/subsystem/air/StartLoadingMap(var/quiet = TRUE)
	can_fire = FALSE
	// Don't let map actually start loading if we are in the middle of firing
	while(current_step)
		stoplag()
	. = ..()

/datum/controller/subsystem/air/StopLoadingMap(var/quiet = TRUE)
	can_fire = TRUE
	. = ..()

// Reboot the air master.  A bit hacky right now, but sometimes necessary still.
/datum/controller/subsystem/air/proc/RebootZAS()
	can_fire = FALSE // Pause processing while we reboot
	// If we should happen to be in the middle of processing... wait until that finishes.
	if (state != SS_IDLE)
		report_progress("ZAS Rebuild initiated. Waiting for current air tick to complete before continuing.")
		while (state != SS_IDLE)
			stoplag()

	// Invalidate all zones
	for(var/datum/zas_zone/zone in zones)
		zone.c_invalidate()

	// Reset all the lists
	zones.Cut()
	edges.Cut()
	tiles_to_update.Cut()
	zones_to_update.Cut()
	active_fire_zones.Cut()
	active_hotspots.Cut()
	active_edges.Cut()

	// Start it up again
	Initialize(REALTIMEOFDAY)

	// Update next_fire so the MC doesn't try to make up for missed ticks.
	next_fire = world.time + wait
	can_fire = TRUE // Unpause

//
// The procs from the ZAS Air Controller are in ZAS/Controller.dm
//

/**
  * Initializes all subtypes of /datum/atmosphere and indexes them by key.
  */
/datum/controller/subsystem/air/proc/generate_atmospheres()
	generated_atmospheres = list()
	for(var/T in subtypesof(/datum/atmosphere))
		var/datum/atmosphere/A = T
		if(initial(A.abstract_type) == T)
			continue
		A = new T
		generated_atmospheres[A.id] = A

/**
  * Preprocess a gas string, replacing it with a specific atmosphere's if necessary.
  */
/datum/controller/subsystem/air/proc/preprocess_gas_string(gas_string, turf/T)
	if(!generated_atmospheres)
		generate_atmospheres()
	if(gas_string == ATMOSPHERE_ID_USE_ZTRAIT)
		gas_string = SSmapping.level_trait(T.z, ZTRAIT_DEFAULT_ATMOS) || GAS_STRING_VACUUM
	gas_string = "[gas_string]"
	if(!generated_atmospheres[gas_string])
		return gas_string
	var/datum/atmosphere/mix = generated_atmospheres[gas_string]
	return mix.gas_string

#undef SSAIR_TURFS
#undef SSAIR_EDGES
#undef SSAIR_FIREZONES
#undef SSAIR_HOTSPOTS
#undef SSAIR_ZONES
#undef SSAIR_DONE

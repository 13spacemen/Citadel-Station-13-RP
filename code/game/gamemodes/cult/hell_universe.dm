/*

In short:
 * Random gateways spawning hellmonsters
 * Broken Fire Alarms
 * Random tiles changing to culty tiles.

*/
/datum/universal_state/hell
	name = "Hell Rising"
	desc = "OH FUCK OH FUCK OH FUCK"

	decay_rate = 5 // 5% chance of a turf decaying on lighting update/airflow (there's no actual tick for turfs)

/datum/universal_state/hell/OnShuttleCall(var/mob/user)
	return 1
	/*
	if(user)
		to_chat(user, "<span class='sinister'>All you hear on the frequency is static and panicked screaming. There will be no shuttle call today.</span>")
	return 0
	*/

/datum/universal_state/hell/DecayTurf(var/turf/T)
	if(!T.holy)
		T.cultify()
		for(var/obj/machinery/light/L in T.contents)
			new /obj/structure/cult/pylon(L.loc)
			qdel(L)

// Apply changes when entering state
/datum/universal_state/hell/OnEnter()
	set background = 1
//	garbage_collector.garbage_collect = 0

	escape_list = get_area_turfs(locate(/area/hallway/secondary/exit))

	//Separated into separate procs for profiling
	AreaSet()
	MiscSet()
	APCSet()
	OverlayAndAmbientSet()
	lightsout(0,0)

	runedec += 9000	//basically removing the rune cap


/datum/universal_state/hell/proc/AreaSet()
	for(var/area/A in GLOB.sortedAreas)
		if(!istype(A,/area) || istype(A, /area/space))
			continue

		A.updateicon()

/datum/universal_state/hell/OverlayAndAmbientSet()
	spawn(0)
		for(var/datum/lighting_corner/L in world)
			L.update_lumcount(1, 0, 0)
		for(var/turf/space/T in world)
			T.color = "#FF0000"

/datum/universal_state/hell/proc/MiscSet()
	for(var/turf/simulated/floor/T in world)
		if(!T.holy && prob(1))
			new /obj/effect/gateway/active/cult(T)

	for (var/obj/machinery/firealarm/alm in GLOB.machines)
		if (!(alm.machine_stat & BROKEN))
			alm.ex_act(2)

/datum/universal_state/hell/proc/APCSet()
	for (var/obj/machinery/power/apc/APC in GLOB.apcs)
		if (!(APC.machine_stat & BROKEN) && !APC.is_critical)
			APC.emagged = 1
			APC.update_icon()

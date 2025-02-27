#define CONNECTION_DIRECT 2
#define CONNECTION_SPACE 4
#define CONNECTION_INVALID 8

/*

Overview:
	Connections are made between turfs by air_master.connect(). They represent a single point where two zones converge.

Class Vars:
	A - Always a simulated turf.
	B - A simulated or unsimulated turf.

	zoneA - The archived zone of A. Used to check that the zone hasn't changed.
	zoneB - The archived zone of B. May be null in case of unsimulated connections.

	edge - Stores the edge this connection is in. Can reference an edge that is no longer processed
		   after this connection is removed, so make sure to check edge.coefficient > 0 before re-adding it.

Class Procs:

	mark_direct()
		Marks this connection as direct. Does not update the edge.
		Called when the connection is made and there are no doors between A and B.
		Also called by update() as a correction.

	mark_indirect()
		Unmarks this connection as direct. Does not update the edge.
		Called by update() as a correction.

	mark_space()
		Marks this connection as unsimulated. Updating the connection will check the validity of this.
		Called when the connection is made.
		This will not be called as a correction, any connections failing a check against this mark are erased and rebuilt.

	direct()
		Returns 1 if no doors are in between A and B.

	valid()
		Returns 1 if the connection has not been erased.

	erase()
		Called by update() and connection_manager/erase_all().
		Marks the connection as erased and removes it from its edge.

	update()
		Called by connection_manager/update_all().
		Makes numerous checks to decide whether the connection is still valid. Erases it automatically if not.

*/

/datum/zas_connection
	var/turf/simulated/A
	var/turf/simulated/B
	var/datum/zas_zone/zoneA
	var/datum/zas_zone/zoneB
	var/datum/zas_edge/edge
	var/state = 0

/datum/zas_connection/New(turf/simulated/A, turf/simulated/B)
	#ifdef ZAS_DEBUG
	ASSERT(A.has_valid_zone())
	//ASSERT(air_master.has_valid_zone(B))
	#endif
	src.A = A
	src.B = B
	zoneA = A.zone
	if(!istype(B))
		mark_space()
		edge = air_master.get_edge(A.zone,B)
		edge.add_connection(src)
	else
		zoneB = B.zone
		edge = air_master.get_edge(A.zone,B.zone)
		edge.add_connection(src)

/datum/zas_connection/proc/mark_direct()
	if(!direct())
		state |= CONNECTION_DIRECT
		edge.direct++
	//to_chat(world, "Marked direct.")

/datum/zas_connection/proc/mark_indirect()
	if(direct())
		state &= ~CONNECTION_DIRECT
		edge.direct--
	//to_chat(world, "Marked indirect.")

/datum/zas_connection/proc/mark_space()
	state |= CONNECTION_SPACE

/datum/zas_connection/proc/direct()
	return (state & CONNECTION_DIRECT)

/datum/zas_connection/proc/valid()
	return !(state & CONNECTION_INVALID)

/datum/zas_connection/proc/erase()
	edge.remove_connection(src)
	state |= CONNECTION_INVALID
	//to_chat(world, "Connection Erased: [state]")

/datum/zas_connection/proc/update()
	//to_chat(world, "Updated, \...")
	if(!istype(A,/turf/simulated))
		//to_chat(world, "Invalid A.")
		erase()
		return

	var/block_status = A.CheckAirBlock(B)
	switch(block_status)
		if(ATMOS_PASS_AIR_BLOCKED)
			erase()
			return
		if(ATMOS_PASS_ZONE_BLOCKED)
			mark_indirect()
		if(ATMOS_PASS_NOT_BLOCKED)
			mark_direct()

	var/b_is_space = !istype(B,/turf/simulated)

	if(state & CONNECTION_SPACE)
		if(!b_is_space)
			//to_chat(world, "Invalid B.")
			erase()
			return
		if(A.zone != zoneA)
			//to_chat(world, "Zone changed, \...")
			if(!A.zone)
				erase()
				//to_chat(world, "erased.")
				return
			else
				edge.remove_connection(src)
				edge = air_master.get_edge(A.zone, B)
				edge.add_connection(src)
				zoneA = A.zone

		//to_chat(world, "valid.")
		return

	else if(b_is_space)
		//to_chat(world, "Invalid B.")
		erase()
		return

	if(A.zone == B.zone)
		//to_chat(world, "A == B")
		erase()
		return

	if(A.zone != zoneA || (zoneB && (B.zone != zoneB)))

		//to_chat(world, "Zones changed, \...")
		if(A.zone && B.zone)
			edge.remove_connection(src)
			edge = air_master.get_edge(A.zone, B.zone)
			edge.add_connection(src)
			zoneA = A.zone
			zoneB = B.zone
		else
			//to_chat(world, "erased.")
			erase()
			return


	//to_chat(world, "valid.")

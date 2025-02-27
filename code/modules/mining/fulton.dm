var/global/list/total_extraction_beacons = list()

/obj/item/extraction_pack
	name = "fulton extraction pack"
	desc = "A balloon pack that can be used to extract equipment or personnel to a Fulton Recovery Beacon. Anything not bolted down can be moved. Link the pack to a beacon by using the pack in hand."
	icon = 'icons/obj/fulton.dmi'
	icon_state = "extraction_pack"
	w_class = ITEMSIZE_NORMAL
	var/obj/structure/extraction_point/beacon
	var/list/beacon_networks = list("station")
	var/uses_left = 3
	var/can_use_indoors = FALSE
	var/safe_for_living_creatures = 1
	var/stuntime = 15

/obj/item/extraction_pack/wormhole
	name = "wormhole fulton extraction pack"
	desc = "A balloon pack with integrated wormhole technology and less disruptive movement that can be used to extract equipment or personnel to a Fulton Recovery Beacon. Anything not bolted down can be moved. Link the pack to a beacon by using the pack in hand."
	can_use_indoors = TRUE
	stuntime = 3

/obj/item/extraction_holdercrate
	name = "extraction crate"
	desc = "A regular old crate."
	icon = 'icons/obj/storage.dmi'
	icon_state = "phoroncrate"

/obj/item/extraction_pack/examine(mob/user)
	. = ..()
	. +="It has [uses_left] use\s remaining."

/obj/item/extraction_pack/attack_self(mob/user)
	var/list/possible_beacons = list()
	for(var/B in global.total_extraction_beacons)
		var/obj/structure/extraction_point/EP = B
		if(EP.beacon_network in beacon_networks)
			possible_beacons += EP

	if(!possible_beacons.len)
		to_chat(user, "There are no extraction beacons in existence!")
		return

	else
		var/A

		A = input("Select a beacon to connect to", "Balloon Extraction Pack", A) as null|anything in possible_beacons

		if(!A)
			return
		beacon = A
		to_chat(user, "You link the extraction pack to the beacon system.")

/obj/item/extraction_pack/afterattack(atom/movable/A, mob/living/carbon/user, flag, params)
	if(!beacon)
		to_chat(user, "[src] is not linked to a beacon, and cannot be used.")
		return
	if(!can_use_indoors)
		var/turf/T = get_turf(A)
		if(T && !T.outdoors)
			to_chat(user, "[src] can only be used on things that are outdoors!")
			return
	if(!flag)
		return
	if(!istype(A))
		return
	else
		if(!safe_for_living_creatures && check_for_living_mobs(A))
			to_chat(user, "[src] is not safe for use with living creatures, they wouldn't survive the trip back!")
			return
		if(!isturf(A.loc)) // no extracting stuff inside other stuff
			return
		if(A.anchored)
			return
		to_chat(user, "<span class='notice'>You start attaching the pack to [A]...</span>")
		if(do_after(user,50,target=A))
			to_chat(user, "<span class='notice'>You attach the pack to [A] and activate it.</span>")
			/* No components, sorry. No convienence for you!
			if(loc == user && istype(user.back, /obj/item/storage/backpack))
				var/obj/item/storage/backpack/B = user.back
				B.SendSignal(COMSIG_TRY_STORAGE_INSERT, src, user, FALSE, FALSE)
			*/
			uses_left--
			if(uses_left <= 0)
				user.temporarily_remove_from_inventory(src, INV_OP_FORCE | INV_OP_SHOULD_NOT_INTERCEPT | INV_OP_SILENT)
			var/mutable_appearance/balloon
			var/mutable_appearance/balloon2
			var/mutable_appearance/balloon3
			if(isliving(A))
				var/mob/living/M = A
				M.AdjustStunned(10) // Keep them from moving during the duration of the extraction
				if(M.buckled)
					M.buckled.unbuckle_mob(M)
			else
				A.anchored = TRUE
				A.density = FALSE
			var/obj/effect/extraction_holder/holder_obj = new(A.loc)
			holder_obj.appearance = /obj/item/extraction_holdercrate
			A.forceMove(holder_obj)
			balloon2 = mutable_appearance('icons/obj/fulton_balloon.dmi', "fulton_expand")
			balloon2.pixel_y = 18
			balloon2.appearance_flags = RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM
			holder_obj.add_overlay(balloon2)
			sleep(4)
			balloon = mutable_appearance('icons/obj/fulton_balloon.dmi', "fulton_balloon")
			balloon.pixel_y = 18
			balloon.appearance_flags = RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM
			holder_obj.cut_overlay(balloon2)
			holder_obj.add_overlay(balloon)
			playsound(holder_obj.loc, 'sound/items/fulext_deploy.wav', 50, 1, -3)
			update_icon(A)
			animate(holder_obj, pixel_z = 10, time = 20)
			sleep(20)
			animate(holder_obj, pixel_z = 15, time = 10)
			sleep(10)
			animate(holder_obj, pixel_z = 10, time = 10)
			sleep(10)
			animate(holder_obj, pixel_z = 15, time = 10)
			sleep(10)
			animate(holder_obj, pixel_z = 10, time = 10)
			sleep(10)
			playsound(holder_obj.loc, 'sound/items/fultext_launch.wav', 50, 1, -3)
			animate(holder_obj, pixel_z = 1000, time = 30)
			if(ishuman(A))
				var/mob/living/carbon/L = A
				L.AdjustStunned(stuntime)
				L.drowsyness = 0
				update_icon(A)
			sleep(30)
			var/list/flooring_near_beacon = list()
			for(var/turf/T in range(1, beacon))
				if(T.density)
					continue
				flooring_near_beacon += T
			if(!length(flooring_near_beacon))
				holder_obj.forceMove(get_turf(beacon))
			else
				holder_obj.forceMove(pick(flooring_near_beacon))
			animate(holder_obj, pixel_z = 10, time = 50)
			sleep(50)
			animate(holder_obj, pixel_z = 15, time = 10)
			sleep(10)
			animate(holder_obj, pixel_z = 10, time = 10)
			sleep(10)
			balloon3 = mutable_appearance('icons/obj/fulton_balloon.dmi', "fulton_retract")
			balloon3.pixel_y = 10
			balloon3.appearance_flags = RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM
			holder_obj.cut_overlay(balloon)
			holder_obj.add_overlay(balloon3)
			sleep(4)
			holder_obj.cut_overlay(balloon3)
			A.anchored = FALSE // An item has to be unanchored to be extracted in the first place.
			A.density = initial(A.density)
			animate(holder_obj, pixel_z = 0, time = 5)
			sleep(5)
			A.forceMove(holder_obj.loc)
			qdel(holder_obj)
			if(uses_left <= 0)
				qdel(src)


/obj/item/fulton_core
	name = "extraction beacon signaller"
	desc = "Emits a signal which fulton recovery devices can lock onto. Activate in hand to create a beacon."
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "subspace_amplifier"

/obj/item/fulton_core/attack_self(mob/user)
	if(do_after(user,15,target = user) && !QDELETED(src))
		new /obj/structure/extraction_point(get_turf(user))
		qdel(src)

/obj/structure/extraction_point
	name = "fulton recovery beacon"
	desc = "A beacon for the fulton recovery system. Activate a pack in your hand to link it to a beacon."
	icon = 'icons/obj/fulton.dmi'
	icon_state = "extraction_point"
	anchored = TRUE
	density = FALSE
	var/beacon_network = "station"

/obj/structure/extraction_point/Initialize(mapload)
	. = ..()
	name += " ([rand(100,999)]) ([get_area_name(src, TRUE)])"
	global.total_extraction_beacons += src

/obj/structure/extraction_point/Destroy()
	global.total_extraction_beacons -= src
	..()

/obj/effect/extraction_holder
	name = "extraction holder"
	desc = "you shouldnt see this"
	var/atom/movable/stored_obj

/obj/item/extraction_pack/proc/check_for_living_mobs(atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(L.stat != DEAD)
			return 1
	for(var/thing in A.GetAllContents())
		if(isliving(A))
			var/mob/living/L = A
			update_icon()
			if(L.stat != DEAD)
				return 1
	return 0

/obj/effect/extraction_holder/singularity_pull()
	return

/obj/effect/extraction_holder/singularity_pull()
	return

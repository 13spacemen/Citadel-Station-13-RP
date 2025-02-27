/obj/item/chameleon
	name = "chameleon projector"
	icon = 'icons/obj/device.dmi'
	icon_state = "shield0"
	slot_flags = SLOT_BELT
	item_state = "electronic"
	throwforce = 5.0
	throw_speed = 1
	throw_range = 5
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_ILLEGAL = 4, TECH_MAGNET = 4)
	var/can_use = 1
	var/obj/effect/dummy/chameleon/active_dummy = null
	var/saved_item = /obj/item/cigbutt
	var/saved_icon = 'icons/obj/clothing/masks.dmi'
	var/saved_icon_state = "cigbutt"
	var/saved_overlays

/obj/item/chameleon/dropped(mob/user, flags, atom/newLoc)
	disrupt()
	..()

/obj/item/chameleon/equipped(mob/user, slot, flags)
	..()
	disrupt()
	..()

/obj/item/chameleon/attack_self()
	toggle()

/obj/item/chameleon/afterattack(atom/target, mob/user , proximity)
	if(!proximity) return
	if(!active_dummy)
		if(istype(target,/obj/item) && !istype(target, /obj/item/disk/nuclear))
			playsound(get_turf(src), 'sound/weapons/flash.ogg', 100, 1, -6)
			to_chat(user, "<span class='notice'>Scanned [target].</span>")
			saved_item = target.type
			saved_icon = target.icon
			saved_icon_state = target.icon_state
			saved_overlays = target.overlays

/obj/item/chameleon/proc/toggle()
	if(!can_use || !saved_item) return
	if(active_dummy)
		eject_all()
		playsound(get_turf(src), 'sound/effects/pop.ogg', 100, 1, -6)
		qdel(active_dummy)
		active_dummy = null
		to_chat(usr, "<span class='notice'>You deactivate the [src].</span>")
		var/obj/effect/overlay/T = new /obj/effect/overlay(get_turf(src))
		T.icon = 'icons/effects/effects.dmi'
		flick("emppulse",T)
		spawn(8) qdel(T)
	else
		playsound(get_turf(src), 'sound/effects/pop.ogg', 100, 1, -6)
		var/obj/O = new saved_item(src)
		if(!O) return
		var/obj/effect/dummy/chameleon/C = new /obj/effect/dummy/chameleon(usr.loc)
		C.activate(O, usr, saved_icon, saved_icon_state, saved_overlays, src)
		qdel(O)
		to_chat(usr, "<span class='notice'>You activate the [src].</span>")
		var/obj/effect/overlay/T = new/obj/effect/overlay(get_turf(src))
		T.icon = 'icons/effects/effects.dmi'
		flick("emppulse",T)
		spawn(8) qdel(T)

/obj/item/chameleon/proc/disrupt(var/delete_dummy = 1)
	if(active_dummy)
		var/datum/effect_system/spark_spread/spark_system = new /datum/effect_system/spark_spread
		spark_system.set_up(5, 0, src)
		spark_system.attach(src)
		spark_system.start()
		eject_all()
		if(delete_dummy)
			qdel(active_dummy)
		active_dummy = null
		can_use = 0
		spawn(50) can_use = 1

/obj/item/chameleon/proc/eject_all()
	for(var/atom/movable/A in active_dummy)
		A.forceMove(active_dummy.loc)
		if(ismob(A))
			var/mob/M = A
			M.update_perspective()

/obj/effect/dummy/chameleon
	name = ""
	desc = ""
	density = 0
	anchored = 1
	var/can_move = 1
	var/obj/item/chameleon/master = null

/obj/effect/dummy/chameleon/proc/activate(var/obj/O, var/mob/M, new_icon, new_iconstate, new_overlays, var/obj/item/chameleon/C)
	name = O.name
	desc = O.desc
	icon = new_icon
	icon_state = new_iconstate
	overlays = new_overlays
	setDir(O.dir)
	M.loc = src
	master = C
	master.active_dummy = src

/obj/effect/dummy/chameleon/attackby()
	for(var/mob/M in src)
		to_chat(M, "<span class='warning'>Your chameleon-projector deactivates.</span>")
	master.disrupt()

/obj/effect/dummy/chameleon/attack_hand()
	for(var/mob/M in src)
		to_chat(M, "<span class='warning'>Your chameleon-projector deactivates.</span>")
	master.disrupt()

/obj/effect/dummy/chameleon/ex_act()
	for(var/mob/M in src)
		to_chat(M, "<span class='warning'>Your chameleon-projector deactivates.</span>")
	master.disrupt()

/obj/effect/dummy/chameleon/bullet_act()
	for(var/mob/M in src)
		to_chat(M, "<span class='warning'>Your chameleon-projector deactivates.</span>")
	..()
	master.disrupt()

/obj/effect/dummy/chameleon/relaymove(var/mob/user, direction)
	if(istype(loc, /turf/space)) return //No magical space movement!

	if(can_move)
		can_move = 0
		switch(user.bodytemperature)
			if(300 to INFINITY)
				spawn(10) can_move = 1
			if(295 to 300)
				spawn(13) can_move = 1
			if(280 to 295)
				spawn(16) can_move = 1
			if(260 to 280)
				spawn(20) can_move = 1
			else
				spawn(25) can_move = 1
		step(src, direction)
	return

/obj/effect/dummy/chameleon/Destroy()
	master.disrupt(0)
	..()

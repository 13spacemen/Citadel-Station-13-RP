// Used to deploy the bacon.
/obj/item/supply_beacon
	name = "inactive supply beacon"
	icon = 'icons/obj/supplybeacon.dmi'
	desc = "An inactive, hacked supply beacon stamped with the local system's Rapid Fabrication logo. Good for one (1) ballistic supply pod shipment."
	icon_state = "beacon"
	var/deploy_path = /obj/machinery/power/supply_beacon
	var/deploy_time = 30

/obj/item/supply_beacon/supermatter
	name = "inactive supermatter supply beacon"
	deploy_path = /obj/machinery/power/supply_beacon/supermatter

/obj/item/supply_beacon/attack_self(var/mob/user)
	user.visible_message("<span class='notice'>\The [user] begins setting up \the [src].</span>")
	if(!do_after(user, deploy_time))
		return
	var/obj/S = new deploy_path(get_turf(user))
	user.visible_message("<span class='notice'>\The [user] deploys \the [S].</span>")
	qdel(src)

/obj/machinery/power/supply_beacon
	name = "supply beacon"
	desc = "A bulky moonshot supply beacon. Someone has been messing with the wiring."
	icon = 'icons/obj/supplybeacon.dmi'
	icon_state = "beacon"

	anchored = FALSE
	density = TRUE
	layer = MOB_LAYER - 0.1

	var/target_drop_time
	var/drop_delay = 450
	var/expended
	var/drop_type

/obj/machinery/power/supply_beacon/Initialize(mapload, newdir)
	. = ..()
	if(!drop_type)
		drop_type = pick(supply_drop_random_loot_types())

/obj/machinery/power/supply_beacon/supermatter
	name = "supermatter supply beacon"
	drop_type = "supermatter"

/obj/machinery/power/supply_beacon/attackby(obj/item/W, mob/user)
	if(!use_power && W.is_wrench())
		if(!anchored && !connect_to_network())
			to_chat(user, "<span class='warning'>This device must be placed over an exposed cable.</span>")
			return
		anchored = !anchored
		user.visible_message("<span class='notice'>\The [user] [anchored ? "secures" : "unsecures"] \the [src].</span>")
		playsound(src, W.usesound, 50, 1)
		return
	return ..()

/obj/machinery/power/supply_beacon/attack_hand(mob/user)

	if(expended)
		update_use_power(USE_POWER_OFF)
		to_chat (user, "<span class='warning'>\The [src] has used up its charge.</span>")
		return

	if(anchored)
		return use_power ? deactivate(user) : activate(user)
	else
		to_chat(user, "<span class='warning'>You need to secure the beacon with a wrench first!</span>")
		return

/obj/machinery/power/supply_beacon/attack_ai(mob/user)
	if(user.Adjacent(src))
		attack_hand(user)

/obj/machinery/power/supply_beacon/proc/activate(mob/user)
	if(expended)
		return
	// 0.5 kw
	if(surplus() < 0.5)
		if(user) to_chat(user, "<span class='notice'>The connected wire doesn't have enough current.</span>")
		return
	set_light(3, 3, "#00CCAA")
	icon_state = "beacon_active"
	use_power = USE_POWER_IDLE
	if(user) to_chat(user, "<span class='notice'>You activate the beacon. The supply drop will be dispatched soon.</span>")

/obj/machinery/power/supply_beacon/proc/deactivate(mob/user, permanent)
	if(permanent)
		expended = 1
		icon_state = "beacon_depleted"
	else
		icon_state = "beacon"
	set_light(0)
	use_power = USE_POWER_OFF
	target_drop_time = null
	if(user) to_chat(user, "<span class='notice'>You deactivate the beacon.</span>")

/obj/machinery/power/supply_beacon/Destroy()
	if(use_power)
		deactivate()
	..()

/obj/machinery/power/supply_beacon/process(delta_time)
	if(expended)
		return PROCESS_KILL
	if(!use_power)
		return
	if(draw_power(0.5) < 0.5)
		deactivate()
		return
	if(!target_drop_time)
		target_drop_time = world.time + drop_delay
	else if(world.time >= target_drop_time)
		deactivate(permanent = 1)
		var/drop_x = src.x - 2
		var/drop_y = src.y - 2
		var/drop_z = src.z
		command_announcement.Announce("[GLOB.using_map.starsys_name] Rapid Fabrication priority supply request #[rand(1000,9999)]-[rand(100,999)] recieved. Shipment dispatched via ballistic supply pod for immediate delivery. Have a nice day.", "Thank You For Your Patronage")
		spawn(rand(100, 300))
			new /datum/random_map/droppod/supply(null, drop_x, drop_y, drop_z, supplied_drop = drop_type) // Splat.

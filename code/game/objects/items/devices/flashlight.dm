/obj/item/flashlight
	name = "flashlight"
	desc = "A hand-held emergency light."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "flashlight"
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_BELT
	matter = list(MAT_STEEL = 50, MAT_GLASS = 20)
	action_button_name = "Toggle Flashlight"
	var/on = FALSE
	///Luminosity when on
	var/brightness_on = 4
	///Lighting power when on
	var/flashlight_power = 0.8
	///Lighting colour when on
	var/flashlight_colour = LIGHT_COLOR_INCANDESCENT_FLASHLIGHT
	var/obj/item/cell/cell
	var/cell_type = /obj/item/cell/device
	var/list/brightness_levels
	var/brightness_level = "medium"
	var/power_usage
	var/power_use = 1

/obj/item/flashlight/Initialize(mapload)
	. = ..()

	if(power_use && cell_type)
		cell = new cell_type(src)
		brightness_levels = list("low" = 0.25, "medium" = 0.5, "high" = 1)
		power_usage = brightness_levels[brightness_level]
	else
		verbs -= /obj/item/flashlight/verb/toggle

	update_icon()

/obj/item/flashlight/Destroy()
	STOP_PROCESSING(SSobj, src)
	QDEL_NULL(cell)
	return ..()

/obj/item/flashlight/get_cell()
	return cell

/obj/item/flashlight/verb/toggle()
	set name = "Toggle Flashlight Brightness"
	set category = "Object"
	set src in usr
	set_brightness(usr)

/obj/item/flashlight/proc/set_brightness(mob/user as mob)
	var/choice = input("Choose a brightness level.") as null|anything in brightness_levels
	if(choice)
		brightness_level = choice
		power_usage = brightness_levels[choice]
		to_chat(user, SPAN_NOTICE("You set the brightness level on \the [src] to [brightness_level]."))
		update_icon()

/obj/item/flashlight/process(delta_time)
	if(!on || !cell)
		return PROCESS_KILL

	if(brightness_level && power_usage)
		if(cell.use(power_usage) != power_usage) //We weren't able to use our full power_usage amount!
			visible_message(SPAN_WARNING("\The [src] flickers before going dull."))
			set_light(FALSE)
			playsound(src.loc, 'sound/effects/sparks3.ogg', 10, 1, -3) //Small cue that your light went dull in your pocket.
			on = FALSE
			update_icon()
			return PROCESS_KILL

/obj/item/flashlight/update_icon()
	if(on)
		icon_state = "[initial(icon_state)]-on"

		if(brightness_level == "low")
			set_light(brightness_on/2, flashlight_power*0.75, flashlight_colour)
		else if(brightness_level == "high")
			set_light(brightness_on*1.5, flashlight_power*1.1, flashlight_colour)
		else
			set_light(brightness_on, flashlight_power, flashlight_colour)

	else
		icon_state = "[initial(icon_state)]"
		set_light(0)

/obj/item/flashlight/examine(mob/user)
	. = ..()
	if(power_use && brightness_level)
		. += "\The [src] is set to [brightness_level]. "
		if(cell)
			. += "\The [src] has a \the [cell] attached. "
			if(cell.charge <= cell.maxcharge*0.25)
				. += "It appears to have a low amount of power remaining."
			else if(cell.charge > cell.maxcharge*0.25 && cell.charge <= cell.maxcharge*0.5)
				. += "It appears to have an average amount of power remaining."
			else if(cell.charge > cell.maxcharge*0.5 && cell.charge <= cell.maxcharge*0.75)
				. += "It appears to have an above average amount of power remaining."
			else if(cell.charge > cell.maxcharge*0.75 && cell.charge <= cell.maxcharge)
				. += "It appears to have a high amount of power remaining."

/obj/item/flashlight/AltClick(mob/user)
	attack_self(user)

/obj/item/flashlight/attack_self(mob/user)
	if(power_use)
		if(!isturf(user.loc))
			to_chat(user, "You cannot turn the light on while in this [user.loc].") //To prevent some lighting anomalities.
			return FALSE
		if(!cell || cell.charge == 0)
			to_chat(user, "You flick the switch on [src], but nothing happens.")
			return FALSE
	on = !on
	if(on && power_use)
		START_PROCESSING(SSobj, src)
	else if(power_use)
		STOP_PROCESSING(SSobj, src)
	playsound(src.loc, 'sound/weapons/empty.ogg', 15, 1, -3)
	update_icon()
	user.update_action_buttons()
	return TRUE

/obj/item/flashlight/emp_act(severity)
	for(var/obj/O in contents)
		O.emp_act(severity)
	..()

/obj/item/flashlight/attack(mob/living/M as mob, mob/living/user as mob)
	add_fingerprint(user)
	if(on && user.zone_sel.selecting == O_EYES)

		if((CLUMSY in user.mutations) && prob(50))	//too dumb to use flashlight properly
			return ..()	//just hit them in the head

		var/mob/living/carbon/human/H = M	//mob has protective eyewear
		if(istype(H))
			for(var/obj/item/clothing/C in list(H.head,H.wear_mask,H.glasses))
				if(istype(C) && (C.body_parts_covered & EYES))
					to_chat(user, SPAN_WARNING("You're going to need to remove [C.name] first."))
					return

			var/obj/item/organ/vision
			if(H.species.vision_organ)
				vision = H.internal_organs_by_name[H.species.vision_organ]
			if(!vision)
				to_chat(user, SPAN_WARNING("You can't find any [H.species.vision_organ ? H.species.vision_organ : "eyes"] on [H]!"))

			user.visible_message(SPAN_NOTICE("\The [user] directs [src] to [M]'s eyes."), \
							 	 SPAN_NOTICE("You direct [src] to [M]'s eyes."))
			if(H != user)	//can't look into your own eyes buster
				if(M.stat == DEAD || M.blinded)	//mob is dead or fully blind
					to_chat(user, SPAN_WARNING("\The [M]'s pupils do not react to the light!"))
					return
				if(XRAY in M.mutations)
					to_chat(user, SPAN_NOTICE("\The [M] pupils give an eerie glow!"))
				if(vision.is_bruised())
					to_chat(user, SPAN_WARNING("There's visible damage to [M]'s [vision.name]!"))
				else if(M.eye_blurry)
					to_chat(user, SPAN_NOTICE("\The [M]'s pupils react slower than normally."))
				if(M.getBrainLoss() > 15)
					to_chat(user, SPAN_NOTICE("There's visible lag between left and right pupils' reactions."))

				var/list/pinpoint = list("oxycodone"=1,"tramadol"=5)
				var/list/dilating = list("space_drugs"=5,"mindbreaker"=1)
				if(M.reagents.has_any_reagent(pinpoint) || H.ingested.has_any_reagent(pinpoint))
					to_chat(user, SPAN_NOTICE("\The [M]'s pupils are already pinpoint and cannot narrow any more."))
				else if(M.reagents.has_any_reagent(dilating) || H.ingested.has_any_reagent(dilating))
					to_chat(user, SPAN_NOTICE("\The [M]'s pupils narrow slightly, but are still very dilated."))
				else
					to_chat(user, SPAN_NOTICE("\The [M]'s pupils narrow."))

			user.setClickCooldown(user.get_attack_speed(src)) //can be used offensively
			M.flash_eyes()
	else
		return ..()

/obj/item/flashlight/attack_hand(mob/user as mob)
	if(user.get_inactive_held_item() == src)
		if(cell)
			cell.update_icon()
			user.put_in_hands(cell)
			cell = null
			to_chat(user, SPAN_NOTICE("You remove the cell from the [src]."))
			playsound(src, 'sound/machines/button.ogg', 30, TRUE, 0)
			on = FALSE
			update_icon()
			return
		..()
	else
		return ..()

/obj/item/flashlight/attackby(obj/item/W, mob/user as mob)
	if(power_use)
		if(istype(W, /obj/item/cell))
			if(istype(W, /obj/item/cell/device))
				if(!cell)
					if(!user.attempt_insert_item_for_installation(W, src))
						return
					cell = W
					to_chat(user, SPAN_NOTICE("You install a cell in \the [src]."))
					playsound(src, 'sound/machines/button.ogg', 30, 1, 0)
					update_icon()
				else
					to_chat(user, SPAN_NOTICE("\The [src] already has a cell."))
			else
				to_chat(user, SPAN_NOTICE("\The [src] cannot use that type of cell."))
	else
		..()

/obj/item/flashlight/pen
	name = "penlight"
	desc = "A pen-sized light, used by medical staff."
	icon_state = "penlight"
	item_state = "pen"
	drop_sound = 'sound/items/drop/accessory.ogg'
	pickup_sound = 'sound/items/pickup/accessory.ogg'
	slot_flags = SLOT_EARS
	brightness_on = 2
	w_class = ITEMSIZE_TINY
	power_use = 0

/obj/item/flashlight/color	//Default color is blue, just roll with it.
	name = "blue flashlight"
	desc = "A hand-held emergency light. This one is blue."
	icon_state = "flashlight_blue"

/obj/item/flashlight/color/red
	name = "red flashlight"
	desc = "A hand-held emergency light. This one is red."
	icon_state = "flashlight_red"

/obj/item/flashlight/color/orange
	name = "orange flashlight"
	desc = "A hand-held emergency light. This one is orange."
	icon_state = "flashlight_orange"

/obj/item/flashlight/color/yellow
	name = "yellow flashlight"
	desc = "A hand-held emergency light. This one is yellow."
	icon_state = "flashlight_yellow"

/obj/item/flashlight/maglight
	name = "maglight"
	desc = "A very, very heavy duty flashlight."
	icon_state = "maglight"
	flashlight_colour = LIGHT_COLOR_FLUORESCENT_FLASHLIGHT
	force = 10
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_SMALL
	attack_verb = list ("smacked", "thwacked", "thunked")
	matter = list(MAT_STEEL = 200, MAT_GLASS = 50)
	hitsound = "swing_hit"

/obj/item/flashlight/drone
	name = "low-power flashlight"
	desc = "A miniature lamp, that might be used by small robots."
	icon_state = "penlight"
	item_state = null
	brightness_on = 2
	w_class = ITEMSIZE_TINY
	power_use = 0

// the desk lamps are a bit special
/obj/item/flashlight/lamp
	name = "desk lamp"
	desc = "A desk lamp with an adjustable mount."
	icon_state = "lamp"
	force = 10
	brightness_on = 5
	w_class = ITEMSIZE_LARGE
	power_use = 0
	on = 1


// green-shaded desk lamp
/obj/item/flashlight/lamp/green
	desc = "A classic green-shaded desk lamp."
	icon_state = "lampgreen"
	brightness_on = 5
	flashlight_colour = "#FFC58F"

/obj/item/flashlight/lamp/verb/toggle_light()
	set name = "Toggle light"
	set category = "Object"
	set src in oview(1)

	if(!usr.stat)
		attack_self(usr)

// FLARES

/obj/item/flashlight/flare
	name = "flare"
	desc = "A red standard-issue flare. There are instructions on the side reading 'pull cord, make light'."
	w_class = ITEMSIZE_SMALL
	brightness_on = 8 // Pretty bright.
	flashlight_power = 0.8
	flashlight_colour = LIGHT_COLOR_FLARE
	icon_state = "flare"
	item_state = "flare"
	action_button_name = null //just pull it manually, neckbeard.
	var/fuel = 0
	var/on_damage = 7
	var/produce_heat = 1500
	power_use = 0
	drop_sound = 'sound/items/drop/gloves.ogg'
	pickup_sound = 'sound/items/pickup/gloves.ogg'

/obj/item/flashlight/flare/Initialize(mapload)
	. = ..()
	fuel = rand(800, 1000) // Sorry for changing this so much but I keep under-estimating how long X number of ticks last in seconds.

/obj/item/flashlight/flare/process(delta_time)
	var/turf/pos = get_turf(src)
	if(pos)
		pos.hotspot_expose(produce_heat, 5)
	fuel = max(fuel - 1, 0)
	if(!fuel || !on)
		turn_off()
		if(!fuel)
			src.icon_state = "[initial(icon_state)]-empty"
		STOP_PROCESSING(SSobj, src)

/obj/item/flashlight/flare/proc/turn_off()
	on = FALSE
	src.force = initial(src.force)
	src.damtype = initial(src.damtype)
	update_icon()

/obj/item/flashlight/flare/attack_self(mob/user)

	// Usual checks
	if(!fuel)
		to_chat(user, SPAN_NOTICE("It's out of fuel."))
		return
	if(on)
		return

	. = ..()
	// All good, turn it on.
	if(.)
		user.visible_message(SPAN_NOTICE("[user] activates the flare."), SPAN_NOTICE("You pull the cord on the flare, activating it!"))
		src.force = on_damage
		src.damtype = "fire"
		START_PROCESSING(SSobj, src)

/obj/item/flashlight/flare/proc/ignite() //Used for flare launchers.
	on = !on
	update_icon()
	force = on_damage
	damtype = "fire"
	START_PROCESSING(SSobj, src)
	return TRUE

//Glowsticks

/obj/item/flashlight/glowstick
	name = "green glowstick"
	desc = "A green military-grade glowstick."
	w_class = ITEMSIZE_SMALL
	brightness_on = 4
	flashlight_power = 0.9
	flashlight_colour = "#49F37C"
	icon_state = "glowstick"
	item_state = "glowstick"
	var/fuel = 0
	power_use = 0

/obj/item/flashlight/glowstick/Initialize(mapload)
	. = ..()
	fuel = rand(1600, 2000)

/obj/item/flashlight/glowstick/process(delta_time)
	fuel = max(fuel - 1, 0)
	if(!fuel || !on)
		turn_off()
		if(!fuel)
			src.icon_state = "[initial(icon_state)]-empty"
		STOP_PROCESSING(SSobj, src)

/obj/item/flashlight/glowstick/proc/turn_off()
	on = FALSE
	update_icon()

/obj/item/flashlight/glowstick/attack_self(mob/user)

	if(!fuel)
		to_chat(user, SPAN_NOTICE("The glowstick has already been turned on."))
		return
	if(on)
		return

	. = ..()
	if(.)
		user.visible_message(SPAN_NOTICE("[user] cracks and shakes the glowstick."), SPAN_NOTICE("You crack and shake the glowstick, turning it on!"))
		START_PROCESSING(SSobj, src)

/obj/item/flashlight/glowstick/red
	name = "red glowstick"
	desc = "A red military-grade glowstick."
	flashlight_colour = "#FC0F29"
	icon_state = "glowstick_red"
	item_state = "glowstick_red"

/obj/item/flashlight/glowstick/blue
	name = "blue glowstick"
	desc = "A blue military-grade glowstick."
	flashlight_colour = "#599DFF"
	icon_state = "glowstick_blue"
	item_state = "glowstick_blue"

/obj/item/flashlight/glowstick/orange
	name = "orange glowstick"
	desc = "A orange military-grade glowstick."
	flashlight_colour = "#FA7C0B"
	icon_state = "glowstick_orange"
	item_state = "glowstick_orange"

/obj/item/flashlight/glowstick/yellow
	name = "yellow glowstick"
	desc = "A yellow military-grade glowstick."
	flashlight_colour = "#FEF923"
	icon_state = "glowstick_yellow"
	item_state = "glowstick_yellow"

/obj/item/flashlight/slime
	gender = PLURAL
	name = "glowing slime extract"
	desc = "A slimy ball that appears to be glowing from bioluminesence."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "floor1" //not a slime extract sprite but... something close enough!
	item_state = "slime"
	flashlight_colour = "#FFF423"
	w_class = ITEMSIZE_TINY
	brightness_on = 6
	on = TRUE //Bio-luminesence has one setting, on.
	power_use = 0

/obj/item/flashlight/slime/Initialize(mapload)
	. = ..()
	set_light(brightness_on, flashlight_power, flashlight_colour)

/obj/item/flashlight/slime/update_icon()
	return

/obj/item/flashlight/slime/attack_self(mob/user)
	return //Bio-luminescence does not toggle.

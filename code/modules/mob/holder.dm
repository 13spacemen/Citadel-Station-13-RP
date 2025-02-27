//Helper object for picking dionaea (and other creatures) up.
/obj/item/holder
	name = "holder"
	desc = "You shouldn't ever see this."
	icon = 'icons/obj/objects.dmi'
	slot_flags = SLOT_HEAD | SLOT_HOLSTER
	show_messages = 1

	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/mob/clothing/species/teshari/head.dmi',
		SPECIES_VOX = 'icons/mob/clothing/species/vox/head.dmi'
		)

	origin_tech = null
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_holder.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_holder.dmi',
		)
	pixel_y = 8
	var/static/list/holder_mob_icon_cache = list()
	var/mob/living/held_mob

/obj/item/holder/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/holder/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/holder/process(delta_time)
	update_state()
	drop_items()

/obj/item/holder/dropped(mob/user, flags, atom/newLoc)
	. = ..()
	update_state()

/obj/item/holder/examine(mob/user)
	return held_mob?.examine(user) || list("WARNING WARNING: No held_mob on examine. REPORT THIS TO A CODER.")

/obj/item/holder/proc/update_state()
	if(!(contents.len))
		qdel(src)
	else if(isturf(loc))
		drop_items()
		if(held_mob)
			held_mob.forceMove(loc)
			held_mob = null
		qdel(src)

/obj/item/holder/proc/drop_items()
	for(var/atom/movable/M in contents)
		if(M == held_mob)
			continue
		M.forceMove(get_turf(src))

/obj/item/holder/onDropInto(var/atom/movable/AM)
	if(ismob(loc))   // Bypass our holding mob and drop directly to its loc
		return loc.loc
	return ..()

/obj/item/holder/GetID()
	for(var/mob/M in contents)
		var/obj/item/I = M.GetIdCard()
		if(I)
			return I
	return null

/obj/item/holder/GetAccess()
	var/obj/item/I = GetID()
	return I ? I.GetAccess() : ..()

/obj/item/holder/proc/sync(var/mob/living/M)
	dir = 2
	overlays.Cut()
	icon = M.icon
	icon_state = M.icon_state
	item_state = M.item_state
	color = M.color
	name = M.name
	desc = M.desc
	overlays |= M.overlays
	var/mob/living/carbon/human/H = loc
	if(istype(H))
		if(H.l_hand == src)
			H.update_inv_l_hand()
		else if(H.r_hand == src)
			H.update_inv_r_hand()

/obj/item/holder/container_resist(mob/living/held)
	var/mob/M = loc
	if(istype(M))
		M.drop_item_to_ground(src, INV_OP_FORCE)
		to_chat(M, SPAN_WARNING("\The [held] wriggles out of your grip!"))
		to_chat(held, SPAN_WARNING("You wiggle out of [M]'s grip!"))
	else if(istype(loc, /obj/item/clothing/accessory/holster))
		var/obj/item/clothing/accessory/holster/holster = loc
		if(holster.holstered == src)
			holster.clear_holster()
		to_chat(held, SPAN_WARNING("You extricate yourself from [holster]."))
		held.forceMove(get_turf(held))
	else if(isitem(loc))
		to_chat(held, SPAN_WARNING("You struggle free of [loc]."))
		held.forceMove(get_turf(held))


//Mob specific holders.
/obj/item/holder/diona
	origin_tech = list(TECH_MAGNET = 3, TECH_BIO = 5)
	slot_flags = SLOT_HEAD | SLOT_OCLOTHING | SLOT_HOLSTER

/obj/item/holder/drone
	origin_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 5)

/obj/item/holder/pai
	origin_tech = list(TECH_DATA = 2)

/obj/item/holder/mouse
	w_class = ITEMSIZE_TINY

/obj/item/holder/borer
	origin_tech = list(TECH_BIO = 6)

/obj/item/holder/leech
	color = "#003366"
	origin_tech = list(TECH_BIO = 5, TECH_PHORON = 2)

/obj/item/holder/fish
	attack_verb = list("fished", "disrespected", "smacked", "smackereled")
	hitsound = 'sound/effects/slime_squish.ogg'
	slot_flags = SLOT_HOLSTER
	origin_tech = list(TECH_BIO = 3)

/obj/item/holder/protoblob
	slot_flags = SLOT_HEAD | SLOT_OCLOTHING | SLOT_HOLSTER | SLOT_ICLOTHING | SLOT_ID
	w_class = ITEMSIZE_TINY
	allowed = list(/obj/item/gun,/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/melee/baton)


/obj/item/holder/fish/afterattack(var/atom/target, var/mob/living/user, proximity)
	if(!target)
		return
	if(!proximity)
		return
	if(isliving(target))
		var/mob/living/L = target
		if(prob(10))
			L.Stun(2)

//Roach Types
/obj/item/holder/roach
	w_class = ITEMSIZE_TINY
/obj/item/holder/roachling
	w_class = ITEMSIZE_TINY
/obj/item/holder/panzer
	w_class = ITEMSIZE_TINY
/obj/item/holder/jager
	w_class = ITEMSIZE_TINY
/obj/item/holder/seuche
	w_class = ITEMSIZE_TINY
/obj/item/holder/fuhrer
	w_class = ITEMSIZE_TINY

/obj/item/holder/attackby(obj/item/W as obj, mob/user as mob)
	for(var/mob/M in src.contents)
		M.attackby(W,user)

//Mob procs and vars for scooping up
/mob/living/var/holder_type

/mob/living/OnMouseDropLegacy(var/atom/over_object)
	var/mob/living/carbon/human/H = over_object
	if((usr == over_object || usr == src) && holder_type && issmall(src) && istype(H) && !H.lying && Adjacent(H) && (src.a_intent == INTENT_HELP && H.a_intent == INTENT_HELP))
		if(!issmall(H) || !istype(src, /mob/living/carbon/human))
			get_scooped(H, (usr == src))
		return
	return ..()

/mob/living/proc/get_scooped(var/mob/living/carbon/grabber, var/self_grab)

	if(!holder_type || buckled || pinned.len)
		return

	if(self_grab)
		if(src.incapacitated()) return
	else
		if(grabber.incapacitated()) return

	var/obj/item/holder/H = new holder_type(get_turf(src))
	H.held_mob = src
	src.forceMove(H)
	grabber.put_in_hands(H)

	if(self_grab)
		to_chat(grabber, "<span class='notice'>\The [src] clambers onto you!</span>")
		to_chat(src, "<span class='notice'>You climb up onto \the [grabber]!</span>")
		grabber.equip_to_slot_if_possible(H, SLOT_ID_BACK, INV_OP_SILENT)
	else
		to_chat(grabber, "<span class='notice'>You scoop up \the [src]!</span>")
		to_chat(src, "<span class='notice'>\The [grabber] scoops you up!</span>")

	H.sync(src)
	return H

/obj/item/holder/human
	icon = 'icons/mob/holder_complex.dmi'
	var/list/generate_for_slots = list(slot_l_hand_str, slot_r_hand_str, SLOT_ID_BACK)
	slot_flags = SLOT_BACK

/obj/item/holder/human/sync(var/mob/living/M)

	// Generate appropriate on-mob icons.
	var/mob/living/carbon/human/owner = M
	if(istype(owner) && owner.species)

		var/skin_colour = rgb(owner.r_skin, owner.g_skin, owner.b_skin)
		var/hair_colour = rgb(owner.r_hair, owner.g_hair, owner.b_hair)
		var/eye_colour =  rgb(owner.r_eyes, owner.g_eyes, owner.b_eyes)
		var/species_name = lowertext(owner.species.get_bodytype_legacy(owner))

		for(var/cache_entry in generate_for_slots)
			var/cache_key = "[owner.species]-[cache_entry]-[skin_colour]-[hair_colour]"
			if(!holder_mob_icon_cache[cache_key])

				// Generate individual icons.
				var/icon/mob_icon = icon(icon, "[species_name]_holder_[cache_entry]_base")
				mob_icon.Blend(skin_colour, ICON_ADD)
				var/icon/hair_icon = icon(icon, "[species_name]_holder_[cache_entry]_hair")
				hair_icon.Blend(hair_colour, ICON_ADD)
				var/icon/eyes_icon = icon(icon, "[species_name]_holder_[cache_entry]_eyes")
				eyes_icon.Blend(eye_colour, ICON_ADD)

				// Blend them together.
				mob_icon.Blend(eyes_icon, ICON_OVERLAY)
				mob_icon.Blend(hair_icon, ICON_OVERLAY)

				// Add to the cache.
				holder_mob_icon_cache[cache_key] = mob_icon
			item_icons[cache_entry] = holder_mob_icon_cache[cache_key]

	// Handle the rest of sync().
	..(M)

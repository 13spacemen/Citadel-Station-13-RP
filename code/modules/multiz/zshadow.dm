/mob  // TODO: rewrite as obj.
	var/mob/zshadow/shadow

/mob/zshadow
	plane = OVER_OPENSPACE_PLANE
	name = "shadow"
	desc = "Z-level shadow"
	status_flags = GODMODE
	anchored = 1
	unacidable = 1
	density = 0
	opacity = 0					// Don't trigger lighting recalcs gah! TODO - consider multi-z lighting.
	//auto_init = FALSE 			// We do not need to be initialize()d
	var/mob/owner = null		// What we are a shadow of.

/mob/zshadow/can_fall()
	return FALSE

/mob/zshadow/Initialize(mapload, mob/attach)
	. = ..()
	owner = attach
	sync_icon(attach)

/mob/zshadow/Destroy()
	if(owner)
		if(owner.shadow == src)
			owner.shadow = null
		owner = null
	..() //But we don't return because the hint is wrong
	return QDEL_HINT_QUEUE

/mob/Destroy()
	if(shadow)
		QDEL_NULL(shadow)
	return ..()

/mob/zshadow/examine(mob/user)
	if(!owner)
	 	// The only time we should have a null owner is if we are in nullspace. Help figure out why we were examined.
		stack_trace("[src] ([type]) @ [log_info_line()] was examined by [user] @ [global.log_info_line(user)]")
		return
	return owner.examine(user)

// Relay some stuff they hear
/mob/zshadow/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "", var/italics = 0, var/mob/speaker = null, var/sound/speech_sound, var/sound_vol)
	if(speaker && speaker.z != src.z)
		return // Only relay speech on our acutal z, otherwise we might relay sounds that were themselves relayed up!
	if(isliving(owner))
		verb += " from above"
	return owner.hear_say(message, verb, language, alt_name, italics, speaker, speech_sound, sound_vol)

/mob/zshadow/proc/sync_icon(var/mob/M)
	name = M.name
	icon = M.icon
	icon_state = M.icon_state
	//color = M.color
	color = "#848484"
	overlays = M.overlays
	transform = M.transform
	dir = M.dir
	invisibility = M.invisibility
	if(shadow)
		shadow.sync_icon(src)

/mob/living/Moved()
	. = ..()
	check_shadow()

/mob/living/forceMove()
	. = ..()
	check_shadow()

/mob/living/proc/check_shadow()
	var/mob/M = src
	if(!isturf(M.loc))
		if(M.shadow)
			QDEL_NULL(M.shadow)
		return
	var/turf/simulated/open/OS = GetAbove(M)
	while(istype(OS))
		if(!M.shadow)
			M.shadow = new /mob/zshadow(OS, M)
		M.shadow.forceMove(OS)
		M = M.shadow
		OS = OS.Above()
	// The topmost level does not need a shadow!
	if(M.shadow)
		QDEL_NULL(M.shadow)

//
// Handle cases where the owner mob might have changed its icon or overlays.
//

/mob/living/update_icons()
	. = ..()
	if(shadow)
		shadow.sync_icon(src)

// WARNING - the true carbon/human/update_icons does not call ..(), therefore we must sideways override this.
// But be careful, we don't want to screw with that proc.  So lets be cautious about what we do here.
/mob/living/carbon/human/update_icons()
	. = ..()
	if(shadow)
		shadow.sync_icon(src)

/mob/setDir(new_dir)
	. = ..()
	if(shadow)
		shadow.setDir(new_dir)

// Transfer messages about what we are doing to upstairs
/mob/visible_message(var/message, var/self_message, var/blind_message, range)
	. = ..()
	if(shadow)
		shadow.visible_message(message, self_message, blind_message, range)

/mob/zshadow/set_typing_indicator(var/state)
	if(!typing_indicator)
		typing_indicator = new
		typing_indicator.icon = 'icons/mob/talk_vr.dmi'
		typing_indicator.icon_state = "typing"
	if(state && !typing)
		overlays += typing_indicator
		typing = 1
	else if(!state && typing)
		overlays -= typing_indicator
		typing = 0
	if(shadow)
		shadow.set_typing_indicator(state)

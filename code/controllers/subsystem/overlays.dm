SUBSYSTEM_DEF(overlays)
	name = "Overlay"
	subsystem_flags = SS_TICKER
	wait = 1
	priority = FIRE_PRIORITY_OVERLAYS
	init_order = INIT_ORDER_OVERLAY

	var/list/queue						// Queue of atoms needing overlay compiling (TODO-VERIFY!)
	var/list/stats
	var/list/overlay_icon_state_caches	// Cache thing
	var/list/overlay_icon_cache			// Cache thing

/datum/controller/subsystem/overlays/PreInit()
	overlay_icon_state_caches = list()
	overlay_icon_cache = list()
	queue = list()
	stats = list()

/datum/controller/subsystem/overlays/Initialize()
	initialized = TRUE
	fire(mc_check = FALSE)
	..()

/datum/controller/subsystem/overlays/stat_entry()
	..("Ov:[length(queue)]")

/datum/controller/subsystem/overlays/Shutdown()
	text2file(render_stats(stats), "[GLOB.log_directory]/overlay.log")

/datum/controller/subsystem/overlays/Recover()
	overlay_icon_state_caches = SSoverlays.overlay_icon_state_caches
	overlay_icon_cache = SSoverlays.overlay_icon_cache
	queue = SSoverlays.queue


/datum/controller/subsystem/overlays/fire(resumed = FALSE, mc_check = TRUE)
	var/list/queue = src.queue
	var/static/count = 0
	if (count)
		var/c = count
		count = 0 //so if we runtime on the Cut, we don't try again.
		queue.Cut(1,c+1)

	for (var/thing in queue)
		count++
		if(thing)
			STAT_START_STOPWATCH
			var/atom/A = thing
			COMPILE_OVERLAYS(A)
			STAT_STOP_STOPWATCH
			STAT_LOG_ENTRY(stats, A.type)
		if(mc_check)
			if(MC_TICK_CHECK)
				break
		else
			CHECK_TICK

	if (count)
		queue.Cut(1,count+1)
		count = 0

/proc/iconstate2appearance(icon, iconstate)
	// var/static/image/stringbro = new() // Moved to be superglobal due to BYOND insane init order stupidness.
	var/list/icon_states_cache = SSoverlays.overlay_icon_state_caches
	var/list/cached_icon = icon_states_cache[icon]
	if (cached_icon)
		var/cached_appearance = cached_icon["[iconstate]"]
		if (cached_appearance)
			return cached_appearance
	stringbro.icon = icon
	stringbro.icon_state = iconstate
	if (!cached_icon) //not using the macro to save an associated lookup
		cached_icon = list()
		icon_states_cache[icon] = cached_icon
	var/cached_appearance = stringbro.appearance
	cached_icon["[iconstate]"] = cached_appearance
	return cached_appearance

/proc/icon2appearance(icon)
	// var/static/image/iconbro = new() // Moved to be superglobal due to BYOND insane init order stupidness.
	var/list/icon_cache = SSoverlays.overlay_icon_cache
	. = icon_cache[icon]
	if (!.)
		iconbro.icon = icon
		. = iconbro.appearance
		icon_cache[icon] = .

/atom/proc/build_appearance_list(old_overlays)
	// var/static/image/appearance_bro = new() // Moved to be superglobal due to BYOND insane init order stupidness.
	var/list/new_overlays = list()
	if (!islist(old_overlays))
		old_overlays = list(old_overlays)
	for (var/overlay in old_overlays)
		if(!overlay)
			continue
		if (istext(overlay))
			new_overlays += iconstate2appearance(icon, overlay)
		else if(isicon(overlay))
			new_overlays += icon2appearance(overlay)
		else
			if(isloc(overlay))
				var/atom/A = overlay
				if (A.flags & OVERLAY_QUEUED)
					COMPILE_OVERLAYS(A)
			appearance_bro.appearance = overlay //this works for images and atoms too!
			if(!ispath(overlay))
				var/image/I = overlay
				appearance_bro.dir = I.dir
			new_overlays += appearance_bro.appearance
	return new_overlays

#define NOT_QUEUED_ALREADY (!(flags & OVERLAY_QUEUED))
#define QUEUE_FOR_COMPILE flags |= OVERLAY_QUEUED; SSoverlays.queue += src;

/**
 * Cut all of atom's normal overlays.  Usually leaves "priority" overlays untouched.
 *
 *  @param priority If true, also will cut priority overlays.
 */
/atom/proc/cut_overlays(priority = FALSE)
	var/list/cached_overlays = our_overlays
	var/list/cached_priority = priority_overlays

	var/need_compile = FALSE

	if(LAZYLEN(cached_overlays)) //don't queue empty lists, don't cut priority overlays
		cached_overlays.Cut()  //clear regular overlays
		need_compile = TRUE

	if(priority && LAZYLEN(cached_priority))
		cached_priority.Cut()
		need_compile = TRUE

	if(NOT_QUEUED_ALREADY && need_compile)
		QUEUE_FOR_COMPILE

/**
 * Removes specific overlay(s) from the atom.  Usually does not remove them from "priority" overlays.
 *
 * @param overlays The overlays to removed, type can be anything that is allowed for add_overlay().
 * @param priority If true, also will remove them from the "priority" overlays.
 */
/atom/proc/cut_overlay(list/overlays, priority)
	if(!overlays)
		return

	overlays = build_appearance_list(overlays)

	var/list/cached_overlays = our_overlays	//sanic
	var/list/cached_priority = priority_overlays
	var/init_o_len = LAZYLEN(cached_overlays)
	var/init_p_len = LAZYLEN(cached_priority)  //starter pokemon

	LAZYREMOVE(cached_overlays, overlays)
	if(priority)
		LAZYREMOVE(cached_priority, overlays)

	if(NOT_QUEUED_ALREADY && ((init_o_len != LAZYLEN(cached_overlays)) || (init_p_len != LAZYLEN(cached_priority))))
		QUEUE_FOR_COMPILE

/**
 * Adds specific overlay(s) to the atom.
 * It is designed so any of the types allowed to be added to /atom/overlays can be added here too. More details below.
 *
 * @param overlays The overlay(s) to add.  These may be
 *	- A string: In which case it is treated as an icon_state of the atom's icon.
 *	- An icon: It is treated as an icon.
 *	- An atom: Its own overlays are compiled and then it's appearance is added. (Meaning its current apperance is frozen).
 *	- An image: Image's apperance is added (i.e. subsequently editing the image will not edit the overlay)
 *	- A type path: Added to overlays as is.  Does whatever it is BYOND does when you add paths to overlays.
 *	- Or a list containing any of the above.
 * @param priority The overlays are added to the "priority" list istead of the normal one.
 */
/atom/proc/add_overlay(list/overlays, priority = FALSE)
	if(!overlays)
		return

	overlays = build_appearance_list(overlays)

	LAZYINITLIST(our_overlays)	//always initialized after this point
	LAZYINITLIST(priority_overlays)

	var/list/cached_overlays = our_overlays	//sanic
	var/list/cached_priority = priority_overlays
	var/init_o_len = cached_overlays.len
	var/init_p_len = cached_priority.len  //starter pokemon
	var/need_compile

	if(priority)
		cached_priority += overlays  //or in the image. Can we use [image] = image?
		need_compile = init_p_len != cached_priority.len
	else
		cached_overlays += overlays
		need_compile = init_o_len != cached_overlays.len

	if(NOT_QUEUED_ALREADY && need_compile) //have we caught more pokemon?
		QUEUE_FOR_COMPILE

/**
 * Copy the overlays from another atom, either replacing all of ours or appending to our existing overlays.
 * Note: This copies only the normal overlays, not the "priority" overlays.
 *
 * @param other The atom to copy overlays from.
 * @param cut_old If true, all of our overlays will be *replaced* by the other's. If other is null, that means cutting all ours.
 */
/atom/proc/copy_overlays(atom/other, cut_old)	//copys our_overlays from another atom
	if(!other)
		if(cut_old)
			cut_overlays()
		return

	var/list/cached_other = other.our_overlays
	if(cached_other)
		if(cut_old || !LAZYLEN(our_overlays))
			our_overlays = cached_other.Copy()
		else
			our_overlays |= cached_other
		if(NOT_QUEUED_ALREADY)
			QUEUE_FOR_COMPILE
	else if(cut_old)
		cut_overlays()

#undef NOT_QUEUED_ALREADY
#undef QUEUE_FOR_COMPILE

//TODO: Better solution for these?
/image/proc/add_overlay(x)
	overlays += x

/image/proc/cut_overlay(x)
	overlays -= x

/image/proc/cut_overlays(x)
	overlays.Cut()

/image/proc/copy_overlays(atom/other, cut_old)
	if(!other)
		if(cut_old)
			cut_overlays()
		return

	var/list/cached_other = other.our_overlays
	if(cached_other)
		if(cut_old || !overlays.len)
			overlays = cached_other.Copy()
		else
			overlays |= cached_other
	else if(cut_old)
		cut_overlays()

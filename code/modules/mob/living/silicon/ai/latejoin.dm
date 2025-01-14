var/global/list/empty_playable_ai_cores = list()

/mob/living/silicon/ai/verb/store_core()
	set name = "Store Core"
	set category = "OOC"
	set desc = "Enter intelligence storage. This is functionally equivalent to cryo or robotic storage, freeing up your job slot."

	if(SSticker && SSticker.mode && SSticker.mode.name == "AI malfunction")
		to_chat(usr, "<span class='danger'>You cannot use this verb in malfunction. If you need to leave, please adminhelp.</span>")
		return

	// Guard against misclicks, this isn't the sort of thing we want happening accidentally
	if(alert("WARNING: This will immediately empty your core and ghost you, removing your character from the round permanently (similar to cryo and robotic storage). Are you entirely sure you want to do this?",
					"Store Core", "No", "No", "Yes") != "Yes")
		return

	// We warned you.
	empty_playable_ai_cores += new /obj/structure/AIcore/deactivated(loc)
	GLOB.global_announcer.autosay("[src] has been moved to intelligence storage.", "Artificial Intelligence Oversight")

	//Handle job slot/tater cleanup.
	set_respawn_timer()
	clear_client()

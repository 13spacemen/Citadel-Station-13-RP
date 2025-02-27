var/datum/antagonist/technomancer/technomancers

/datum/antagonist/technomancer
	id = MODE_TECHNOMANCER
	role_type = BE_WIZARD
	role_text = "Technomancer"
	role_text_plural = "Technomancers"
	bantype = "wizard"
	landmark_id = "wizard"
	welcome_text = "You will need to purchase <b>functions</b> and perhaps some <b>equipment</b> from the various machines around your \
	base. Choose your technological arsenal carefully.  Remember that without the <b>core</b> on your back, your functions are \
	powerless, and therefore you will be as well.<br>\
	In your pockets you will find a one-time use teleport device. Use it to leave the base and go to the colony, when you are ready."
	antag_sound = 'sound/effects/antag_notice/technomancer_alert.ogg'
	flags = ANTAG_OVERRIDE_JOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_CHOOSE_NAME | ANTAG_SET_APPEARANCE | ANTAG_VOTABLE
	antaghud_indicator = "wizard"

	hard_cap = 1
	hard_cap_round = 3
	initial_spawn_req = 1
	initial_spawn_target = 1

	id_type = /obj/item/card/id/syndicate

/datum/antagonist/technomancer/New()
	..()
	technomancers = src

/datum/antagonist/technomancer/update_antag_mob(var/datum/mind/technomancer)
	..()
	technomancer.store_memory("<B>Remember:</B> Do not forget to purchase the functions and equipment you need.")
	technomancer.current.real_name = "[pick(wizard_first)] [pick(wizard_second)]"
	technomancer.current.name = technomancer.current.real_name

/datum/antagonist/technomancer/equip(var/mob/living/carbon/human/technomancer_mob)

	if(!..())
		return 0

	technomancer_mob.equip_to_slot_or_del(new /obj/item/clothing/under/technomancer/master(technomancer_mob), SLOT_ID_UNIFORM)
	create_id("Technomagus", technomancer_mob)
	technomancer_mob.equip_to_slot_or_del(new /obj/item/disposable_teleporter/free(technomancer_mob), SLOT_ID_RIGHT_POCKET)
	technomancer_mob.equip_to_slot_or_del(new /obj/item/technomancer_catalog(technomancer_mob), SLOT_ID_LEFT_POCKET)
	technomancer_mob.equip_to_slot_or_del(new /obj/item/radio/headset(technomancer_mob), SLOT_ID_LEFT_EAR)
	var/obj/item/technomancer_core/core = new /obj/item/technomancer_core(technomancer_mob)
	technomancer_mob.equip_to_slot_or_del(core, SLOT_ID_BACK)
	technomancer_belongings.Add(core) // So it can be Tracked.
	technomancer_mob.equip_to_slot_or_del(new /obj/item/flashlight(technomancer_mob), SLOT_ID_BELT)
	technomancer_mob.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(technomancer_mob), SLOT_ID_SHOES)
	technomancer_mob.equip_to_slot_or_del(new /obj/item/clothing/head/technomancer/master(technomancer_mob), SLOT_ID_HEAD)
	return 1

/datum/antagonist/technomancer/proc/equip_apprentice(var/mob/living/carbon/human/technomancer_mob)

	technomancer_mob.equip_to_slot_or_del(new /obj/item/clothing/under/technomancer/apprentice(technomancer_mob), SLOT_ID_UNIFORM)
	create_id("Techno-apprentice", technomancer_mob)
	technomancer_mob.equip_to_slot_or_del(new /obj/item/disposable_teleporter/free(technomancer_mob), SLOT_ID_RIGHT_POCKET)

	var/obj/item/technomancer_catalog/apprentice/catalog = new /obj/item/technomancer_catalog/apprentice()
	catalog.bind_to_owner(technomancer_mob)
	technomancer_mob.equip_to_slot_or_del(catalog, SLOT_ID_LEFT_POCKET)

	technomancer_mob.equip_to_slot_or_del(new /obj/item/radio/headset(technomancer_mob), SLOT_ID_LEFT_EAR)
	var/obj/item/technomancer_core/core = new /obj/item/technomancer_core(technomancer_mob)
	technomancer_mob.equip_to_slot_or_del(core, SLOT_ID_BACK)
	technomancer_belongings.Add(core) // So it can be Tracked.
	technomancer_mob.equip_to_slot_or_del(new /obj/item/flashlight(technomancer_mob), SLOT_ID_BELT)
	technomancer_mob.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(technomancer_mob), SLOT_ID_SHOES)
	technomancer_mob.equip_to_slot_or_del(new /obj/item/clothing/head/technomancer/apprentice(technomancer_mob), SLOT_ID_HEAD)
	return 1

/datum/antagonist/technomancer/check_victory()
	var/survivor
	for(var/datum/mind/player in current_antagonists)
		if(!player.current || player.current.stat == DEAD)
			continue
		survivor = 1
		break
	if(!survivor)
		feedback_set_details("round_end_result","loss - technomancer killed")
		to_chat(world, "<span class='danger'><font size = 3>The [(current_antagonists.len>1)?"[role_text_plural] have":"[role_text] has"] been killed!</font></span>")

/datum/antagonist/technomancer/print_player_summary()
	..()
	for(var/obj/item/technomancer_core/core in technomancer_belongings)
		if(core.wearer)
			continue // Only want abandoned cores.
		if(!core.spells.len)
			continue // Cores containing spells only.
		to_chat(world, "Abandoned [core] had [english_list(core.spells)].<br>")

/datum/antagonist/technomancer/print_player_full(var/datum/mind/player)
	var/text = print_player_lite(player)

	var/obj/item/technomancer_core/core
	if(player.original)
		core = locate() in player.original
		if(core)
			text += "<br>Bought [english_list(core.spells)], and used \a [core]."
		else
			text += "<br>They've lost their core."

	return text

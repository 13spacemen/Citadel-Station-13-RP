/datum/preferences
	//The mob should have a gender you want before running this proc. Will run fine without H
/datum/preferences/proc/randomize_appearance_and_body_for(var/mob/living/carbon/human/H)
	var/datum/species/current_species = name_static_species_meta(species) || get_static_species_meta(/datum/species/human)
	set_biological_gender(pick(current_species.genders))

	h_style = random_hair_style(biological_gender, species)
	f_style = random_facial_hair_style(biological_gender, species)
	if(current_species)
		if(current_species.species_appearance_flags & HAS_SKIN_TONE)
			s_tone = random_skin_tone()
		if(current_species.species_appearance_flags & HAS_SKIN_COLOR)
			r_skin = rand (0,255)
			g_skin = rand (0,255)
			b_skin = rand (0,255)
		if(current_species.species_appearance_flags & HAS_EYE_COLOR)
			randomize_eyes_color()
		if(current_species.species_appearance_flags & HAS_HAIR_COLOR)
			randomize_hair_color("hair")
			randomize_hair_color("facial")
		if(current_species.species_appearance_flags & HAS_SKIN_COLOR)
			r_skin = rand (0,255)
			g_skin = rand (0,255)
			b_skin = rand (0,255)
	if(current_species.species_appearance_flags & HAS_UNDERWEAR)
		all_underwear.Cut()
		for(var/datum/category_group/underwear/WRC in GLOB.global_underwear.categories)
			var/datum/category_item/underwear/WRI = pick(WRC.items)
			all_underwear[WRC.name] = WRI.name


	backbag = rand(1, 7)
	pdachoice = rand(1, 7)
	age = rand(current_species.min_age, current_species.max_age)
	b_type = RANDOM_BLOOD_TYPE
	if(H)
		copy_to(H,1)


/datum/preferences/proc/randomize_hair_color(var/target = "hair")
	if(prob (75) && target == "facial") // Chance to inherit hair color
		r_facial = r_hair
		g_facial = g_hair
		b_facial = b_hair
		return

	var/red
	var/green
	var/blue

	var/col = pick ("blonde", "black", "chestnut", "copper", "brown", "wheat", "old", "punk")
	switch(col)
		if("blonde")
			red = 255
			green = 255
			blue = 0
		if("black")
			red = 0
			green = 0
			blue = 0
		if("chestnut")
			red = 153
			green = 102
			blue = 51
		if("copper")
			red = 255
			green = 153
			blue = 0
		if("brown")
			red = 102
			green = 51
			blue = 0
		if("wheat")
			red = 255
			green = 255
			blue = 153
		if("old")
			red = rand (100, 255)
			green = red
			blue = red
		if("punk")
			red = rand (0, 255)
			green = rand (0, 255)
			blue = rand (0, 255)

	red = max(min(red + rand (-25, 25), 255), 0)
	green = max(min(green + rand (-25, 25), 255), 0)
	blue = max(min(blue + rand (-25, 25), 255), 0)

	switch(target)
		if("hair")
			r_hair = red
			g_hair = green
			b_hair = blue
		if("facial")
			r_facial = red
			g_facial = green
			b_facial = blue

/datum/preferences/proc/randomize_eyes_color()
	var/red
	var/green
	var/blue

	var/col = pick ("black", "grey", "brown", "chestnut", "blue", "lightblue", "green", "albino")
	switch(col)
		if("black")
			red = 0
			green = 0
			blue = 0
		if("grey")
			red = rand (100, 200)
			green = red
			blue = red
		if("brown")
			red = 102
			green = 51
			blue = 0
		if("chestnut")
			red = 153
			green = 102
			blue = 0
		if("blue")
			red = 51
			green = 102
			blue = 204
		if("lightblue")
			red = 102
			green = 204
			blue = 255
		if("green")
			red = 0
			green = 102
			blue = 0
		if("albino")
			red = rand (200, 255)
			green = rand (0, 150)
			blue = rand (0, 150)

	red = max(min(red + rand (-25, 25), 255), 0)
	green = max(min(green + rand (-25, 25), 255), 0)
	blue = max(min(blue + rand (-25, 25), 255), 0)

	r_eyes = red
	g_eyes = green
	b_eyes = blue

/datum/preferences/proc/randomize_skin_color()
	var/red
	var/green
	var/blue

	var/col = pick ("black", "grey", "brown", "chestnut", "blue", "lightblue", "green", "albino")
	switch(col)
		if("black")
			red = 0
			green = 0
			blue = 0
		if("grey")
			red = rand (100, 200)
			green = red
			blue = red
		if("brown")
			red = 102
			green = 51
			blue = 0
		if("chestnut")
			red = 153
			green = 102
			blue = 0
		if("blue")
			red = 51
			green = 102
			blue = 204
		if("lightblue")
			red = 102
			green = 204
			blue = 255
		if("green")
			red = 0
			green = 102
			blue = 0
		if("albino")
			red = rand (200, 255)
			green = rand (0, 150)
			blue = rand (0, 150)

	red = max(min(red + rand (-25, 25), 255), 0)
	green = max(min(green + rand (-25, 25), 255), 0)
	blue = max(min(blue + rand (-25, 25), 255), 0)

	r_skin = red
	g_skin = green
	b_skin = blue

/datum/preferences/proc/dress_preview_mob(var/mob/living/carbon/human/mannequin)
	copy_to(mannequin, TRUE)

	if(!equip_preview_mob)
		return

	var/datum/job/previewJob
	// Determine what job is marked as 'High' priority, and dress them up as such.
	if(job_civilian_low & ASSISTANT)
		previewJob = SSjob.get_job(USELESS_JOB)
	else
		for(var/datum/job/job in SSjob.occupations)
			var/job_flag
			switch(job.department_flag)
				if(CIVILIAN)
					job_flag = job_civilian_high
				if(MEDSCI)
					job_flag = job_medsci_high
				if(ENGSEC)
					job_flag = job_engsec_high
			if(job.flag == job_flag)
				previewJob = job
				break

	if((equip_preview_mob & EQUIP_PREVIEW_LOADOUT) && !(previewJob && (equip_preview_mob & EQUIP_PREVIEW_JOB) && (previewJob.type == /datum/job/station/ai || previewJob.type == /datum/job/station/cyborg)))
		var/list/equipped_slots = list()
		for(var/thing in gear)
			var/datum/gear/G = gear_datums[thing]
			if(G)
				var/permitted = 0
				if(!G.allowed_roles)
					permitted = 1
				else if(!previewJob)
					permitted = 0
				else
					for(var/job_name in G.allowed_roles)
						if(previewJob.title == job_name)
							permitted = 1

				if(G.whitelisted && (G.whitelisted != mannequin.species.name))
					permitted = 0

				if(!permitted)
					continue

				if(G.slot && !(G.slot in equipped_slots))
					var/metadata = gear[G.display_name]
					if(G.slot == "implant")
						// todo: remove fucking snowflake
						continue
					if(mannequin.force_equip_to_slot_or_del(G.spawn_item(mannequin, metadata), G.slot, INV_OP_SILENT))
						if(G.slot != /datum/inventory_slot_meta/abstract/attach_as_accessory)
							equipped_slots += G.slot

	if((equip_preview_mob & EQUIP_PREVIEW_JOB) && previewJob)
		mannequin.job = previewJob.title
		previewJob.equip_preview(mannequin, player_alt_titles[previewJob.title])

/datum/preferences/proc/update_preview_icon()
	var/mob/living/carbon/human/dummy/mannequin/mannequin = get_mannequin(client_ckey)
	mannequin.delete_inventory(TRUE)
	if(regen_limbs)
		var/datum/species/current_species = character_static_species_meta()
		current_species.create_organs(mannequin)
		regen_limbs = 0
	dress_preview_mob(mannequin)
	mannequin.update_transform()
	COMPILE_OVERLAYS(mannequin)

	update_character_previews(new /mutable_appearance(mannequin))

//TFF 5/8/19 - add randomised sensor setting for random button clicking
/datum/preferences/randomize_appearance_and_body_for(var/mob/living/carbon/human/H)
	sensorpref = rand(1,5)

/datum/preferences/proc/get_valid_hairstyles()
	var/list/valid_hairstyles = list()
	for(var/hairstyle in hair_styles_list)
		var/datum/sprite_accessory/S = hair_styles_list[hairstyle]
		if(S.apply_restrictions && !(species in S.species_allowed) && (!custom_base || !(custom_base in S.species_allowed))) //Custom species base species allowance
			continue

		valid_hairstyles[hairstyle] = hair_styles_list[hairstyle]

	return valid_hairstyles

/datum/preferences/proc/get_valid_facialhairstyles()
	var/list/valid_facialhairstyles = list()
	for(var/facialhairstyle in facial_hair_styles_list)
		var/datum/sprite_accessory/S = facial_hair_styles_list[facialhairstyle]
		if(biological_gender == MALE && S.gender == FEMALE)
			continue
		if(biological_gender == FEMALE && S.gender == MALE)
			continue
		if(S.apply_restrictions && !(species in S.species_allowed) && (!custom_base || !(custom_base in S.species_allowed))) //Custom species base species allowance
			continue

		valid_facialhairstyles[facialhairstyle] = facial_hair_styles_list[facialhairstyle]

	return valid_facialhairstyles

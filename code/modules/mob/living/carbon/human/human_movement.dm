#define HUMAN_LOWEST_SLOWDOWN -3

/mob/living/carbon/human/movement_delay(oldloc, direct)
	. = ..()

	var/tally = 0

	if(species.slowdown)
		tally = species.slowdown

	if (istype(loc, /turf/space))
		return 1		//until tg movement slowdown + modifiers is a thing I guess ...

	if(embedded_flag)
		handle_embedded_objects() //Moving with objects stuck in you can cause bad times.

	if(force_max_speed)
		return HUMAN_LOWEST_SLOWDOWN

	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.haste) && M.haste == TRUE)
			return HUMAN_LOWEST_SLOWDOWN // Returning -1 will actually result in a slowdown for Teshari.
		if(!isnull(M.slowdown))
			tally += M.slowdown

	var/health_deficiency = (getMaxHealth() - health)
	if(health_deficiency >= 40)
		tally += (health_deficiency / 25)

	if(can_feel_pain())
		if(!(CE_SPEEDBOOST in chem_effects)) //Hyperzine stops pain slowdown
			if(halloss >= 10)
				tally += (halloss / 10) //halloss shouldn't slow you down if you can't even feel it

	var/hungry = (500 - nutrition)/5 // So overeat would be 100 and default level would be 80
	if (hungry >= 70)
		tally += hungry/50

	if (feral >= 10) //crazy feral animals give less and less of a shit about pain and hunger as they get crazier
		tally = max(species.slowdown, species.slowdown+((tally-species.slowdown)/(feral/10))) // As feral scales to damage, this amounts to an effective +1 slowdown cap
		if(shock_stage >= 10) tally -= 1.5 //this gets a +3 later, feral critters take reduced penalty
	if(reagents.has_reagent("numbenzyme"))
		tally += 1.5 //A tad bit of slowdown.
	if(riding_datum) //Bit of slowdown for taur rides if rider is bigger or fatter than mount.
		var/datum/riding/R = riding_datum
		var/mob/living/L = R.ridden
		for(var/mob/living/M in L.buckled_mobs)
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				if(H.size_multiplier > L.size_multiplier)
					tally += 1
				if(H.weight > L.weight)
					tally += 1

	if(istype(buckled, /obj/structure/bed/chair/wheelchair))
		for(var/organ_name in list(BP_L_HAND, BP_R_HAND, BP_L_ARM, BP_R_ARM))
			var/obj/item/organ/external/E = get_organ(organ_name)
			if(!E || E.is_stump())
				tally += 4
			else if(E.splinted && E.splinted.loc != E)
				tally += 0.5
			else if(E.status & ORGAN_BROKEN)
				tally += 1.5
	else
		for(var/organ_name in list(BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT))
			var/obj/item/organ/external/E = get_organ(organ_name)
			if(!E || E.is_stump())
				tally += 4
			else if(E.splinted && E.splinted.loc != E)
				tally += 0.5
			else if(E.status & ORGAN_BROKEN)
				tally += 1.5

	if(shock_stage >= 10) tally += 3

	if(aiming && aiming.aiming_at) tally += 5 // Iron sights make you slower, it's a well-known fact.

	if(FAT in src.mutations)
		tally += 1.5

	if (bodytemperature < species.cold_level_1)
		tally += (species.cold_level_1 - bodytemperature) / 10 * 1.75

	tally += max(2 * stance_damage, 0) //damaged/missing feet or legs is slow

	if(mRun in mutations)
		tally = 0

	// Turf related slowdown
	var/turf/T = get_turf(src)
	tally += calculate_turf_slowdown(T, direct)

	// Item related slowdown.
	var/item_tally = calculate_item_encumbrance()
	if(item_tally > 0) // is it greater than 0? run the wacky shit
		item_tally *= species.item_slowdown_mod // your item slowdown kicks in, but
		if(!(CE_SPEEDBOOST in chem_effects)) // hyperzine users ignore item slow
			tally += item_tally // no hyperzine? slowed down by things
	else
		tally += item_tally // if it's less than 0 that means it speeds you up, theoretically, so, hit it

	/* removed - kevinz000. A system will eventually be reintroduced to do this, but for the moment I'd rather this Not be a thing.
	// Dragging heavy objects will also slow you down, similar to above.
	if(pulling)
		if(istype(pulling, /obj/item))
			var/obj/item/pulled = pulling
			item_tally += max(pulled.slowdown, 0)
		else if(ishuman(pulling))
			var/mob/living/carbon/human/H = pulling
			var/their_slowdown = max(H.calculate_item_encumbrance(), 1)
			item_tally = max(item_tally, their_slowdown) // If our slowdown is less than theirs, then we become as slow as them (before species modifires).
	*/

	if(CE_SLOWDOWN in chem_effects)
		if (tally >= 0 )
			tally = (tally + tally/4) //Add a quarter of penalties on top.
		tally += chem_effects[CE_SLOWDOWN]

	return max(HUMAN_LOWEST_SLOWDOWN, tally + . + config_legacy.human_delay)	// Minimum return should be the same as force_max_speed

// This calculates the amount of slowdown to receive from items worn. This does NOT include species modifiers.
// It is in a seperate place to avoid an infinite loop situation with dragging mobs dragging each other.
// Also its nice to have these things seperated.
/mob/living/carbon/human/proc/calculate_item_encumbrance()
	if(!buckled && shoes) // Shoes can make you go faster.
		. += shoes.slowdown

	// Loop through some slots, and add up their slowdowns.
	// Includes slots which can provide armor, the back slot, and suit storage.
	for(var/obj/item/I in list(wear_suit, w_uniform, back, gloves, head, s_store))
		. += I.slowdown

	// Hands are also included, to make the 'take off your armor instantly and carry it with you to go faster' trick no longer viable.
	// This is done seperately to disallow negative numbers (so you can't hold shoes in your hands to go faster).
	for(var/obj/item/I in list(r_hand, l_hand))
		. += max(I.slowdown, 0)

// Similar to above, but for turf slowdown.
/mob/living/carbon/human/proc/calculate_turf_slowdown(turf/T, direct)
	if(!T)
		return 0

	if(T.movement_cost)
		var/turf_move_cost = T.movement_cost
		if(istype(T, /turf/simulated/floor/water))
			if(species.water_movement)
				turf_move_cost = clamp(HUMAN_LOWEST_SLOWDOWN, turf_move_cost + species.water_movement, 15)
			if(shoes)
				var/obj/item/clothing/shoes/feet = shoes
				if(feet.water_speed)
					turf_move_cost = clamp(HUMAN_LOWEST_SLOWDOWN, turf_move_cost + feet.water_speed, 15)
			. += turf_move_cost

		if(istype(T, /turf/simulated/floor/outdoors/snow))
			if(species.snow_movement)
				turf_move_cost = clamp(HUMAN_LOWEST_SLOWDOWN, turf_move_cost + species.snow_movement, 15)
			if(shoes)
				var/obj/item/clothing/shoes/feet = shoes
				if(feet.water_speed)
					turf_move_cost = clamp(HUMAN_LOWEST_SLOWDOWN, turf_move_cost + feet.snow_speed, 15)
			. += turf_move_cost

	// Wind makes it easier or harder to move, depending on if you're with or against the wind.
	if(T.outdoors && (T.z <= SSplanets.z_to_planet.len))
		var/datum/planet/P = SSplanets.z_to_planet[z]
		if(P)
			var/datum/weather_holder/WH = P.weather_holder
			if(WH && WH.wind_speed) // Is there any wind?
				// With the wind.
				if(direct & WH.wind_dir)
					. = max(. - (WH.wind_speed / 3), -1) // Wind speedup is capped to prevent supersonic speeds from a storm.
				// Against it.
				else if(direct & GLOB.reverse_dir[WH.wind_dir])
					. += (WH.wind_speed / 3)

#undef HUMAN_LOWEST_SLOWDOWN

/mob/living/carbon/human/Process_Spacemove(dir)
	//Do we have a working jetpack?
	var/obj/item/tank/jetpack/thrust
	if(back)
		if(istype(back,/obj/item/tank/jetpack))
			thrust = back
		else if(istype(back,/obj/item/rig))
			var/obj/item/rig/rig = back
			for(var/obj/item/rig_module/maneuvering_jets/module in rig.installed_modules)
				thrust = module.jets
				break

	if(thrust && !lying)
		if(dir != NONE)
			if(thrust.allow_thrust(0.01, src))
				return TRUE
		else
			if(thrust.stabilization_on && thrust.allow_thrust(0.01, src))
				return TRUE
	if(flying)
		return TRUE

	return ..()

/mob/living/carbon/human/Process_Spaceslipping(var/prob_slip = 5)
	//If knocked out we might just hit it and stop.  This makes it possible to get dead bodies and such.

	if(species.flags & NO_SLIP)
		return

	if(stat)
		prob_slip = 0 // Changing this to zero to make it line up with the comment, and also, make more sense.

	//Do we have magboots or such on if so no slip
	if(istype(shoes, /obj/item/clothing/shoes/magboots) && (shoes.clothing_flags & NOSLIP))
		prob_slip = 0

	//Check hands and mod slip
	if(!l_hand)	prob_slip -= 2
	else if(l_hand.w_class <= 2)	prob_slip -= 1
	if (!r_hand)	prob_slip -= 2
	else if(r_hand.w_class <= 2)	prob_slip -= 1

	prob_slip = round(prob_slip)
	return(prob_slip)

// Handle footstep sounds
/mob/living/carbon/human/handle_footstep(turf/T)
	if(is_incorporeal())
		return
	if(!config_legacy.footstep_volume || !T.footstep_sounds || !T.footstep_sounds.len)
		return
	// Future Upgrades - Multi species support
	var/list/footstep_sounds = T.footstep_sounds["human"]
	if(!footstep_sounds)
		return

	var/S = pick(footstep_sounds)
	if(!S) return

	// Play every 20 steps while walking, for the sneak
	if(m_intent == "walk" && step_count++ % 20 != 0)
		return

	// Play every other step while running
	if(m_intent == "run" && step_count++ % 2 != 0)
		return

	var/volume = config_legacy.footstep_volume

	// Reduce volume while walking or barefoot
	if(!shoes || m_intent == "walk")
		volume *= 0.5
	else if(shoes)
		var/obj/item/clothing/shoes/feet = shoes
		if(istype(feet))
			volume *= feet.step_volume_mod

	if(!has_organ(BP_L_FOOT) && !has_organ(BP_R_FOOT))
		return // no feet = no footsteps

	if(buckled || lying || throwing)
		return // people flying, lying down or sitting do not step

	if(!has_gravity(src) && prob(75))
		return // Far less likely to make noise in no gravity

	playsound(T, S, volume, FALSE)

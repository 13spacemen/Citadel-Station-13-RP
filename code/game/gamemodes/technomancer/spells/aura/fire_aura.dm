/datum/technomancer/spell/fire_aura
	name = "Fire Storm"
	desc = "This causes everyone within four meters of you to heat up, eventually burning to death if they remain for too long.  \
	This does not affect you or your allies.  It also causes a large amount of fire to erupt around you, however the main threat is \
	still the heating up."
	enhancement_desc = "Increased heat generation, more fires, and higher temperature cap."
	spell_power_desc = "Radius, heat rate, heat capacity, and amount of fires made increased."
	cost = 100
	obj_path = /obj/item/spell/aura/fire
	ability_icon_state = "tech_fireaura"
	category = OFFENSIVE_SPELLS

/obj/item/spell/aura/fire
	name = "Fire Storm"
	desc = "Things are starting to heat up."
	icon_state = "fire_bolt"
	aspect = ASPECT_FIRE
	glow_color = "#FF6A00"

/obj/item/spell/aura/fire/process(delta_time)
	if(!pay_energy(100))
		qdel(src)
	var/list/nearby_things = range(round(calculate_spell_power(4)),owner)

	var/temp_change = calculate_spell_power(25)
	var/datum/species/baseline = get_static_species_meta(/datum/species/human)
	var/temp_cap = baseline.heat_level_3 * 1.5
	var/fire_power = calculate_spell_power(2)

	if(check_for_scepter())
		temp_change *= 2
		temp_cap *= 2
		fire_power *= 2

	for(var/mob/living/carbon/human/H in nearby_things)
		if(is_ally(H))
			continue

		var/protection = H.get_heat_protection(500)
		if(protection < 1)
			var/heat_factor = abs(protection - 1)
			temp_change *= heat_factor
			H.bodytemperature = min(H.bodytemperature + temp_change, temp_cap)

	turf_check:
		for(var/turf/simulated/T in nearby_things)
			if(prob(30))
				for(var/mob/living/carbon/human/H in T)
					if(is_ally(H))
						continue turf_check
				T.hotspot_expose(500, 50, 1)
				T.create_fire(fire_power)

	adjust_instability(3)

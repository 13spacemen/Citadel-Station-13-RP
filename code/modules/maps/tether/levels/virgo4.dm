// -- Datums -- //

/obj/effect/overmap/visitable/sector/virgo4
	name = "Virgo 4"
	desc = "Home to sand, and things with big fluffy ears."
	scanner_desc = @{"[i]Stellar Body[/i]: Virgo 4
[i]Class[/i]: M-Class Planet
[i]Habitability[/i]: Moderate (High Temperature)
[b]Notice[/b]: Request authorization from planetary authorities before attempting to construct settlements"}
	icon_state = "globe"
	color = "#ffd300" //Sandy
	in_space = 0
	initial_generic_waypoints = list("beach_e", "beach_c", "beach_nw")

//This is a special subtype of the thing that generates ores on a map
//It will generate more rich ores because of the lower numbers than the normal one
/datum/random_map/noise/ore/beachmine
	descriptor = "beach mine ore distribution map"
	deep_val = 0.6 //More riches, normal is 0.7 and 0.8
	rare_val = 0.5

//The check_map_sanity proc is sometimes unsatisfied with how AMAZING our ores are
/datum/random_map/noise/ore/beachmine/check_map_sanity()
	var/rare_count = 0
	var/surface_count = 0
	var/deep_count = 0

	// Increment map sanity counters.
	for(var/value in map)
		if(value < rare_val)
			surface_count++
		else if(value < deep_val)
			rare_count++
		else
			deep_count++
	// Sanity check.
	if(surface_count < 100)
		admin_notice("<span class='danger'>Insufficient surface minerals. Rerolling...</span>", R_DEBUG)
		return 0
	else if(rare_count < 50)
		admin_notice("<span class='danger'>Insufficient rare minerals. Rerolling...</span>", R_DEBUG)
		return 0
	else if(deep_count < 50)
		admin_notice("<span class='danger'>Insufficient deep minerals. Rerolling...</span>", R_DEBUG)
		return 0
	else
		return 1

// -- Objs -- //
// Two mob spawners that are placed on the map that spawn some mobs!
// They keep track of their mob, and when it's dead, spawn another (only if nobody is looking)
// Note that if your map has step teleports, mobs may wander through them accidentally and not know how to get back
/obj/tether_away_spawner/beach_outside
	name = "Beach Outside Spawner" //Just a name
	faction = "beach_out" //Sets all the mobs to this faction so they don't infight
	atmos_comp = TRUE //Sets up their atmos tolerances to work in this setting, even if they don't normally (20% up/down tolerance for each gas, and heat)
	prob_spawn = 50 //Chance of this spawner spawning a mob (once this is missed, the spawner is 'depleted' and won't spawn anymore)
	prob_fall = 25 //Chance goes down by this much each time it spawns one (not defining and prob_spawn 100 means they spawn as soon as one dies)
	//guard = 40 //They'll stay within this range (not defining this disables them staying nearby and they will wander the map (and through step teleports))
	mobs_to_pick_from = list(
		/mob/living/simple_mob/animal/passive/snake
	)

/obj/tether_away_spawner/beach_outside_friendly
	name = "Fennec Spawner"
	faction = "fennec"
	atmos_comp = TRUE
	prob_spawn = 100
	prob_fall = 25
	//guard = 40
	mobs_to_pick_from = list(
		/mob/living/simple_mob/vore/fennec
	)

/obj/tether_away_spawner/beach_cave
	name = "Beach Cave Spawner"
	faction = "beach_cave"
	atmos_comp = TRUE
	prob_spawn = 100
	prob_fall = 40
	//guard = 20
	mobs_to_pick_from = list(
		/mob/living/simple_mob/vore/aggressive/frog = 6, //Frogs are 3x more likely to spawn than,
		/mob/living/simple_mob/vore/aggressive/deathclaw = 2, //these deathclaws are, with these values,
		/mob/living/simple_mob/animal/giant_spider = 4,
		/mob/living/simple_mob/vore/aggressive/giant_snake = 2,
		/mob/living/simple_mob/animal/giant_spider/webslinger = 2
	)

// These are step-teleporters, for map edge transitions
// This top one goes INTO the cave
/obj/effect/step_trigger/teleporter/away_beach_tocave/Initialize(mapload)
	. = ..()
	teleport_x = src.x //X is horizontal. This is a top of map transition, so you want the same horizontal alignment in the cave as you have on the beach
	teleport_y = 2 //2 is because it's putting you on row 2 of the map to the north
	teleport_z = z+1 //The cave is always our Z-level plus 1, because it's loaded after us

//This one goes OUT OF the cave
/obj/effect/step_trigger/teleporter/away_beach_tobeach/Initialize(mapload)
	. = ..()
	teleport_x = src.x //Same reason as bove
	teleport_y = world.maxy - 1 //This means "1 space from the top of the map"
	teleport_z = z-1 //Opposite of 'tocave', beach is always loaded as the map before us

// -- Turfs -- //

//These are just some special turfs for the beach water
/turf/simulated/floor/beach/coastwater
	name = "Water"
	icon_state = "water"

/turf/simulated/floor/beach/coastwater/Initialize(mapload)
	. = ..()
	add_overlay(image("icon"='icons/misc/beach.dmi',"icon_state"="water","layer"=MOB_LAYER+0.1))

// -- Areas -- //

/area/tether_away/beach
	name = "\improper Away Mission - Virgo 4 Beach"
	icon_state = "away"
	dynamic_lighting = 1
	requires_power = 1

/area/tether_away/beach/powershed
	name = "\improper Away Mission - Virgo 4 Coast PS"
	icon_state = "blue2"

/area/tether_away/beach/coast
	name = "\improper Away Mission - Virgo 4 Coast"
	icon_state = "blue2"

/area/tether_away/beach/water
	name = "\improper Away Mission - Virgo 4 Water"
	icon_state = "bluenew"

/area/tether_away/beach/jungle
	name = "\improper Away Mission - Virgo 4 Desert"
	icon_state = "green"

/area/tether_away/beach/resort
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "yellow"

/area/tether_away/beach/resort/kitchen
	name = "\improper Away Mission - Virgo 4 Kitchen"
	icon_state = "grewhicir"

/area/tether_away/beach/resort/lockermed
	name = "\improper Away Mission - Virgo 4 Utility Pavilion"
	icon_state = "cyawhicir"

/area/tether_away/beach/resort/janibar
	name = "\improper Away Mission - Virgo 4 Bar"
	icon_state = "purwhicir"

/area/tether_away/beach/resort/dorm1
	name = "\improper Away Mission - Virgo 4 Private Room 1"
	icon_state = "bluwhicir"
	area_flags = AREA_RAD_SHIELDED
/area/tether_away/beach/resort/dorm2
	name = "\improper Away Mission - Virgo 4 Private Room 2"
	icon_state = "bluwhicir"
	area_flags = AREA_RAD_SHIELDED
/area/tether_away/beach/resort/dorm3
	name = "\improper Away Mission - Virgo 4 Private Room 3"
	icon_state = "bluwhicir"
	area_flags = AREA_RAD_SHIELDED
/area/tether_away/beach/resort/dorm4
	name = "\improper Away Mission - Virgo 4 Private Room 4"
	icon_state = "bluwhicir"
	area_flags = AREA_RAD_SHIELDED

/area/tether_away/beach/cavebase
	name = "\improper Away Mission - Virgo 4 Mysterious Cave"
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "orawhicir"
	area_flags = AREA_RAD_SHIELDED

//Some areas for the cave, which are referenced by our init object to seed submaps and ores
/area/tether_away/cave
	area_flags = AREA_RAD_SHIELDED
	ambience = list('sound/ambience/ambimine.ogg', 'sound/ambience/song_game.ogg')

/area/tether_away/cave/explored/normal
	name = "\improper Away Mission - Virgo 4 Cave (E)"
	icon_state = "explored"

/area/tether_away/cave/unexplored/normal
	name = "\improper Away Mission - Virgo 4 Cave (UE)"
	icon_state = "unexplored"

/area/tether_away/cave/explored/deep
	name = "\improper Away Mission - Virgo 4 Cave Deep (E)"
	icon_state = "explored_deep"

/area/tether_away/cave/unexplored/deep
	name = "\improper Away Mission - Virgo 4 Cave Deep (UE)"
	icon_state = "unexplored_deep"

// Desert World Reborn Areas..

/area/tether_away/beach/desert/poi
	name = "\improper Away Mission - Virgo 4 Desert"
	icon_state = "away"
	requires_power = 1

/area/tether_away/beach/desert/explored
	name = "\improper Away Mission - Virgo 4 Desert (E)"
	icon_state = "explored"

/area/tether_away/beach/desert/unexplored
	name = "\improper Away Mission - Virgo 4 Desert (UE)"
	icon_state = "unexplored"

/area/tether_away/beach/desert/poi/WW_Town
	name = "V4 - Ghost Town"

/area/tether_away/beach/desert/poi/landing_pad
	name = "V4 - Prefab Homestead"

/area/tether_away/beach/desert/poi/solar_farm
	name = "V4 - Prefab Solar Farm"

/area/tether_away/beach/desert/poi/dirt_farm
	name = "V4 - Abandoned Farmstead"

/area/tether_away/beach/desert/poi/graveyard
	name = "V4 - Desert Graveyard"

/area/tether_away/beach/desert/poi/goldmine
	name = "V4 - Desert Goldmine"

/area/tether_away/beach/desert/poi/ranch
	name = "V4 - Abandoned Ranch"

/area/tether_away/beach/desert/poi/saloon
	name = "V4 - Saloon"

/area/tether_away/beach/desert/poi/temple
	name = "V4 - Old Temple"

/area/tether_away/beach/desert/poi/tomb
	name = "V4 - Old Tomb"

/area/tether_away/beach/desert/poi/AuxiliaryResearchFacility
	name = "V4 - Research Facility"

/area/tether_away/beach/desert/poi/vault
	name = "V4 - Desert Bunker"

/area/tether_away/beach/desert/poi/covert_post
	name = "V4 - Clown Listening Post"

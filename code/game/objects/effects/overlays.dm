/obj/effect/overlay
	name = "overlay"
	unacidable = 1
	var/i_attached//Added for possible image attachments to objects. For hallucinations and the like.

/obj/effect/overlay/beam//Not actually a projectile, just an effect.
	name="beam"
	icon='icons/effects/beam.dmi'
	icon_state="b_beam"
	var/tmp/atom/BeamSource
	New()
		..()
		spawn(10) qdel(src)

/obj/effect/overlay/palmtree_r
	name = "Palm tree"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "palm1"
	density = 1
	plane = MOB_PLANE
	layer = ABOVE_MOB_LAYER
	anchored = 1

/obj/effect/overlay/palmtree_l
	name = "Palm tree"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "palm2"
	density = 1
	plane = MOB_PLANE
	layer = ABOVE_MOB_LAYER
	anchored = 1

/obj/effect/overlay/coconut
	name = "Coconuts"
	icon = 'icons/misc/beach.dmi'
	icon_state = "coconuts"

/obj/effect/overlay/bluespacify
	name = "Bluespace"
	icon = 'icons/turf/space.dmi'
	icon_state = "bluespacify"
	plane = ABOVE_PLANE

/obj/effect/overlay/wallrot
	name = "wallrot"
	desc = "Ick..."
	icon = 'icons/effects/wallrot.dmi'
	anchored = 1
	density = 1
	plane = MOB_PLANE
	layer = ABOVE_MOB_LAYER
	mouse_opacity = 0

/obj/effect/overlay/wallrot/Initialize(mapload)
	. = ..()
	pixel_x += rand(-10, 10)
	pixel_y += rand(-10, 10)

/obj/effect/overlay/snow
	name = "snow"
	icon = 'icons/turf/overlays.dmi'
	icon_state = "snow"
	anchored = 1

// Todo: Add a version that gradually reaccumulates over time by means of alpha transparency. -Spades
/obj/effect/overlay/snow/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/shovel))
		user.visible_message("<span class='notice'>[user] begins to shovel away \the [src].</span>")
		if(do_after(user, 40))
			to_chat(user, "<span class='notice'>You have finished shoveling!</span>")
			qdel(src)
		return

/obj/effect/overlay/snow/floor
	icon_state = "snowfloor"
	plane = TURF_PLANE
	layer = ABOVE_TURF_LAYER
	mouse_opacity = 0 //Don't block underlying tile interactions

/obj/effect/overlay/snow/floor/edges
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow_edges"

/obj/effect/overlay/snow/floor/surround
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow_surround"

/obj/effect/overlay/snow/floor/edges_new
	icon = 'icons/turf/snow_new.dmi'
	icon_state = "snow_edges"

/obj/effect/overlay/snow/floor/surround_new
	icon = 'icons/turf/snow_new.dmi'
	icon_state = "snow_surround"

/obj/effect/overlay/snow/floor/grav_edges
	icon = 'icons/turf/snow_new.dmi'
	icon_state = "gravsnow_edges"

/obj/effect/overlay/snow/floor/grav_surround
	icon = 'icons/turf/snow_new.dmi'
	icon_state = "gravsnow_surround"

/obj/effect/overlay/snow/airlock
	icon_state = "snowairlock"
	layer = DOOR_CLOSED_LAYER+0.01

/obj/effect/overlay/snow/floor/pointy
	icon_state = "snowfloorpointy"

/obj/effect/overlay/snow/wall
	icon_state = "snowwall"
	plane = MOB_PLANE
	layer = ABOVE_MOB_LAYER

/obj/effect/overlay/holographic
	mouse_opacity = FALSE
	anchored = TRUE
	plane = ABOVE_PLANE

// Similar to the tesla ball but doesn't actually do anything and is purely visual.
/obj/effect/overlay/energy_ball
	name = "energy ball"
	desc = "An energy ball."
	icon = 'icons/obj/tesla_engine/energy_ball.dmi'
	icon_state = "energy_ball"
	plane = ABOVE_LIGHTING_PLANE
	pixel_x = -32
	pixel_y = -32

/obj/effect/overlay/vis
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	anchored = TRUE
	vis_flags = VIS_INHERIT_DIR
	///When detected to be unused it gets set to world.time, after a while it gets removed
	var/unused = 0
	///overlays which go unused for this amount of time get cleaned up
	var/cache_expiration = 2 MINUTES

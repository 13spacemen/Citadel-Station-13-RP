/obj/item/glass_jar
	name = "glass jar"
	desc = "A small empty jar."
	icon = 'icons/obj/items.dmi'
	icon_state = "jar"
	w_class = ITEMSIZE_SMALL
	matter = list(MAT_GLASS = 200)
	item_flags = NOBLUDGEON
	var/list/accept_mobs = list(/mob/living/simple_mob/animal/passive/lizard, /mob/living/simple_mob/animal/passive/mouse, /mob/living/simple_mob/animal/sif/leech, /mob/living/simple_mob/animal/sif/frostfly, /mob/living/simple_mob/animal/sif/glitterfly)
	var/contains = 0 // 0 = nothing, 1 = money, 2 = animal, 3 = spiderling
	drop_sound = 'sound/items/drop/glass.ogg'
	pickup_sound = 'sound/items/pickup/glass.ogg'

/obj/item/glass_jar/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/glass_jar/afterattack(var/atom/A, var/mob/user, var/proximity)
	if(!proximity || contains)
		return
	if(istype(A, /mob))
		var/accept = 0
		for(var/D in accept_mobs)
			if(istype(A, D))
				accept = 1
		if(!accept)
			to_chat(user, "[A] doesn't fit into \the [src].")
			return
		var/mob/L = A
		user.visible_message("<span class='notice'>[user] scoops [L] into \the [src].</span>", "<span class='notice'>You scoop [L] into \the [src].</span>")
		L.loc = src
		contains = 2
		update_icon()
		return
	else if(istype(A, /obj/effect/spider/spiderling))
		var/obj/effect/spider/spiderling/S = A
		user.visible_message("<span class='notice'>[user] scoops [S] into \the [src].</span>", "<span class='notice'>You scoop [S] into \the [src].</span>")
		S.loc = src
		STOP_PROCESSING(SSobj, S) // No growing inside jars
		contains = 3
		update_icon()
		return

/obj/item/glass_jar/attack_self(var/mob/user)
	switch(contains)
		if(1)
			for(var/obj/O in src)
				O.loc = user.loc
			to_chat(user, "<span class='notice'>You take money out of \the [src].</span>")
			contains = 0
			update_icon()
			return
		if(2)
			for(var/mob/M in src)
				M.loc = user.loc
				user.visible_message("<span class='notice'>[user] releases [M] from \the [src].</span>", "<span class='notice'>You release [M] from \the [src].</span>")
			contains = 0
			update_icon()
			return
		if(3)
			for(var/obj/effect/spider/spiderling/S in src)
				S.loc = user.loc
				user.visible_message("<span class='notice'>[user] releases [S] from \the [src].</span>", "<span class='notice'>You release [S] from \the [src].</span>")
				START_PROCESSING(SSobj, S) // They can grow after being let out though
			contains = 0
			update_icon()
			return

/obj/item/glass_jar/attackby(var/obj/item/W, var/mob/user)
	if(istype(W, /obj/item/spacecash))
		if(contains == 0)
			contains = 1
		if(contains != 1)
			return
		if(!user.attempt_insert_item_for_installation(W, src))
			return
		var/obj/item/spacecash/S = W
		user.visible_message("<span class='notice'>[user] puts [S.worth] [S.worth > 1 ? "thalers" : "thaler"] into \the [src].</span>")
		update_icon()

/obj/item/glass_jar/update_icon() // Also updates name and desc
	underlays.Cut()
	overlays.Cut()
	switch(contains)
		if(0)
			name = initial(name)
			desc = initial(desc)
		if(1)
			name = "tip jar"
			desc = "A small jar with money inside."
			for(var/obj/item/spacecash/S in src)
				var/image/money = image(S.icon, S.icon_state)
				money.pixel_x = rand(-2, 3)
				money.pixel_y = rand(-6, 6)
				money.transform *= 0.6
				underlays += money
		if(2)
			for(var/mob/M in src)
				var/image/victim = image(M.icon, M.icon_state)
				victim.pixel_y = 6
				victim.color = M.color
				if(M.plane == ABOVE_LIGHTING_PLANE)	// This will only show up on the ground sprite, due to the HuD being over it, so we need both images.
					var/image/victim_glow = image(M.icon, M.icon_state)
					victim_glow.pixel_y = 6
					victim_glow.color = M.color
					underlays += victim_glow
				underlays += victim
				name = "glass jar with [M]"
				desc = "A small jar with [M] inside."
		if(3)
			for(var/obj/effect/spider/spiderling/S in src)
				var/image/victim = image(S.icon, S.icon_state)
				underlays += victim
				name = "glass jar with [S]"
				desc = "A small jar with [S] inside."
	return

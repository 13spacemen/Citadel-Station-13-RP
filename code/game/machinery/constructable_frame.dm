//Circuit boards are in /code/game/objects/items/weapons/circuitboards/machinery/

/obj/machinery/constructable_frame //Made into a seperate type to make future revisions easier.
	name = "machine frame"
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "box_0"
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_OFF
	var/obj/item/circuitboard/circuit = null
	var/list/components = null
	var/list/req_components = null
	var/list/req_component_names = null
	var/state = 1

	proc/update_desc()
		var/D
		if(req_components)
			var/list/component_list = new
			for(var/I in req_components)
				if(req_components[I] > 0)
					component_list += "[num2text(req_components[I])] [req_component_names[I]]"
			D = "Requires [english_list(component_list)]."
		desc = D

/obj/machinery/constructable_frame/machine_frame
	attackby(obj/item/P as obj, mob/user as mob)
		switch(state)
			if(1)
				if(istype(P, /obj/item/stack/cable_coil))
					var/obj/item/stack/cable_coil/C = P
					if (C.get_amount() < 5)
						to_chat(user, SPAN_WARNING("You need five lengths of cable to add them to the frame."))
						return
					playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, TRUE)
					to_chat(user, SPAN_NOTICE("You start to add cables to the frame."))
					if(do_after(user, 20) && state == 1)
						if(C.use(5))
							to_chat(user, SPAN_NOTICE("You add cables to the frame."))
							state = 2
							icon_state = "box_1"
				else
					if(P.is_wrench())
						playsound(src, W.usesound, 75, TRUE)
						to_chat(user, SPAN_NOTICE("You dismantle the frame"))
						new /obj/item/stack/material/steel(src.loc, 5)
						qdel(src)
			if(2)
				if(istype(P, /obj/item/circuitboard))
					var/obj/item/circuitboard/B = P
					if(B.board_type == "machine")
						playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, TRUE)
						to_chat(user, SPAN_NOTICE("You add the circuit board to the frame."))
						circuit = P
						user.drop_item()
						P.loc = src
						icon_state = "box_2"
						state = 3
						components = list()
						req_components = circuit.req_components.Copy()
						for(var/A in circuit.req_components)
							req_components[A] = circuit.req_components[A]
						req_component_names = circuit.req_components.Copy()
						for(var/A in req_components)
							var/cp = text2path(A)
							var/obj/ct = new cp() // have to quickly instantiate it get name
							req_component_names[A] = ct.name
						update_desc()
						to_chat(user, desc)
					else
						to_chat(user, SPAN_WARNING("This frame does not accept circuit boards of this type!"))
				else
					if(P.is_wirecutter())
						playsound(src.loc, P.usesound, 50, TRUE)
						to_chat(user, SPAN_NOTICE("You remove the cables."))
						state = 1
						icon_state = "box_0"
						var/obj/item/stack/cable_coil/A = new /obj/item/stack/cable_coil(src.loc)
						A.amount = 5

			if(3)
				if(P.is_crowbar())
					playsound(src, P.usesound, 50, TRUE)
					state = 2
					circuit.loc = src.loc
					circuit = null
					if(components.len == 0)
						to_chat(user, SPAN_NOTICE("You remove the circuit board."))
					else
						to_chat(user, SPAN_NOTICE("You remove the circuit board and other components."))
						for(var/obj/item/W in components)
							W.loc = src.loc
					desc = initial(desc)
					req_components = null
					components = null
					icon_state = "box_1"
				else
					if(P.is_screwdriver())
						var/component_check = 1
						for(var/R in req_components)
							if(req_components[R] > 0)
								component_check = 0
								break
						if(component_check)
							playsound(src.loc, P.usesound, 50, TRUE)
							var/obj/machinery/new_machine = new src.circuit.build_path(src.loc, src.dir)

							if(new_machine.component_parts)
								new_machine.component_parts.Cut()
							else
								new_machine.component_parts = list()

							src.circuit.construct(new_machine)

							for(var/obj/O in src)
								if(circuit.contain_parts) // things like disposal don't want their parts in them
									O.loc = new_machine
								else
									O.loc = null
								new_machine.component_parts += O

							if(circuit.contain_parts)
								circuit.loc = new_machine
							else
								circuit.loc = null

							new_machine.RefreshParts()
							qdel(src)
					else
						if(istype(P, /obj/item))
							for(var/I in req_components)
								if(istype(P, text2path(I)) && (req_components[I] > 0))
									playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, TRUE)
									if(P.is_cable_coil))
										var/obj/item/stack/cable_coil/CP = P
										if(CP.get_amount() > 1)
											var/camt = min(CP.amount, req_components[I]) // amount of cable to take, idealy amount required, but limited by amount provided
											var/obj/item/stack/cable_coil/CC = new /obj/item/stack/cable_coil(src)
											CC.amount = camt
											CC.update_icon()
											CP.use(camt)
											components += CC
											req_components[I] -= camt
											update_desc()
											break
									user.drop_item()
									P.loc = src
									components += P
									req_components[I]--
									update_desc()
									break
							to_chat(user, desc)
							if(P && P.loc != src && !istype(P, /obj/item/stack/cable_coil))
								to_chat(user, SPAN_WARNING("You cannot add that component to the machine!"))

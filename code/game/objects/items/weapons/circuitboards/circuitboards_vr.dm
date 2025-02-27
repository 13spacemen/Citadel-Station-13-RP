#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

// Board for the parts lathe in partslathe.dm
/obj/item/circuitboard/partslathe
	name = T_BOARD("parts lathe")
	build_path = /obj/machinery/partslathe
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2)
	req_components = list(
							/obj/item/stock_parts/matter_bin = 2,
							/obj/item/stock_parts/manipulator = 2,
							/obj/item/stock_parts/console_screen = 1)

// Board for the algae oxygen generator in algae_generator.dm
/obj/item/circuitboard/algae_farm
	name = T_BOARD("algae oxygen generator")
	build_path = /obj/machinery/atmospherics/component/binary/algae_farm
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_ENGINEERING = 3, TECH_BIO = 2)
	req_components = list(
							/obj/item/stock_parts/matter_bin = 2,
							/obj/item/stock_parts/manipulator = 1,
							/obj/item/stock_parts/capacitor = 1,
							/obj/item/stock_parts/console_screen = 1)

//Board for the High performance gas pump
/obj/item/circuitboard/massive_gas_pump
	name = T_BOARD("High performance gas pump")
	build_path = /obj/machinery/atmospherics/component/binary/massive_gas_pump
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_ENGINEERING = 3, TECH_POWER = 2)
	req_components = list(
							/obj/item/stock_parts/matter_bin = 2,
							/obj/item/stock_parts/manipulator = 2,
							/obj/item/stock_parts/capacitor = 1)

/obj/item/circuitboard/massive_heat_pump
	name = T_BOARD("High performance heat pump")
	build_path = /obj/machinery/atmospherics/component/binary/massive_heat_pump
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_ENGINEERING = 3, TECH_POWER = 2)
	req_components = list(
							/obj/item/stock_parts/matter_bin = 1,
							/obj/item/stock_parts/micro_laser = 2,
							/obj/item/stock_parts/capacitor = 2)

// Board for the thermal regulator in airconditioner_vr.dm
/obj/item/circuitboard/thermoregulator
	name = T_BOARD("thermal regulator")
	build_path = /obj/machinery/power/thermoregulator
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_ENGINEERING = 4, TECH_POWER = 3)
	req_components = list(
							/obj/item/stack/cable_coil = 20,
							/obj/item/stock_parts/capacitor/super = 3)

// Board for the bomb tester in bomb_tester_vr.dm
/obj/item/circuitboard/bomb_tester
	name = T_BOARD("explosive effect simulator")
	build_path = /obj/machinery/bomb_tester
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_PHORON = 3, TECH_DATA = 2, TECH_MAGNET = 2)
	req_components = list(
							/obj/item/stock_parts/matter_bin/adv = 1,
							/obj/item/stock_parts/scanning_module = 5)

// Board for the timeclock terminal in timeclock_vr.dm
/obj/item/circuitboard/timeclock
	name = T_BOARD("timeclock")
	build_path = /obj/machinery/computer/timeclock
	board_type = new /datum/frame/frame_types/timeclock_terminal
	matter = list(MAT_STEEL = 50, MAT_GLASS = 50)

// Board for the ID restorer in id_restorer_vr.dm
/obj/item/circuitboard/id_restorer
	name = T_BOARD("ID restoration console")
	build_path = /obj/machinery/computer/id_restorer
	board_type = new /datum/frame/frame_types/id_restorer
	matter = list(MAT_STEEL = 50, MAT_GLASS = 50)

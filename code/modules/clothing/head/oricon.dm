//SolGov uniform hats

//Utility
/obj/item/clothing/head/soft/orion
	name = "\improper SolGov cap"
	desc = "It's a blue ballcap in Orion Confederation Government colors."
	icon_state = "orionsoft"
	item_state_slots = list(
		slot_l_hand_str = "lightbluesoft",
		slot_r_hand_str = "lightbluesoft",
		)

/obj/item/clothing/head/soft/orion/expedition
	name = "\improper SifGuard cap"
	desc = "It's a black ballcap bearing a Sif Defense Force crest."
	icon_state = "expeditionsoft"
	item_state_slots = list(
		slot_l_hand_str = "blacksoft",
		slot_r_hand_str = "blacksoft",
		)

/obj/item/clothing/head/soft/orion/fleet
	name = "fleet cap"
	desc = "It's a navy blue ballcap with a CNA Fleet crest."
	icon_state = "fleetsoft"
	item_state_slots = list(
		slot_l_hand_str = "darkbluesoft",
		slot_r_hand_str = "darkbluesoft",
		)

/obj/item/clothing/head/utility
	name = "utility cover"
	desc = "An eight-point utility cover."
	icon_state = "greyutility"
	item_state_slots = list(
		slot_l_hand_str = "helmet",
		slot_r_hand_str = "helmet",
		)
	siemens_coefficient = 0.9
	body_parts_covered = 0

/obj/item/clothing/head/utility/fleet
	name = "fleet utility cover"
	desc = "A navy blue utility cover bearing the crest of a OCG Fleet."
	icon_state = "navyutility"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 10, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.7

/obj/item/clothing/head/utility/marine
	name = "marine utility cover"
	desc = "A grey utility cover bearing the crest of the OCG Marine Corps."
	icon_state = "greyutility"
	armor = list(melee = 10, bullet = 0, laser = 10,energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/head/utility/marine/tan
	name = "tan utility cover"
	desc = "A tan utility cover bearing the crest of the OCG Marine Corps."
	icon_state = "tanutility"

/obj/item/clothing/head/utility/marine/green
	name = "green utility cover"
	desc = "A green utility cover bearing the crest of the OCG Marine Corps."
	icon_state = "greenutility"

//Service

/obj/item/clothing/head/service
	name = "service cover"
	desc = "A service uniform cover."
	icon_state = "greenwheelcap"
	item_state_slots = list(
		slot_l_hand_str = "helmet",
		slot_r_hand_str = "helmet",
		)
	siemens_coefficient = 0.9
	body_parts_covered = 0

/obj/item/clothing/head/service/marine
	name = "marine wheel cover"
	desc = "A green service uniform cover with an OCG Marine Corps crest."
	icon_state = "greenwheelcap"

/obj/item/clothing/head/service/marine/command
	name = "marine officer's wheel cover"
	desc = "A green service uniform cover with an OCG Marine Corps crest and gold stripe."
	icon_state = "greenwheelcap_com"

/obj/item/clothing/head/service/marine/garrison
	name = "marine garrison cap"
	desc = "A green garrison cap belonging to the OCG Marine Corps."
	icon_state = "greengarrisoncap"

/obj/item/clothing/head/service/marine/garrison/command
	name = "marine officer's garrison cap"
	desc = "A green garrison cap belonging to the OCG Marine Corps. This one has a gold pin."
	icon_state = "greengarrisoncap_com"

/obj/item/clothing/head/service/marine/campaign
	name = "campaign cover"
	desc = "A green campaign cover with an OCG Marine Corps crest. Only found on the heads of Drill Instructors."
	icon_state = "greendrill"

//Dress

/obj/item/clothing/head/dress
	name = "dress cover"
	desc = "A dress uniform cover."
	icon_state = "greenwheelcap"
	item_state_slots = list(
		slot_l_hand_str = "helmet",
		slot_r_hand_str = "helmet",
		)
	siemens_coefficient = 0.9
	body_parts_covered = 0

/obj/item/clothing/head/dress/expedition
	name = "\improper SifGuard dress cap"
	desc = "A peaked grey dress uniform cap belonging to the Sif Defense Force."
	icon_state = "greydresscap"

/obj/item/clothing/head/dress/expedition/command
	name = "\improper SifGuard command dress cap"
	desc = "A peaked grey dress uniform cap belonging to the Sif Defense Force. This one is trimmed in gold."
	icon_state = "greydresscap_com"

/obj/item/clothing/head/dress/fleet
	name = "fleet dress wheel cover"
	desc = "A white dress uniform cover. This one has an OCG Fleet crest."
	icon_state = "whitepeakcap"

/obj/item/clothing/head/dress/fleet/command
	name = "fleet command dress wheel cover"
	desc = "A white dress uniform cover. This one has a gold stripe and an OCG Fleet crest."
	icon_state = "whitepeakcap_com"

/obj/item/clothing/head/dress/marine
	name = "marine dress wheel cover"
	desc = "A white dress uniform cover with an OCG Marine Corps crest."
	icon_state = "whitewheelcap"

/obj/item/clothing/head/dress/marine/command
	name = "marine officer's dress wheel cover"
	desc = "A white dress uniform cover with an OCG Marine Corps crest and gold stripe."
	icon_state = "whitewheelcap_com"

//Berets

/obj/item/clothing/head/beret/orion
	name = "peacekeeper beret"
	desc = "A beret in Orion Confederation Government colors. For peacekeepers that are more inclined towards style than safety."
	icon_state = "beret_lightblue"

/obj/item/clothing/head/beret/orion/gateway
	name = "gateway administration beret"
	desc = "An orange beret denoting service in the Gateway Administration. For personnel that are more inclined towards style than safety."
	icon_state = "beret_orange"

/obj/item/clothing/head/beret/orion/customs
	name = "customs and trade beret"
	desc = "A purple beret denoting service in the Customs and Trade Bureau. For personnel that are more inclined towards style than safety."
	icon_state = "beret_purpleyellow"

/obj/item/clothing/head/beret/orion/orbital
	name = "orbital assault beret"
	desc = "A blue beret denoting orbital assault training. For helljumpers that are more inclined towards style than safety."
	icon_state = "beret_blue"

/obj/item/clothing/head/beret/orion/research
	name = "government research beret"
	desc = "A green beret denoting service in the Bureau of Research. For explorers that are more inclined towards style than safety."
	icon_state = "beret_green"

/obj/item/clothing/head/beret/orion/health
	name = "health service beret"
	desc = "A white beret denoting service in the Interstellar Health Service. For medics that are more inclined towards style than safety."
	icon_state = "beret_white"

/obj/item/clothing/head/beret/orion/expedition
	name = "\improper SifGuard beret"
	desc = "A black beret belonging to the Sif Defense Force. For personnel that are more inclined towards style than safety."
	icon_state = "beret_black"

/obj/item/clothing/head/beret/orion/expedition/security
	name = "\improper SifGuard security beret"
	desc = "A Sif Defense Force beret with a security crest. For personnel that are more inclined towards style than safety."
	icon_state = "beret_black_security"

/obj/item/clothing/head/beret/orion/expedition/medical
	name = "\improper SifGuard medical beret"
	desc = "A Sif Defense Force beret with a medical crest. For personnel that are more inclined towards style than safety."
	icon_state = "beret_black_medical"

/obj/item/clothing/head/beret/orion/expedition/engineering
	name = "\improper SifGuard engineering beret"
	desc = "A Sif Defense Force beret with an engineering crest. For personnel that are more inclined towards style than safety."
	icon_state = "beret_black_engineering"

/obj/item/clothing/head/beret/orion/expedition/supply
	name = "\improper SifGuard supply beret"
	desc = "A Sif Defense Force beret with a supply crest. For personnel that are more inclined towards style than safety."
	icon_state = "beret_black_supply"

/obj/item/clothing/head/beret/orion/expedition/command
	name = "\improper SifGuard command beret"
	desc = "A Sif Defense Force beret with a command crest. For personnel that are more inclined towards style than safety."
	icon_state = "beret_black_command"

/obj/item/clothing/head/beret/orion/fleet
	name = "fleet beret"
	desc = "A navy blue beret belonging to the OCG Fleet. For personnel that are more inclined towards style than safety."
	icon_state = "beret_navy"

/obj/item/clothing/head/beret/orion/fleet/security
	name = "fleet security beret"
	desc = "An OCG Fleet beret with a security crest. For personnel that are more inclined towards style than safety."
	icon_state = "beret_navy_security"

/obj/item/clothing/head/beret/orion/fleet/medical
	name = "fleet medical beret"
	desc = "An OCG Fleet beret with a medical crest. For personnel that are more inclined towards style than safety."
	icon_state = "beret_navy_medical"

/obj/item/clothing/head/beret/orion/fleet/engineering
	name = "fleet engineering beret"
	desc = "An OCG Fleet with an engineering crest. For personnel that are more inclined towards style than safety."
	icon_state = "beret_navy_engineering"

/obj/item/clothing/head/beret/orion/fleet/supply
	name = "fleet supply beret"
	desc = "An OCG Fleet beret with a supply crest. For personnel that are more inclined towards style than safety."
	icon_state = "beret_navy_supply"

/obj/item/clothing/head/beret/orion/fleet/command
	name = "fleet command beret"
	desc = "An OCG Fleet beret with a command crest. For personnel that are more inclined towards style than safety."
	icon_state = "beret_navy_command"

//OriCon uniform hats

//Utility
/obj/item/clothing/head/soft/orion
	name = "\improper OriCon cap"
	desc = "It's a blue ballcap in Orion Confederation Government colors."

/obj/item/clothing/head/soft/orion/expedition
	name = "explorer's cap"
	desc = "It's a black ballcap bearing a Society of Universal Cartographers crest."

/obj/item/clothing/head/soft/orion/fleet
	name = "fleet cap"
	desc = "It's a navy blue ballcap with a JSDF Fleet crest."

/obj/item/clothing/head/utility
	name = "utility cover"
	desc = "An eight-point utility cover."

/obj/item/clothing/head/utility/fleet
	name = "fleet utility cover"
	desc = "A navy blue utility cover bearing the crest of a JSDF Fleet."

/obj/item/clothing/head/utility/marine
	name = "marine utility cover"
	desc = "A grey utility cover bearing the crest of the JSDF Marine Corps."

/obj/item/clothing/head/utility/marine/tan
	name = "tan utility cover"
	desc = "A tan utility cover bearing the crest of the JSDF Marine Corps."

/obj/item/clothing/head/utility/marine/green
	name = "green utility cover"
	desc = "A green utility cover bearing the crest of the JSDF Marine Corps."

/obj/item/clothing/head/utility/marine/green/officer // "And YOU told me you were gonna wear something nice!"
	name = "\improper officer's cap"
	desc = "A green utility cover bearing the crest of the JSDF Marine Corps. This one has an officer's emblem."
	icon_state = "UNSCsoft"
	icon = 'icons/obj/clothing/hats.dmi'

//Service

/obj/item/clothing/head/service
	name = "service cover"
	desc = "A service uniform cover."

/obj/item/clothing/head/service/marine
	name = "marine wheel cover"
	desc = "A green service uniform cover with a JSDF Marine Corps crest."

/obj/item/clothing/head/service/marine/command
	name = "marine officer's wheel cover"
	desc = "A green service uniform cover with a JSDF Marine Corps crest and gold stripe."

/obj/item/clothing/head/service/marine/garrison
	name = "marine garrison cap"
	desc = "A green garrison cap belonging to the JSDF Marine Corps."

/obj/item/clothing/head/service/marine/garrison/command
	name = "marine officer's garrison cap"
	desc = "A green garrison cap belonging to the JSDF Marine Corps. This one has a gold pin."

/obj/item/clothing/head/service/marine/campaign
	name = "campaign cover"
	desc = "A green campaign cover with a JSDF Marine Corps crest. Only found on the heads of Drill Instructors."
	icon_state = "greendrill"

//Dress

/obj/item/clothing/head/dress/expedition
	name = "explorer's dress cap"
	desc = "A peaked grey dress uniform cap belonging to the Society of Universal Cartographers."

/obj/item/clothing/head/dress/expedition/command
	name = "explorer's command dress cap"
	desc = "A peaked grey dress uniform cap belonging to the Society of Universal Cartographers. This one is trimmed in gold."

/obj/item/clothing/head/dress/fleet
	name = "fleet dress wheel cover"
	desc = "A white dress uniform cover. This one has a JSDF Fleet crest."

/obj/item/clothing/head/dress/fleet/command
	name = "fleet command dress wheel cover"
	desc = "A white dress uniform cover. This one has a gold stripe and a JSDF Fleet crest."

/obj/item/clothing/head/dress/marine
	name = "marine dress wheel cover"
	desc = "A white dress uniform cover with a JSDF Marine Corps crest."

/obj/item/clothing/head/dress/marine/command
	name = "marine officer's dress wheel cover"
	desc = "A white dress uniform cover with a JSDF Marine Corps crest and gold stripe."

/obj/item/clothing/head/dress/marine/command/admiral
	name = "admiral's dress wheel cover"
	desc = "A white dress uniform cover with a JSDF Navy crest and gold stripe."

//Berets

/obj/item/clothing/head/beret/orion
	name = "peacekeeper beret"
	desc = "A beret in Orion Confederation Government colors. For peacekeepers that are more inclined towards style than safety."

/obj/item/clothing/head/beret/orion/gateway
	name = "gateway administration beret"
	desc = "An orange beret denoting service in the Gateway Administration. For personnel that are more inclined towards style than safety."

/obj/item/clothing/head/beret/orion/customs
	name = "customs and trade beret"
	desc = "A purple beret denoting service in the Customs and Trade Bureau. For personnel that are more inclined towards style than safety."

/obj/item/clothing/head/beret/orion/orbital
	name = "orbital assault beret"
	desc = "A blue beret denoting orbital assault training. For helljumpers that are more inclined towards style than safety."

/obj/item/clothing/head/beret/orion/research
	name = "government research beret"
	desc = "A green beret denoting service in the Bureau of Research. For explorers that are more inclined towards style than safety."

/obj/item/clothing/head/beret/orion/health
	name = "health service beret"
	desc = "A white beret denoting service in the Interstellar Health Service. For medics that are more inclined towards style than safety."

/obj/item/clothing/head/beret/orion/expedition
	name = "explorer's beret"
	desc = "A black beret belonging to the Society of Universal Cartographers. For personnel that are more inclined towards style than safety."

/obj/item/clothing/head/beret/orion/expedition/security
	name = "explorer's security beret"
	desc = "A Society of Universal Cartographers beret with a security crest. For personnel that are more inclined towards style than safety."

/obj/item/clothing/head/beret/orion/expedition/medical
	name = "explorer's medical beret"
	desc = "A Society of Universal Cartographers beret with a medical crest. For personnel that are more inclined towards style than safety."

/obj/item/clothing/head/beret/orion/expedition/engineering
	name = "explorer's engineering beret"
	desc = "A Society of Universal Cartographers beret with an engineering crest. For personnel that are more inclined towards style than safety."

/obj/item/clothing/head/beret/orion/expedition/supply
	name = "explorer's supply beret"
	desc = "A Society of Universal Cartographers beret with a supply crest. For personnel that are more inclined towards style than safety."

/obj/item/clothing/head/beret/orion/expedition/command
	name = "explorer's command beret"
	desc = "A Society of Universal Cartographers beret with a command crest. For personnel that are more inclined towards style than safety."

/obj/item/clothing/head/beret/orion/fleet
	name = "fleet beret"
	desc = "A navy blue beret belonging to the JSDF Fleet. For personnel that are more inclined towards style than safety."

/obj/item/clothing/head/beret/orion/fleet/security
	name = "fleet security beret"
	desc = "A JSDF Fleet beret with a security crest. For personnel that are more inclined towards style than safety."

/obj/item/clothing/head/beret/orion/fleet/medical
	name = "fleet medical beret"
	desc = "A JSDF Fleet beret with a medical crest. For personnel that are more inclined towards style than safety."

/obj/item/clothing/head/beret/orion/fleet/engineering
	name = "fleet engineering beret"
	desc = "A JSDF Fleet with an engineering crest. For personnel that are more inclined towards style than safety."

/obj/item/clothing/head/beret/orion/fleet/supply
	name = "fleet supply beret"
	desc = "A JSDF Fleet beret with a supply crest. For personnel that are more inclined towards style than safety."

/obj/item/clothing/head/beret/orion/fleet/command
	name = "fleet command beret"
	desc = "A JSDF Fleet beret with a command crest. For personnel that are more inclined towards style than safety."

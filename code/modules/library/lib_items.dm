/* Library Items
 *
 * Contains:
 *		Bookcase
 *		Book
 *		Barcode Scanner
 */


/*
 * Bookcase
 */

/obj/structure/bookcase
	name = "bookcase"
	icon = 'icons/obj/library.dmi'
	icon_state = "book-0"
	anchored = 1
	density = 1
	opacity = 1

/obj/structure/bookcase/Initialize(mapload)
	. = ..()
	for(var/obj/item/I in loc)
		if(istype(I, /obj/item/book))
			I.loc = src
	update_icon()

/obj/structure/bookcase/attackby(obj/item/O as obj, mob/user as mob)
	if(istype(O, /obj/item/book))
		if(!user.attempt_insert_item_for_installation(O, src))
			return
		update_icon()
	else if(istype(O, /obj/item/pen))
		var/newname = sanitizeSafe(input("What would you like to title this bookshelf?"), MAX_NAME_LEN)
		if(!newname)
			return
		else
			name = ("bookcase ([newname])")
	else if(O.is_wrench())
		playsound(loc, O.usesound, 100, 1)
		to_chat(user, (anchored ? "<span class='notice'>You unfasten \the [src] from the floor.</span>" : "<span class='notice'>You secure \the [src] to the floor.</span>"))
		anchored = !anchored
	else if(O.is_screwdriver())
		playsound(loc, O.usesound, 75, 1)
		to_chat(user, "<span class='notice'>You begin dismantling \the [src].</span>")
		if(do_after(user,25 * O.toolspeed))
			to_chat(user, "<span class='notice'>You dismantle \the [src].</span>")
			new /obj/item/stack/material/wood(get_turf(src), 3)
			for(var/obj/item/book/b in contents)
				b.loc = (get_turf(src))
			qdel(src)

	else
		..()

/obj/structure/bookcase/attack_hand(var/mob/user as mob)
	if(contents.len)
		var/obj/item/book/choice = input("Which book would you like to remove from the shelf?") as null|obj in contents
		if(choice)
			if(!usr.canmove || usr.stat || usr.restrained() || !in_range(loc, usr))
				return
			if(ishuman(user))
				if(!user.get_active_held_item())
					user.put_in_hands(choice)
			else
				choice.loc = get_turf(src)
			update_icon()

/obj/structure/bookcase/ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/obj/item/book/b in contents)
				qdel(b)
			qdel(src)
			return
		if(2.0)
			for(var/obj/item/book/b in contents)
				if (prob(50)) b.loc = (get_turf(src))
				else qdel(b)
			qdel(src)
			return
		if(3.0)
			if (prob(50))
				for(var/obj/item/book/b in contents)
					b.loc = (get_turf(src))
				qdel(src)
			return
		else
	return

/obj/structure/bookcase/update_icon()
	if(contents.len < 5)
		icon_state = "book-[contents.len]"
	else
		icon_state = "book-5"



/obj/structure/bookcase/manuals/medical
	name = "Medical Manuals bookcase"

	New()
		..()
		new /obj/item/book/manual/medical_cloning(src)
		new /obj/item/book/manual/medical_diagnostics_manual(src)
		new /obj/item/book/manual/medical_diagnostics_manual(src)
		new /obj/item/book/manual/medical_diagnostics_manual(src)
		update_icon()


/obj/structure/bookcase/manuals/engineering
	name = "Engineering Manuals bookcase"

	New()
		..()
		new /obj/item/book/manual/engineering_construction(src)
		new /obj/item/book/manual/engineering_particle_accelerator(src)
		new /obj/item/book/manual/engineering_hacking(src)
		new /obj/item/book/manual/engineering_guide(src)
		new /obj/item/book/manual/atmospipes(src)
		new /obj/item/book/manual/engineering_singularity_safety(src)
		new /obj/item/book/manual/evaguide(src)
		update_icon()

/obj/structure/bookcase/manuals/research_and_development
	name = "R&D Manuals bookcase"

	New()
		..()
		new /obj/item/book/manual/research_and_development(src)
		update_icon()

/obj/structure/bookcase/legal/sop
	name = "Legal Manuals bookcase"
	icon_state = "legalbook-0"

	New()
		..()
		new /obj/item/book/manual/legal/sop_vol1
		new /obj/item/book/manual/legal/sop_vol2
		new /obj/item/book/manual/legal/sop_vol3
		new /obj/item/book/manual/legal/sop_vol4
		new /obj/item/book/manual/legal/sop_vol5_1
		new /obj/item/book/manual/legal/sop_vol5_2
		new /obj/item/book/manual/legal/sop_vol5_3
		new /obj/item/book/manual/legal/sop_vol5_4
		new /obj/item/book/manual/legal/sop_vol5_5
		new /obj/item/book/manual/legal/sop_vol5_6
		new /obj/item/book/manual/legal/sop_vol5_7
		update_icon()

/obj/structure/bookcase/legal/corpreg
	name = "Corporate Regulations bookcase"
	icon_state = "legalbook-0"

	New()
		..()
		new /obj/item/book/manual/legal/cr_vol1
		new /obj/item/book/manual/legal/cr_vol2
		new /obj/item/book/manual/legal/cr_vol3
		new /obj/item/book/manual/legal/cr_vol4
		new /obj/item/book/manual/legal/cr_vol5
		update_icon()

/obj/structure/bookcase/legal/combo
	name = "Policy Reference bookcase"
	icon_state = "legalbook-0"

	New()
		..()
		new /obj/item/book/manual/legal/sop_vol1
		new /obj/item/book/manual/legal/sop_vol2
		new /obj/item/book/manual/legal/sop_vol3
		new /obj/item/book/manual/legal/sop_vol4
		new /obj/item/book/manual/legal/sop_vol5_1
		new /obj/item/book/manual/legal/sop_vol5_2
		new /obj/item/book/manual/legal/sop_vol5_3
		new /obj/item/book/manual/legal/sop_vol5_4
		new /obj/item/book/manual/legal/sop_vol5_5
		new /obj/item/book/manual/legal/sop_vol5_6
		new /obj/item/book/manual/legal/sop_vol5_7
		new /obj/item/book/manual/legal/cr_vol1
		new /obj/item/book/manual/legal/cr_vol2
		new /obj/item/book/manual/legal/cr_vol3
		new /obj/item/book/manual/legal/cr_vol4
		new /obj/item/book/manual/legal/cr_vol5
		update_icon()

/obj/structure/bookcase/legal/update_icon()
	if(contents.len < 5)
		icon_state = "legalbook-[contents.len]"
	else
		icon_state = "legalbook-5"

/*
 * Book
 */
/obj/item/book
	name = "book"
	icon = 'icons/obj/library.dmi'
	icon_state ="book"
	throw_speed = 1
	throw_range = 5
	flags = NOCONDUCT
	w_class = ITEMSIZE_NORMAL		 //upped to three because books are, y'know, pretty big. (and you could hide them inside eachother recursively forever)
	attack_verb = list("bashed", "whacked", "educated")
	var/dat			 // Actual page content
	var/due_date = 0 // Game time in 1/10th seconds
	var/author		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	var/libcategory = "Miscellaneous"	// The library category this book sits in. "Fiction", "Non-Fiction", "Adult", "Reference", "Religion"
	var/unique = 0   // 0 - Normal book, 1 - Should not be treated as normal book, unable to be copied, unable to be modified
	var/title		 // The real name of the book.
	var/carved = 0	 // Has the book been hollowed out for use as a secret storage item?
	var/obj/item/store	//What's in the book?
	drop_sound = 'sound/items/drop/book.ogg'
	pickup_sound = 'sound/items/pickup/book.ogg'


/obj/item/book/attack_self(var/mob/user as mob)
	if(carved)
		if(store)
			to_chat(user, "<span class='notice'>[store] falls out of [title]!</span>")
			store.loc = get_turf(src.loc)
			store = null
			return
		else
			to_chat(user, "<span class='notice'>The pages of [title] have been cut out!</span>")
			return
	if(src.dat)
		user << browse("<TT><I>Penned by [author].</I></TT> <BR>" + "[dat]", "window=book")
		user.visible_message("[user] opens a book titled \"[src.title]\" and begins reading intently.")
		onclose(user, "book")
	else
		to_chat(user, "This book is completely blank!")

/obj/item/book/attackby(obj/item/W, mob/user)
	if(carved)
		if(!store)
			if(W.w_class < ITEMSIZE_LARGE)
				if(!user.attempt_insert_item_for_installation(W, src))
					return
				store = W
				to_chat(user, "<span class='notice'>You put [W] in [title].</span>")
				return
			else
				to_chat(user, "<span class='notice'>[W] won't fit in [title].</span>")
				return
		else
			to_chat(user, "<span class='notice'>There's already something in [title]!</span>")
			return
	if(istype(W, /obj/item/pen))
		if(unique)
			to_chat(user, "These pages don't seem to take the ink well. Looks like you can't modify it.")
			return
		var/choice = input("What would you like to change?") in list("Title", "Contents", "Author", "Cancel")
		switch(choice)
			if("Title")
				var/newtitle = reject_bad_text(sanitizeSafe(input("Write a new title:")))
				if(!newtitle)
					to_chat(usr, "The title is invalid.")
					return
				else
					src.name = newtitle
					src.title = newtitle
			if("Contents")
				var/content = sanitize(input("Write your book's contents (HTML NOT allowed):") as message|null, MAX_BOOK_MESSAGE_LEN)
				if(!content)
					to_chat(usr, "The content is invalid.")
					return
				else
					src.dat += content
			if("Author")
				var/newauthor = sanitize(input(usr, "Write the author's name:"))
				if(!newauthor)
					to_chat(usr, "The name is invalid.")
					return
				else
					src.author = newauthor
			else
				return
	else if(istype(W, /obj/item/barcodescanner))
		var/obj/item/barcodescanner/scanner = W
		if(!scanner.computer)
			to_chat(user, "[W]'s screen flashes: 'No associated computer found!'")
		else
			switch(scanner.mode)
				if(0)
					scanner.book = src
					to_chat(user, "[W]'s screen flashes: 'Book stored in buffer.'")
				if(1)
					scanner.book = src
					scanner.computer.buffer_book = src.name
					to_chat(user, "[W]'s screen flashes: 'Book stored in buffer. Book title stored in associated computer buffer.'")
				if(2)
					scanner.book = src
					for(var/datum/borrowbook/b in scanner.computer.checkouts)
						if(b.bookname == src.name)
							scanner.computer.checkouts.Remove(b)
							to_chat(user, "[W]'s screen flashes: 'Book stored in buffer. Book has been checked in.'")
							return
					to_chat(user, "[W]'s screen flashes: 'Book stored in buffer. No active check-out record found for current title.'")
				if(3)
					scanner.book = src
					for(var/obj/item/book in scanner.computer.inventory)
						if(book == src)
							to_chat(user, "[W]'s screen flashes: 'Book stored in buffer. Title already present in inventory, aborting to avoid duplicate entry.'")
							return
					scanner.computer.inventory.Add(src)
					to_chat(user, "[W]'s screen flashes: 'Book stored in buffer. Title added to general inventory.'")
	else if(istype(W, /obj/item/material/knife) || W.is_wirecutter())
		if(carved)	return
		to_chat(user, "<span class='notice'>You begin to carve out [title].</span>")
		if(do_after(user, 30))
			to_chat(user, "<span class='notice'>You carve out the pages from [title]! You didn't want to read it anyway.</span>")
			carved = 1
			return
	else
		..()

/obj/item/book/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(user.zone_sel.selecting == O_EYES)
		user.visible_message("<span class='notice'>You open up the book and show it to [M]. </span>", \
			"<span class='notice'> [user] opens up a book and shows it to [M]. </span>")
		M << browse("<TT><I>Penned by [author].</I></TT> <BR>" + "[dat]", "window=book")
		user.setClickCooldown(DEFAULT_QUICK_COOLDOWN) //to prevent spam

/*
* Book Bundle (Multi-page book)
*/

/obj/item/book/bundle
	var/page = 1 //current page
	var/list/pages = list() //the contents of each page

/obj/item/book/bundle/proc/show_content(mob/user as mob)
	var/dat
	var/obj/item/W = pages[page]
	// first
	if(page == 1)
		dat+= "<DIV STYLE='float:left; text-align:left; width:33.33333%'><A href='?src=\ref[src];prev_page=1'>Front</A></DIV>"
		dat+= "<DIV STYLE='float:right; text-align:right; width:33.33333%'><A href='?src=\ref[src];next_page=1'>Next Page</A></DIV><BR><HR>"
	// last
	else if(page == pages.len)
		dat+= "<DIV STYLE='float:left; text-align:left; width:33.33333%'><A href='?src=\ref[src];prev_page=1'>Previous Page</A></DIV>"
		dat+= "<DIV STYLE='float:right; text-align:right; with:33.33333%'><A href='?src=\ref[src];next_page=1'>Back</A></DIV><BR><HR>"
	// middle pages
	else
		dat+= "<DIV STYLE='float:left; text-align:left; width:33.33333%'><A href='?src=\ref[src];prev_page=1'>Previous Page</A></DIV>"
		dat+= "<DIV STYLE='float:right; text-align:right; width:33.33333%'><A href='?src=\ref[src];next_page=1'>Next Page</A></DIV><BR><HR>"
	if(istype(pages[page], /obj/item/paper))
		var/obj/item/paper/P = W
		if(!(istype(usr, /mob/living/carbon/human) || isobserver(usr) || istype(usr, /mob/living/silicon)))
			dat += "<HTML><HEAD><TITLE>[P.name]</TITLE></HEAD><BODY>[stars(P.info)][P.stamps]</BODY></HTML>"
		else
			dat += "<HTML><HEAD><TITLE>[P.name]</TITLE></HEAD><BODY>[P.info][P.stamps]</BODY></HTML>"
		user << browse(dat, "window=[name]")
	else if(istype(pages[page], /obj/item/photo))
		var/obj/item/photo/P = W
		user << browse_rsc(P.img, "tmp_photo.png")
		user << browse(dat + "<html><head><title>[P.name]</title></head>" \
		+ "<body style='overflow:hidden'>" \
		+ "<div> <img src='tmp_photo.png' width = '180'" \
		+ "[P.scribble ? "<div> Written on the back:<br><i>[P.scribble]</i>" : null]"\
		+ "</body></html>", "window=[name]")
	else if(!isnull(pages[page]))
		if(!(istype(usr, /mob/living/carbon/human) || isobserver(usr) || istype(usr, /mob/living/silicon)))
			dat += "<HTML><HEAD><TITLE>Page [page]</TITLE></HEAD><BODY>[stars(pages[page])]</BODY></HTML>"
		else
			dat += "<HTML><HEAD><TITLE>Page [page]</TITLE></HEAD><BODY>[pages[page]]</BODY></HTML>"
		user << browse(dat, "window=[name]")

/obj/item/book/bundle/attack_self(mob/user as mob)
	src.show_content(user)
	add_fingerprint(usr)
	update_icon()
	return

/obj/item/book/bundle/Topic(href, href_list)
	if(..())
		return 1
	if((src in usr.contents) || (istype(src.loc, /obj/item/folder) && (src.loc in usr.contents)))
		usr.set_machine(src)
		if(href_list["next_page"])
			if(page != pages.len)
				page++
				playsound(src.loc, "pageturn", 50, 1)
		if(href_list["prev_page"])
			if(page > 1)
				page--
				playsound(src.loc, "pageturn", 50, 1)
		src.attack_self(usr)
		updateUsrDialog()
	else
		to_chat(usr, "<span class='notice'>You need to hold it in your hands!</span>")

/*
 * Barcode Scanner
 */
/obj/item/barcodescanner
	name = "barcode scanner"
	icon = 'icons/obj/library.dmi'
	icon_state ="scanner"
	throw_speed = 1
	throw_range = 5
	w_class = ITEMSIZE_SMALL
	var/obj/machinery/librarycomp/computer // Associated computer - Modes 1 to 3 use this
	var/obj/item/book/book	 //  Currently scanned book
	var/mode = 0 					// 0 - Scan only, 1 - Scan and Set Buffer, 2 - Scan and Attempt to Check In, 3 - Scan and Attempt to Add to Inventory

	attack_self(mob/user as mob)
		mode += 1
		if(mode > 3)
			mode = 0
		to_chat(user, "[src] Status Display:")
		var/modedesc
		switch(mode)
			if(0)
				modedesc = "Scan book to local buffer."
			if(1)
				modedesc = "Scan book to local buffer and set associated computer buffer to match."
			if(2)
				modedesc = "Scan book to local buffer, attempt to check in scanned book."
			if(3)
				modedesc = "Scan book to local buffer, attempt to add book to general inventory."
			else
				modedesc = "ERROR"
		to_chat(user, " - Mode [mode] : [modedesc]")
		if(src.computer)
			to_chat(user, "<font color=green>Computer has been associated with this unit.</font>")
		else
			to_chat(user, "<font color=red>No associated computer found. Only local scans will function properly.</font>")
		to_chat(user, "\n")

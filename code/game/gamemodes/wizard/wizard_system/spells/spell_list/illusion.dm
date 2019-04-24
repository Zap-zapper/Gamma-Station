/obj/effect/proc_holder/magic/click_on/illusion
	name = "Decoy"
	desc = ""
	mana_cost = 0
	types_to_click = list("objects","mobs", "turfs")
	var/scanned = null


/obj/effect/dummy/chameleon/illusion/proc/copy(atom/target)		//Atom because either mob or obj/item
	name = target.name
	desc = target.desc
	copying = target
	density = target.density
	anchored = FALSE
	appearance = target.appearance
	layer = initial(target.layer)
	plane = initial(target.plane)


/obj/effect/proc_holder/magic/click_on/illusion/check_turf_cast(turf/target)
	if(!scanned)
		to_chat(owner.current, "<font color='purple'><i>What do you want me to create?!</i></font>")
		return TRUE

	if(istype(target, /turf/simulated/wall))
		to_chat(owner.current, "<font color='purple'><i>How can I forge an illusion inside a wall?! You fool!</i></font>")
		return TRUE


/obj/effect/proc_holder/magic/click_on/illusion/check_object_cast(obj/target)
	if(!istype(target, /obj/item))
		return TRUE


/obj/effect/proc_holder/magic/click_on/illusion/cast_on_mob(mob/living/target)
	to_chat(owner.current, "<font color='purple'><i>I scanned the [target]! Now I can create decoys of it!</i></font>")
	scanned = target


/obj/effect/proc_holder/magic/click_on/illusion/cast_on_object(obj/target)
	to_chat(owner.current, "<font color='purple'><i>I scanned the [target]! Now I can create decoys of it!</i></font>")
	scanned = target


/obj/effect/proc_holder/magic/click_on/illusion/cast_on_turf(turf/target)
	var/obj/effect/dummy/chameleon/illusion/decoy = new (target)
	decoy.copy(scanned)
	decoy.dir = owner.current.dir

	QDEL_IN(decoy, ILLUSION_LIFESPAN)

	var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
	spark_system.set_up(5, 0, decoy)
	spark_system.start()


/obj/effect/dummy/chameleon/illusion
	var/atom/copying = null

/obj/effect/dummy/chameleon/illusion/examine(mob/user)
	if(copying)
		copying.examine(user)		//Messy, because if I, for example, undress, copy will be examined as undressed, despite it being dressed. Still, the best solution against examine-check.
		return
	..()


/obj/effect/dummy/chameleon/illusion/Destroy()
	var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
	spark_system.set_up(5, 0, src)
	spark_system.start()
	return ..()

/obj/effect/dummy/chameleon/illusion/attackby()
	Destroy()

/obj/effect/dummy/chameleon/illusion/attack_hand()
	Destroy()

/obj/effect/dummy/chameleon/illusion/ex_act()
	Destroy()

/obj/effect/dummy/chameleon/illusion/emp_act()
	Destroy()

/obj/effect/dummy/chameleon/illusion/bullet_act()
	Destroy()


#undef ILLUSION_MANACOST
#undef ILLUSION_LIFESPAN
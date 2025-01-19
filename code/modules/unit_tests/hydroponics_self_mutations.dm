/// Unit test to ensure plants can't self-mutate into themselves.
/datum/unit_test/hydroponics_self_mutation
	name = "HYDROPONICS: Plants Shall Not Mutate Into Themselves"

/datum/unit_test/hydroponics_self_mutation/Run()
	for(var/datum/plant/P as anything in subtypesof(/datum/plant))
		if(isabstract(P))
			continue

		P = new P()
		for(var/datum/plant_mutation/mutation as anything in P.possible_mutations)
			if(mutation.plant_type == P.type)
				TEST_FAIL("[P.type] has itself as a possible mutation.")

		qdel(P)

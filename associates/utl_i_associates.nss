//::///////////////////////////////////////////////
//:: Utility Include: Associates
//:: utl_i_associates.nss
//:://////////////////////////////////////////////
/*
    A number of utility functions for Associates. These 
    are focused on managing or changing NPC party members, such
    as summons, henchmen/companions, dominated, familiars and
    animal companions.
*/
//:://////////////////////////////////////////////
//:: Part of the nwscript_utility_scripts project; see for dates/creator info
//:: https://github.com/Finaldeath/nwscript_utility_scripts
//:://////////////////////////////////////////////

// This will port all associates of oMaster to the given location.
// It automatically moves associates of associates (eg; a henchmans
// summoned monster).
// * oMaster - a PC or NPC to port associates of
// * lTarget - the destination target
void PortAssociates(object oMaster, location lTarget);

// If called then any EffectSummonCreature() effects applied in the next 0.2 or
// so seconds will appear and not cause the originals to disappear (although the
// unsummon VFX will still play).
// It is recommended to limit nLimit to something sane and at most 99.
// * oSummoner - Summoner to affect. If called in a spell script it would be OBJECT_SELF
// * nLimit - The amount of summons we should allow, default: 1
void AllowMultipleSummonedCreatures(object oSummoner = OBJECT_SELF, int nLimit = 1);



// This will port all associates of oMaster to the given location.
// It automatically moves associates of associates (eg; a henchmans
// summoned monster).
// * oMaster - a PC or NPC to port associates of
// * lTarget - the destination target
void PortAssociates(object oMaster, location lTarget)
{
    object oAssociate;
    int nType, i;
    for(nType = 1; nType <= 5; nType++)
    {
        i = 1;
        oAssociate = GetAssociate(nType, oMaster, i);
        while(GetIsObjectValid(oAssociate))
        {
            AssignCommand(oAssociate, ClearAllActions());
            AssignCommand(oAssociate, JumpToLocation(lTarget));
            PortAssociates(oAssociate, lTarget);
            i++;
            oAssociate = GetAssociate(nType, oMaster, i);
        }
    }
}

// If called then any EffectSummonCreature() effects applied in the next 0.2 or
// so seconds will appear and not cause the originals to disappear (although the
// unsummon VFX will still play).
// It is recommended to limit nLimit to something sane and at most 99.
// * oSummoner - Summoner to affect. If called in a spell script it would be OBJECT_SELF
// * nLimit - The amount of summons we should allow, default: 1
void AllowMultipleSummonedCreatures(object oSummoner = OBJECT_SELF, int nLimit = 1)
{
    int nNth = 1;
    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oSummoner, nNth);
    // Do nLimit - 1 of summons
    while(GetIsObjectValid(oSummon) && nNth < nLimit)
    {
        // This code stops the usual engine calls to DestroyObject() for the time
        // EffectSummonCreature occurs.
        AssignCommand(oSummon, SetIsDestroyable(FALSE, FALSE, FALSE));
        AssignCommand(oSummon, DelayCommand(0.3, SetIsDestroyable(TRUE, FALSE, FALSE)));
        nNth++;
        oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oSummoner, nNth);
    }
}
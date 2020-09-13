//::///////////////////////////////////////////////
//:: Utility Include: Reputation
//:: utl_i_reputation.nss
//:://////////////////////////////////////////////
/*
    The reputation systems in Neverwinter Nights are known to be a rather
    messy black box. Scripts can cause creatures to change to standard
    factions but not custom ones very easily, and "reputation changes" are
    done engine-wide not controlled by scripts.

    This has some utility functions to take the edge off the issues especially
    around making a hostile creature friendly (it is recommended to make
    these kinds of creatures immortal if they must do some kind of 
    speaking).
*/
//:://////////////////////////////////////////////
//:: Part of the nwscript_utility_scripts project; see for dates/creator info
//:: https://github.com/Finaldeath/nwscript_utility_scripts
//:://////////////////////////////////////////////

// This will make all PC and PC party faction members friendly with oSource and all of oSource
// factions, in the given area oSource is in. This will do these actions:
// - Clear all combat actions from creatures (ClearAllActions(TRUE)) regardless of faction
// - Clear all personal reputations (ClearPersonalReputation)
// - Set the personal reputation to "friendly" with no decay (SetIsTemporaryFriend)
// * oSource - the NPC who's faction we want to be friendly to all PC parties
// * bRemoveHostileSpells - If TRUE removes any AOE effects in the area, all effects from 
//      oSource and all faction members of oSource, and any effects they've created on any PC.
// * bPlot - If TRUE sets all faction members of oSource's faction in the area
//   to plot to stop further damage and faction changes
void SetAllCreaturesFriendly(object oSource, int bRemoveHostileSpells = TRUE, int bPlot = TRUE);

// For every PC and every member of the PCs party it will set oCreature to be friendly.
// * oCreature - Creature to be friends with
// Uses SetIsTemporaryFriend and ClearPoersonalReputation
void SetAllPlayerPartiesFriendlyTo(object oCreature);

// For each member in oPC's party it will set them to be friendly to oCreature, including
// henchmen etc.
// * oPC - a member of the party (usually best being the party leader)
// * oCreature - Creature to be friends with
// Uses SetIsTemporaryFriend and ClearPoersonalReputation
void SetPlayerPartyFriendlyTo(object oPC, object oCreature);



// This will make all PC and PC party faction members friendly with oSource and all of oSource
// factions, in the given area oSource is in. This will do these actions:
// - Clear all combat actions from creatures (ClearAllActions(TRUE)) regardless of faction
// - Clear all personal reputations (ClearPersonalReputation)
// - Set the personal reputation to "friendly" with no decay (SetIsTemporaryFriend)
// * oSource - the NPC who's faction we want to be friendly to all PC parties
// * bRemoveHostileSpells - If TRUE removes any AOE effects in the area, all effects from 
//      oSource and all faction members of oSource, and any effects they've created on any PC.
// * bPlot - If TRUE sets all faction members of oSource's faction in the area
//   to plot to stop further damage and faction changes
void SetAllCreaturesFriendly(object oSource, int bRemoveHostileSpells = TRUE, int bPlot = TRUE)
{
    // Loop all items in the area since we need both AOE and creatures
    object oArea = GetArea(oSource);
    int nObjectType;
    effect eEffect;
    object oEffectCreator;
    object oObject = GetFirstObjectInArea(oArea);
    while(GetIsObjectValid(oObject))
    {
        nObjectType = GetObjectType(oObject);
        if(nObjectType == OBJECT_TYPE_CREATURE)
        {
            // All creatures actions and combat state is cleared regardless
            AssignCommand(oObject, ClearAllActions(TRUE));

            // Check if they are a different faction
            if(!GetFactionEqual(oObject, oSource))
            {
                // Remove effects from target that oSource's faction created
                if(bRemoveHostileSpells)
                {
                    eEffect = GetFirstEffect(oObject);
                    while(GetIsEffectValid(eEffect))
                    {
                        oEffectCreator = GetEffectCreator(eEffect);
                        if(GetIsObjectValid(oEffectCreator) && GetFactionEqual(oSource, oEffectCreator))
                        {
                            RemoveEffect(oObject, eEffect);
                        }
                        eEffect = GetNextEffect(oObject);
                    }
                }
            }
            else
            {
                // Set every PC party to be friendly to this creature
                SetAllPlayerPartiesFriendlyTo(oObject);

                // Equal factions optionally get all effects removed and optionally set to plot
                if(bRemoveHostileSpells)
                {
                    eEffect = GetFirstEffect(oObject);
                    while(GetIsEffectValid(eEffect))
                    {
                        RemoveEffect(oObject, eEffect);
                        eEffect = GetNextEffect(oObject);
                    }
                }
                // Set plot flag if we requested it
                if(bPlot)
                {
                    SetPlotFlag(oObject, TRUE);
                }
            }
        }
        else if(nObjectType == OBJECT_TYPE_AREA_OF_EFFECT)
        {
            // Destroy if removing effects
            if(bRemoveHostileSpells)
            {
                DestroyObject(oObject);
            }
        }
        oObject = GetNextObjectInArea(oArea);
    }
}

// For every PC and every member of the PCs party it will set oCreature to be friendly.
// * oCreature - Creature to be friends with
// Uses SetIsTemporaryFriend and ClearPoersonalReputation
void SetAllPlayerPartiesFriendlyTo(object oCreature)
{
    object oPC = GetFirstPC();
    while(GetIsObjectValid(oPC))
    {
        // No DMs
        if(!GetIsDM(oPC))
        {
            // Optimises it so that if they are the faction leader, we run a loop of their party,
            // else it will find them when we find their party leader.
            if(GetFactionLeader(oPC) == oPC)
            {
                SetPlayerPartyFriendlyTo(oPC, oCreature);
            }
        }
        oPC = GetNextPC();
    }
}

// For each member in oPC's party it will set them to be friendly to oCreature, including
// henchmen etc.
// * oPC - a member of the party (usually best being the party leader)
// * oCreature - Creature to be friends with
// Uses SetIsTemporaryFriend and ClearPoersonalReputation
void SetPlayerPartyFriendlyTo(object oPC, object oCreature)
{
    // For each member of the faction
    object oFactionMember = GetFirstFactionMember(oPC);
    while(GetIsObjectValid(oFactionMember))
    {
        // Set to be friendly, both ways
        ClearPersonalReputation(oFactionMember, oCreature);
        ClearPersonalReputation(oCreature, oFactionMember);
        SetIsTemporaryFriend(oFactionMember, oCreature, FALSE);
        SetIsTemporaryFriend(oCreature, oFactionMember, FALSE);

        oFactionMember = GetNextFactionMember(oPC);
    }
}
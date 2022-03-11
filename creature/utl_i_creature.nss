//::///////////////////////////////////////////////
//:: Utility Include: Creature
//:: utl_i_creature.nss
//:://////////////////////////////////////////////
/*
    A number of creature utility functions.

    Creature functions generally apply to players as well.
*/
//:://////////////////////////////////////////////
//:: Part of the nwscript_utility_scripts project; see for dates/creator info
//:: https://github.com/Finaldeath/nwscript_utility_scripts
//:://////////////////////////////////////////////

const int ENCUMBRANCE_LEVEL_NORMAL     = 0;
const int ENCUMBRANCE_LEVEL_HEAVY      = 1;
const int ENCUMBRANCE_LEVEL_OVERLOADED = 2;

// Returns the ENCUMBRANCE_LEVEL_* value related to how many items are on the creature
// * oCreature - Creature to check encumbrance of
// Return values:
//   ENCUMBRANCE_LEVEL_NORMAL - Can run normally
//   ENCUMBRANCE_LEVEL_HEAVY - Cannot run, only walk
//   ENCUMBRANCE_LEVEL_OVERLOADED - Can only walk at 50% speed
int GetEncumbranceLevel(object oCreature = OBJECT_SELF);

// Checks if a creature has a given domain.
// * oCreature - Creature to check
// * nDomain - DOMAIN_* constant or line from domains.2da
int GetHasDomain(object oCreature, int nDomain);

// Sets the creature event scripts to the given values
// * oCreature - A creature to set event scripts on
// * Script - The different script names (in toolset order). If blank the script will not be changed.
void SetCreatureEventScripts(object oCreature, string sBlock = "", string sDamage = "", string sDeath = "", string sConversation = "", string sDisturb = "", string sCombat = "", string sHeart = "", string sAttack = "", string sNotice = "", string sRest = "", string sSpawn = "", string sSpell = "", string sUser = "" );

// Creates a clone of oCreature (and returns it as an object for further usage, or OBJECT_INVALID if the copy didn't succeed.
// It sets the default AI and makes every item they have undroppable and cursed (so corpse cannot be looted)
// * oCreature - Creature to clone
// * lSpawn - Location to create the clone
// * nStandardFaction - A standard faction to change the creature to
// * bMakeEvil - Will adjust the alignment of the copy to be Chaotic Evil
object CreateDoppleganger(object oCreature, location lSpawn, int nStandardFaction = STANDARD_FACTION_HOSTILE, int bMakeEvil = TRUE);

// Calculates the number of steps along both moral and ethical axes that
// the two target's alignments' differ.
int CompareAlignment(object oSource, object oTarget);

// Checks for a creatures favored class, which should not get XP penalties.
// * oCreature - Creature to check
// - Returns CLASS_TYPE_INVALID if none are found or on error 
int GetFavoredClass(object oCreature);

// Checks if nClass is a prestige class for the purposes of XP / multiclassing and returns TRUE if so
int GetIsPrestigeClass(int nClass);

// Returns the CLASS_TYPE_* of the highest class oCreature has.
// Returns CLASS_TYPE_INVALID on error
int GetHighestLevelClass(object oCreature);


// Returns the ENCUMBRANCE_LEVEL_* value related to how many items are on the creature
// * oCreature - Creature to check encumbrance of
// Return values:
//   ENCUMBRANCE_LEVEL_NORMAL - Can run normally
//   ENCUMBRANCE_LEVEL_HEAVY - Cannot run, only walk
//   ENCUMBRANCE_LEVEL_OVERLOADED - Can only walk at 50% speed
int GetEncumbranceLevel(object oCreature = OBJECT_SELF)
{
    int nWeight = GetWeight(oCreature);
    int nStr = GetAbilityScore(oCreature, ABILITY_STRENGTH);

    // 2da limit is 100
    if(nStr > 100) return ENCUMBRANCE_LEVEL_NORMAL;

    int nEnc = StringToInt(Get2DAString("encumbrance", "Heavy", nStr));
    if(nWeight > nEnc) return ENCUMBRANCE_LEVEL_OVERLOADED;

    nEnc = StringToInt(Get2DAString("encumbrance", "Normal", nStr));
    if(nWeight > nEnc) return ENCUMBRANCE_LEVEL_HEAVY;

    return ENCUMBRANCE_LEVEL_NORMAL;
}

// Checks if a creature has a given domain.
// * oCreature - Creature to check
// * nDomain - DOMAIN_* constant or line from domains.2da
int GetHasDomain(object oCreature, int nDomain)
{
    int nPosition, nClass;
    for(nPosition = 1; nPosition <= 3; nPosition++)
    {
        nClass = GetClassByPosition(nPosition, oCreature);
        if(nClass == CLASS_TYPE_INVALID)
        {
            return FALSE;
        }
        // There are 2 potential domain slots
        if(GetDomain(oCreature, 1, nClass) == nDomain || GetDomain(oCreature, 2, nClass) == nDomain)
        {
            return TRUE;
        }
    }
    return FALSE;
}

// Sets the creature event scripts to the given values
// * oCreature - A creature to set event scripts on
// * Script - The different script names (in toolset order). If blank the script will not be changed. 
void SetCreatureEventScripts(object oCreature, string sBlock = "", string sDamage = "", string sDeath = "", string sConversation = "", string sDisturb = "", string sCombat = "", string sHeart = "", string sAttack = "", string sNotice = "", string sRest = "", string sSpawn = "", string sSpell = "", string sUser = "" )
{
    // Set the event scripts
    if (sBlock != "" ) SetEventScript(oCreature, EVENT_SCRIPT_CREATURE_ON_BLOCKED_BY_DOOR, sBlock);
    if (sDamage != "" ) SetEventScript(oCreature, EVENT_SCRIPT_CREATURE_ON_DAMAGED, sDamage);
    if (sDeath != "" ) SetEventScript(oCreature, EVENT_SCRIPT_CREATURE_ON_DEATH, sDeath);
    if (sConversation != "" ) SetEventScript(oCreature, EVENT_SCRIPT_CREATURE_ON_DIALOGUE, sConv);
    if (sDisturb != "" ) SetEventScript(oCreature, EVENT_SCRIPT_CREATURE_ON_DISTURBED, sDisturb);
    if (sCombat != "" ) SetEventScript(oCreature, EVENT_SCRIPT_CREATURE_ON_END_COMBATROUND, sCombat);
    if (sHeart != "" ) SetEventScript(oCreature, EVENT_SCRIPT_CREATURE_ON_HEARTBEAT, sHeart);
    if (sAttack != "" ) SetEventScript(oCreature, EVENT_SCRIPT_CREATURE_ON_MELEE_ATTACKED, sAttack);
    if (sNotice != "" ) SetEventScript(oCreature, EVENT_SCRIPT_CREATURE_ON_NOTICE, sNotice);
    if (sRest != "" ) SetEventScript(oCreature, EVENT_SCRIPT_CREATURE_ON_RESTED, sRest);
    if (sSpawn != "" ) SetEventScript(oCreature, EVENT_SCRIPT_CREATURE_ON_SPAWN_IN, sSpawn);
    if (sSpell != "" ) SetEventScript(oCreature, EVENT_SCRIPT_CREATURE_ON_SPELLCASTAT, sSpell);
    if (sUser != "" ) SetEventScript(oCreature, EVENT_SCRIPT_CREATURE_ON_USER_DEFINED_EVENT, sUser);
}

// Creates a clone of oCreature (and returns it as an object for further usage, or OBJECT_INVALID if the copy didn't succeed.
// It sets the default AI and makes every item they have undroppable and cursed (so corpse cannot be looted)
// * oCreature - Creature to clone
// * lSpawn - Location to create the clone
// * nStandardFaction - A standard faction to change the creature to
// * bMakeEvil - Will adjust the alignment of the copy to be Chaotic Evil
object CreateDoppleganger(object oCreature, location lSpawn, int nStandardFaction = STANDARD_FACTION_HOSTILE, int bMakeEvil = TRUE)
{
    object oClone = CopyObject(oCreature, lSpawn);

    // Will be a invalid copy if, for instance, the spawn location is invalid
    if(!GetIsObjectValid(oClone)) return OBJECT_INVALID;

    // Change the faction
    ChangeToStandardFaction(oClone, nStandardFaction);

    // Make the clone chaotic evil if required
    if(bMakeEvil)
    {
        AdjustAlignment(oClone, ALIGNMENT_EVIL, 100);
        AdjustAlignment(oClone, ALIGNMENT_CHAOTIC, 100);
    }

    // Set all the clones items to be undroppable so cannot be retrieved on death
    object oItem = GetFirstItemInInventory(oClone);
    while(GetIsObjectValid(oItem))
    {
        SetItemCursedFlag(oItem, TRUE);
        SetDroppableFlag(oItem, FALSE);
        oItem = GetNextItemInInventory(oClone);
    }
    // Sort inventory slots as well
    int i;
    for(i = 0; i < NUM_INVENTORY_SLOTS; i++)
    {
        oItem = GetItemInSlot(i, oClone);
        SetItemCursedFlag(oItem, TRUE);
        SetDroppableFlag(oItem, FALSE);
    }

    // Set the clone to use the XP2 AI
    SetCreatureEventScripts(oClone, "x2_def_onblocked",
                                    "x2_def_ondamage",
                                    "x2_def_ondeath",
                                    "x2_def_onconv",
                                    "x2_def_ondisturb",
                                    "x2_def_endcombat",
                                    "x2_def_heartbeat",
                                    "x2_def_attacked",
                                    "x2_def_percept",
                                    "x2_def_rested",
                                    "x2_def_spawn",
                                    "x2_def_spellcast",
                                    "x2_def_userdef");

    // We run the OnSpawn script on it - this won't do much if it has "doubled up" ie cloned an NPC
    // but helps PCs
    ExecuteScript("x2_def_spawn", oClone);

    // Return the clone for further changes in the script running it
    return oClone;
}

// Calculates the number of steps along both moral and ethical axes that
// the two target's alignments' differ.
int CompareAlignment(object oSource, object oTarget)
{
    int nStepDif;
    int nGE1 = GetAlignmentGoodEvil(oSource);
    int nLC1 = GetAlignmentLawChaos(oSource);
    int nGE2 = GetAlignmentGoodEvil(oTarget);
    int nLC2 = GetAlignmentLawChaos(oTarget);

    if(nGE1 == ALIGNMENT_GOOD)
    {
        if(nGE2 == ALIGNMENT_NEUTRAL)
            nStepDif += 1;
        else if(nGE2 == ALIGNMENT_EVIL)
            nStepDif += 2;
    }
    else if(nGE1 == ALIGNMENT_NEUTRAL)
    {
        if(nGE2 != ALIGNMENT_NEUTRAL)
            nStepDif += 1;
    }
    else if(nGE1 == ALIGNMENT_EVIL)
    {
        if(nLC2 == ALIGNMENT_NEUTRAL)
            nStepDif += 1;
        else if(nLC2 == ALIGNMENT_GOOD)
            nStepDif += 2;
    }
    if(nLC1 == ALIGNMENT_LAWFUL)
    {
        if(nLC2 == ALIGNMENT_NEUTRAL)
            nStepDif += 1;
        else if(nLC2 == ALIGNMENT_CHAOTIC)
            nStepDif += 2;
    }
    else if(nLC1 == ALIGNMENT_NEUTRAL)
    {
        if(nLC2 != ALIGNMENT_NEUTRAL)
            nStepDif += 1;
    }
    else if(nLC1 == ALIGNMENT_CHAOTIC)
    {
        if(nLC2 == ALIGNMENT_NEUTRAL)
            nStepDif += 1;
        else if(nLC2 == ALIGNMENT_LAWFUL)
            niStepDif += 2;
    }
    return nStepDif;
}

// Checks for a creatures favored class, which should not get XP penalties.
// * oCreature - Creature to check
// - Returns CLASS_TYPE_INVALID if none are found or on error 
int GetFavoredClass(object oCreature)
{
    string sFavored = Get2DAString("racialtypes", "Favored", GetRacialType(oCreature));
    if(sFavored == "") return CLASS_TYPE_INVALID;
    
    return StringToInt(sFavored);
}

// Checks if nClass is a prestige class for the purposes of XP / multiclassing and returns TRUE if so
int GetIsPrestigeClass(int nClass)
{
    if(Get2DAString("classes", "XPPenalty", nClass) == "1") return TRUE;
    // Invalid 2da entry or error
    return FALSE;
}

// Returns the CLASS_TYPE_* of the highest class oCreature has.
// Returns CLASS_TYPE_INVALID on error
int GetHighestLevelClass(object oCreature)
{
    int nSlot, nClass, nLevel, nHighest;
    int nHighestClass = CLASS_TYPE_INVALID;
    for(nSlot = 1; nSlot <= 3; nSlot++)
    {
        nClass = GetClassByPosition(nSlot, oCreature);
        nLevel = GetLevelByClass(nClass, oCreature);
        if(nLevel > nHighest)
        {
            nHighest = nLevel;
            nHighestClass = nClass;
        }
    }
    return nHighestClass;
}
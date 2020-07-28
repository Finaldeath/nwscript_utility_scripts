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

const int ENCUMBERANCE_LEVEL_NORMAL     = 0;
const int ENCUMBERANCE_LEVEL_HEAVY      = 1;
const int ENCUMBERANCE_LEVEL_OVERLOADED = 2;

// Returns the ENCUMBERANCE_LEVEL_* value related to how many items are on the creature
// * oCreature - Creature to check encumerance of
int GetEncumberanceLevel(object oCreature = OBJECT_SELF);



// Returns the ENCUMBERANCE_LEVEL_* value related to how many items are on the creature
// * oCreature - Creature to check encumerance of
int GetEncumberanceLevel(object oCreature = OBJECT_SELF)
{
    int nWeight = GetWeight(oCreature);
    int nStr = GetAbilityScore(oCreature, ABILITY_STRENGTH);

    int nEnc = StringToInt(Get2DAString("encumbrance", "Heavy", nStr));
    if(nWeight > nEnc) return ENCUMBERANCE_LEVEL_OVERLOADED;

    nEnc = StringToInt(Get2DAString("encumbrance", "Normal", nStr));
    if(nWeight > nEnc) return ENCUMBERANCE_LEVEL_HEAVY;

    return ENCUMBERANCE_LEVEL_NORMAL;
}
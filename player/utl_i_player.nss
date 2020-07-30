//::///////////////////////////////////////////////
//:: Utility Include: Player
//:: utl_i_player.nss
//:://////////////////////////////////////////////
/*
    A number of player-only utility functions. Players are a special kind
    of creature object and have a number of things that only work on them (such
    as experience)
*/
//:://////////////////////////////////////////////
//:: Part of the nwscript_utility_scripts project; see for dates/creator info
//:: https://github.com/Finaldeath/nwscript_utility_scripts
//:://////////////////////////////////////////////

// Send a message to all PCs in the game
// * sMessage - Message to send
void SendMessageToAllPCs(string sMessage);

// Returns the level that can be obtained if at a particular experience level
// EG: 45,000 returns 10, since you can be level 10 with 45,000 XP
// * nXP - The XP to check
int GetLevelByXP(int nXP);

// Returns the XP required for a particular level to be obtained
// EG: Level 10 requires 45,000 XP
// * nLevel - Level to check
int GetXPByLevel(int nLevel);

// This returns a PCs true level, since they may not be levelled up fully.
// If used on an NPC returns their hit dice.
// * oCreature - Creature (usually PC) to check
int GetTrueLevel(object oCreature);

// Checks if this is a PC object. Works even if the object is logging out.
// * oObject - Object to check
int GetIsPCObject(object oObject);



// Send a message to all PCs in the game
// * sMessage - Message to send
void SendMessageToAllPCs(string sMessage)
{
    object oPC = GetFirstPC();
    while(GetIsObjectValid(oPC))
    {
        SendMessageToPC(oPC, sMessage);
        oPC = GetNextPC();
    }
}

// Returns the level that can be obtained if at a particular experience level
// EG: 45,000 returns 10, since you can be level 10 with 45,000 XP
// * nXP - The XP to check
int GetLevelByXP(int nXP)
{
    float fXP    = IntToFloat(nXP) / 1000;
    float fLevel = (sqrt(8 * fXP + 1) + 1) / 2;
    int   nLevel = FloatToInt(fLevel);
    return nLevel;
}

// Returns the XP required for a particular level to be obtained
// EG: Level 10 requires 45,000 XP
// * nLevel - Level to check
int GetXPByLevel(int nLevel)
{
    int nXP = (((nLevel - 1)*nLevel)/2)*1000;
    return nXP;
}

// This returns a PCs true level, since they may not be levelled up fully.
// If used on an NPC returns their hit dice.
// * oCreature - Creature (usually PC) to check
int GetTrueLevel(object oCreature)
{
    int nXP = GetXP(oCreature);

    if(nXP == 0) return GetHitDice(oCreature);

    return GetLevelByXP(nXP);
}

// Checks if this is a PC object. Works even if the object is logging out.
// * oObject - Object to check
int GetIsPCObject(object oObject)
{
	// Object identifiers are 32bit numbers, if converted using ObjectToString().
	// PCs count down from 7fffffff and all other objects count up from 00000000.
	// PC objects will start with "7ff" and be 8 characters long.
    string sCreature = ObjectToString(oObject);
    if(GetStringLength(sCreature) == 8 &&
       GetStringLeft(sCreature, 3) == "7ff")
    {
        return TRUE;
    }
    return FALSE;
}
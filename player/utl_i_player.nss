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

// Returns the level that can be obtained if at a particular experience level using exptable.
// EG: by default 45,000 returns 10, since you can be level 10 with 45,000 XP
// * nXP - The amount of XP to check
int GetLevelObtainableAtExperience(int nXP);

// Returns the XP required for a particular level to be obtained
// EG: Level 10 requires 45,000 XP
// * nLevel - Level to check
int GetExperienceRequiredForLevel(int nLevel);

// Returns the experience required to gain on nCurrentLevel to level-up
// * nCurrentLevel - Level to check
int GetExperienceToNextLevel(int nCurrentLevel);

// This returns a PCs true level, since they may not be levelled up fully.
// If used on an NPC returns their hit dice.
// * oCreature - Creature (usually PC) to check
int GetTrueLevel(object oCreature);

// Checks if this is a PC object. Works even if the object is logging out.
// * oObject - Object to check
int GetIsPCObject(object oObject);

// Checks if any player is in the given area.
// * oArea - Area to check, default: OBJECT_SELF useful if run on an area event script
int GetAnyPCInArea(object oArea = OBJECT_SELF);

// This will identify the items in the PCs inventory using their own lore value.
// * oPC - PC to identify items on
void IdentifyPCInventoryUsingLore(object oPC = OBJECT_SELF);



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

// Returns the level that can be obtained if at a particular experience level using exptable.
// EG: by default 45,000 returns 10, since you can be level 10 with 45,000 XP
// * nXP - The amount of XP to check
int GetLevelObtainableAtExperience(int nXP)
{
    int i, nXPAtLevel;
    string sEntry;
    for (i = 0; i < 40; i++)
    {
        sEntry = Get2DAString("exptable", "XP", i);
        nXPAtLevel = StringToInt(sEntry);
        if(nXPAtLevel > nXP)
            return StringToInt(Get2DAString("exptable", "Level", i-1));
    }
    return 0;
}

// Returns the XP required for a particular level to be obtained
// EG: Level 10 requires 45,000 XP
// * nLevel - Level to check
int GetExperienceRequiredForLevel(int nLevel)
{
    if(nLevel <= 1) return 0;
    if(nLevel > 40) nLevel = 40;
    int row = nLevel - 1;
    string entry = Get2DAString("exptable", "XP", row);
    return StringToInt(entry);
}

// Returns the experience required to gain on nCurrentLevel to level-up
// * nCurrentLevel - Level to check
int GetExperienceToNextLevel(int nCurrentLevel)
{
    int nCurrent = GetExperienceRequiredForLevel(nCurrentLevel);
    int nNext = GetExperienceRequiredForLevel(nCurrentLevel+1);
    return (nNext - nCurrent);
}

// This returns a PCs true level, since they may not be levelled up fully.
// If used on an NPC returns their hit dice.
// * oCreature - Creature (usually PC) to check
int GetTrueLevel(object oCreature)
{
    int nXP = GetXP(oCreature);

    if(nXP == 0) return GetHitDice(oCreature);

    return GetLevelObtainableAtExperience(nXP);
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

// Checks if any player is in the given area.
// * oArea - Area to check, default: OBJECT_SELF useful if run on an area event script
int GetAnyPCInArea(object oArea = OBJECT_SELF)
{
    object oPC = GetFirstPC();
    while(GetIsObjectValid(oPC))
    {
        if(GetArea(oPC) == oArea)
        {
            return TRUE;
        }
        oPC = GetNextPC();
    }
    return FALSE;
}

// This will identify the items in the PCs inventory using their own lore value.
// * oPC - PC to identify items on
void IdentifyPCInventoryUsingLore(object oPC = OBJECT_SELF)
{
    int nGP;
    string sMax = Get2DAString("SkillVsItemCost", "DeviceCostMax", GetSkillRank(SKILL_LORE, oPC));
    int nMax = StringToInt(sMax);
    if (sMax == "") nMax = 120000000;
    object oItem = GetFirstItemInInventory(oPC);
    while(GetIsObjectValid(oItem))
    {
        if(!GetIdentified(oItem))
        {
            // Check for the value of the item first.
            SetIdentified(oItem, TRUE);
            nGP = GetGoldPieceValue(oItem);
            // If oPC has enough Lore skill to ID the item, then do so.
            if(nMax >= nGP)
                SendMessageToPC(oPC, "Item identified: " + GetName(oItem));
            else
                SetIdentified(oItem, FALSE);
        }
        oItem = GetNextItemInInventory(oPC);
    }
}
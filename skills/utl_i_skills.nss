//::///////////////////////////////////////////////
//:: Utility Include: Skills
//:: utl_i_skills.nss
//:://////////////////////////////////////////////
/*
    This contains functions to deal with skill checks, appriase and stores and
    other skill based functions.

    It replicates the Bioware method of appraise and adds additional documentation.
*/
//:://////////////////////////////////////////////
//:: Part of the nwscript_utility_scripts project; see for dates/creator info
//:: https://github.com/Finaldeath/nwscript_utility_scripts
//:://////////////////////////////////////////////

// Returns a value that will be subtracted from the oTarget's DC to resist Appraise or Persuasion
// - Charm returns 10
// - Dominate retturns 20
// Updated from Bioware's, this now checks the effects they are under are from someone in the
// same faction as oPC
int GetNPCEasyMark(object oNPC, object oPC);

// Opens a given store with Bioware's version of appraise checks
// Checks are Appraise Skill Rank + d10() vs. OBJECT_SELF skill rank + d10.
// Additional modifier if the NPC is an "Easy Mark"
// * oStore - Store to open
// * oPC - PC opening the store. The object opening the store (ie the storeowner) stores
//         the last rank of appraise so it cannot be repeated.
// * nBonusMarkUp/nBonusMarkDown - Base bonus mark up and down on the store.
void AppraiseOpenStore(object oStore, object oPC, int nBonusMarkUp = 0, int nBonusMarkDown = 0);

// As AppraiseOpenStore except the check is PCs Appraise Skill Rank + d10() vs. 0 so it should always be positive.
void AppraiseOpenStoreFavourable(object oStore, object oPC, int nBonusMarkUp = 0, int nBonusMarkDown = 0);

// Opens a given store with Bioware's version of appraise checks
// Checks are Appraise Skill Rank + d10() vs. OBJECT_SELF skill rank + d10.
// Additional modifier if the NPC is an "Easy Mark"
// * oStore - Store to open
// * oPC - PC opening the store. The object opening the store (ie the storeowner) stores
//         the last rank of appraise so it cannot be repeated.
// * nBonusMarkUp/nBonusMarkDown - Base bonus mark up and down on the store.
void AppraiseOpenStore(object oStore, object oPC, int nBonusMarkUp = 0, int nBonusMarkDown = 0)
{
    string sTag          = ObjectToString(OBJECT_SELF);
    int nPlayerSkillRank = GetSkillRank(SKILL_APPRAISE, oPC);
    int nNPCSkillRank    = GetSkillRank(SKILL_APPRAISE, OBJECT_SELF) - GetNPCEasyMark(OBJECT_SELF, oPC);
    if (nNPCSkillRank < 1) nNPCSkillRank = 1;

    int nAdjust       = 0;
    int nPreviousRank = GetLocalInt(oPC, "X0_APPRAISERANK" + sTag);

    /*
        An opposed skill check (a d10 roll instead). Your appraise skill versus the shopkeepers appraise skill.

        Possible Results:

        Percentage Rebate/Penalty: The 'difference'

        Feedback: [Appraise Skill]: Merchant's reaction is unfavorable.
                    [Appraise Skill]: Merchant's reaction is neutral.
                    [Appraise Skill]: Merchant's reaction is favorable.

        Additional: Remember last reaction for this particular skill.
        When the player gets a new skill rank in this skill they'll get a
        reroll against this merchant.
    */

    // If the player's rank has improved, let them have another appraise check against this merchant
    if ((nPlayerSkillRank > nPreviousRank) || !GetLocalInt(oPC, "X0_APPRAISEVISITED" + sTag))
    {
        SetLocalInt(oPC, "X0_APPRAISERANK" + sTag, nPlayerSkillRank);
        SetLocalInt(oPC, "X0_APPRAISEVISITED" + sTag, TRUE);

        nPlayerSkillRank += d10();
        nNPCSkillRank += d10();
        nAdjust = nNPCSkillRank - nPlayerSkillRank;
    }
    else
    {
        // Recover last reaction
        nAdjust = GetLocalInt(oPC, "X0_APPRAISEADJUST" + sTag);
    }
    if (nNPCSkillRank > nPlayerSkillRank)
    {
        FloatingTextStrRefOnCreature(8963, oPC, FALSE);
    }
    else if (nNPCSkillRank < nPlayerSkillRank)
    {
        FloatingTextStrRefOnCreature(8965, oPC, FALSE);
    }
    else
    {
        FloatingTextStrRefOnCreature(8964, oPC, FALSE);
    }

    SetLocalInt(oPC, "X0_APPRAISEADJUST" + sTag, nAdjust);

    // Hard cap of 30% max up or down
    if (nAdjust > 30) nAdjust = 30;
    if (nAdjust < -30) nAdjust = -30;
    nBonusMarkUp   = nBonusMarkUp + nAdjust;
    nBonusMarkDown = nBonusMarkDown - nAdjust;

    OpenStore(oStore, oPC, nBonusMarkUp, nBonusMarkDown);
}

// As AppraiseOpenStore except the check is PCs Appraise Skill Rank + d10() vs. 0 so it should always be positive.
void AppraiseOpenStoreFavourable(object oStore, object oPC, int nBonusMarkUp = 0, int nBonusMarkDown = 0)
{
    string sTag          = ObjectToString(OBJECT_SELF);
    int nPlayerSkillRank = GetSkillRank(SKILL_APPRAISE, oPC);
    int nNPCSkillRank    = 0;

    int nAdjust       = 0;
    int nPreviousRank = GetLocalInt(oPC, "X0_APPRAISERANK" + sTag);

    // If the player's rank has improved, let them have another appraise check against this merchant
    if ((nPlayerSkillRank > nPreviousRank) || !GetLocalInt(oPC, "X0_APPRAISEVISITED" + sTag))
    {
        SetLocalInt(oPC, "X0_APPRAISERANK" + sTag, nPlayerSkillRank);
        SetLocalInt(oPC, "X0_APPRAISEVISITED" + sTag, TRUE);

        nPlayerSkillRank += d10();
        nAdjust = nNPCSkillRank - nPlayerSkillRank;
    }
    else
    {
        // Recover last reaction
        nAdjust = GetLocalInt(oPC, "X0_APPRAISEADJUST" + sTag);
    }
    FloatingTextStrRefOnCreature(8965, oPC, FALSE);
    SetLocalInt(oPC, "X0_APPRAISEADJUST" + sTag, nAdjust);

    // Hard cap of 30% max up or down
    if (nAdjust > 30) nAdjust = 30;
    if (nAdjust < -30) nAdjust = -30;
    nBonusMarkUp   = nBonusMarkUp + nAdjust;
    nBonusMarkDown = nBonusMarkDown - nAdjust;

    OpenStore(oStore, oPC, nBonusMarkUp, nBonusMarkDown);
}

// Returns a value that will be subtracted from the oTarget's DC to resist Appraise or Persuasion
// - Charm returns 10
// - Dominate retturns 20
// Updated from Bioware's, this now checks the effects they are under are from someone in the
// same faction as oPC
int GetNPCEasyMark(object oNPC, object oPC)
{
    int nCharmMod = 0;
    effect eCheck = GetFirstEffect(oNPC);
    while (GetIsEffectValid(eCheck))
    {
        if (GetFactionEqual(oPC, GetEffectCreator(eCheck)))
        {
            switch (GetEffectType(eCheck))
            {
                case EFFECT_TYPE_CHARMED:
                {
                    if (nCharmMod < 10) nCharmMod = 10;
                }
                break;
                case EFFECT_TYPE_DOMINATED:
                case EFFECT_TYPE_CUTSCENE_DOMINATED:
                {
                    if (nCharmMod < 20) nCharmMod = 20;
                }
                break;
            }
        }
        eCheck = GetNextEffect(oNPC);
    }
    return nCharmMod;
}

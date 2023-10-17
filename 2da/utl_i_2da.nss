//::///////////////////////////////////////////////
//:: Utility Include: 2da
//:: utl_i_2da.nss
//:://////////////////////////////////////////////
/*
    A number of utility functions for 2das.
*/
//:://////////////////////////////////////////////
//:: Part of the nwscript_utility_scripts project; see for dates/creator info
//:: https://github.com/Finaldeath/nwscript_utility_scripts
//:://////////////////////////////////////////////

const string RULESET_2DA       = "ruleset";
const string CACHED_2DA_PREFIX = "CACHED";

// Caches all ruleset.2da entries onto the module as local variables, both
// as float and integers. Strings and blanks are ignored.
void CacheRuleset2da();

// Gets a integer ruleset.2da entry from the cache (generate cache if not present)
int GetRulesetInt(string sEntry, int nDefault = 0);

// Gets a float ruleset.2da entry from the cache (generate cache if not present)
float GetRulesetFloat(string sEntry, float fDefault = 0.0);

// Caches all ruleset.2da entries onto the module as local variables, both
// as float and integers. Strings and blanks are ignored.
void CacheRuleset2da()
{
    int nRow;
    object oModule = GetModule();
    for (nRow = 0; nRow <= Get2DARowCount(RULESET_2DA); nRow++)
    {
        string sLabel = Get2DAString(RULESET_2DA, "Label", nRow);

        if (sLabel != "")
        {
            string sEntry = Get2DAString(RULESET_2DA, "Value", nRow);

            if (sEntry != "")
            {
                int nValue = StringToInt(sEntry);
                if (nValue != 0) SetLocalInt(oModule, RULESET_2DA + sLabel, nValue);
                float fValue = StringToFloat(sEntry);
                if (fValue != 0.0) SetLocalFloat(oModule, RULESET_2DA + sLabel, fValue);
            }
        }
    }
    // Set we've cached this 2da
    SetLocalInt(oModule, CACHED_2DA_PREFIX + RULESET_2DA, TRUE);
}

// Gets a integer ruleset.2da entry from the cache (generate cache if not present)
int GetRulesetInt(string sEntry, int nDefault = 0)
{
    if (!GetLocalInt(GetModule(), CACHED_2DA_PREFIX + RULESET_2DA)) CacheRuleset2da();

    int nReturn = GetLocalInt(GetModule(), RULESET_2DA + sEntry);

    if (nReturn == 0) return nDefault;

    return nReturn;
}

// Gets a float ruleset.2da entry from the cache (generate cache if not present)
float GetRulesetFloat(string sEntry, float fDefault = 0.0)
{
    if (!GetLocalInt(GetModule(), CACHED_2DA_PREFIX + RULESET_2DA)) CacheRuleset2da();

    float fReturn = GetLocalFloat(GetModule(), RULESET_2DA + sEntry);

    if (fReturn == 0.0) return fDefault;

    return fReturn;
}

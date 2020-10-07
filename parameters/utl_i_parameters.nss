//::///////////////////////////////////////////////
//:: Utility Include: Parameters
//:: utl_i_parameters.nss
//:://////////////////////////////////////////////
/*
    These are helper functions for the NWN:EE Script Parameter
    functions SetScriptParam and GetScriptParam.

    Example:

// Conversation action script to apply a permanent effect to the given ability score by the given amount
void main()
{
    string sAbilityScore = GetScriptParam("ABILITY");
    int nAbility = ConstantStringToInt(sAbilityScore, -1);
    // Error checking
    if(nAbility == -1)
    {
        SpeakString("Error, invalid ability score:" + sAbilityScore);
        return;
    }
    int nAmount = StringToInt(GetScriptParam("AMOUNT"));
    if(nAmount < 0 || nAmount > 10)
    {
        SpeakString("Error, invalid ability score amount:" + IntToString(nAmount));
        return;
    }
    // Apply effect
    effect eEffect = EffectAbilityIncrease(nAbility, nAmount);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, GetPCSpeaker());
}
*/
//:://////////////////////////////////////////////
//:: Part of the nwscript_utility_scripts project; see for dates/creator info
//:: https://github.com/Finaldeath/nwscript_utility_scripts
//:://////////////////////////////////////////////

// This function will convert a string of a constant name into an integer.
// Only constants in nwscript.nss will be returned.
// Example: "ABILITY_INTELLIGENCE" will get converted to the integer 3
// Use this to convert script params into usable values.
// * sConstantName - The name of a constant to convert 
// * nErrorValue - The value to return if the constant isn't found. Default: 0
int ConstantStringToInt(string sConstantName, int nErrorValue = 0);

// This function will convert a string of a constant name into an float.
// Only constants in nwscript.nss will be returned.
// Example: "RADIUS_SIZE_SMALL" will get converted to the float 1.67
// Use this to convert script params into usable values.
// * sConstantName - The name of a constant to convert 
// * nErrorValue - The value to return if the constant isn't found. Default: 0.0
float ConstantStringToFloat(string sConstantName, float fErrorValue = 0.0);

// This function will convert a string of a constant name into a string.
// Only constants in nwscript.nss will be returned.
// Example: "TILESET_RESREF_BEHOLDER_CAVES" will get converted to the string "tib01"
// Use this to convert script params into usable values.
// * sConstantName - The name of a constant to convert 
// * sErrorValue - The value to return if the constant isn't found. Default: ""
string ConstantStringToString(string sConstantName, string sErrorValue = "");


// This function will convert a string of a constant name into an integer.
// Only constants in nwscript.nss will be returned.
// Example: "ABILITY_INTELLIGENCE" will get converted to the integer 3
// Use this to convert script params into usable values.
// * sConstantName - The name of a constant to convert 
// * nErrorValue - The value to return if the constant isn't found. Default: 0
int ConstantStringToInt(string sConstantName, int nErrorValue = 0)
{
    // This is the error return value being set in case ExecuteScriptChunk fails.
    SetLocalInt(GetModule(), "CONVERTED_SCRIPT_PARAM", nErrorValue);
    // From the example this does SetLocalInt(GetModule(), "CONVERTED_SCRIPT_PARAM", ABILITY_INTELLIGENCE);
    ExecuteScriptChunk("SetLocalInt(GetModule(), \"CONVERTED_SCRIPT_PARAM\", " + sConstantName + "));", GetModule());
    // Returns the value set, or nErrorValue if none was set
    return GetLocalInt(GetModule(), "CONVERTED_SCRIPT_PARAM");
}

// This function will convert a string of a constant name into an float.
// Only constants in nwscript.nss will be returned.
// Example: "RADIUS_SIZE_SMALL" will get converted to the float 1.67
// Use this to convert script params into usable values.
// * sConstantName - The name of a constant to convert 
// * fErrorValue - The value to return if the constant isn't found. Default: 0.0
float ConstantStringToFloat(string sConstantName, float fErrorValue = 0.0)
{
    // This is the error return value being set in case ExecuteScriptChunk fails.
    SetLocalFloat(GetModule(), "CONVERTED_SCRIPT_PARAM", fErrorValue);
    // From the example this does SetLocalFloat(GetModule(), "CONVERTED_SCRIPT_PARAM", RADIUS_SIZE_SMALL);
    ExecuteScriptChunk("SetLocalFloat(GetModule(), \"CONVERTED_SCRIPT_PARAM\", " + sConstantName + "));", GetModule());
    // Returns the value set, or fErrorValue if none was set
    return GetLocalFloat(GetModule(), "CONVERTED_SCRIPT_PARAM");
}

// This function will convert a string of a constant name into a string.
// Only constants in nwscript.nss will be returned.
// Example: "TILESET_RESREF_BEHOLDER_CAVES" will get converted to the string "tib01"
// Use this to convert script params into usable values.
// * sConstantName - The name of a constant to convert 
// * sErrorValue - The value to return if the constant isn't found. Default: ""
string ConstantStringToString(string sConstantName, string sErrorValue = "")
{
    // This is the error return value being set in case ExecuteScriptChunk fails.
    SetLocalString(GetModule(), "CONVERTED_SCRIPT_PARAM", sErrorValue);
    // From the example this does SetLocalString(GetModule(), "CONVERTED_SCRIPT_PARAM", TILESET_RESREF_BEHOLDER_CAVES);
    ExecuteScriptChunk("SetLocalString(GetModule(), \"CONVERTED_SCRIPT_PARAM\", " + sConstantName + "));", GetModule());
    // Returns the value set, or sErrorValue if none was set
    return GetLocalString(GetModule(), "CONVERTED_SCRIPT_PARAM");
}
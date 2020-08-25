//::///////////////////////////////////////////////
//:: Utility Include: Effects
//:: utl_i_effects.nss
//:://////////////////////////////////////////////
/*
    Utility functions for effects.
*/
//:://////////////////////////////////////////////
//:: Part of the nwscript_utility_scripts project; see for dates/creator info
//:: https://github.com/Finaldeath/nwscript_utility_scripts
//:://////////////////////////////////////////////

// Returns TRUE if oObject has effects tagged with sTag
// * oObject - Object to check
// * sTag - Tag to check for
int GetHasTaggedEffect(object oObject, string sTag);

// Remove all effects with the matching tag
// * oObject - The object to remove effects from
// * sTag - The tag 
void RemoveTaggedEffects(object oObject, string sTag);

// Applies an effect to an object with a required tag and an optional subtype 
/// A convenient wrapper to for applying all modifications an effect at once
// * nDurationType: A DURATION_TYPE_* constant.
// * eEffect: The effect to apply.
// * sEffectTag: The tag name of the effect.
// * oTarget: The target of the effect.
// * fDuration: The duration of temporary effects. (Default: 0.0f)
// * nSubType: Sets the effect as magical or non-magical that can or cannot be removed by certain ingame spells or events. (Default: SUBTYPE_MAGICAL)
// If the value is an invalid subtype it will change it to SUBTYPE_MAGICAL and log an error
void ApplyTaggedEffectToObject(int nDurationType, effect Effect, object oTarget, string sEffectTag, float fDuration = 0.0, int nSubType = SUBTYPE_MAGICAL);


// Returns TRUE if oObject has effects tagged with sTag
// * oObject - Object to check
// * sTag - Tag to check for
int GetHasTaggedEffect(object oObject, string sTag)
{
    effect eEffect = GetFirstEffect(oObject);
    while (GetIsEffectValid(eEffect))
    {
        if (GetEffectTag(eEffect) == sTag)
            return TRUE;

        eEffect = GetNextEffect(oObject);
    }
    return FALSE;
}

// Remove all effects with the matching tag
// * oObject - The object to remove effects from
// * sTag - The tag 
void RemoveTaggedEffects(object oObject, string sTag)
{
    effect eEffect = GetFirstEffect(oObject);
    while (GetIsEffectValid(eEffect))
    {
        if (GetEffectTag(eEffect) == sTag)
            RemoveEffect(oObject, eEffect);

        eEffect = GetNextEffect(oObject);
    }
}

// Applies an effect to an object with a required tag and an optional subtype 
/// A convenient wrapper to for applying all modifications an effect at once
// * nDurationType: A DURATION_TYPE_* constant.
// * eEffect: The effect to apply.
// * sEffectTag: The tag name of the effect.
// * oTarget: The target of the effect.
// * fDuration: The duration of temporary effects. (Default: 0.0f)
// * nSubType: Sets the effect as magical or non-magical that can or cannot be removed by certain ingame spells or events. (Default: SUBTYPE_MAGICAL)
// If the value is an invalid subtype it will change it to SUBTYPE_MAGICAL and log an error
void ApplyTaggedEffectToObject(int nDurationType, effect eEffect, object oTarget, string sEffectTag, float fDuration = 0.0, int nSubType = SUBTYPE_MAGICAL)
{    
    eEffect = TagEffect(eEffect, sEffectTag);
    
    // log nSubType value problem if necessary
    if(nSubType != SUBTYPE_EXTRAORDINARY && nSubType != SUBTYPE_MAGICAL && nSubType != SUBTYPE_SUPERNATURAL)
    {
        string sInvalidSub = IntToString(nSubType);
        string sLog = "ApplyTaggedEffectToObject was given invalid subtype " + sInvalidSub + " as a parameter";
        WriteTimestampedLogEntry(sLog);  
    }
    
    // Assign Subtype otherwise defaults to Subtype Magic
    if(nSubType == SUBTYPE_EXTRAORDINARY)
    {
        eEffect = ExtraordinaryEffect(eEffect);        
    }
    else if(nSubType == SUBTYPE_SUPERNATURAL)
    {
        eEffect = SupernaturalEffect(eEffect);    
    {
    else
    {
        eEffect = MagicalEffect(eEffect);
    }
    
    ApplyEffectToObject(nDurationType, eEffect, oTarget, fDuration); 
}
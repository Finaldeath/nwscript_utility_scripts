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
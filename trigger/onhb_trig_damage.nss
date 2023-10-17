//::///////////////////////////////////////////////
//:: Utility File: On Heartbeat for Damage
//:: onhb_trig_damage.nss
//:://////////////////////////////////////////////
/*
    Example of how to use an efficient trigger to do damage to all creatures within it.

    This script should not be assigned to the trigger. The trigger script "onen_trig_damage"
    will set this to run on the heartbeat and remove it automatically.

    Based on scripts by Sacha.
*/
//:://////////////////////////////////////////////
//:: Part of the nwscript_utility_scripts project; see for dates/creator info
//:: https://github.com/Finaldeath/nwscript_utility_scripts
//:://////////////////////////////////////////////

void main()
{
    // Check for any object left in the trigger area, if not we exit.
    object oCreature = GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
    if (!GetIsObjectValid(oCreature))
    {
        SetEventScript(OBJECT_SELF, EVENT_SCRIPT_TRIGGER_ON_HEARTBEAT, "");
        return;
    }
    // For consistency with the On Enter script we do this damage for PCs and associates only
    while (GetIsObjectValid(oCreature))
    {
        if (GetIsPC(oCreature) || GetIsPC(GetMaster(oCreature)))
        {
            // Fortitude saving throw, DC 15, versus Traps
            if (!FortitudeSave(oCreature, 15, SAVING_THROW_TYPE_TRAP))
            {
                // Apply 2d6 acid damage and an effect
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_ACID_S), oCreature);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(2), DAMAGE_TYPE_ACID), oCreature);
            }
        }
        oCreature = GetNextInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
    }
}

//::///////////////////////////////////////////////
//:: Utility File: On Enter for Damage
//:: onen_trig_damage.nss
//:://////////////////////////////////////////////
/*
    Example of how to use an efficient trigger to do damage to all creatures within it.

    This should be added to the On Enter script with *no* script present in the On Heartbeat.

    Once it detects a PC entering it, the trigger turns on (ala a trap) and damages them, then
    enables the heartbeat to damage anyone else staying in the area.

    Note the reason for damaging those entering as well as heartbeat is it is very easy in NWN
    to run over an entire trigger area before the heartbeat (which can get delayed) even runs
    once.

    Provided by Sacha.
*/
//:://////////////////////////////////////////////
//:: Part of the nwscript_utility_scripts project; see for dates/creator info
//:: https://github.com/Finaldeath/nwscript_utility_scripts
//:://////////////////////////////////////////////

void main()
{
    // Example on how to damage the person entering if PC or associate
    object oEnterer = GetEnteringObject();

    // Stop if not a PC or associate of a PC
    if (!GetIsPC(oEnterer) && !GetIsPC(GetMaster(oEnterer))) return;

    // Check event script is set and set it if not.
    if (GetEventScript(OBJECT_SELF, EVENT_SCRIPT_TRIGGER_ON_HEARTBEAT) != "")
    {
        SetEventScript(OBJECT_SELF, EVENT_SCRIPT_TRIGGER_ON_HEARTBEAT, "onhb_trig_damage");
    }

    // Fortitude saving throw, DC 15, versus Traps
    if (!FortitudeSave(oEnterer, 15, SAVING_THROW_TYPE_TRAP))
    {
        // Apply 2d6 acid damage and an effect
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_ACID_S), oEnterer);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(2), DAMAGE_TYPE_ACID), oEnterer);
    }
}

//::///////////////////////////////////////////////
//:: On Heartbeat: Permanent VFX
//:: onhb_permvfx.nss
//:://////////////////////////////////////////////
/*
    This single-firing heartbeat script will apply the vfx (visualeffects.2da) line stored on the placeable
    under the local named "vfx" permanently as a supernatural effect.

    Afterwards it wipes the heartbeat event so it only fires once, acting similarly to a "On Spawn" script
    but suitable for a placeable or door.

    Originally written by clippy.
*/
//:://////////////////////////////////////////////
//:: Part of the nwscript_utility_scripts project; see for dates/creator info
//:: https://github.com/Finaldeath/nwscript_utility_scripts
//:://////////////////////////////////////////////

void main()
{
    int vfx = GetLocalInt(OBJECT_SELF, "vfx");
    if (vfx)
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectVisualEffect(vfx)), OBJECT_SELF);
    SetEventScript(OBJECT_SELF, EVENT_SCRIPT_PLACEABLE_ON_HEARTBEAT, "");
}

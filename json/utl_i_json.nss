//::///////////////////////////////////////////////
//:: Utility Include: JSON
//:: utl_i_json.nss
//:://////////////////////////////////////////////
/*
    The JSON functions included in version 1.85.8193.30 allow reading of more object data than previous. This
    include will include some helper functions for this.

    It also can technically set data, but mostly this is converting to JSON then recreating the object, thus
    it is not a real "Set" since the object is duplicated.
*/
//:://////////////////////////////////////////////
//:: Part of the nwscript_utility_scripts project; see for dates/creator info
//:: https://github.com/Finaldeath/nwscript_utility_scripts
//:://////////////////////////////////////////////


// Retrieves the soundset.2da line used for oCreature, or -1 on error.
int GetCreatureSoundset(object oCreature)
{
    if(GetObjectType(oCreature) != OBJECT_TYPE_CREATURE) return -1;

    // Convert to JSON
    json jGet = ObjectToJson(oCreature);

    // Retrieve the key 
    jGet = JsonObjectGet(jGet, "SoundSetFile");

    if(JsonGetType(jGet) == JSON_TYPE_NULL) return -1;

    // Retrieve the value 
    jGet = JsonObjectGet(jGet, "value");

    if(JsonGetType(jGet) != JSON_TYPE_INTEGER) return -1;

    return JsonGetInt(jGet);
}

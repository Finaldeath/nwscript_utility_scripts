//::///////////////////////////////////////////////
//:: Utility Include: Objects
//:: utl_i_object.nss
//:://////////////////////////////////////////////
/*
    These provide generic object related utility functions.
*/
//:://////////////////////////////////////////////
//:: Part of the nwscript_utility_scripts project; see for dates/creator info
//:: https://github.com/Finaldeath/nwscript_utility_scripts
//:://////////////////////////////////////////////

// Returns an object matching sTag in oArea
// A replacement for GetNearestObjectByTag() when you don't have a object to be near
// * sTag - Tag of object(s) to find
// * oArea - Area to search
// * nNth - finds the nNth copy of the tagged object
object GetObjectInAreaByTag(string sTag, object oArea, int nNth = 1);



// Returns an object matching sTag in oArea
// A replacement for GetNearestObjectByTag() when you don't have a object to be near
// * sTag - Tag of object(s) to find
// * oArea - Area to search
// * nNth - finds the nNth copy of the tagged object
object GetObjectInAreaByTag(string sTag, object oArea, int nNth = 1)
{
    int j = 0;
    int i = 0;
    object oObject = GetObjectByTag(sTag, i);
    while(GetIsObjectValid(oObject))
    {
        if(GetArea(oObject) == oArea)
        {
            if(++j == n)
            {
                return oObject;
            }
        }
        oObject = GetObjectByTag(sTag, ++i);
    }
    return OBJECT_INVALID;
}
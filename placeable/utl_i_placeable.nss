//::///////////////////////////////////////////////
//:: Utility Include: Placeables
//:: utl_i_placeable.nss
//:://////////////////////////////////////////////
/*
    These provide functions for placeable manipulations.
*/
//:://////////////////////////////////////////////
//:: Part of the nwscript_utility_scripts project; see for dates/creator info
//:: https://github.com/Finaldeath/nwscript_utility_scripts
//:://////////////////////////////////////////////

// Closes any open placeable inventories that oPC has open by creating a temporary
// placeable and having them open it, then destroying it.
// * oPC - PC who might have a placeable inventory open
void CloseAnyOpenPlaceableInventory(object oPC);



// Closes any open placeable inventories that oPC has open by creating a temporary
// placeable and having them open it, then destroying it.
// * oPC - PC who might have a placeable inventory open
void CloseAnyOpenPlaceableInventory(object oPC)
{
    // Temporary placeable with inventory to create. The corpse resref can be replaced with a custom
    // placeable (ideally with no name) but must have no appearance/walkmesh to work properly.
    object oTempPlaceable = CreateObject(OBJECT_TYPE_PLACEABLE, "x0_plc_corpse", GetLocation(oPC));

    // Assigns the PC to use it
    AssignCommand(oPC, DoPlaceableObjectAction(oTempPlaceable, PLACEABLE_ACTION_USE));

    // Destroys the placeable
    DestroyObject(oTempPlaceable, 0.1);
}

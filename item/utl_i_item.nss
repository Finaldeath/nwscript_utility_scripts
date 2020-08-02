//::///////////////////////////////////////////////
//:: Utility Include: Item
//:: utl_i_item.nss
//:://////////////////////////////////////////////
/*
    A number of item utility functions including functions to manipulate
    inventories of objects (which contain items).
*/
//:://////////////////////////////////////////////
//:: Part of the nwscript_utility_scripts project; see for dates/creator info
//:: https://github.com/Finaldeath/nwscript_utility_scripts
//:://////////////////////////////////////////////

// Returns the base AC value of oArmor, based on the appearance of it
// * oArmor - Armor piece to check
int GetArmorBaseACValue(object oArmor);

// Destroys all the items in the inventory of oObject
// Creatures also have all equipped items destroyed
// * oObject - a placeable, store, creature or container
void ClearInventory(object oObject);

// Destroys all the items in the inventory of oObject that matches the resref
// Creatures also have all equipped items checked
// * oObject - a placeable, store, creature or container
// * sResRef - item resref to check
void DestroyAllItemsByResRef(object oObject, string sResRef);

// Destroys all the items in the inventory of oObject that matches the tag
// Creatures also have all equipped items checked
// * oObject - a placeable, store, creature or container
// * sTag - item tag to check
void DestroyAllItemsByTag(object oObject, string sTag);

// Makes all items in the inventory/equipped items of oObject flagged as droppable (and cursed) or not
// Will not affect creature items (which should never be droppable)
// * oObject - a placeable, store, creature or container
// * bDroppable - If TRUE it will set the droppable flag to TRUE and cursed to FALSE.
//                If FALSE it does the opposite and sets droppable flag to FALSE and cursed flag to TRUE
void SetInventoryDroppable(object oObject, int bDroppable = TRUE);



// Returns the base AC value of oArmor, based on the appearance of it
// * oArmor - Armor piece to check
int GetArmorBaseACValue(object oArmor)
{
    // Get the appearance of the torso slot
    int nAppearance = GetItemAppearance(oArmor, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_TORSO);
    // Look up in parts_chest.2da the relevant line, which links to the actual AC bonus of the armor
    // We cast it to int, even though the column is technically a float.
    int nAC = StringToInt(Get2DAString("parts_chest", "ACBONUS", nAppearance));
 
    // Return the given AC value (0 to 8)
    return nAC;
}

// Destroys all the items in the inventory of oObject
// Creatures also have all equipped items destroyed
// * oObject - a placeable, store, creature or container
void ClearInventory(object oObject)
{
    // In case we're passed something else
    if(!GetHasInventory(oObject)) return;

    object oItem = GetFirstItemInInventory(oObject);
    while(GetIsObjectValid(oItem))
    {
        // Boxes in inventories
        if(GetHasInventory(oItem))
        {
            object oItem2 = GetFirstItemInInventory(oItem);
            while(GetIsObjectValid(oItem))
            {
                DestroyObject(oItem2);
                oItem2 = GetNextItemInInventory(oItem);
            }
        }
        DestroyObject(oItem);
        oItem = GetNextItemInInventory(oObject);
    }
    // Clear inventory slots as well for creatures
    if (GetObjectType(oObject) == OBJECT_TYPE_CREATURE)
    {
        int i;
        for(i = 0; i < NUM_INVENTORY_SLOTS; i++)
            DestroyObject(GetItemInSlot(i, oObject));
    }
}


// Destroys all the items in the inventory of oObject that matches the resref
// Creatures also have all equipped items checked
// * oObject - a placeable, store, creature or container
// * sResRef - item resref to check
void DestroyAllItemsByResRef(object oObject, string sResRef)
{
    object oItem = GetFirstItemInInventory(oObject);
    while(GetIsObjectValid(oItem))
    {
        if(GetHasInventory(oItem))
        {
            object oItem2 = GetFirstItemInInventory(oItem);
            while(oItem2 != OBJECT_INVALID)
            {
                if(FindSubString(sResRef, GetResRef(oItem2)) >= 0)
                    DestroyObject(oItem2);
                oItem2 = GetNextItemInInventory(oItem);
            }
        }

        if (FindSubString(sResRef, GetResRef(oItem)) >= 0)
            DestroyObject(oItem);
        oItem = GetNextItemInInventory(oObject);
    }
    // Check inventory slots as well for creatures
    if(GetObjectType(oObject) == OBJECT_TYPE_CREATURE)
    {
        int i;
        for(i = 0; i < NUM_INVENTORY_SLOTS; i++)
        {
            oItem = GetItemInSlot(i, oObject);
            if(FindSubString(sResRef, GetResRef(oItem)) >= 0)
                DestroyObject(oItem);
        }
    }
}

// Destroys all the items in the inventory of oObject that matches the tag
// Creatures also have all equipped items checked
// * oObject - a placeable, store, creature or container
// * sTag - item tag to check
void DestroyAllItemsByTag(object oObject, string sTag)
{
    object oItem = GetFirstItemInInventory(oObject);
    while(GetIsObjectValid(oItem))
    {
        if(GetHasInventory(oItem))
        {
            object oItem2 = GetFirstItemInInventory(oItem);
            while(oItem2 != OBJECT_INVALID)
            {
                if(FindSubString(sTag, GetTag(oItem2)) >= 0)
                    DestroyObject(oItem2);
                oItem2 = GetNextItemInInventory(oItem);
            }
        }

        if (FindSubString(sTag, GetTag(oItem)) >= 0)
            DestroyObject(oItem);
        oItem = GetNextItemInInventory(oObject);
    }
    // Check inventory slots as well for creatures
    if(GetObjectType(oObject) == OBJECT_TYPE_CREATURE)
    {
        int i;
        for(i = 0; i < NUM_INVENTORY_SLOTS; i++)
        {
            oItem = GetItemInSlot(i, oObject);
            if(FindSubString(sTag, GetTag(oItem)) >= 0)
                DestroyObject(oItem);
        }
    }
}

// Makes all items in the inventory/equipped items of oObject flagged as droppable (and cursed) or not
// Will not affect creature items (which should never be droppable)
// * oObject - a placeable, store, creature or container
// * bDroppable - If TRUE it will set the droppable flag to TRUE and cursed to FALSE.
//                If FALSE it does the opposite and sets droppable flag to FALSE and cursed flag to TRUE
void SetInventoryDroppable(object oObject, int bDroppable = TRUE)
{
    // Cursed flag setup
    int bCursed = TRUE;
    if(bDroppable) bCursed = FALSE;

    // Set all the clones items to be undroppable so cannot be retrieved on death
    object oItem = GetFirstItemInInventory(oObject);
    while(GetIsObjectValid(oItem))
    {
        // Boxes in inventories
        if(GetHasInventory(oItem))
        {
            object oItem2 = GetFirstItemInInventory(oItem);
            while(GetIsObjectValid(oItem))
            {
                SetItemCursedFlag(oItem2, bCursed);
                SetDroppableFlag(oItem2, bDroppable);
                oItem2 = GetNextItemInInventory(oItem);
            }
        }
        SetItemCursedFlag(oItem, bCursed);
        SetDroppableFlag(oItem, bDroppable);
        oItem = GetNextItemInInventory(oObject);
    }
    // Check inventory slots as well for creatures
    if(GetObjectType(oObject) == OBJECT_TYPE_CREATURE)
    {
        int i;
        // Bolts are the 13th slot, everything after are creature items
        for(i = 0; i < INVENTORY_SLOT_BOLTS; i++)
        {
            oItem = GetItemInSlot(i, oObject);
            SetItemCursedFlag(oItem, bCursed);
            SetDroppableFlag(oItem, bDroppable);
        }
    }
}
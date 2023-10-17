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

// Returns amount of gold a player acquired
// Only works in the Module's OnAcquireItem or OnUserDefined events
// Note: it's not possible to do GetGoldUnacquired in a similar manner; this requires NWNX.
int GetGoldAcquired();

// Destroys all the items in the inventory of oObject
// Creatures also have all equipped items destroyed
// * oObject - a placeable, store, creature or container
void ClearInventory(object oObject);

// Destroys all the items in the inventory of oObject that matches the given resref
// Creatures also have all equipped items checked
// * oObject - a placeable, store, creature or container
// * sResRef - resref of item to destroy
void DestroyAllItemsByResRef(object oObject, string sResRef);

// Destroys all the items in the inventory of oObject that matches the resref
// list given.
// Creatures also have all equipped items checked
// * oObject - a placeable, store, creature or container
// * sResRefList - resref of item to destroy, or multiple resrefs divided by an
//                 resref-invalid character, eg; abc12;xyz34
void DestroyAllItemsByResRefList(object oObject, string sResRefList);

// Destroys all the items in the inventory of oObject that matches the tag
// Creatures also have all equipped items checked
// * oObject - a placeable, store, creature or container
// * sTag - tag of item to destroy
void DestroyAllItemsByTag(object oObject, string sTag);

// Destroys all the items in the inventory of oObject that matches the tag list
// Creatures also have all equipped items checked
// * oObject - a placeable, store, creature or container
// * sTagList - item tag list. Divide it with a tag-invalid character, eg; abc12;xyz34
// - Note: This function assumes tags are unique! Do not use if you
//         have both mybadasssword and mybadasssword2 and search for tag "mybadasssword"
//         since this finds both.
void DestroyAllItemsByTagList(object oObject, string sTagList);

// Makes all items in the inventory/equipped items of oObject flagged as droppable (and cursed) or not
// Will not affect creature items (which should never be droppable)
// * oObject - a placeable, store, creature or container
// * bDroppable - If TRUE it will set the droppable flag to TRUE and cursed to FALSE.
//                If FALSE it does the opposite and sets droppable flag to FALSE and cursed flag to TRUE
void SetInventoryDroppable(object oObject, int bDroppable = TRUE);

// Clever function (thanks clippy) to have a random item be picked from oOwner's inventory.
// Loops all inventory items at least once.
// * oOwner - a placeable, creature, or container to look through the inventory of
object GetRandomItemInInventory(object oOwner);

// Counts the amount of items possessed by oObject that match sTag. Takes into account stacks
// (so 1 item of 99 arrows will return 99).
// * oOwner - a placeable, creature, or container to look through the inventory of
// * sTag - item tag to check
int CountItemsByTagInInventory(object oObject, string sTag);

// Retrieves the ELC level required to equip oItem. Uses the itemvalue.2da file. Uses the identified value.
// - Returns the last row +1 for anything valued over the last row in that 2da
//   to match how the game works for very high value items (makes them unequippable)
int GetMaxSingleItemValue(object oItem);

// Returns TRUE if the given item is a throwable item, like a throwing axe
int GetItemIsThrowable(object oItem);

// Returns TRUE if the given item is a held ranged weapon, like a crossbow
int GetItemIsRanged(object oItem);

// Returns TRUE if the given item is a melee weapon, like a longsword
int GetItemIsMelee(object oItem);

// Returns TRUE if the given item is a weapon, as in does damage and is equippable
// Ammo is not considered a weapon.
int GetItemIsWeapon(object oItem);

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

// Returns amount of gold a player acquired
// Only works in the Module's OnAcquireItem or OnUserDefined events
// Note: it's not possible to do GetGoldUnacquired in a similar manner; this requires NWNX.
int GetGoldAcquired()
{
    int nTotalGold = 0;
    object oItem   = GetModuleItemAcquired();

    // The only item that is not valid after acquiring it is gold
    // therefore an invalid item is always gold
    if (GetIsObjectValid(oItem) == FALSE)
    {
        nTotalGold = GetModuleItemAcquiredStackSize();
    }
    return nTotalGold;
}

// Destroys all the items in the inventory of oObject
// Creatures also have all equipped items destroyed
// * oObject - a placeable, store, creature or container
void ClearInventory(object oObject)
{
    // In case we're passed something else
    if (!GetHasInventory(oObject)) return;

    object oItem = GetFirstItemInInventory(oObject);
    while (GetIsObjectValid(oItem))
    {
        DestroyObject(oItem);
        oItem = GetNextItemInInventory(oObject);
    }
    // Clear inventory slots as well for creatures
    if (GetObjectType(oObject) == OBJECT_TYPE_CREATURE)
    {
        int i;
        for (i = 0; i < NUM_INVENTORY_SLOTS; i++)
            DestroyObject(GetItemInSlot(i, oObject));
    }
}

// Destroys all the items in the inventory of oObject that matches the given resref
// Creatures also have all equipped items checked
// * oObject - a placeable, store, creature or container
// * sResRef - resref of item to destroy
void DestroyAllItemsByResRef(object oObject, string sResRef)
{
    object oItem = GetFirstItemInInventory(oObject);
    while (GetIsObjectValid(oItem))
    {
        if (GetResRef(oItem) == sResRef)
            DestroyObject(oItem);
        oItem = GetNextItemInInventory(oObject);
    }
    // Check inventory slots as well for creatures
    if (GetObjectType(oObject) == OBJECT_TYPE_CREATURE)
    {
        int i;
        for (i = 0; i < NUM_INVENTORY_SLOTS; i++)
        {
            oItem = GetItemInSlot(i, oObject);
            if (GetResRef(oItem) == sResRef)
                DestroyObject(oItem);
        }
    }
}

// Destroys all the items in the inventory of oObject that matches the resref
// list given.
// Creatures also have all equipped items checked
// * oObject - a placeable, store, creature or container
// * sResRefList - item resref list. Divide it with a resref-invalid character, eg; abc12;xyz34
// - Note: This function assumes resrefs are unique! Do not use if you
//         have both mybadasssword and mybadasssword2 and search for resref "mybadasssword"
//         since this finds both.
void DestroyAllItemsByResRefList(object oObject, string sResRefList)
{
    object oItem = GetFirstItemInInventory(oObject);
    while (GetIsObjectValid(oItem))
    {
        if (FindSubString(sResRefList, GetResRef(oItem)) >= 0)
            DestroyObject(oItem);
        oItem = GetNextItemInInventory(oObject);
    }
    // Check inventory slots as well for creatures
    if (GetObjectType(oObject) == OBJECT_TYPE_CREATURE)
    {
        int i;
        for (i = 0; i < NUM_INVENTORY_SLOTS; i++)
        {
            oItem = GetItemInSlot(i, oObject);
            if (FindSubString(sResRefList, GetResRef(oItem)) >= 0)
                DestroyObject(oItem);
        }
    }
}

// Destroys all the items in the inventory of oObject that matches the tag
// Creatures also have all equipped items checked
// * oObject - a placeable, store, creature or container
// * sTag - tag of item to destroy
void DestroyAllItemsByTag(object oObject, string sTag)
{
    object oItem = GetFirstItemInInventory(oObject);
    while (GetIsObjectValid(oItem))
    {
        if (GetTag(oItem) == sTag)
            DestroyObject(oItem);
        oItem = GetNextItemInInventory(oObject);
    }
    // Check inventory slots as well for creatures
    if (GetObjectType(oObject) == OBJECT_TYPE_CREATURE)
    {
        int i;
        for (i = 0; i < NUM_INVENTORY_SLOTS; i++)
        {
            oItem = GetItemInSlot(i, oObject);
            if (GetTag(oItem) == sTag)
                DestroyObject(oItem);
        }
    }
}

// Destroys all the items in the inventory of oObject that matches the tag list
// Creatures also have all equipped items checked
// * oObject - a placeable, store, creature or container
// * sTagList - item tag list. Divide it with a tag-invalid character, eg; abc12;xyz34
// - Note: This function assumes tags are unqiue! Do not use if you
//         have both mybadasssword and mybadasssword2 and search for tag "mybadasssword"
//         since this finds both.
void DestroyAllItemsByTagList(object oObject, string sTagList)
{
    object oItem = GetFirstItemInInventory(oObject);
    while (GetIsObjectValid(oItem))
    {
        if (FindSubString(sTagList, GetTag(oItem)) >= 0)
            DestroyObject(oItem);
        oItem = GetNextItemInInventory(oObject);
    }
    // Check inventory slots as well for creatures
    if (GetObjectType(oObject) == OBJECT_TYPE_CREATURE)
    {
        int i;
        for (i = 0; i < NUM_INVENTORY_SLOTS; i++)
        {
            oItem = GetItemInSlot(i, oObject);
            if (FindSubString(sTagList, GetTag(oItem)) >= 0)
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
    if (bDroppable) bCursed = FALSE;

    // Set all the clones items to be undroppable so cannot be retrieved on death
    object oItem = GetFirstItemInInventory(oObject);
    while (GetIsObjectValid(oItem))
    {
        SetItemCursedFlag(oItem, bCursed);
        SetDroppableFlag(oItem, bDroppable);
        oItem = GetNextItemInInventory(oObject);
    }
    // Check inventory slots as well for creatures
    if (GetObjectType(oObject) == OBJECT_TYPE_CREATURE)
    {
        int i;
        // Bolts are the 13th slot, everything after are creature items
        for (i = 0; i < INVENTORY_SLOT_BOLTS; i++)
        {
            oItem = GetItemInSlot(i, oObject);
            SetItemCursedFlag(oItem, bCursed);
            SetDroppableFlag(oItem, bDroppable);
        }
    }
}

// Clever function (thanks clippy) to have a random item be picked from oOwner's inventory.
// Loops all inventory items at least once.
// * oOwner - a placeable, creature, or container to look through the inventory of
object GetRandomItemInInventory(object oOwner)
{
    object oReturnItem = OBJECT_INVALID, oItem = GetFirstItemInInventory(oOwner);
    int index = 0;
    while (GetIsObjectValid(oItem))
    {
        if (Random(++index) == 0)
            oReturnItem = oItem;
        oItem = GetNextItemInInventory(oOwner);
    }
    return oReturnItem;
}

// Counts the amount of items possessed by oObject that match sTag. Takes into account stacks
// (so 1 item of 99 arrows will return 99).
// * oOwner - a placeable, creature, or container to look through the inventory of
// * sTag - item tag to check
int CountItemsByTagInInventory(object oObject, string sTag)
{
    object oItem = GetFirstItemInInventory(oObject);
    int nCount   = 0;
    while (GetIsObjectValid(oItem))
    {
        if (GetTag(oItem) == sTag)
            nCount += GetItemStackSize(oItem);
        oItem = GetNextItemInInventory(oObject);
    }
    // Check inventory slots as well for creatures
    if (GetObjectType(oObject) == OBJECT_TYPE_CREATURE)
    {
        int i;
        for (i = 0; i < NUM_INVENTORY_SLOTS; i++)
        {
            oItem = GetItemInSlot(i, oObject);
            if (GetTag(oItem) == sTag)
                nCount += GetItemStackSize(oItem);
        }
    }
    return nCount;
}

// Retrieves the ELC level required to equip oItem. Uses the itemvalue.2da file. Uses the identified value.
// - Returns the last row +1 for anything valued over the last row in that 2da
//   to match how the game works for very high value items (makes them unequippable)
int GetMaxSingleItemValue(object oItem)
{
    // Get true item value (ie identify it and reset identified flag)
    int bIdentified = GetIdentified(oItem);
    SetIdentified(oItem, TRUE);
    int nGP = GetGoldPieceValue(oItem);
    SetIdentified(oItem, bIdentified);

    // Loop itemvalue.2da to find what level you'd need to be to equip it
    int nRow, nRows = Get2DARowCount("itemvalue");
    for (nRow = 0; nRow < nRows; nRow++)
    {
        if (nGP <= StringToInt(Get2DAString("itemvalue", "MAXSINGLEITEMVALUE", nRow)))
        {
            // Level is row + 1 as per Label column
            return nRow + 1;
        }
    }
    // Else return row count + 1 - impossible to equip (usually this is 61)
    return nRows + 1;
}

// Returns TRUE if the given item is a throwable item, like a throwing axe
int GetItemIsThrowable(object oItem)
{
    int nType = GetBaseItemType(oItem);
    // Error check
    if (nType == BASE_ITEM_INVALID) return FALSE;

    // Type 11 is thrown weapons
    return (Get2DAString("baseitems", "WeaponWield", nType) == "11");
}

// Returns TRUE if the given item is a held ranged weapon, like a crossbow
int GetItemIsRanged(object oItem)
{
    int nType = GetBaseItemType(oItem);
    // Error check
    if (nType == BASE_ITEM_INVALID) return FALSE;

    string sWeaponWield = Get2DAString("baseitems", "WeaponWield", nType);

    // Type 5 = bow, 6 = crossbow and 10 = sling
    return (sWeaponWield == "5" || sWeaponWield == "6" || sWeaponWield == "10");
}

// Returns TRUE if the given item is a melee weapon, like a longsword
int GetItemIsMelee(object oItem)
{
    int nType = GetBaseItemType(oItem);
    // Error check
    if (nType == BASE_ITEM_INVALID) return FALSE;

    // Check it has a valid WeaponSize
    if (Get2DAString("baseitems", "WeaponSize", nType) == "") return FALSE;

    string sWeaponWield = Get2DAString("baseitems", "WeaponWield", nType);

    // Blank == 1 handed, 4 = 2 handed, 8 = double sided, 9 = creature weapon
    return (sWeaponWield == "" || sWeaponWield == "4" || sWeaponWield == "8" || sWeaponWield == "9");
}

// Returns TRUE if the given item is a weapon, as in does damage and is equippable
// Ammo is not considered a weapon.
int GetItemIsWeapon(object oItem)
{
    int nType = GetBaseItemType(oItem);
    // Error check
    if (nType == BASE_ITEM_INVALID) return FALSE;

    // Check it has a valid WeaponSize
    if (Get2DAString("baseitems", "WeaponSize", nType) == "") return FALSE;

    // Check if there is damage assigned
    // Creature weapons get 0 NumDice
    return (Get2DAString("baseitems", "NumDice", nType) != "");
}

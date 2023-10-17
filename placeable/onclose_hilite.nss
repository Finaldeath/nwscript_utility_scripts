//::///////////////////////////////////////////////
//:: On Close Hilite
//:: onclose_hilite.nss
//:://////////////////////////////////////////////
/*
    This will turn a placeables hilite colour off (set to black) if
    it is emptied. This makes it easier to see unsearched chests.

    An alternative change can be to set the colour to something else
    if there are items left, because a PC has opened it at least once.

    Better for singleplayer/co-op or instanced MP areas.
*/
//:://////////////////////////////////////////////
//:: Part of the nwscript_utility_scripts project; see for dates/creator info
//:: https://github.com/Finaldeath/nwscript_utility_scripts
//:://////////////////////////////////////////////

const int DARK_BLUE  = 0x0000FF;
const int DARK_RED   = 0xFF0000;
const int DARK_GREEN = 0x00FF00;
const int BLACK      = 0x000000;
const int WHITE      = 0xFFFFFF;

void main()
{
    // If empty set to "all empty" colour
    if (!GetIsObjectValid(GetFirstItemInInventory(OBJECT_SELF)))
    {
        SetObjectHiliteColor(OBJECT_SELF, BLACK);
    }
    else
    {
        // Else reset to default highlight
        // Alternatively change -1 to a colour to mark it as "searched but still has items in it"
        SetObjectHiliteColor(OBJECT_SELF, -1);
    }
}

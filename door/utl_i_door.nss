//::///////////////////////////////////////////////
//:: Utility Include: Doors
//:: utl_i_door.nss
//:://////////////////////////////////////////////
/*
    Door specific related utility functions.
*/
//:://////////////////////////////////////////////
//:: Part of the nwscript_utility_scripts project; see for dates/creator info
//:: https://github.com/Finaldeath/nwscript_utility_scripts
//:://////////////////////////////////////////////

// Causes a door to always open forward
// place on both OnOpen and OnClose events of a door
void OpenDoorForward();

// Causes a door to always open backward
// place on both OnOpen and OnClose events of a door
void OpenDoorBackward();

// Causes a door to always open backward
// place on both OnOpen and OnClose events of a door
void OpenDoorForward()
{
    int nDoorOpen = GetLocalInt(OBJECT_SELF, "DoorOpen");

    if (nDoorOpen == FALSE)
    {
        AssignCommand(OBJECT_SELF, PlayAnimation(ANIMATION_DOOR_OPEN1));
        SetLocalInt(OBJECT_SELF, "DoorOpen", TRUE);
    }
    else
    {
        AssignCommand(OBJECT_SELF, PlayAnimation(ACTION_CLOSEDOOR));
        SetLocalInt(OBJECT_SELF, "DoorOpen", FALSE);
    }
}

// Causes a door to always open backward
// place on both OnOpen and OnClose events of a door
void OpenDoorBackward()
{
    int nDoorOpen = GetLocalInt(OBJECT_SELF, "DoorOpen");

    if (nDoorOpen == FALSE)
    {
        AssignCommand(OBJECT_SELF, PlayAnimation(ANIMATION_DOOR_OPEN2));
        SetLocalInt(OBJECT_SELF, "DoorOpen", TRUE);
    }
    else
    {
        AssignCommand(OBJECT_SELF, PlayAnimation(ACTION_CLOSEDOOR));
        SetLocalInt(OBJECT_SELF, "DoorOpen", FALSE);
    }
}

//::///////////////////////////////////////////////
//:: Utility Script: Player Checks
//:: utl_pcchecks.nss
//:://////////////////////////////////////////////
/*
    This lean script executes itself every 1 second, and will automatically do some
    things that you might want to happen on players regularly.

    To start it use the line ExecuteScript("utl_pcchecks", GetModule()) in the
    On Module Start event.
*/
//:://////////////////////////////////////////////
//:: Part of the nwscript_utility_scripts project; see for dates/creator info
//:: https://github.com/Finaldeath/nwscript_utility_scripts
//:://////////////////////////////////////////////

// These are the toggle flags for different behaviours. Change them and recompile the script.
// Alternatively if you want them set during runtime replace them with local variables.

// This will turn off expertise if the player is casting a spell
const int STOP_EXPERTISE_ABUSE = 1;

void main()
{
    object oModule = GetModule();
    
    // Loop every PC and check what they are doing.
    object oPC = GetFirstPC();
    while(GetIsObjectValid(oPC))
    {
        if(!GetIsDM(oPC))
        {
            if(STOP_EXPERTISE_ABUSE && GetCurrentAction(oPC) == ACTION_CASTSPELL)
            {
                SetActionMode(oPC, ACTION_MODE_EXPERTISE, FALSE);
                SetActionMode(oPC, ACTION_MODE_IMPROVED_EXPERTISE, FALSE);
            }
        }
        oPC = GetNextPC();
    }
    // Run again in 1 second
    DelayCommand(1.0, ExecuteScript("utl_pcchecks", oModule));
}
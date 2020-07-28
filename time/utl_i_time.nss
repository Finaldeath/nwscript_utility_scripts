//::///////////////////////////////////////////////
//:: Utility Include: Time
//:: utl_i_time.nss
//:://////////////////////////////////////////////
/*
    Time related utility functions.
*/
//:://////////////////////////////////////////////
//:: Part of the nwscript_utility_scripts project; see for dates/creator info
//:: https://github.com/Finaldeath/nwscript_utility_scripts
//:://////////////////////////////////////////////

const int PERIOD_DAY   = 1;
const int PERIOD_NIGHT = 2;
const int PERIOD_DAWN  = 3;
const int PERIOD_DUSK  = 4;

// Returns the PEROID_* the game considers the time to be based on the moduels dawn/dusk/night/day settings
int GetDayPeriod();



// Returns the PEROID_* the game considers the time to be based on the moduels dawn/dusk/night/day settings
int GetDayPeriod()
{
    if (GetIsNight())
        return PERIOD_NIGHT;
    else if (GetIsDawn())
        return PERIOD_DAWN;
    else if (GetIsDusk())
        return PERIOD_DUSK;
    else
        return PERIOD_DAY;
}
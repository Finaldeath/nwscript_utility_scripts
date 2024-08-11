//::///////////////////////////////////////////////
//:: Utility Include: Timer
//:: utl_i_timer.nss
//:://////////////////////////////////////////////
/*
    Timer functions; this will belay the need for DelayCommand and
    therefore works on PCs who logout and "cleans up" automatically for
    dead creatures.

    It works on the basis of a simple local integer set to a time in the
    future using the module time.

    It uses a global variable so to be more efficient in loops or larger
    scripts like AI. However this means do not use them inside a DelayCommand()
    call since the elapsed seconds will be set at script execution time once only.
*/
//:://////////////////////////////////////////////
//:: Part of the nwscript_utility_scripts project; see for dates/creator info
//:: https://github.com/Finaldeath/nwscript_utility_scripts
//:://////////////////////////////////////////////

// Timer variable name prefix
const string TIMER_VARIABLE_PREFIX = "TIMER";

// This is a global variable for the TimerCalculateElapsedSeconds()
int GlobalElapsedSeconds;

// Sets a timer named sTimerName on oTarget, elapsing in nSeconds
void SetTimer(string sTimerName, int nSeconds, object oTarget = OBJECT_SELF);

// Returns TRUE if sTimer has expired or has never been sent
int GetTimerEnded(string sTimerName, object oTarget = OBJECT_SELF);

// Deletes timer sTimerName on oTarget
void DeleteTimer(string sTimerName, object oTarget = OBJECT_SELF);

// Internal timer function.
// Get module int for start year. Used purely to stop elapsed time from going over.
int GetTimerStartYear()
{
    // Module int if not got, get it and set it now.
    int nStartYear = GetLocalInt(GetModule(), "START_YEAR");
    if (nStartYear == 0)
    {
        nStartYear = GetCalendarYear();
        if (nStartYear == 0) nStartYear = 1;
        SetLocalInt(GetModule(), "START_YEAR", nStartYear);
    }
    return nStartYear;
}

// Internal timer function.
// Returns elapsed game-time in seconds and sets to variable GlobalElapsedSeconds.
// Thanks to https://forum.neverwintervault.org/t/timers-and-timings/865/8
void TimerCalculateElapsedSeconds()
{
    if (GlobalElapsedSeconds) return;

    int nYear           = GetCalendarYear() - GetTimerStartYear();  // Added GetStartYear() since Year can be very high.
    int nMonth          = GetCalendarMonth();
    int nDay            = GetCalendarDay();
    int nHour           = GetTimeHour();
    int nMinute         = GetTimeMinute();
    int nSecond         = GetTimeSecond();
    int nSecondsPerHour = FloatToInt(HoursToSeconds(1));

    GlobalElapsedSeconds = nYear * 12 * 28 * 24 * nSecondsPerHour + (nMonth - 1) * 28 * 24 * nSecondsPerHour + (nDay - 1) * 24 * nSecondsPerHour + nHour * nSecondsPerHour + nMinute * 60 + nSecond;
}

// Sets a timer named sTimerName on oTarget, elapsing in nSeconds
void SetTimer(string sTimerName, int nSeconds, object oTarget = OBJECT_SELF)
{
    // Do this every timer call for now, relatively efficient (makes sure GlobalElapsedSeconds is set first)
    TimerCalculateElapsedSeconds();

    // We set the timer against them as the time we must go past
    SetLocalInt(oTarget, TIMER_VARIABLE_PREFIX + sTimerName, GlobalElapsedSeconds + nSeconds);
}

// Returns TRUE if sTimer has expired or has never been sent
int GetTimerEnded(string sTimerName, object oTarget = OBJECT_SELF)
{
    // Do this every timer call for now, relatively efficient (makes sure GlobalElapsedSeconds is set first)
    TimerCalculateElapsedSeconds();

    // If timer isn't set it'll return 0, so elapsed seconds will always be higher
    return (GlobalElapsedSeconds >= GetLocalInt(oTarget, TIMER_VARIABLE_PREFIX + sTimerName));
}

// Deletes timer sTimerName on oTarget
void DeleteTimer(string sTimerName, object oTarget = OBJECT_SELF)
{
    DeleteLocalInt(oTarget, TIMER_VARIABLE_PREFIX + sTimerName);
}

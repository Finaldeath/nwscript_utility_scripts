//::///////////////////////////////////////////////
//:: Utility Include: Debug
//:: utl_i_debug.nss
//:://////////////////////////////////////////////
/*
    Debug specific related utility functions. This is a very simple debug library and
    does not include log levels or anything remotely complex.

    It contains functions to debug the amount of time a script takes to run, how many
    instructions have been run, and a simple DebugPrint function to debug things.

    If included it will automatically get the instruction count
    inline, which shouldn't really have any overhead.

    Note the DebugPrint() command may want some changes. By default it
    prints all debug messages to the first player as a message but
    you could have log entries, SpeakString calls or anything else
    you need text to go.
*/
//:://////////////////////////////////////////////
//:: Part of the nwscript_utility_scripts project; see for dates/creator info
//:: https://github.com/Finaldeath/nwscript_utility_scripts
//:://////////////////////////////////////////////

// Global to count the initial instructions
int DEBUG_INITIAL_INSTRUCTIONS = GetScriptInstructionsRemaining();

// This will print the given debug string to whatever method the function calls
// * sDebug - Debug string to print
// Note: By default this just uses SendMessageToPC and has uncommented options for
// other methods. You could uncomment them all to remove all debug printing as well.
void DebugPrint(string sDebug);

// This will print the a string for the amount script instructions run at this given point.
// This is not necessarily indicative of how fast a script (some functions with the same amount of
// instructions run vastly slower) is but can be an additional thing to help check larger scripts.
void DebugInstructionCount();

// This will return a formatted time string from SQL - including microseconds - to time a script portion.
// Input the resulting string into DebugRuntimeEnd() to calculate the time.
// EG:
// string sStart = DebugRuntimeStart();
// ...various code...
// DebugRuntimeEnd(sStart);
string DebugRuntimeStart();

// This will print a debug string of the amount of seconds and milliseconds since a specific previous call
// * sRuntimeStart - The earlier time to test against. Obtain by using DebugRuntimeStart() earlier in the script.
void DebugRuntimeEnd(string sRuntimeStart);

// This will print the given debug string to whatever method the function calls
// * sDebug - Debug string to print
// Note: By default this just uses SendMessageToPC and has uncommented options for
// other methods. You could uncomment them all to remove all debug printing as well.
void DebugPrint(string sDebug)
{
    // Basic sending the debug string to the first PC. You could uncomment this to remove all debug messages in a final build.
    SendMessageToPC(GetFirstPC(), sDebug);

    // Other options you may want to use:
    // WriteTimestampedLogEntry(sDebug);
    // SpeakString(sDebug);
}

// This will print the a string for the amount script instructions run at this given point.
// This is not necessarily indicative of how fast a script (some functions with the same amount of
// instructions run vastly slower) is but can be an additional thing to help check larger scripts.
void DebugInstructionCount()
{
    DebugPrint("[Debug] Instructions ran: " + IntToString(DEBUG_INITIAL_INSTRUCTIONS - GetScriptInstructionsRemaining()));
}

// This will return a formatted time string from SQL - including microseconds - to time a script portion.
// Input the resulting string into DebugRuntimeEnd() to calculate the time.
// EG:
// string sStart = DebugRuntimeStart();
// ...various code...
// DebugRuntimeEnd(sStart);
string DebugRuntimeStart()
{
    // WriteTimestampedLogEntry("[JAI_DebugRuntimeStart] Start of Combat Round");
    sqlquery x = SqlPrepareQueryObject(GetModule(), "select strftime('%f', 'now');");
    SqlStep(x);
    return SqlGetString(x, 0);
}

// This will print a debug string of the amount of seconds and milliseconds since a specific previous call
// * sRuntimeStart - The earlier time to test against. Obtain by using DebugRuntimeStart() earlier in the script.
void DebugRuntimeEnd(string sRuntimeStart)
{
    sqlquery x = SqlPrepareQueryObject(GetModule(), "select strftime('%f', 'now');");
    SqlStep(x);
    string sRuntimeEnd = SqlGetString(x, 0);

    // Sort out the integers 00:000
    int nStartSeconds      = StringToInt(GetSubString(sRuntimeStart, 0, 2));
    int nStartMilliseconds = StringToInt(GetSubString(sRuntimeStart, 3, 3));
    int nEndSeconds        = StringToInt(GetSubString(sRuntimeEnd, 0, 2));
    int nEndMilliseconds   = StringToInt(GetSubString(sRuntimeEnd, 3, 3));

    // Totals
    if (nStartSeconds > nEndSeconds) nEndSeconds += 60;
    if (nStartMilliseconds > nEndMilliseconds) nEndMilliseconds += 1000;

    // Get final timing
    int nFinalSeconds      = nEndSeconds - nStartSeconds;
    int nFinalMilliseconds = nEndMilliseconds - nStartMilliseconds;

    // Pad string appropriately for easy comparisons
    string sSeconds      = IntToString(nFinalSeconds);
    string sMilliseconds = IntToString(nFinalMilliseconds);
    if (nFinalSeconds < 10) sSeconds = "0" + sSeconds;
    if (nFinalMilliseconds < 10)
    {
        sMilliseconds = "00" + sMilliseconds;
    }
    else if (nFinalMilliseconds < 100)
    {
        sMilliseconds = "0" + sMilliseconds;
    }

    DebugPrint("[Debug] Script Timing. Start: [" + sRuntimeStart + "] end: [" + sRuntimeEnd + "] Total: [" + sSeconds + ":" + sMilliseconds + "]");
}

//::///////////////////////////////////////////////
//:: Utility Include: Strings
//:: utl_i_strings.nss
//:://////////////////////////////////////////////
/*
    This contains a number of string related utility functions.

    It is recommended when dealing with strings to not do too much long
    string searching, due to potential TMI errors (eg looping descriptions in
    a players inventory).
*/
//:://////////////////////////////////////////////
//:: Part of the nwscript_utility_scripts project; see for dates/creator info
//:: https://github.com/Finaldeath/nwscript_utility_scripts
//:://////////////////////////////////////////////

// Removes all spaces from the left side of a given string
string ltrim(string sString);

// Removes all spaces from both left and right sides of a given string
string trim(string sString);

// Removes all spaces from the right side of a given string
string rtrim(string sString);



// Removes all spaces from the left side of a given string
string ltrim(string sString)
{
    while (GetStringLeft(sString, 1) == " ")
        sString = GetStringRight(sString, GetStringLength(sString) - 1);
    return sString;
}

// Removes all spaces from the right side of a given string
string rtrim(string sString)
{
    while (GetStringRight(sString, 1) == " ")
        sString = GetStringLeft(sString, GetStringLength(sString) - 1);
    return sString;
}

// Removes all spaces from both left and right sides of a given string
string trim(string sString)
{
    return ltrim(rtrim(sString));
}
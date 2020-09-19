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

// Replaces all instance of sToReplace with sReplacement in the string sString
// Examples:
//   ReplaceChars("aabb", "a", "y") = "yabb"
//   ReplaceChars("aabb", "x", "y") = "aabb"
string ReplaceChars(string sString, string sToReplace, string sReplacement);

// Converts the given integer to string as IntToString and then pads the left side until
// it's nLength characters long. If sign is specified, the first character is reserved 
// for it, and it is always present.
// Strings longer than the given length are trunctated to their nLength right characters.
// Examples:
//  IntToPaddedString(-15, 4, FALSE) = "0015"
//  IntToPaddedString(-15, 4, TRUE)  = "-015"
string IntToPaddedString(int nX, int nLength = 4, int nSigned = FALSE);

// Converts a boolean to a string.
// * bBoolean - Boolean to convert
// * bTLK - If TRUE this uses TLK values 8141 "True" and 8142 "False" to localise, 
//          if FALSE it will always return "True" or "False".
string BooleanToString(int bBoolean, int bTLK = FALSE);



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

// Replaces all instance of sToReplace with sReplacement in the string sString
// Examples:
//   ReplaceChars("aabb", "a", "y") = "yabb"
//   ReplaceChars("aabb", "x", "y") = "aabb"
string ReplaceChars(string sString, string sToReplace, string sReplacement)
{
    int nIndex;
    while((nIndex = FindSubString(sString, sToReplace)) != -1)
    {
        sString = GetStringLeft(sString, nIndex) +
                  sReplacement +
                  GetSubString(sString, nIndex + GetStringLength(sToReplace), GetStringLength(sString) - nIndex - GetStringLength(sToReplace));
    }
    return sString;
}

// Converts the given integer to string as IntToString and then pads the left side until
// it's nLength characters long. If sign is specified, the first character is reserved 
// for it, and it is always present.
// Strings longer than the given length are trunctated to their nLength right characters.
// Examples:
//  IntToPaddedString(-15, 4, FALSE) = "0015"
//  IntToPaddedString(-15, 4, TRUE)  = "-015"
string IntToPaddedString(int nX, int nLength = 4, int nSigned = FALSE)
{
    if(nSigned)
        nLength--; // To allow for sign
    string sResult = IntToString(nX);
    // Trunctate to nLength rightmost characters
    if(GetStringLength(sResult) > nLength)
        sResult = GetStringRight(sResult, nLength);
    // Pad the left side with zero
    while(GetStringLength(sResult) < nLength)
    {
        sResult = "0" + sResult;
    }
    if(nSigned)
    {
        if(nX >= 0)
            sResult = "+" + sResult;
        else
            sResult = "-" + sResult;
    }
    return sResult;
}

// Converts a boolean to a string.
// * bBoolean - Boolean to convert
// * bTLK - If TRUE this uses TLK values 8141 "True" and 8142 "False" to localise, 
//          if FALSE it will always return "True" or "False".
string BooleanToString(int bBoolean, int bTLK = FALSE)
{
    return bTLK ?
            (bBoolean ? GetStringByStrRef(8141) : GetStringByStrRef(8142)):
            (bBoolean ? "True" : "False");
}
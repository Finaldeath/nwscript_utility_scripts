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

// COLOR_TOKEN originally by rdjparadis. Used to generate colors from RGB values. NEVER modify this string.
// This requires a later version of NWN:EE to use the \x escape character
// For more information: https://nwn.wiki/display/NWN1/Colour+Tokens
// NB: First character is "nearest to 00" since we can't use \x00 itself (means you can't get completely black is all)
const string COLOR_TOKEN = "\x01\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0A\x0B\x0C\x0D\x0E\x0F\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1A\x1B\x1C\x1D\x1E\x1F\x20\x21\x22\x23\x24\x25\x26\x27\x28\x29\x2A\x2B\x2C\x2D\x2E\x2F\x30\x31\x32\x33\x34\x35\x36\x37\x38\x39\x3A\x3B\x3C\x3D\x3E\x3F\x40\x41\x42\x43\x44\x45\x46\x47\x48\x49\x4A\x4B\x4C\x4D\x4E\x4F\x50\x51\x52\x53\x54\x55\x56\x57\x58\x59\x5A\x5B\x5C\x5D\x5E\x5F\x60\x61\x62\x63\x64\x65\x66\x67\x68\x69\x6A\x6B\x6C\x6D\x6E\x6F\x70\x71\x72\x73\x74\x75\x76\x77\x78\x79\x7A\x7B\x7C\x7D\x7E\x7F\x80\x81\x82\x83\x84\x85\x86\x87\x88\x89\x8A\x8B\x8C\x8D\x8E\x8F\x90\x91\x92\x93\x94\x95\x96\x97\x98\x99\x9A\x9B\x9C\x9D\x9E\x9F\xA0\xA1\xA2\xA3\xA4\xA5\xA6\xA7\xA8\xA9\xAA\xAB\xAC\xAD\xAE\xAF\xB0\xB1\xB2\xB3\xB4\xB5\xB6\xB7\xB8\xB9\xBA\xBB\xBC\xBD\xBE\xBF\xC0\xC1\xC2\xC3\xC4\xC5\xC6\xC7\xC8\xC9\xCA\xCB\xCC\xCD\xCE\xCF\xD0\xD1\xD2\xD3\xD4\xD5\xD6\xD7\xD8\xD9\xDA\xDB\xDC\xDD\xDE\xDF\xE0\xE1\xE2\xE3\xE4\xE5\xE6\xE7\xE8\xE9\xEA\xEB\xEC\xED\xEE\xEF\xF0\xF1\xF2\xF3\xF4\xF5\xF6\xF7\xF8\xF9\xFA\xFB\xFC\xFD\xFE\xFF";

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
// Strings longer than the given length are truncated to their nLength right characters.
// Examples:
//  IntToPaddedString(-15, 4, FALSE) = "0015"
//  IntToPaddedString(-15, 4, TRUE)  = "-015"
string IntToPaddedString(int nX, int nLength = 4, int nSigned = FALSE);

// Converts a boolean to a string.
// * bBoolean - Boolean to convert
// * bTLK - If TRUE this uses TLK values 8141 "True" and 8142 "False" to localise, 
//          if FALSE it will always return "True" or "False".
string BooleanToString(int bBoolean, int bTLK = FALSE);

// Returns a randomised string of the first nCharCount characters in sOriginalString.
// * sOriginalString - string to randomise
// * nCharCount - this amount of characters to randomise. If 0 or less, will do all characters. Default 0.
// Example: RandomiseString("abcde", 2) could return "ab" or "ba"
// Return value on error: ""
string RandomiseString(string sOriginalString, int nCharCount = 0);

// Gets a suitable <cXXX> token to use at the start of a block of colored text. Must be terminated by </c>
// - nRed - Red amount (0-255)
// - nGreen - Green amount (0-255)
// - nBlue - Blue amount (0-255)
string GetColorCode(int nRed=255, int nGreen=255, int nBlue=255);

// Converts sString into a colored string, <cXXX>sString</c>.
// - nRed - Red amount (0-255)
// - nGreen - Green amount (0-255)
// - nBlue - Blue amount (0-255)
string GetStringColoredRGB(string sString, int nRed=255, int nGreen=255, int nBlue=255);



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
// Strings longer than the given length are truncated to their nLength right characters.
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

// Returns a randomised string of the first nCharCount characters in sOriginalString.
// * sOriginalString - string to randomise
// * nCharCount - this amount of characters to randomise. If 0 or less, will do all characters. Default 0.
// Example: RandomiseString("abcde", 2) could return "ab" or "ba"
// Return value on error: ""
string RandomiseString(string sOriginalString, int nCharCount = 0)
{
    // Error handling
    if(sOriginalString == "") return "";
    // Check for if we want to use the entire string.
    if(nCharCount < 1 || nCharCount > GetStringLength(sOriginalString))
    {
        nCharCount = GetStringLength(sOriginalString);
    }
    string sReturnValue = "";
    int nCount, nPlace;
    for(nCount = 0; nCount < nCharCount; nCount++)
    {
        nPlace = Random(nCount + 1);
        sReturnValue = GetSubString(sReturnValue, 0, nPlace) + GetSubString(sOriginalString, nCount, 1) + GetSubString(sReturnValue, nPlace, GetStringLength(sReturnValue));
    }
    return sReturnValue;
}

// Gets a suitable <cXXX> token to use at the start of a block of colored text. Must be terminated by </c>
// - nRed - Red amount (0-255)
// - nGreen - Green amount (0-255)
// - nBlue - Blue amount (0-255)
string GetColorCode(int nRed=255, int nGreen=255, int nBlue=255)
{
    return "<c" + GetSubString(COLOR_TOKEN, nRed, 1) + GetSubString(COLOR_TOKEN, nGreen, 1) + GetSubString(COLOR_TOKEN, nBlue, 1) + ">";
}

// Converts sString into a colored string, <cXXX>sString</c>.
// - nRed - Red amount (0-255)
// - nGreen - Green amount (0-255)
// - nBlue - Blue amount (0-255)
string GetStringColoredRGB(string sString, int nRed=255, int nGreen=255, int nBlue=255)
{
    return GetColorCode(nRed, nGreen, nBlue) + sString + "</c>";
}

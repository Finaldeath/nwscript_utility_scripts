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

// COLOR_TOKEN by rdjparadis. Used to generate colors from RGB values. NEVER modify this string.
const string COLOR_TOKEN = "                  ##################$%&'()*+,-./0123456789:;;==?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[[]^_`abcdefghijklmnopqrstuvwxyz{|}~~Ã¢â€šÂ¬Ã‚ÂÃ¢â‚¬Å¡Ã†â€™Ã¢â‚¬Å¾Ã¢â‚¬Â¦Ã¢â‚¬Â Ã¢â‚¬Â¡Ã‹â€ Ã¢â‚¬Â°Ã…Â Ã¢â‚¬Â¹Ã…â€™Ã‚ÂÃ…Â½Ã‚ÂÃ‚ÂÃ¢â‚¬ËœÃ¢â‚¬â„¢Ã¢â‚¬Å“Ã¢â‚¬ÂÃ¢â‚¬Â¢Ã¢â‚¬â€œÃ¢â‚¬â€Ã‹Å“Ã¢â€žÂ¢Ã…Â¡Ã¢â‚¬ÂºÃ…â€œÃ‚ÂÃ…Â¾Ã…Â¸Ã‚Â¡Ã‚Â¡Ã‚Â¢Ã‚Â£Ã‚Â¤Ã‚Â¥Ã‚Â¦Ã‚Â§Ã‚Â¨Ã‚Â©Ã‚ÂªÃ‚Â«Ã‚Â¬Ã‚Â¬Ã‚Â®Ã‚Â¯Ã‚Â°Ã‚Â±Ã‚Â²Ã‚Â³Ã‚Â´Ã‚ÂµÃ‚Â¶Ã‚Â·Ã‚Â¸Ã‚Â¹Ã‚ÂºÃ‚Â»Ã‚Â¼Ã‚Â½Ã‚Â¾Ã‚Â¿Ãƒâ‚¬ÃƒÂÃƒâ€šÃƒÆ’Ãƒâ€žÃƒâ€¦Ãƒâ€ Ãƒâ€¡ÃƒË†Ãƒâ€°ÃƒÅ Ãƒâ€¹ÃƒÅ’ÃƒÂÃƒÅ½ÃƒÂÃƒÂÃƒâ€˜Ãƒâ€™Ãƒâ€œÃƒâ€Ãƒâ€¢Ãƒâ€“Ãƒâ€”ÃƒËœÃƒâ„¢ÃƒÅ¡Ãƒâ€ºÃƒÅ“ÃƒÂÃƒÅ¾ÃƒÅ¸ÃƒÂ ÃƒÂ¡ÃƒÂ¢ÃƒÂ£ÃƒÂ¤ÃƒÂ¥ÃƒÂ¦ÃƒÂ§ÃƒÂ¨ÃƒÂ©ÃƒÂªÃƒÂ«ÃƒÂ¬ÃƒÂ­ÃƒÂ®ÃƒÂ¯ÃƒÂ°ÃƒÂ±ÃƒÂ²ÃƒÂ³ÃƒÂ´ÃƒÂµÃƒÂ¶ÃƒÂ·ÃƒÂ¸ÃƒÂ¹ÃƒÂºÃƒÂ»ÃƒÂ¼ÃƒÂ½ÃƒÂ¾ÃƒÂ¾";

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

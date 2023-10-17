//::///////////////////////////////////////////////
//:: Style Guide
//:: style_guide.nss
//:://////////////////////////////////////////////
/*
    This is an example of how to use the Style Guide for the NWscript utilty scripts repo:  https://github.com/Finaldeath/nwscript_utility_scripts

    It is following how nwscript.nss and many general Bioware include files are written.

    This box may contain examples, notes, and a description of the file.
*/
//:://////////////////////////////////////////////
//:: Part of the nwscript_utility_scripts project; see for dates/creator info
//:: https://github.com/Finaldeath/nwscript_utility_scripts
//:://////////////////////////////////////////////

// Lowercase name for include files, comment above if necessary
#include "include_file"

// Declarations of constants come first. These may need explaining with comments. Constants are all capitals.

const int COOL_NUMBER_1 = 42;       // From "Hitchhikers Guide to the Galaxy"
const int COOL_NUMBER_2 = 1089;     // Magic number
const int COOL_NUMBER_3 = 1729;     // Hardy-Ramanujan
const int COOL_NUMBER_4 = 6174;     // Kaprekar's constant
const int COOL_NUMBER_5 = 8675309;  // Jenny's phone number

// Declarations of a function are needed so they properly appear in the Toolset.
// You may want to write a description of this particular set of functions above however.

// Returns if the number provided is cool or not.
// * nNumber - The number to check
int GetIsTheNumberCool(int nNumber);

// The functions can omit the documentation or repeat it.

int GetIsTheNumberCool(int nNumber)
{
    // Comments may explain something inline

    // 42 is known to be the answer to life, the universe and everything and we check it first.
    if (nNumber == COOL_NUMBER_1) return TRUE;

    // Declared variables may have a comment.
    int bReturn = FALSE;

    // Switch statements may have a number of ways of looking
    switch (nNumber)
    {
        case COOL_NUMBER_2:
        case COOL_NUMBER_3:
        case COOL_NUMBER_4:
        {
            // Math ones
            bReturn = TRUE;
        }
        break;
        case COOL_NUMBER_5: bReturn = TRUE; break;  // Special number 5
        default:
        {
            // We don't think it's cool
            bReturn = FALSE;
        }
        break;
    }
    return bReturn;
}

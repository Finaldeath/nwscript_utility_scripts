# NWscript Utility Scripts Style Guide
Scripts in this repository should follow this simple style guide. We are following Bioware's coding style for simplicity and readability, and to match the default game files.

There is an example header.nss available to use at the top of files.

There is also a style_guide.nss file that copies some of this in so you can view it separately.

# Filenames and contents

Filenames are limited to 16 characters so brevity here is necessary.

The order of file contents should at least roughly follow the below ordering:

* Header
* Include statements
* Constants
* Function defintions
* Private functions
* Functions

# Clarity over brevity

More comments are welcomed if only because someone may be reading this in 5 years time wondering why it was written this way.

Variables and functions should be clearly named with longer words if necessary. Visual Studio Code and even the Toolset have autocomplete for a reason. It also reduces clashes.

# Comments

Longer comments should usually be not on the same line as a declared variable, function or if statement. However any comments are welcome.

Just please don't comment on lines with brackets.

```c
// Good comment
if(nVariable == 10)
{
}

if(nVariable == 10) // Not great comment
{
}

if(nVariable == 10)
{// Awful comment
}// And again, why?
```

# File Header

This is the standard file header; the fields should be filled in with necessary information.

```c
//::///////////////////////////////////////////////
//:: File Title
//:: filename.nss
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Part of the nwscript_utility_scripts project; see for dates/creator info
//:: https://github.com/Finaldeath/nwscript_utility_scripts
//:://////////////////////////////////////////////
```

# Include Delcarations

Include file references should be named in lower case, with a comment line above if necessary.

```c
// We need this for the function GetIsTheNumberCool
#include "util_cool_num"
```

# Constant Declarations

Constants should be all upper case. Generally to provide compatibility they should be prefixed with something so scripts can be mix and matched. Examples:

```c
const int NUMBER_UTILITY_MAGIC_INTEGER_1 = 42;
```

# Variable Declarations

Variables should use hungarian notation with camel case. Examples are:

```c
int nInteger
int bBoolean
float fFloat
string sString
vector vVector
location lLocation
object oObject
effect eEffect
talent tTalent
itemproperty ipItemProperty
sqlquery sqlSQLQuery
```

# Function Declarations

Functions need to be declared once at the top of a file with a line of comments for the toolset to recognise them in the "Helper" panel. Later on this line of comments can be ommitted, or repeated.

Function names should be CamelCase usually utilising "Get", "Set", "Check", and other verbs to declare what the function does more clearly.

Functions should have descriptive variable names, which can be clarified in the comments as per below.

```c
// Returns if the number provided is cool or not.
// * nNumber - The number to check
int GetIsTheNumberCool(int nNumber);

int GetIsTheNumberCool(int nNumber)
{
	...
}
```

You might want to prefix a collection of functions in one file with a lowercase prefix, as per this second example, but if used should be applied to all the functions in that file. You might optionally remove the underscore. This sort of creates a local "namespace" and helps categorise things if many includes are used.

```c
// Returns if the number provided is cool or not.
// * nNumber - The number to check
int numutil_GetIsTheNumberCool(int nNumber);

int numutil_GetIsTheNumberCool(int nNumber)
{
	...
}
```

Optionally you can include Docgen compatible definitions, but we won't add them for you! (they also look a bit naff in the toolset/Visual Studio).

```c
/// @brief Returns if the number provided is cool or not.
/// @param nNumber The number to check
/// @return TRUE if the number is cool
int numutil_GetIsTheNumberCool(int nNumber);

int numutil_GetIsTheNumberCool(int nNumber)
{
	...
}
```

# Private Functions

You can optionally prefix the entire function name with an underscore to mark it as "Private" and not to be used outside the utility script itself.

These should not be declared at the very top of the file so the toolset doesn't automatically show them or autocomplete them.

```c
// Private function
// Returns the main integer needed for this utility
int _GetMainInteger()
{

}

// Private function
// Returns the main integer needed for this utility
int _utilfnc_GetMainInteger()
{

}
```

# Code blocks

Code blocks need to be indented with brackets on a new line.

There should be one function per line and if statement may need to be made multi-line to fit well on a screen.

```c
// Speak default line if nLine if it is 10, but can provide sOverride to override it
void SpeakSomething(int nLine, string sOverride = "")
{
	if(nLine == 10)
	{
		if(sOverride == "")
		{
			SpeakString("Hello there");
		}
		else
		{
			SpeakString(sOverride);
		}
	}
}
```

Single lines are of course usable if no brackets are used. Sometimes making it go on a second line is more readable.

```c
if(nVariable == 10) return TRUE;

if(nVariable == 10 && sString == "" && bBoolean == FALSE)
	return TRUE;
```

# Switch statements

These should be made as readable as possible with only one value per line. Brackets are very useful in cases where comments are involved even if there is only one thing going on.

```c
    switch(nNumber)
    {
        case COOL_NUMBER_2:
        case COOL_NUMBER_3:
        case COOL_NUMBER_4:
        {
            // Math ones
            bReturn = TRUE;
        }
        break;
        case COOL_NUMBER_5: bReturn = TRUE;     break; // Special number 5
        default:
        {
			// We don't think it's cool
            bReturn = FALSE;
        }
        break;
    }
```


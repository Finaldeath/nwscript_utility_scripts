//::///////////////////////////////////////////////
//:: Utility Include: Reputation
//:: utl_i_reputation.nss
//:://////////////////////////////////////////////
/*
    The reputation systems in Neverwinter Nights are known to be a rather
    messy black box. Scripts can cause creatures to change to standard
    factions but not custom ones very easily, and "reputation changes" are
    done engine-wide not controlled by scripts.

    This has some utility functions to take the edge off the issues especially
    around making a hostile creature friendly (it is recommended to make
    these kinds of creatures immortal if they must do some kind of 
    speaking).
*/
//:://////////////////////////////////////////////
//:: Part of the nwscript_utility_scripts project; see for dates/creator info
//:: https://github.com/Finaldeath/nwscript_utility_scripts
//:://////////////////////////////////////////////

// Returns the SPELL_SCHOOL_* constant for the single letter sSchool
// that would be from spells.2da
// * sSchool - a single letter of the spell school (G, A, C, D, E, V, I, N or T)
// Returns -1 on error.
int SpellSchoolIDFromString(string sSchool);



// Returns the SPELL_SCHOOL_* constant for the single letter sSchool
// that would be from spells.2da
// * sSchool - a single letter of the spell school (G, A, C, D, E, V, I, N or T)
// Returns -1 on error.
int SpellSchoolIDFromString(string sSchool)
{
    return FindSubString("GACDEVINT", sSchool);
}

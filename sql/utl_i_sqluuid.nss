//::///////////////////////////////////////////////
//:: Utility Include: SQLocals Campaign
//:: utl_i_sqluuid.nss
//:://////////////////////////////////////////////
/*
    Daz wrote these library functions to act as replacements for the usual local
    functions:
    * GetLocalInt / SetLocalInt / DeleteLocalInt
    * GetLocalFloat / SetLocalFloat / DeleteLocalFloat
    * GetLocalString / SetLocalString / DeleteLocalString
    * GetLocalObject / SetLocalObject / DeleteLocalObject (NB: remember these are references NOT serialised objects)
    * GetLocalLocation / SetLocalLocation / DeleteLocalLocation
    * Plus a new function for saving just a vector by itself.

    This version stores variables in the campaign DB using the UUID of the object as 
    the identifier, therefore it suggests only using this for oPlayer since their UUIDs
    are persistent after server restarts.

    Note for players existing OnClientLeave this is still valid, while the 
    versions in utl_i_sqlplayer is not.
*/
//:://////////////////////////////////////////////
//:: Based off of the nwscript_utility_scripts project; see for dates/creator info
//:: https://github.com/Finaldeath/nwscript_utility_scripts
//:://////////////////////////////////////////////

const string SQLLOCALUUID_DATABASE_NAME  = "sqllocalsuuid_db";

const string SQLOCALSUUID_TABLE_NAME     = "sqlocalsuuid_table";

const int SQLOCALSUUID_TYPE_ALL          = 0;
const int SQLOCALSUUID_TYPE_INT          = 1;
const int SQLOCALSUUID_TYPE_FLOAT        = 2;
const int SQLOCALSUUID_TYPE_STRING       = 4;
const int SQLOCALSUUID_TYPE_OBJECT       = 8;
const int SQLOCALSUUID_TYPE_VECTOR       = 16;
const int SQLOCALSUUID_TYPE_LOCATION     = 32;

// Returns an integer stored in the campaign DB for oPlayer, or 0 on error
// * oPlayer - a player object (uses GetObjectUUID to identify)
// * sVarName - name of the variable to retrieve
int SQLocalsUUID_GetInt(object oPlayer, string sVarName);
// Sets an integer stored in the campaign DB for oPlayer to the given value
// * oPlayer - a player object (uses GetObjectUUID to identify)
// * sVarName - name of the variable to set
// * nValue - Value to store
void SQLocalsUUID_SetInt(object oPlayer, string sVarName, int nValue);
// Deletes an integer stored in the campaign DB for oPlayer
// * oPlayer - a player object (uses GetObjectUUID to identify)
// * sVarName - name of the variable to delete
void SQLocalsUUID_DeleteInt(object oPlayer, string sVarName);

// Returns a float stored in the campaign DB for oPlayer, or 0.0 on error
// * oPlayer - a player object (uses GetObjectUUID to identify)
// * sVarName - name of the variable to retrieve
float SQLocalsUUID_GetFloat(object oPlayer, string sVarName);
// Sets a float stored in the campaign DB for oPlayer to the given value
// * oPlayer - a player object (uses GetObjectUUID to identify)
// * sVarName - name of the variable to set
// * fValue - Value to store
void SQLocalsUUID_SetFloat(object oPlayer, string sVarName, float fValue);
// Deletes a float stored in the campaign DB for oPlayer
// * oPlayer - a player object (uses GetObjectUUID to identify)
// * sVarName - name of the variable to delete
void SQLocalsUUID_DeleteFloat(object oPlayer, string sVarName);

// Returns an string stored in the campaign DB for oPlayer, or "" on error
// * oPlayer - a player object (uses GetObjectUUID to identify)
// * sVarName - name of the variable to retrieve
string SQLocalsUUID_GetString(object oPlayer, string sVarName);
// Sets a string stored in the campaign DB for oPlayer to the given value
// * oPlayer - a player object (uses GetObjectUUID to identify)
// * sVarName - name of the variable to set
// * sValue - Value to store
void SQLocalsUUID_SetString(object oPlayer, string sVarName, string sValue);
// Deletes a string stored in the campaign DB for oPlayer
// * oPlayer - a player object (uses GetObjectUUID to identify)
// * sVarName - name of the variable to delete
void SQLocalsUUID_DeleteString(object oPlayer, string sVarName);

// Returns an object identifier stored in the campaign DB for oPlayer
// If this is used on a player it might return a "once valid" OID, so check
// with GetIsObjectValid, do not compare to OBJECT_INVALID.
// * oPlayer - a player object (uses GetObjectUUID to identify)
// * sVarName - name of the variable to retrieve
object SQLocalsUUID_GetObject(object oPlayer, string sVarName);
// Sets an object identifier stored in the campaign DB for oPlayer to the given value
// * oPlayer - a player object (uses GetObjectUUID to identify)
// * sVarName - name of the variable to set
// * oValue - Value to store
void SQLocalsUUID_SetObject(object oPlayer, string sVarName, object oValue);
// Deletes an object identifier stored in the campaign DB for oPlayer
// * oPlayer - a player object (uses GetObjectUUID to identify)
// * sVarName - name of the variable to delete
void SQLocalsUUID_DeleteObject(object oPlayer, string sVarName);

// Returns a vector stored in the campaign DB for oPlayer, or [0.0, 0.0, 0.0] on error
// * oPlayer - a player object (uses GetObjectUUID to identify)
// * sVarName - name of the variable to retrieve
vector SQLocalsUUID_GetVector(object oPlayer, string sVarName);
// Sets a vector stored in the campaign DB for oPlayer to the given value
// * oPlayer - a player object (uses GetObjectUUID to identify)
// * sVarName - name of the variable to set
// * vValue - Value to store
void SQLocalsUUID_SetVector(object oPlayer, string sVarName, vector vValue);
// Deletes a vector stored in the campaign DB for oPlayer
// * oPlayer - a player object (uses GetObjectUUID to identify)
// * sVarName - name of the variable to delete
void SQLocalsUUID_DeleteVector(object oPlayer, string sVarName);

// Returns a location stored in the campaign DB for oPlayer, or the starting location of the module on error
// * oPlayer - a player object (uses GetObjectUUID to identify)
// * sVarName - name of the variable to retrieve
location SQLocalsUUID_GetLocation(object oPlayer, string sVarName);
// Sets a location stored in the campaign DB for oPlayer to the given value
// * oPlayer - a player object (uses GetObjectUUID to identify)
// * sVarName - name of the variable to set
// * lValue - Value to store
void SQLocalsUUID_SetLocation(object oPlayer, string sVarName, location lValue);
// Deletes a location stored in the campaign DB for oPlayer
// * oPlayer - a player object (uses GetObjectUUID to identify)
// * sVarName - name of the variable to delete
void SQLocalsUUID_DeleteLocation(object oPlayer, string sVarName);

// Deletes a set of locals stored in the campaign DB for oPlayer matching the given criteria
// * oPlayer - a player object (uses GetObjectUUID to identify)
// * nType - The SQLOCALSUUID_TYPE_* you wish to remove (default: SQLOCALSUUID_TYPE_ALL)
// * sLike - The string to compare with the SQL "like" comparison
// * sEscape - The escape character to use with the SQL "escape" keyword
void SQLocalsUUID_Delete(object oPlayer, int nType = SQLOCALSUUID_TYPE_ALL, string sLike = "", string sEscape = "");
// Counts a set of locals stored in the campaign DB for oPlayer matching the given criteria
// * oPlayer - a player object (uses GetObjectUUID to identify)
// * nType - The SQLOCALSUUID_TYPE_* you wish to count (default: SQLOCALSUUID_TYPE_ALL)
// * sLike - The string to compare with the SQL "like" comparison
// * sEscape - The escape character to use with the SQL "escape" keyword
int SQLocalsUUID_Count(object oPlayer, int nType = SQLOCALSUUID_TYPE_ALL, string sLike = "", string sEscape = "");
// Checks a locals stored in the campaign DB for oPlayer is set
// * oPlayer - a player object (uses GetObjectUUID to identify)
// * sVarName - name of the variable to retrieve
// * nType - The SQLOCALSUUID_TYPE_* you wish to check
int SQLocalsUUID_IsSet(object oPlayer, string sVarName, int nType);
// Returns the last Unix time the given variable was updated
// * oPlayer - a player object (uses GetObjectUUID to identify)
// * sVarName - name of the variable to retrieve
// * nType - The SQLOCALSUUID_TYPE_* you wish to check
int SQLocalsUUID_GetLastUpdated_UnixEpoch(object oPlayer, string sVarName, int nType);
// Returns the last UTC time the given variable was updated
// * oPlayer - a player object (uses GetObjectUUID to identify)
// * sVarName - name of the variable to retrieve
// * nType - The SQLOCALSUUID_TYPE_* you wish to check
string SQLocalsUUID_GetLastUpdated_UTC(object oPlayer, string sVarName, int nType);


/* INTERNAL */
void SQLocalsUUID_CreateTable()
{
    sqlquery sql = SqlPrepareQueryCampaign(SQLLOCALUUID_DATABASE_NAME,
        "CREATE TABLE IF NOT EXISTS " + SQLOCALSUUID_TABLE_NAME + " (" +
        "type INTEGER, " +
        "uuid TEXT, " +
        "varname TEXT, " +
        "value TEXT, " +
        "timestamp INTEGER, " +
        "PRIMARY KEY(type, uuid, varname));");
    SqlStep(sql);
}

sqlquery SQLocalsUUID_PrepareSelect(object oPlayer, int nType, string sVarName)
{
    SQLocalsUUID_CreateTable();

    sqlquery sql = SqlPrepareQueryCampaign(SQLLOCALUUID_DATABASE_NAME,
        "SELECT value FROM " + SQLOCALSUUID_TABLE_NAME + " " +
        "WHERE type = @type AND uuid = @uuid AND varname = @varname;");

    SqlBindInt(sql, "@type", nType);
    SqlBindString(sql, "@uuid", GetObjectUUID(oPlayer));
    SqlBindString(sql, "@varname", sVarName);

    return sql;
}

sqlquery SQLocalsUUID_PrepareInsert(object oPlayer, int nType, string sVarName)
{
    SQLocalsUUID_CreateTable();

    sqlquery sql = SqlPrepareQueryCampaign(SQLLOCALUUID_DATABASE_NAME,
        "INSERT INTO " + SQLOCALSUUID_TABLE_NAME + " " +
        "(type, uuid, varname, value, timestamp) VALUES (@type, @uuid, @varname, @value, strftime('%s','now')) " +
        "ON CONFLICT (type, varname) DO UPDATE SET value = @value, timestamp = strftime('%s','now');");

    SqlBindInt(sql, "@type", nType);
    SqlBindString(sql, "@uuid", GetObjectUUID(oPlayer));
    SqlBindString(sql, "@varname", sVarName);

    return sql;
}

sqlquery SQLocalsUUID_PrepareDelete(object oPlayer, int nType, string sVarName)
{
    SQLocalsUUID_CreateTable();

    sqlquery sql = SqlPrepareQueryCampaign(SQLLOCALUUID_DATABASE_NAME,
        "DELETE FROM " + SQLOCALSUUID_TABLE_NAME + " " +
        "WHERE type = @type AND uuid = @uuid AND varname = @varname;");

    SqlBindInt(sql, "@type", nType);
    SqlBindString(sql, "@uuid", GetObjectUUID(oPlayer));
    SqlBindString(sql, "@varname", sVarName);

    return sql;
}

string SQLocalsUUID_LocationToString(location locLocation)
{
    string sAreaId = ObjectToString(GetAreaFromLocation(locLocation));
    vector vPosition = GetPositionFromLocation(locLocation);
    float fFacing = GetFacingFromLocation(locLocation);

    return "#A#" + sAreaId +
           "#X#" + FloatToString(vPosition.x, 0, 5) +
           "#Y#" + FloatToString(vPosition.y, 0, 5) +
           "#Z#" + FloatToString(vPosition.z, 0, 5) +
           "#F#" + FloatToString(fFacing, 0, 5) + "#";
}

location SQLocalsUUID_StringToLocation(string sLocation)
{
    location locLocation;

    int nLength = GetStringLength(sLocation);

    if(nLength > 0)
    {
        int nPos, nCount;

        nPos = FindSubString(sLocation, "#A#") + 3;
        nCount = FindSubString(GetSubString(sLocation, nPos, nLength - nPos), "#");
        object oArea = StringToObject(GetSubString(sLocation, nPos, nCount));

        nPos = FindSubString(sLocation, "#X#") + 3;
        nCount = FindSubString(GetSubString(sLocation, nPos, nLength - nPos), "#");
        float fX = StringToFloat(GetSubString(sLocation, nPos, nCount));

        nPos = FindSubString(sLocation, "#Y#") + 3;
        nCount = FindSubString(GetSubString(sLocation, nPos, nLength - nPos), "#");
        float fY = StringToFloat(GetSubString(sLocation, nPos, nCount));

        nPos = FindSubString(sLocation, "#Z#") + 3;
        nCount = FindSubString(GetSubString(sLocation, nPos, nLength - nPos), "#");
        float fZ = StringToFloat(GetSubString(sLocation, nPos, nCount));

        vector vPosition = Vector(fX, fY, fZ);

        nPos = FindSubString(sLocation, "#F#") + 3;
        nCount = FindSubString(GetSubString(sLocation, nPos, nLength - nPos), "#");
        float fOrientation = StringToFloat(GetSubString(sLocation, nPos, nCount));

        if (GetIsObjectValid(oArea))
            locLocation = Location(oArea, vPosition, fOrientation);
        else
            locLocation = GetStartingLocation();
    }

    return locLocation;
}
/* **** */

/* INT */

// Returns an integer stored in the campaign DB for oPlayer, or 0 on error
// * oPlayer - a player object (uses GetObjectUUID to identify)
// * sVarName - name of the variable to retrieve
int SQLocalsUUID_GetInt(object oPlayer, string sVarName)
{
    if (!GetIsPC(oPlayer) || sVarName == "") return 0;

    sqlquery sql = SQLocalsUUID_PrepareSelect(oPlayer, SQLOCALSUUID_TYPE_INT, sVarName);

    if (SqlStep(sql))
        return SqlGetInt(sql, 0);
    else
        return 0;
}

// Sets an integer stored in the campaign DB for oPlayer to the given value
// * oPlayer - a player object (uses GetObjectUUID to identify)
// * sVarName - name of the variable to retrieve
// * nValue - Value to store
void SQLocalsUUID_SetInt(object oPlayer, string sVarName, int nValue)
{
    if (!GetIsPC(oPlayer) || sVarName == "") return;

    sqlquery sql = SQLocalsUUID_PrepareInsert(oPlayer, SQLOCALSUUID_TYPE_INT, sVarName);
    SqlBindInt(sql, "@value", nValue);
    SqlStep(sql);
}

// Deletes an integer stored in the campaign DB for oPlayer
// * oPlayer - a player object (uses GetObjectUUID to identify)
// * sVarName - name of the variable to delete
void SQLocalsUUID_DeleteInt(object oPlayer, string sVarName)
{
    if (!GetIsPC(oPlayer) || sVarName == "") return;

    sqlquery sql = SQLocalsUUID_PrepareDelete(oPlayer, SQLOCALSUUID_TYPE_INT, sVarName);
    SqlStep(sql);
}
/* **** */

/* FLOAT */

// Returns a float stored in the campaign DB for oPlayer, or 0.0 on error
// * oPlayer - a player object (uses GetObjectUUID to identify)
// * sVarName - name of the variable to retrieve
float SQLocalsUUID_GetFloat(object oPlayer, string sVarName)
{
    if (!GetIsPC(oPlayer) || sVarName == "") return 0.0f;

    sqlquery sql = SQLocalsUUID_PrepareSelect(oPlayer, SQLOCALSUUID_TYPE_FLOAT, sVarName);

    if (SqlStep(sql))
        return SqlGetFloat(sql, 0);
    else
        return 0.0f;
}

// Sets a float stored in the campaign DB for oPlayer to the given value
// * oPlayer - a player object (uses GetObjectUUID to identify)
// * sVarName - name of the variable to retrieve
// * fValue - Value to store
void SQLocalsUUID_SetFloat(object oPlayer, string sVarName, float fValue)
{
    if (!GetIsPC(oPlayer) || sVarName == "") return;

    sqlquery sql = SQLocalsUUID_PrepareInsert(oPlayer, SQLOCALSUUID_TYPE_FLOAT, sVarName);
    SqlBindFloat(sql, "@value", fValue);
    SqlStep(sql);
}

// Deletes a float stored in the campaign DB for oPlayer
// * oPlayer - a player object (uses GetObjectUUID to identify)
// * sVarName - name of the variable to delete
void SQLocalsUUID_DeleteFloat(object oPlayer, string sVarName)
{
    if (!GetIsPC(oPlayer) || sVarName == "") return;

    sqlquery sql = SQLocalsUUID_PrepareDelete(oPlayer, SQLOCALSUUID_TYPE_FLOAT, sVarName);
    SqlStep(sql);
}
/* **** */

/* STRING */

// Returns an string stored in the campaign DB for oPlayer, or "" on error
// * oPlayer - a player object (uses GetObjectUUID to identify)
// * sVarName - name of the variable to retrieve
string SQLocalsUUID_GetString(object oPlayer, string sVarName)
{
    if (!GetIsPC(oPlayer) || sVarName == "") return "";

    sqlquery sql = SQLocalsUUID_PrepareSelect(oPlayer, SQLOCALSUUID_TYPE_STRING, sVarName);

    if (SqlStep(sql))
        return SqlGetString(sql, 0);
    else
        return "";
}

// Sets a string stored in the campaign DB for oPlayer to the given value
// * oPlayer - a player object (uses GetObjectUUID to identify)
// * sVarName - name of the variable to retrieve
// * sValue - Value to store
void SQLocalsUUID_SetString(object oPlayer, string sVarName, string sValue)
{
    if (!GetIsPC(oPlayer) || sVarName == "") return;

    sqlquery sql = SQLocalsUUID_PrepareInsert(oPlayer, SQLOCALSUUID_TYPE_STRING, sVarName);
    SqlBindString(sql, "@value", sValue);
    SqlStep(sql);
}

// Deletes a string stored in the campaign DB for oPlayer
// * oPlayer - a player object (uses GetObjectUUID to identify)
// * sVarName - name of the variable to delete
void SQLocalsUUID_DeleteString(object oPlayer, string sVarName)
{
    if (!GetIsPC(oPlayer) || sVarName == "") return;

    sqlquery sql = SQLocalsUUID_PrepareDelete(oPlayer, SQLOCALSUUID_TYPE_STRING, sVarName);
    SqlStep(sql);
}
/* **** */

/* OBJECT */


// Returns an object identifier stored in the campaign DB for oPlayer
// If this is used on a player it might return a "once valid" OID, so check
// with GetIsObjectValid, do not compare to OBJECT_INVALID.
// * oPlayer - a player object (uses GetObjectUUID to identify)
// * sVarName - name of the variable to retrieve
object SQLocalsUUID_GetObject(object oPlayer, string sVarName)
{
    if (!GetIsPC(oPlayer) || sVarName == "") return OBJECT_INVALID;

    sqlquery sql = SQLocalsUUID_PrepareSelect(oPlayer, SQLOCALSUUID_TYPE_OBJECT, sVarName);

    if (SqlStep(sql))
        return StringToObject(SqlGetString(sql, 0));
    else
        return OBJECT_INVALID;
}

// Sets an object identifier stored in the campaign DB for oPlayer to the given value
// * oPlayer - a player object (uses GetObjectUUID to identify)
// * sVarName - name of the variable to retrieve
// * oValue - Value to store
void SQLocalsUUID_SetObject(object oPlayer, string sVarName, object oValue)
{
    if (!GetIsPC(oPlayer) || sVarName == "") return;

    sqlquery sql = SQLocalsUUID_PrepareInsert(oPlayer, SQLOCALSUUID_TYPE_OBJECT, sVarName);
    SqlBindString(sql, "@value", ObjectToString(oValue));
    SqlStep(sql);
}

// Deletes an object identifier stored in the campaign DB for oPlayer
// * oPlayer - a player object (uses GetObjectUUID to identify)
// * sVarName - name of the variable to delete
void SQLocalsUUID_DeleteObject(object oPlayer, string sVarName)
{
    if (!GetIsPC(oPlayer) || sVarName == "") return;

    sqlquery sql = SQLocalsUUID_PrepareDelete(oPlayer, SQLOCALSUUID_TYPE_OBJECT, sVarName);
    SqlStep(sql);
}
/* **** */

/* VECTOR */

// Returns a vector stored in the campaign DB for oPlayer, or [0.0, 0.0, 0.0] on error
// * oPlayer - a player object (uses GetObjectUUID to identify)
// * sVarName - name of the variable to retrieve
vector SQLocalsUUID_GetVector(object oPlayer, string sVarName)
{
    if (!GetIsPC(oPlayer) || sVarName == "") return [0.0f, 0.0f, 0.0f];

    sqlquery sql = SQLocalsUUID_PrepareSelect(oPlayer, SQLOCALSUUID_TYPE_VECTOR, sVarName);

    if (SqlStep(sql))
        return SqlGetVector(sql, 0);
    else
        return [0.0f, 0.0f, 0.0f];
}

// Sets a vector stored in the campaign DB for oPlayer to the given value
// * oPlayer - a player object (uses GetObjectUUID to identify)
// * sVarName - name of the variable to retrieve
// * vValue - Value to store
void SQLocalsUUID_SetVector(object oPlayer, string sVarName, vector vValue)
{
    if (!GetIsPC(oPlayer) || sVarName == "") return;

    sqlquery sql = SQLocalsUUID_PrepareInsert(oPlayer, SQLOCALSUUID_TYPE_VECTOR, sVarName);
    SqlBindVector(sql, "@value", vValue);
    SqlStep(sql);
}

// Deletes a vector stored in the campaign DB for oPlayer
// * oPlayer - a player object (uses GetObjectUUID to identify)
// * sVarName - name of the variable to delete
void SQLocalsUUID_DeleteVector(object oPlayer, string sVarName)
{
    if (!GetIsPC(oPlayer) || sVarName == "") return;

    sqlquery sql = SQLocalsUUID_PrepareDelete(oPlayer, SQLOCALSUUID_TYPE_VECTOR, sVarName);
    SqlStep(sql);
}
/* **** */

/* LOCATION */

// Returns a location stored in the campaign DB for oPlayer, or the starting location of the module on error
// * oPlayer - a player object (uses GetObjectUUID to identify)
// * sVarName - name of the variable to retrieve
location SQLocalsUUID_GetLocation(object oPlayer, string sVarName)
{
    if (!GetIsPC(oPlayer) || sVarName == "") return GetStartingLocation();

    sqlquery sql = SQLocalsUUID_PrepareSelect(oPlayer, SQLOCALSUUID_TYPE_LOCATION, sVarName);

    if (SqlStep(sql))
        return SQLocalsUUID_StringToLocation(SqlGetString(sql, 0));
    else
        return GetStartingLocation();
}

// Sets a location stored in the campaign DB for oPlayer to the given value
// * oPlayer - a player object (uses GetObjectUUID to identify)
// * sVarName - name of the variable to retrieve
// * lValue - Value to store
void SQLocalsUUID_SetLocation(object oPlayer, string sVarName, location lValue)
{
    if (!GetIsPC(oPlayer) || sVarName == "") return;

    sqlquery sql = SQLocalsUUID_PrepareInsert(oPlayer, SQLOCALSUUID_TYPE_LOCATION, sVarName);
    SqlBindString(sql, "@value", SQLocalsUUID_LocationToString(lValue));
    SqlStep(sql);
}

// Deletes a location stored in the campaign DB for oPlayer
// * oPlayer - a player object (uses GetObjectUUID to identify)
// * sVarName - name of the variable to delete
void SQLocalsUUID_DeleteLocation(object oPlayer, string sVarName)
{
    if (!GetIsPC(oPlayer) || sVarName == "") return;

    sqlquery sql = SQLocalsUUID_PrepareDelete(oPlayer, SQLOCALSUUID_TYPE_LOCATION, sVarName);
    SqlStep(sql);
}
/* **** */

/* UTILITY */

// Deletes a set of locals stored in the campaign DB for oPlayer matching the given criteria
// * oPlayer - a player object (uses GetObjectUUID to identify)
// * nType - The SQLOCALSUUID_TYPE_* you wish to remove (default: SQLOCALSUUID_TYPE_ALL)
// * sLike - The string to compare with the SQL "like" comparison
// * sEscape - The escape character to use with the SQL "escape" keyword
void SQLocalsUUID_Delete(object oPlayer, int nType = SQLOCALSUUID_TYPE_ALL, string sLike = "", string sEscape = "")
{
    if (!GetIsPC(oPlayer) || nType < 0) return;

    SQLocalsUUID_CreateTable();

    sqlquery sql = SqlPrepareQueryCampaign(SQLLOCALUUID_DATABASE_NAME,
        "DELETE FROM " + SQLOCALSUUID_TABLE_NAME + " " +
        "WHERE " +
        (nType != SQLOCALSUUID_TYPE_ALL ? "AND type & @type " : " ") +
        (sLike != "" ? "AND varname LIKE @like " + (sEscape != "" ? "ESCAPE @escape" : "") : "") +
        ";");

    if (nType != SQLOCALSUUID_TYPE_ALL)
        SqlBindInt(sql, "@type", nType);
    if (sLike != "")
    {
        SqlBindString(sql, "@like", sLike);

        if (sEscape != "")
            SqlBindString(sql, "@escape", sEscape);
    }

    SqlStep(sql);
}

// Counts a set of locals stored in the campaign DB for oPlayer matching the given criteria
// * oPlayer - a player object (uses GetObjectUUID to identify)
// * nType - The SQLOCALSUUID_TYPE_* you wish to count (default: SQLOCALSUUID_TYPE_ALL)
// * sLike - The string to compare with the SQL "like" comparison
// * sEscape - The escape character to use with the SQL "escape" keyword
int SQLocalsUUID_Count(object oPlayer, int nType = SQLOCALSUUID_TYPE_ALL, string sLike = "", string sEscape = "")
{
    if (!GetIsPC(oPlayer) || nType < 0) return 0;

    SQLocalsUUID_CreateTable();

    sqlquery sql = SqlPrepareQueryObject(oPlayer,
        "SELECT COUNT(*) FROM " + SQLOCALSUUID_TABLE_NAME + " " +
        "WHERE " +
        (nType != SQLOCALSUUID_TYPE_ALL ? "AND type & @type " : " ") +
        (sLike != "" ? "AND varname LIKE @like " + (sEscape != "" ? "ESCAPE @escape" : "") : "") +
        ";");

    if (nType != SQLOCALSUUID_TYPE_ALL)
        SqlBindInt(sql, "@type", nType);
    if (sLike != "")
    {
        SqlBindString(sql, "@like", sLike);

        if (sEscape != "")
            SqlBindString(sql, "@escape", sEscape);
    }

    if (SqlStep(sql))
        return SqlGetInt(sql, 0);
    else
        return 0;
}

// Checks a locals stored in the campaign DB for oPlayer is set
// * oPlayer - a player object (uses GetObjectUUID to identify)
// * sVarName - name of the variable to retrieve
// * nType - The SQLOCALSUUID_TYPE_* you wish to check (default: SQLOCALSUUID_TYPE_ALL)
int SQLocalsUUID_IsSet(object oPlayer, string sVarName, int nType)
{
    if (!GetIsPC(oPlayer) || nType < 0) return 0;

    SQLocalsUUID_CreateTable();

    sqlquery sql = SqlPrepareQueryObject(oPlayer,
        "SELECT * FROM " + SQLOCALSUUID_TABLE_NAME + " " +
        "WHERE " +
        (nType != SQLOCALSUUID_TYPE_ALL ? "AND type & @type " : " ") +
        "AND varname = @varname;");

    if (nType != SQLOCALSUUID_TYPE_ALL)
        SqlBindInt(sql, "@type", nType);
    SqlBindString(sql, "@varname", sVarName);

    return SqlStep(sql);
}

// Returns the last Unix time the given variable was updated
// * oPlayer - a player object (uses GetObjectUUID to identify)
// * sVarName - name of the variable to retrieve
// * nType - The SQLOCALSUUID_TYPE_* you wish to check (default: SQLOCALSUUID_TYPE_ALL)
int SQLocalsUUID_GetLastUpdated_UnixEpoch(object oPlayer, string sVarName, int nType)
{
    if (!GetIsPC(oPlayer) || nType <= 0) return 0;

    SQLocalsUUID_CreateTable();

    sqlquery sql = SqlPrepareQueryObject(oPlayer,
        "SELECT timestamp FROM " + SQLOCALSUUID_TABLE_NAME + " " +
        "WHERE type = @type " +
        "AND varname = @varname;");

    SqlBindInt(sql, "@type", nType);
    SqlBindString(sql, "@varname", sVarName);

    if (SqlStep(sql))
        return SqlGetInt(sql, 0);
    else
        return 0;
}

// Returns the last UTC time the given variable was updated
// * oPlayer - a player object (uses GetObjectUUID to identify)
// * sVarName - name of the variable to retrieve
// * nType - The SQLOCALSUUID_TYPE_* you wish to check (default: SQLOCALSUUID_TYPE_ALL)
string SQLocalsUUID_GetLastUpdated_UTC(object oPlayer, string sVarName, int nType)
{
    if (!GetIsPC(oPlayer) || nType <= 0) return "";

    SQLocalsUUID_CreateTable();

    sqlquery sql = SqlPrepareQueryObject(oPlayer,
        "SELECT datetime(timestamp, 'unixepoch') FROM " + SQLOCALSUUID_TABLE_NAME + " " +
        "WHERE type = @type " +
        "AND varname = @varname;");

    SqlBindInt(sql, "@type", nType);
    SqlBindString(sql, "@varname", sVarName);

    if (SqlStep(sql))
        return SqlGetString(sql, 0);
    else
        return "";
}
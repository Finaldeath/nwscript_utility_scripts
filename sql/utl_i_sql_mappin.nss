//::///////////////////////////////////////////////
//:: Persistent Map Functions
//:: utl_i_sql_mappin.nss
//:://////////////////////////////////////////////
/*
    Contributed by Orth. This allows you to save a players map progress and pins made
    persistently into the players sqlite BIC.

    Areas are referenced by resref.

    Run GetMapTilesExplored(oPC, oArea) OnAreaEnter
    Run GetMapPins(oPC) OnClientEnter
    Run SaveMapTilesExplored(oPC, oArea) OnAreaExit
    Run SaveMapPins(oPC) whenever you need to (saves pins for all areas) but recommended to do
    before exporting characters and reguarly.
*/
//:://////////////////////////////////////////////
//:: Part of the nwscript_utility_scripts project; see for dates/creator info
//:: https://github.com/Finaldeath/nwscript_utility_scripts
//:://////////////////////////////////////////////

// Finds an area object based upon a resref
// * sResRef - The resref of the area to find
object GetAreaByResRef(string sResRef);

// Creates the map pin sqlite table if it doesn't exist
// * oPC - the PC to create the Map Pin table for, created on BIC
void CreateMapPinTable(object oPC);

// Create the map exploration state table if it doesn't exist
// * oPC - the PC to create the Map Explored table for, created on BIC
void CreateMapExploredTable(object oPC);

// Gets the persistent map pin data for the PC for all areas.
// Run OnClientEnter.
// * oPC - the PC to get map pins for
void GetMapPins(object oPC);

// Saves the map pin data for the PC for all areas on the sqlite bic
// Run at a suitable interval, eg before exporting all character BICs.
// * oPC - the PC to save map pins for
void SaveMapPins(object oPC);

// Gets the persistent map tiles explored state for the PC for the specified area
// Run OnAreaEnter for entering PCs
// * oPC - the PC to get map exploration information for
// * oArea - the area to check exploration information for
void GetMapTilesExplored(object oPC, object oArea);

// Saves the persistent map tiles explored state for the PC for the specified area
// Run OnAreaExit for exiting PCs
// * oPC - the PC to save map exploration information for
// * oArea - the area to save exploration information for
void SaveMapTilesExplored(object oPC, object oArea);

/* INTERNAL */

// Finds an area object based upon a resref
// * sResRef - The resref of the area to find
object GetAreaByResRef(string sResRef)
{
    object oFoundArea = OBJECT_INVALID;
    object oArea      = GetFirstArea();
    while (oArea != OBJECT_INVALID)
    {
        if (GetResRef(oArea) == sResRef)
        {
            oFoundArea = oArea;
            break;
        }
        oArea = GetNextArea();
    }
    return oFoundArea;
}

// Creates the map pin sqlite table if it doesn't exist
// * oPC - the PC to create the Map Pin table for, created on BIC
void CreateMapPinTable(object oPC)
{
    sqlquery sql = SqlPrepareQueryObject(oPC,
                                         "CREATE TABLE IF NOT EXISTS map_pins (" +
                                             "id INTEGER, " +
                                             "area_resref TEXT, " +
                                             "xpos FLOAT, " +
                                             "ypos FLOAT, " +
                                             "ntry TEXT, " +
                                             "PRIMARY KEY(id));");
    SqlStep(sql);
}

// Create the map exploration state table if it doesn't exist
// * oPC - the PC to create the Map Explored table for, created on BIC
void CreateMapExploredTable(object oPC)
{
    sqlquery sql = SqlPrepareQueryObject(oPC,
                                         "CREATE TABLE IF NOT EXISTS map_tiles_explored (" +
                                             "area_resref TEXT, " +
                                             "x INT, " +
                                             "y INT, " +
                                             "PRIMARY KEY(area_resref, x, y));");
    SqlStep(sql);
}
/* **** */

// Gets the persistent map pin data for the PC for all areas.
// Run OnClientEnter.
// * oPC - the PC to get map pins for
void GetMapPins(object oPC)
{
    if (oPC == OBJECT_INVALID)
        return;

    int iPins = GetLocalInt(oPC, "NW_TOTAL_MAP_PINS");
    if (iPins > 0)
        return;

    CreateMapPinTable(oPC);

    int nIter    = 1;
    sqlquery sql = SqlPrepareQueryObject(oPC, "SELECT area_resref, xpos, ypos, ntry FROM map_pins;");
    while (SqlStep(sql))
    {
        string sIter  = IntToString(nIter);
        object oArea  = GetAreaByResRef(SqlGetString(sql, 0));
        float fX      = SqlGetFloat(sql, 1);
        float fY      = SqlGetFloat(sql, 2);
        string sEntry = SqlGetString(sql, 3);
        SetLocalString(oPC, "NW_MAP_PIN_NTRY_" + sIter, sEntry);
        SetLocalFloat(oPC, "NW_MAP_PIN_XPOS_" + sIter, fX);
        SetLocalFloat(oPC, "NW_MAP_PIN_YPOS_" + sIter, fY);
        SetLocalObject(oPC, "NW_MAP_PIN_AREA_" + sIter, oArea);
        nIter++;
    }
    SetLocalInt(oPC, "NW_TOTAL_MAP_PINS", nIter - 1);
}

// Saves the map pin data for the PC for all areas on the sqlite bic
// Run at a suitable interval, eg before exporting all character BICs.
// * oPC - the PC to save map pins for
void SaveMapPins(object oPC)
{
    if (oPC == OBJECT_INVALID)
        return;

    int iPins = GetLocalInt(oPC, "NW_TOTAL_MAP_PINS");
    if (iPins == 0)
        return;

    // Easiest to just truncate the table and insert them all again
    sqlquery sql = SqlPrepareQueryObject(oPC, "DELETE FROM map_pins;");
    SqlStep(sql);
    int iIter = 1;

    // We build the bindings first for SQLite so instead of doing many INSERTs we just do one
    string sSQL = "INSERT INTO map_pins (id, area_resref, xpos, ypos, ntry) VALUES ";
    while (iIter <= iPins)
    {
        string sIter = IntToString(iIter);
        sSQL += "(@id" + sIter + ", @area_resref" + sIter + ", @xpos" + sIter + ", @ypos" + sIter + ", @ntry" + sIter + "),";
        iIter++;
    }
    sSQL = GetSubString(sSQL, 0, GetStringLength(sSQL) - 1) + ";";
    sql  = SqlPrepareQueryObject(oPC, sSQL);

    iIter = 1;
    while (iIter <= iPins)
    {
        string sIter = IntToString(iIter);
        SqlBindInt(sql, "@id" + sIter, iIter);
        SqlBindString(sql, "@area_resref" + sIter, GetResRef(GetLocalObject(oPC, "NW_MAP_PIN_AREA_" + sIter)));
        SqlBindFloat(sql, "@xpos" + sIter, GetLocalFloat(oPC, "NW_MAP_PIN_XPOS_" + sIter));
        SqlBindFloat(sql, "@ypos" + sIter, GetLocalFloat(oPC, "NW_MAP_PIN_YPOS_" + sIter));
        SqlBindString(sql, "@ntry" + sIter, GetLocalString(oPC, "NW_MAP_PIN_NTRY_" + sIter));
        iIter++;
    }
    SqlStep(sql);
}

// Gets the persistent map tiles explored state for the PC for the specified area
// Run OnAreaEnter for entering PCs
// * oPC - the PC to get map exploration information for
// * oArea - the area to check exploration information for
void GetMapTilesExplored(object oPC, object oArea)
{
    if (oArea == OBJECT_INVALID || oPC == OBJECT_INVALID)
        return;

    CreateMapExploredTable(oPC);

    int nIter    = 1;
    sqlquery sql = SqlPrepareQueryObject(oPC, "SELECT x, y FROM map_tiles_explored WHERE area_resref = @area_resref;");
    SqlBindString(sql, "@area_resref", GetResRef(oArea));
    while (SqlStep(sql))
    {
        SetTileExplored(oPC, oArea, SqlGetInt(sql, 0), SqlGetInt(sql, 1), 1);
    }
}

// Saves the persistent map tiles explored state for the PC for the specified area
// Run OnAreaExit for exiting PCs
// * oPC - the PC to save map exploration information for
// * oArea - the area to save exploration information for
void SaveMapTilesExplored(object oPC, object oArea)
{
    if (oArea == OBJECT_INVALID || oPC == OBJECT_INVALID)
        return;

    string sSQL = "INSERT or IGNORE INTO map_tiles_explored (area_resref, x, y) VALUES ";

    int iWidthInTiles  = GetAreaSize(AREA_WIDTH, oArea);
    int iHeightInTiles = GetAreaSize(AREA_HEIGHT, oArea);
    int iIter          = 0;
    int x              = 0;
    while (x < iWidthInTiles)
    {
        int y = 0;
        while (y < iHeightInTiles)
        {
            string sIter = IntToString(iIter);
            if (GetTileExplored(oPC, oArea, x, y) == 1)
            {
                sSQL += "(@area_resref" + sIter + ",@x" + sIter + ",@y" + sIter + "),";
                iIter++;
            }
            y++;
        }
        x++;
    }
    sSQL         = GetSubString(sSQL, 0, GetStringLength(sSQL) - 1);
    sqlquery sql = SqlPrepareQueryObject(oPC, sSQL);

    x     = 0;
    iIter = 0;
    while (x < iWidthInTiles)
    {
        int y = 0;
        while (y < iHeightInTiles)
        {
            string sIter = IntToString(iIter);
            if (GetTileExplored(oPC, oArea, x, y) == 1)
            {
                SqlBindString(sql, "@area_resref" + sIter, GetResRef(oArea));
                SqlBindInt(sql, "@x" + sIter, x);
                SqlBindInt(sql, "@y" + sIter, y);
                iIter++;
            }
            y++;
        }
        x++;
    }
    SqlStep(sql);
}

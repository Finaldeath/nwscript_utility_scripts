//::///////////////////////////////////////////////
//:: Utility Include: SQL
//:: utl_i_sql.nss
//:://////////////////////////////////////////////
/*
    8193.14 introduced sqlite functionality. Here are some functions related to that.

    Some may be split into separate include files later.

    To use these, first of all understand some SQL, recommended reading:

    * https://nwnlexicon.com/index.php?title=SQLite
    * https://www.sqlite.org/docs.html
*/
//:://////////////////////////////////////////////
//:: Part of the nwscript_utility_scripts project; see for dates/creator info
//:: https://github.com/Finaldeath/nwscript_utility_scripts
//:://////////////////////////////////////////////

// Returns TRUE if sTableName exists in sDatabase.
// * sDatabase - Database to query
// * sTableName - Table name to check exists
int SqlGetTableExistsCampaign(string sDatabase, string sTableName);

// Returns TRUE if sTableName exists on oObject.
// * oObject - Player or module object
// * sTableName - Table name to check exists
int SqlGetTableExistsObject(object oObject, string sTableName);

// Returns the last insert id for sDatabase, -1 on error.
// * sDatabase - Campaign database name to check the last insert ID of
int SqlGetLastInsertIdCampaign(string sDatabase);

// Returns the last insert id for oObject, -1 on error.
// * oObject - Player or module object to check the last insert ID of
int SqlGetLastInsertIdObject(object oObject);



// Returns TRUE if sTableName exists in sDatabase.
// * sDatabase - Database to query
// * sTableName - Table name to check exists
int SqlGetTableExistsCampaign(string sDatabase, string sTableName)
{
    string sQuery = "SELECT name FROM sqlite_master WHERE type='table' AND name=@tableName;";
    sqlquery sql = SqlPrepareQueryCampaign(sDatabase, sQuery);
    SqlBindString(sql, "@tableName", sTableName);

    return SqlStep(sql);
}

// Returns TRUE if sTableName exists on oObject.
// * oObject - Player or module object
// * sTableName - Table name to check exists
int SqlGetTableExistsObject(object oObject, string sTableName)
{
    string sQuery = "SELECT name FROM sqlite_master WHERE type='table' AND name=@tableName;";
    sqlquery sql = SqlPrepareQueryObject(oObject, sQuery);
    SqlBindString(sql, "@tableName", sTableName);

    return SqlStep(sql);
}

// Returns the last insert id for sDatabase, -1 on error.
// * sDatabase - Campaign database name to check the last insert ID of
int SqlGetLastInsertIdCampaign(string sDatabase)
{
    sqlquery sql = SqlPrepareQueryCampaign(sDatabase, "SELECT last_insert_rowid();");

    return SqlStep(sql) ? SqlGetInt(sql, 0) : -1;
}

// Returns the last insert id for oObject, -1 on error.
// * oObject - Player or module object to check the last insert ID of
int SqlGetLastInsertIdObject(object oObject)
{
    sqlquery sql = SqlPrepareQueryObject(oObject, "SELECT last_insert_rowid();");

    return SqlStep(sql) ? SqlGetInt(sql, 0) : -1;
}

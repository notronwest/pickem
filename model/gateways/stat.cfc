component accessors="true" extends="model.base" {

/*
Author: 	
	Ron West
Name:
	$getRecordByType
Summary:
	Gets the wins you have for the type of team
Returns:
	Query qryRecord
Arguments:
	Numeric nTypeID
	Numeric nUserID
	Numeric nSeasonID
History:
	2015-10-07 - RLW - Created
*/
public Query function getRecordByType( Required Numeric nTypeID, Required Numeric nUserID, Required Numeric nSeasonID ){
	var qryRecord = variables.dbService.runQuery("SELECT COALESCE(sum(case when p.nWin = 1 then 1 end), 0) as nWins,
COALESCE(sum(case when p.nWin = 0 then 1 end), 0) as nLosses
FROM team t
join pick p
on t.nTeamID = p.nTeamID
join game g
on p.nGameID = g.nGameID
join `week` w
on g.nWeekID = w.nWeekID
where t.nType = #arguments.nTypeID#
and p.nUserID = #arguments.nUserID#
and w.nSeasonID = #arguments.nSeasonID#");
	return qryRecord;
}

/*
Author: 	
	Ron West
Name:
	$getRecordBySpread
Summary:
	Gets the record by a given spread
Returns:
	Query qryRecord
Arguments:
	Numeric nSpread
	String sSpreadOperator
	Numeric nUserID
	Numeric nSeasonID
History:
	2015-10-07 - RLW - Created
*/
public Query function getRecordBySpread( Required Numeric nSpread, Required String sSpreadOperator, Required Numeric nUserID, Required Numeric nType, Required Numeric nSeasonID ){
	var qryRecord = variables.dbService.runQuery("SELECT COALESCE(sum(case when p.nWin = 1 then 1 end), 0) as nWins,
COALESCE(sum(case when p.nWin = 0 then 1 end), 0) as nLosses
FROM team t
join pick p
on t.nTeamID = p.nTeamID
join game g
on p.nGameID = g.nGameID
join `week` w
on g.nWeekID = w.nWeekID
where t.nType = #arguments.nType#
and g.nSpread #arguments.sSpreadOperator# #arguments.nSpread#
and p.nUserID = #arguments.nUserID#
and w.nSeasonID = #arguments.nSeasonID#");
	return qryRecord;
}

/*
Author: 	
	Ron West
Name:
	$getRecordFavoriteBySpread
Summary:
	Gets the record by a given spread
Returns:
	Query qryRecord
Arguments:
	Numeric nSpread
	String sSpreadOperator
	Numeric nUserID
	Numeric nSeasonID
History:
	2015-10-07 - RLW - Created
*/
public Query function getRecordFavoriteBySpread( Required Numeric nSpread, Required String sSpreadOperator, Required Numeric nUserID, Required Numeric nType, Required Numeric nSeasonID ){
	var qryRecord = variables.dbService.runQuery("SELECT COALESCE(sum(case when p.nWin = 1 then 1 end), 0) as nWins,
COALESCE(sum(case when p.nWin = 0 then 1 end), 0) as nLosses
FROM team t
join pick p
on t.nTeamID = p.nTeamID
join game g
on p.nGameID = g.nGameID
join `week` w
on g.nWeekID = w.nWeekID
where t.nType = #arguments.nType#
and ( ( upper(g.sSpreadFavor) = 'HOME' and nWinner = nHomeTeamID ) or ( upper(g.sSpreadFavor) = 'AWAY' and nWinner = nAwayTeamID ) )
and g.nSpread #arguments.sSpreadOperator# #arguments.nSpread#
and p.nUserID = #arguments.nUserID#
and w.nSeasonID = #arguments.nSeasonID#");
	return qryRecord;
}

/*
Author: 	
	Ron West
Name:
	$getRecordUnderdogBySpread
Summary:
	Gets the record by a given spread
Returns:
	Query qryRecord
Arguments:
	Numeric nSpread
	String sSpreadOperator
	Numeric nUserID
	Numeric nSeasonID
History:
	2015-10-07 - RLW - Created
*/
public Query function getRecordUnderdogBySpread( Required Numeric nSpread, Required String sSpreadOperator, Required Numeric nUserID, Required Numeric nType, Required Numeric nSeasonID ){
	var qryRecord = variables.dbService.runQuery("SELECT COALESCE(sum(case when p.nWin = 1 then 1 end), 0) as nWins,
COALESCE(sum(case when p.nWin = 0 then 1 end), 0) as nLosses
FROM team t
join pick p
on t.nTeamID = p.nTeamID
join game g
on p.nGameID = g.nGameID
join `week` w
on g.nWeekID = w.nWeekID
where t.nType = #arguments.nType#
and ( ( upper(g.sSpreadFavor) = 'HOME' and nWinner = nAwayTeamID ) or ( upper(g.sSpreadFavor) = 'AWAY' and nWinner = nHomeTeamID ) )
and g.nSpread #arguments.sSpreadOperator# #arguments.nSpread#
and p.nUserID = #arguments.nUserID#
and w.nSeasonID = #arguments.nSeasonID#");
	return qryRecord;
}

/*
Author: 	
	Ron West
Name:
	$getRecordHomeTeamBySpread
Summary:
	Gets the record by a given spread for the home team
Returns:
	Query qryRecord
Arguments:
	Numeric nSpread
	String sSpreadOperator
	Numeric nUserID
	Numeric nSeasonID
History:
	2015-10-07 - RLW - Created
*/
public Query function getRecordHomeTeamBySpread( Required Numeric nSpread, Required String sSpreadOperator, Required Numeric nUserID, Required Numeric nType, Required Numeric nSeasonID ){
	var qryRecord = variables.dbService.runQuery("SELECT COALESCE(sum(case when p.nWin = 1 then 1 end), 0) as nWins,
COALESCE(sum(case when p.nWin = 0 then 1 end), 0) as nLosses
FROM team t
join pick p
on t.nTeamID = p.nTeamID
join game g
on p.nGameID = g.nGameID
join `week` w
on g.nWeekID = w.nWeekID
where t.nType = #arguments.nType#
and upper(g.sSpreadFavor) = 'HOME'
and nWinner = nHomeTeamID
and g.nSpread #arguments.sSpreadOperator# #arguments.nSpread#
and p.nUserID = #arguments.nUserID#
and w.nSeasonID = #arguments.nSeasonID#");
	return qryRecord;
}

/*
Author: 	
	Ron West
Name:
	$getRecordAwayTeamBySpread
Summary:
	Gets the record by a given spread for the away team
Returns:
	Query qryRecord
Arguments:
	Numeric nSpread
	String sSpreadOperator
	Numeric nUserID
	Numeric nSeasonID
History:
	2015-10-07 - RLW - Created
*/
public Query function getRecordAwayTeamBySpread( Required Numeric nSpread, Required String sSpreadOperator, Required Numeric nUserID, Required Numeric nType, Required Numeric nSeasonID ){
	var qryRecord = variables.dbService.runQuery("SELECT COALESCE(sum(case when p.nWin = 1 then 1 end), 0) as nWins,
COALESCE(sum(case when p.nWin = 0 then 1 end), 0) as nLosses
FROM team t
join pick p
on t.nTeamID = p.nTeamID
join game g
on p.nGameID = g.nGameID
join `week` w
on g.nWeekID = w.nWeekID
where t.nType = #arguments.nType#
and upper(g.sSpreadFavor) = 'AWAY'
and nWinner = nAwayTeamID
and g.nSpread #arguments.sSpreadOperator# #arguments.nSpread#
and p.nUserID = #arguments.nUserID#
and w.nSeasonID = #arguments.nSeasonID#");
	return qryRecord;
}

/*
Author: 	
	Ron West
Name:
	$getRecordHomeTeamFavored
Summary:
	Gets the record when home team is favored
Returns:
	Query qryRecord
Arguments:
	Numeric nUserID
	Numeric nType
	Numeric nSeasonID
History:
	2015-10-07 - RLW - Created
*/
public Query function getRecordHomeTeamFavored( Required Numeric nUserID, Required Numeric nType, Required Numeric nSeasonID ){
	var qryRecord = variables.dbService.runQuery("SELECT COALESCE(sum(case when p.nWin = 1 then 1 end), 0) as nWins,
COALESCE(sum(case when p.nWin = 0 then 1 end), 0) as nLosses
FROM team t
join pick p
on t.nTeamID = p.nTeamID
join game g
on p.nGameID = g.nGameID
join `week` w
on g.nWeekID = w.nWeekID
where t.nType = #arguments.nType#
and upper(g.sSpreadFavor) = 'HOME'
and g.nWinner = g.nHomeTeamID
and p.nUserID = #arguments.nUserID#
and w.nSeasonID = #arguments.nSeasonID#");
	return qryRecord;
}

/*
Author: 	
	Ron West
Name:
	$getRecordAwayTeamFavored
Summary:
	Gets the record when away team is favored
Returns:
	Query qryRecord
Arguments:
	Numeric nUserID
	Numeric nType
	Numeric nSeasonID
History:
	2015-10-07 - RLW - Created
*/
public Query function getRecordAwayTeamFavored( Required Numeric nUserID, Required Numeric nType, Required Numeric nSeasonID ){
	var qryRecord = variables.dbService.runQuery("SELECT COALESCE(sum(case when p.nWin = 1 then 1 end), 0) as nWins,
COALESCE(sum(case when p.nWin = 0 then 1 end), 0) as nLosses
FROM team t
join pick p
on t.nTeamID = p.nTeamID
join game g
on p.nGameID = g.nGameID
join `week` w
on g.nWeekID = w.nWeekID
where t.nType = #arguments.nType#
and upper(g.sSpreadFavor) = 'AWAY'
and nWinner = nAwayTeamID
and p.nUserID = #arguments.nUserID#
and w.nSeasonID = #arguments.nSeasonID#");
	return qryRecord;
}

/*
Author: 	
	Ron West
Name:
	$getRecordHomeTeamUnderdog
Summary:
	Gets the record when home team is favored
Returns:
	Query qryRecord
Arguments:
	Numeric nUserID
	Numeric nType
	Numeric nSeasonID
History:
	2015-10-07 - RLW - Created
*/
public Query function getRecordHomeTeamUnderdog( Required Numeric nUserID, Required Numeric nType, Required Numeric nSeasonID ){
	var qryRecord = variables.dbService.runQuery("SELECT COALESCE(sum(case when p.nWin = 1 then 1 end), 0) as nWins,
COALESCE(sum(case when p.nWin = 0 then 1 end), 0) as nLosses
FROM team t
join pick p
on t.nTeamID = p.nTeamID
join game g
on p.nGameID = g.nGameID
join `week` w
on g.nWeekID = w.nWeekID
where t.nType = #arguments.nType#
and upper(g.sSpreadFavor) = 'AWAY'
and g.nWinner = g.nHomeTeamID
and p.nUserID = #arguments.nUserID#
and w.nSeasonID = #arguments.nSeasonID#");
	return qryRecord;
}

/*
Author: 	
	Ron West
Name:
	$getRecordAwayTeamUnderdog
Summary:
	Gets the record when away team is underdog
Returns:
	Query qryRecord
Arguments:
	Numeric nUserID
	Numeric nType
	Numeric nSeasonID
History:
	2015-10-07 - RLW - Created
*/
public Query function getRecordAwayTeamUnderdog( Required Numeric nUserID, Required Numeric nType, Required Numeric nSeasonID ){
	var qryRecord = variables.dbService.runQuery("SELECT COALESCE(sum(case when p.nWin = 1 then 1 end), 0) as nWins,
COALESCE(sum(case when p.nWin = 0 then 1 end), 0) as nLosses
FROM team t
join pick p
on t.nTeamID = p.nTeamID
join game g
on p.nGameID = g.nGameID
join `week` w
on g.nWeekID = w.nWeekID
where t.nType = #arguments.nType#
and upper(g.sSpreadFavor) = 'HOME'
and nWinner = nAwayTeamID
and p.nUserID = #arguments.nUserID#
and w.nSeasonID = #arguments.nSeasonID#");
	return qryRecord;
}

/*
Author: 	
	Ron West
Name:
	$getTeamRecord
Summary:
	Gets the record for the team in the current conditions
Returns:
	Query qryRecord
Arguments:
	Numeric nTeamID
	Numeric nSpread
	Boolean bFavored
	String sLocation
	Numeric nSeasonID
History:
	2015-10-08 - RLW - Created
*/
public Query function getTeamRecord( Required Numeric nTeamID, Required Numeric nSpread, Required Boolean bFavored, Required String sLocation,  Required Numeric nSeasonID ){
	var sField = "nHomeTeamID";
	var sOperator = "<=";
	if( compareNoCase(arguments.sLocation, "away") eq 0 ){
		sField = "nAwayTeamID";
	}
	if( arguments.bFavored ){
		sOperator = ">=";
	}
	var qryRecord = variables.dbService.runQuery("SELECT COALESCE(sum(case when g.nWinner = #arguments.nTeamID# AND g.#sField# = #arguments.nTeamID# AND nSpread #sOperator# #arguments.nSpread# then 1 end), 0) as nWins,
COALESCE(sum(case when g.nWinner != #arguments.nTeamID# AND g.#sField# = #arguments.nTeamID# AND nSpread #sOperator# #arguments.nSpread# then 1 end), 0) as nLosses
FROM game g
JOIN `week` w
on g.nWeekID = w.nWeekID 
WHERE w.nSeasonID = #arguments.nSeasonID#");
	return qryRecord;
}

}
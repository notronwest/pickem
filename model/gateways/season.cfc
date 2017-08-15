component accessors="true" extends="model.baseORMGateway" {


/*
Author:
	Ron West
Name:
	$getSeason
Summary:
	Get seasons by season
Returns:
	Array arSeason
Arguments:
	String nSeasonID
History:
	2012-09-12 - RLW - Created
*/
public Array function getSeason( Required String nSeasonID ){
	var arSeasons = ormExecuteQuery( "from season where nSeasonID = :nSeasonID order by nWeekNumber", { nSeasonID = "#arguments.nSeasonID#" } );
	return arSeasons;
}

/*
Author:
	Ron West
Name:
	$getAllSeasons
Summary:
	Gets all seasons
Returns:
	Array arSeasons
Arguments:
	Void
History:
	2015-08-08 - RLW - Created
*/
public Array function getAll(){
	var arSeasons = ormExecuteQuery("from season order by dtStart desc");
	return arSeasons;
}

/*
Author:
	Ron West
Name:
	$getCurrentSeason
Summary:
	Gets all seasons
Returns:
	model.beans.season oSeason
Arguments:
	Void
History:
	2016-08-26 - RLW - Created
*/
public model.beans.season function getCurrentSeason( Required string sLeagueID ){
	var arSeasons = ormExecuteQuery("from season where sLeagueID = :sLeagueID order by dtStart desc", { sLeagueID = arguments.sLeagueID} );
	return (arrayLen(arSeasons) ? arSeasons[1] : get());
}


/*
Author:
	Ron West
Name:
	$getSeasonByYear
Summary:
	Gets a season by year
Returns:
	model.beans.season oSeason
Arguments:
	Void
History:
	2017-08-13 - RLW - Created
*/
public model.beans.season function getLastYearsSeason(Required string sLeagueID,  string sYear = dateFormat(dateAdd("yyyy", -1, now()), 'yyyy') ){
	var arSeasons = ormExecuteQuery("from season where sLeagueID = :sLeagueID and year(dtStart) = :sYear", { sLeagueID = arguments.sLeagueID, sYear = arguments.sYear} );
	return (arrayLen(arSeasons) ? arSeasons[1] : get());
}
}

component accessors="true" extends="model.base" {
	
/*
Author: 	
	Ron West
Name:
	$get
Summary:
	Gets the standing object
Returns:
	Standing oStanding
Arguments:
	Numeric nStandingID
History:
	2012-09-12 - RLW - Created
*/
public model.beans.standing function get( Numeric nStandingID=0 ){
	var oStanding = new model.beans.standing();
	var arStanding = [];
	if( arguments.nStandingID != 0 ) {
		arStanding = entityLoad("standing", arguments.nStandingID);
		if( arrayLen(arStanding) gt 0 ){
			oStanding = arStanding[1];
		}
	}
	return oStanding;
}

/*
Author: 	
	Ron West
Name:
	$update
Summary:
	Updates the standing object with new data
Returns:
	Standing oStanding
Arguments:
	Standing oStanding
	Struct stStanding
History:
	2012-09-12 - RLW - Created
*/
public model.beans.standing function update( Required model.beans.standing oStanding, Required Struct stStanding ){
	arguments.oStanding.setNWeekID(arguments.stStanding.nWeekID);
	arguments.oStanding.setNWins(arguments.stStanding.nWins);
	arguments.oStanding.setNLosses(arguments.stStanding.nLosses);
	arguments.oStanding.setNUserID(arguments.stStanding.nUserID);
	//arguments.oStanding.setNTiebreaks(arguments.stStanding.nTiebreaks);
	arguments.oStanding.setSSeason(arguments.stStanding.sSeason);
	arguments.oStanding = save(oStanding);
	return arguments.oStanding;
}
/*
Author: 	
	Ron West
Name:
	$save
Summary:
	Saves the standing entity
Returns:
	Standing oStanding
Arguments:
	Standing oStanding
History:
	2012-09-12 - RLW - Created
*/
public model.beans.standing function save( Required model.beans.standing oStanding){
	entitySave(arguments.oStanding);
	ormFlush();
	return arguments.oStanding;
}

/*
Author: 	
	Ron West
Name:
	$savePlace
Summary:
	Saves the place for the user for this week
Returns:
	Standing oStanding
Arguments:
	Numeric nStandingID
	Numeric nPlace
History:
	2012-09-12 - RLW - Created
*/
public model.beans.standing function savePlace( Required Numeric nStandingID, Required Numeric nPlace){
	var oStanding = get(arguments.nStandingID);
	oStanding.setNPlace(arguments.nPlace);
	save(oStanding);
	return oStanding;
}

/*
Author: 	
	Ron West
Name:
	$delete
Summary:
	Deletes the standing entity
Returns:
	Boolean bDeleted
Arguments:
	Standing oStanding
History:
	2012-09-12 - RLW - Created
*/
public Boolean function delete( Required model.beans.standing oStanding){
	var bDeleted = true;
	try{
		entityDelete(arguments.oStanding);
		ormFlush();
	} catch (any e){
		registerError("Error deleting standing bean", e);
		bDeleted = false;
	}
	return bDeleted;
}


/*
Author: 	
	Ron West
Name:
	$getSeason
Summary:
	Gets all standings
Returns:
	Array arStandings
Arguments:
	String sSeason
History:
	2012-09-12 - RLW - Created
*/
public Array function getSeason( Required String sSeason ){
	var arStandings = ormExecuteQuery( "from standing where sSeason = :sSeason order by nWeekID desc, nHighestTiebreak desc", { sSeason = "#arguments.sSeason#" } );
	return arStandings;
}

/*
Author: 	
	Ron West
Name:
	$getUserWeek
Summary:
	Gets standing for this user by week
Returns:
	Array arStandings
Arguments:
	Numeric nUserID
	Numeric nWeekID
History:
	2012-09-12 - RLW - Created
*/
public Array function getUserWeek( Required Numeric nUserID, Required Numeric nWeekID ){
	var arStandings = ormExecuteQuery( "from standing where nUserID = :nUserID and nWeekID = :nWeekID", { nUserID = "#arguments.nUserID#", nWeekID = "#arguments.nWeekID#" } );
	return arStandings;
}

/*
Author: 	
	Ron West
Name:
	$deleteUserWeek
Summary:
	Delete standing for this user by week
Returns:
	Array arStandings
Arguments:
	Numeric nUserID
	Numeric nWeekID
History:
	2012-09-12 - RLW - Created
*/
public Void function deleteUserWeek( Required Numeric nUserID, Required Numeric nWeekID ){
	var arStandings = getUserWeek(arguments.nUserID, arguments.nWeekID);
	var itm = 1;
	for( itm; itm lte arrayLen(arStandings); itm++ ){
		delete(arStandings[itm]);
	}
}

/*
Author: 	
	Ron West
Name:
	$getWeek
Summary:
	Gets standing for this week
Returns:
	Array arStandings
Arguments:
	Numeric nWeekID
History:
	2012-09-12 - RLW - Created
*/
public Array function getWeek( Required Numeric nWeekID ){
	var arStandings = ormExecuteQuery( "from standing where nWeekID = :nWeekID order by nWins desc, nHighestTiebreak desc", { nWeekID = "#arguments.nWeekID#" } );
	return arStandings;
}

/*
Author: 	
	Ron West
Name:
	$getByUser
Summary:
	Gets standing for the given user
Returns:
	Array arStandings
Arguments:
	Numeric nUserID
History:
	2014-09-10 - RLW - Created
*/
public Array function getByUser( Required Numeric nUserID ){
	var arStandings = ormExecuteQuery( "from standing where nUserID = :nUserID", { "nUserID" = arguments.nUserID} );
	return arStandings;
}

/*
Author: 	
	Ron West
Name:
	$updateStandings
Summary:
	Updates the standings for the week
Returns:
	void
Arguments:
	Numeric nWeekID
	String sSeason
History:
	2014-09-11 - RLW - Created
*/
public void function updateStandings( Required Numeric nWeekID, Required String sSeason){
	variables.dbService.runStoredProc("updateStandings", [arguments.nWeekID, arguments.sSeason]);
}

}
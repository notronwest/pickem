component accessors="true" extends="model.services.baseService" {
property name="teamService";
property name="gameService";
property name="weekGateway";
property name="optionGateway";
property name="settingGateway";
property name="pickService";
/*
Author: 	
	Ron West
Name:
	$getRankings
Summary:
	Gets the standings for the week
Returns:
	Array arStandings
Arguments:
	Void
History:
	2015-10-09 - RLW - Created
*/
public Array function getRankings(){
	var stStandingsResults = variables.commonService.getURL("http://localhost:3000/get-standings");
	var arStandings = [];
	// if we have a valid response
	if( find("200", stStandingsResults.statusCode) gt 0 and isJSON(stStandingsResults.fileContent.toString()) ){
		stResponse = deserializeJSON(stStandingsResults.fileContent.toString());
		// make sure the API call was successful
		if( find(200, stResponse.stResults.sStatus) ){
			// get the game data
			arStandings = stResponse.stResults.arStandings;
		} else {
			// API called failed
		}
	} else {
		// need logging
	}
	return arStandings;
}

/*
Author: 	
	Ron West
Name:
	$getTeamResults
Summary:
	Builds a structure of results for the teams playing this week
Returns:
	Struct stResults
Arguments:
	Numeric nWeekID
	Boolean bForce
History:
	2015-10-13 - RLW - Created
*/
public Struct function getTeamResults( Required Numeric nWeekID, Boolean bForce = false ){
	// get the games for this week
	var arWeekGames = variables.gameService.adminWeek(arguments.nWeekID);
	var itm = 1;
	var arGames = [];
	var bGetResults = false;
	var oWeek = variables.weekGateway.get(arguments.nWeekID);

	// clear out the old data
	if( listLen(structKeyList(application.stWeeklyTeamResults)) gt 0 and not structKeyExists(application.stWeeklyTeamResults, arguments.nWeekID) ){
		structClear(application.stWeeklyTeamResults);
	}
	// make sure we have an entry for this week
	if( not structKeyExists(application.stWeeklyTeamResults, arguments.nWeekID) ){
		application.stWeeklyTeamResults[arguments.nWeekID] = {};
		// see if we have data for this week stored in the DB
		if( not isNull(oWeek.getSWeeklyResults())
			and len(oWeek.getSWeeklyResults()) gt 0
			and isJSON(oWeek.getSWeeklyResults()) ){
			// deserialize
			application.stWeeklyTeamResults[arguments.nWeekID] = deserializeJSON(oWeek.getSWeeklyResults());
		} else {
			// we didn't have any results stored in the db
			bGetResults = true;
		}
	}
	// if we are getting the results or if we are forcing it
	if( bGetResults or arguments.bForce ){
		// loop through games this week and get the teams scores
		for( itm; itm lte arrayLen(arWeekGames); itm++ ){
			// get the home teams results
			arGames = variables.teamService.getResults(arWeekGames[itm].sHomeTeam);
			// store this teams data in the struct
			application.stWeeklyTeamResults[arguments.nWeekID][arWeekGames[itm].nHomeTeamID] = arGames;
			// get the away teams results
			arGames = variables.teamService.getResults(arWeekGames[itm].sAwayTeam);
			// store this teams data in the struct
			application.stWeeklyTeamResults[arguments.nWeekID][arWeekGames[itm].nAwayTeamID] = arGames;
		}
		// push the data struct into the week as JSON
		variables.weekGateway.update(oWeek, {"sWeeklyResults" = serializeJSON(application.stWeeklyTeamResults[arguments.nWeekID])});


	}
	return application.stWeeklyTeamResults[arguments.nWeekID];
}

/*
Author: 	
	Ron West
Name:
	$makeAutoPicks
Summary:
	Handles making auto picks for the week
Returns:
	Void
Arguments:
	Numeric nWeekID
	Numeric nSeasonID
History:
	2015-11-07 - RLW - Created
*/
public Void function makeAutoPicks( Required Numeric nWeekID, Required Numeric nSeasonID ){
	var arOption = variables.optionGateway.getByCodeKey("autopick");
	var arUsers = [];
	var itm = 1;
	if( arrayLen(arOption) gt 0 ){
		// get users with this setting
		arUsers = variables.settingGateway.getUsersByOption(arOption[1].getNOptionID());
		for(itm; itm lte arrayLen(arUsers); itm++){
			variables.pickService.autoPick(arUsers[itm].getSValue(), arguments.nWeekID, arUsers[itm].getNUserID(), arguments.nSeasonID);
		}

	}
}

}
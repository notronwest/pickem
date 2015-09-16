component accessors="true" extends="model.services.baseService" {

property name="standingGateway";
property name="weekGateway";
property name="userGateway";
property name="gameService";
property name="pickService";
/*
Author: 	
	Ron West
Name:
	$deleteUserStandings
Summary:
	Deletes the standings for a user
Returns:
	Void
Arguments:
	Numeric nUserID
History:
	2014-09-10 - RLW - Created
*/
public void function deleteUserStandings( Required Numeric nUserID ){
	// get the standings
	var arStandings = variables.standingGateway.getByUser(arguments.nUserID);
	var itm = 1;
	for(itm; itm lte arrayLen(arStandings); itm++ ){
		variables.standingGateway.delete(arStandings[itm]);
	}
}

/*
Author: 	
	Ron West
Name:
	$updateStandingsForSeason	
Summary:
	Updates the standings for the entire season
Returns:
	Void
Arguments:
	Numeric nSeasonID
History:
	2014-11-03 - RLW - Created
	2015-08-08 - RLW - Updated to use seasonID instead of string
*/
public void function updateStandingsForSeason( Required Numeric nSeasonID ){
	var arWeeks = variables.weekGateway.getSeason(arguments.nSeasonID);
	var itm = 1;
	for(itm; itm lte arrayLen(arWeeks); itm++ ){
		variables.standingGateway.updateStandings(arWeeks[itm].getNWeekID(), arguments.nSeasonID);
	}
}

/*
Author: 	
	Ron West
Name:
	$getFullWeekResults
Summary:
	Returns readable full results for given week
Returns:
	Array arFullResults
Arguments:
	Numeric nWeekID
History:
	2015-09-15 - RLW - Created
*/
public Array function getFullWeekResults( Required Numeric nWeekID ){
	var arFullResults = [];
	var arActiveUsers = variables.userGateway.getAll(1);
	var arUserStanding = [];
	// get the games for this week ordered by tiebreak
	var arWeekGames = variables.gameService.adminWeek(arguments.nWeekID, true);
	var stUser = "";
	var itm = 1;
	var x = 1;
	var oUser = "";
	var arGamesByTiebreak = [];
	// build user data for picks
	for( x; x lte arrayLen(arActiveUsers); x++ ){
		// get the standings for this user
		arUserStanding = variables.standingGateway.getUserWeek(arActiveUsers[x].getNUserID(), arguments.nWeekID);
		// get the users picks
		stUserPicks = variables.pickService.getUserWeek(arguments.nWeekID, arActiveUsers[x].getNUserID());
		// add the current standings for this user and their wins
		arrayAppend(arFullResults, {
			sFullName = arActiveUsers[x].getSFirstName() & " " & arActiveUsers[x].getSLastName(),
			lstWins = stUserPicks.lstWins,
			nPlace = (arrayLen(arUserStanding) gt 0) ? arUserStanding[1].getNPlace() : 4030000
		});
	}
	// sort the array by place before returning it
	return variables.commonService.arrayOfStructsSort(arFullResults, "nPlace", "asc", "numeric");
}
}
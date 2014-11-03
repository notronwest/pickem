component accessors="true" extends="model.services.baseService" {

property name="standingGateway";
property name="weekGateway";

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
	String sSeason
History:
	2014-11-03 - RLW - Created
*/
public void function updateStandingsForSeason( Required String sSeason ){
	var arWeeks = variables.weekGateway.getSeason(arguments.sSeason);
	var itm = 1;
	for(itm; itm lte arrayLen(arWeeks); itm++ ){
		variables.standingGateway.updateStandings(arWeeks[itm].getNWeekID(), arguments.sSeason);
	}
}

}
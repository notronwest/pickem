component accessors="true" extends="model.services.baseService" {

property name="pickGateway";
property name="gameService";

/*
Author: 	
	Ron West
Name:
	$getUserWeek
Summary:
	Creates a structure of all of the picks for this user for the given week
Returns:
	Struct stPicks
Arguments:
	Numeric nWeekID
	Numeric nUserID
History:
	2012-09-12 - RLW - Created
*/
public Struct function getUserWeek( Required Numeric nWeekID, Required Numeric nUserID){
	var stUserWeek = {};
	var stPicks = {};
	var lstWins = "";
	var itm = 1;
	try{
		// get the users picks
		var arPicks = variables.pickGateway.getUserWeek(arguments.nWeekID, arguments.nUserID);
		// build return struct
		for( itm; itm lte arrayLen(arPicks); itm++ ){
			// save picks
			structInsert(stPicks, arPicks[itm].getNGameID(), arPicks[itm].getNTeamID());
			// save wins
			if( arPicks[itm].getNWin() eq 1 ){
				lstWins = listAppend(lstWins, arPicks[itm].getNGameID());
			}
		}
		// store data for return
		stUserWeek = { stPicks = stPicks, lstWins = lstWins };
	} catch (any e){
		registerError("Error getting picks for user", e);
	}
	return stUserWeek;
}

/*
Author: 	
	Ron West
Name:
	$sendInPicks
Summary:
	Sends an e-mail with this weeks picks
Returns:
	Void
Arguments:
	Struct stPicks
	Object oWeek
	Struct stUser
History:
	2012-08-20 - RLW - Created
*/
public void function sendInPicks( Required Struct stPicks, Required model.beans.week oWeek, Required Struct stUser ){
 	var itm = 1;
 	var arPicks = [];
 	var sMessage = "";
	// get the games sorted for this week
	var arSortedGames = variables.gameService.buildOrderedArray(arguments.oWeek.getNWeekID());
	
	// loop through the games and find out which pick was made
	for( itm=1; itm lte arrayLen(arSortedGames); itm++ ){
		if( arSortedGames[itm].nTeamID eq arguments.stPicks[arSortedGames[itm].nGameID]){
			arrayAppend(arPicks, itm);
		}
	}
	
	// construct e-mail message
	sMessage = listChangeDelims(arrayToList(arPicks), chr(13));
	// send e-mail
	variables.commonService.sendEmail(request.sAdminEmail, "My picks for #arguments.oWeek.getSName()#", sMessage, arguments.stUser.sEmail);
}

/*
Author: 	
	Ron West
Name:
	$deleteUserPicks
Summary:
	Deletes all of the picks for a user
Returns:
	Void
Arguments:
	Numeric nUserID
History:
	2014-09-10 - RLW - Created
*/
public void function deleteUserPicks( Required Numeric nUserID ){
	// get all of the picks
	var arPicks = variables.pickGateway.getByUser(arguments.nUserID);
	var itm = 1;
	for( itm; itm lte arrayLen(arPicks); itm++ ){
		variables.pickGateway.delete(arPicks[itm]);
	}
}

/*
Author: 	
	Ron West
Name:
	$userHasPicks
Summary:
	Determines if the user has picks or not
Returns:
	Boolean bHasPicks
Arguments:
	Numeric nWeekID
	Numeric nUserID
History:
	2014-09-19 - RLW - Created
*/
public Boolean function userHasPicks( Required Numeric nWeekID, Required Numeric nUserID ){
	var stUserPicks = getUserWeek(arguments.nWeekID, arguments.nUserID);
	var bHasPicks = false;
	if( listLen(structKeyList(stUserPicks.stPicks)) gt 0 ){
		bHasPicks = true;
	}
	return bHasPicks;
}

}


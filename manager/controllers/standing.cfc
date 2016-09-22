component accessors="true" extends="model.baseController" {

property name="standingService";
property name="standingGateway";
property name="userGateway";
property name="weekGateway";
property name="gameService";

public void function before(rc){
	param name="rc.bDebugTiebreak" default="0";
}

public void function home(rc){
	// get the standings records ordered by week
	var arTempStandings = variables.standingGateway.getSeason(rc.nCurrentSeasonID);
	var itm = 1;
	var nWeekID = 0;
	var nUserID = 0;
	// tracks which weeks have already had a winner determined
	var arWeekFirstPlace = [];
	var arWeekSecondPlace = [];
	rc.stWeekData = {};
	rc.stWeekWinners = {};
	rc.stWeekSecondPlace = {};
	rc.stWeekNoPicks = {};
	rc.stWeekAutoPick = {};
	rc.stWeekTiebreak = {};
	rc.stUsers = {};
	rc.stSeasonWins = {};
	rc.stSeasonPoints = {};
	rc.arStandings = [];
	// get the weeks
	rc.arWeeks = variables.weekGateway.getSeason(rc.nCurrentSeasonID);
	// loop through the standings and build the data for each week
	for( itm; itm lte arrayLen(arTempStandings); itm++ ){
		// setup this week
		nWeekID = arTempStandings[itm].getWeek().getNWeekNumber();
		nUserID = arTempStandings[itm].getNUserID();
		// build structure for users
		if( not structKeyExists(rc.stUsers, nUserID) ){
			rc.stUsers[nUserID] = variables.userGateway.get(nUserID);
		}
		// store the wins for this user for this week
		if( not structKeyExists(rc.stWeekData, nUserID) ){
			rc.stWeekData[nUserID] = {};
		}
		if( not structKeyExists(rc.stWeekData[nUserID], nWeekID) ){
			rc.stWeekData[nUserID][nWeekID] = {};
		}
		// store the highest tiebreakers for each user for each week
		if( not structKeyExists(rc.stWeekTiebreak, nUserID) ){
			rc.stWeekTiebreak[nUserID] = {};
		}
		// if this user doesn't have picks for this week
		if( arTempStandings[itm].getBHasPicks() neq 1 ){
			if( not structKeyExists(rc.stWeekNoPicks, nWeekID) ){
				rc.stWeekNoPicks[nWeekID] = [];
			}
			arrayAppend(rc.stWeekNoPicks[nWeekID], nUserID);
		}
		// if this user was auto picked for this week
		if( arTempStandings[itm].getBAutoPick() eq 1 ){
			if( not structKeyExists(rc.stWeekAutoPick, nWeekID) ){
				rc.stWeekAutoPick[nWeekID] = [];
			}
			arrayAppend(rc.stWeekAutoPick[nWeekID], nUserID);
		}
		// store this users wins
		rc.stWeekData[nUserID][nWeekID].wins = arTempStandings[itm].getNWins();
		// store this users points
		rc.stWeekData[nUserID][nWeekID].nPoints = (isNull(arTempStandings[itm].getNPoints())) ? 0 : arTempStandings[itm].getNPoints();
		// store this users place
		rc.stWeekData[nUserID][nWeekID].nPlace = arTempStandings[itm].getNPlace();
		// store this users highest tiebreak
		rc.stWeekTiebreak[nUserID][nWeekID] = [IsNull(arTempStandings[itm].getNHighestTiebreak()) ? 0 : arTempStandings[itm].getNHighestTiebreak(),
			IsNull(arTempStandings[itm].getNTiebreak2()) ? 0 : arTempStandings[itm].getNTiebreak2(),
			IsNull(arTempStandings[itm].getNTiebreak3()) ? 0 : arTempStandings[itm].getNTiebreak3(),
			IsNull(arTempStandings[itm].getNTiebreak4()) ? 0 : arTempStandings[itm].getNTiebreak4(),
			IsNull(arTempStandings[itm].getNTiebreak5()) ? 0 : arTempStandings[itm].getNTiebreak5(),
			IsNull(arTempStandings[itm].getNTiebreak6()) ? 0 : arTempStandings[itm].getNTiebreak6(),
			IsNull(arTempStandings[itm].getNTiebreak7()) ? 0 : arTempStandings[itm].getNTiebreak7(),
			IsNull(arTempStandings[itm].getNTiebreak8()) ? 0 : arTempStandings[itm].getNTiebreak8(),
			IsNull(arTempStandings[itm].getNTiebreak9()) ? 0 : arTempStandings[itm].getNTiebreak9(),
			IsNull(arTempStandings[itm].getNTiebreak10()) ? 0 : arTempStandings[itm].getNTiebreak10()
		];
		// increase this users season wins
		if( not structKeyExists(rc.stSeasonWins, nUserID) ){
			rc.stSeasonWins[nUserID] = arTempStandings[itm].getNWins();
		} else {
			rc.stSeasonWins[nUserID] = rc.stSeasonWins[nUserID] + arTempStandings[itm].getNWins();
		}
		// increase this users season points
		if( not structKeyExists(rc.stSeasonPoints, nUserID) ){
			structInsert(rc.stSeasonPoints, nUserID, arTempStandings[itm].getNPoints());
		} else {
			structUpdate(rc.stSeasonPoints, nUserID, rc.stSeasonPoints[nUserID] + arTempStandings[itm].getNPoints());
		}
	}
	// sort the seasonWins
	if( rc.bIsNFLUnderdog or rc.bIsNFLPerfection ){
		rc.arStandings = structSort(rc.stSeasonPoints, "numeric", "desc");
	} else {
		rc.arStandings = structSort(rc.stSeasonWins, "numeric", "desc");
	}
}

public void function calculate(rc){
	param name="rc.nWeekID" default="0";
	if( rc.nWeekID neq 0 ){
		// calculate winners for this week
		variables.standingGateway.updateStandings(rc.nWeekID, rc.nCurrentSeasonID);
		rc.sMessage = "Winners calculated";
	} else {
		rc.sMessage = "Error: Please provide a valid week parameter";
	}
	
	variables.framework.setView("main.message");
}

public void function updateStandingsForSeason(rc){
	variables.standingService.updateStandingsForSeason(rc.nCurrentSeasonID);
	rc.sMessage = "All standings updated for #rc.oCurrentSeason.getSName()#";
	variables.framework.setView("main.message");
}

public void function fullResults(rc){
	param name="rc.nWeekID" default="0";
	// get the results
	rc.arFullResults = variables.standingService.getFullWeekResults(rc.nWeekID);
	// get the game data
	rc.arWeekGames = variables.gameService.adminWeek(rc.nWeekID, true);
}

}
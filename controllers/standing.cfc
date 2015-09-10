component accessors="true" extends="model.base" {

property name="standingService";
property name="standingGateway";
property name="userGateway";
property name="weekGateway";

public void function home(rc){
	// get the standings records ordered by week
	var arStandings = variables.standingGateway.getSeason(rc.nCurrentSeasonID);
	var itm = 1;
	var nWeekID = 0;
	var nUserID = 0;
	// tracks which weeks have already had a winner determined
	var arWeekFirstPlace = [];
	var arWeekSecondPlace = [];
	rc.stWeekWins = {};
	rc.stWeekWinners = {};
	rc.stWeekSecondPlace = {};
	rc.stWeekNoPicks = {};
	rc.stWeekTiebreak = {};
	rc.stUsers = {};
	rc.stSeasonWins = {};
	rc.arStandings = [];
	// get the weeks
	rc.arWeeks = variables.weekGateway.getSeason(rc.nCurrentSeasonID);
	// loop through the standings and build the data for each week
	for( itm; itm lte arrayLen(arStandings); itm++ ){
		// setup this week
		nWeekID = arStandings[itm].getWeek().getNWeekNumber();
		nUserID = arStandings[itm].getNUserID();
		// build structure for users
		if( not structKeyExists(rc.stUsers, nUserID) ){
			rc.stUsers[nUserID] = variables.userGateway.get(nUserID);
		}
		// store the wins for this user for this week
		if( not structKeyExists(rc.stWeekWins, nUserID) ){
			rc.stWeekWins[nUserID] = {};
		}
		// store the highest tiebreakers for each user for each week
		if( not structKeyExists(rc.stWeekTiebreak, nUserID) ){
			rc.stWeekTiebreak[nUserID] = {};
		}
		// if this user doesn't have picks for this week
		if( arStandings[itm].getBHasPicks() neq 1 ){
			if( not structKeyExists(rc.stWeekNoPicks, nWeekID) ){
				rc.stWeekNoPicks[nWeekID] = [];
			}
			arrayAppend(rc.stWeekNoPicks[nWeekID], nUserID);
		}
		// store this users wins
		rc.stWeekWins[nUserID][nWeekID] = arStandings[itm].getNWins();
		// store this users highest tiebreak
		rc.stWeekTiebreak[nUserID][nWeekID] = [arStandings[itm].getNHighestTiebreak(),
			arStandings[itm].getNTiebreak2(),
			arStandings[itm].getNTiebreak3(),
			arStandings[itm].getNTiebreak4(),
			arStandings[itm].getNTiebreak5(),
			arStandings[itm].getNTiebreak6(),
			arStandings[itm].getNTiebreak7(),
			arStandings[itm].getNTiebreak8(),
			arStandings[itm].getNTiebreak9(),
			arStandings[itm].getNTiebreak10()
		];
		// store the winners
		if( not structKeyExists(rc.stWeekWinners, nWeekID) ){
			rc.stWeekWinners[nWeekID] = {};
			rc.stWeekSecondPlace[nWeekID] = {};
		}
		// if there is no current first place
		if( arStandings[itm].getNPlace() eq 1 and not arrayFind(arWeekFirstPlace, nWeekID) ){
			rc.stWeekWinners[nWeekID][nUserID] = 1;
			arrayAppend(arWeekFirstPlace, nWeekID);
		} else if( arStandings[itm].getNPlace() eq 1 and not arrayFind(arWeekSecondPlace, nWeekID) ){ // if this user is second and there are no second place people outlined yet
			rc.stWeekSecondPlace[nWeekID][nUserID] = 1;
			arrayAppend(arWeekSecondPlace, nWeekID);
		} else if ( arStandings[itm].getNPlace() eq 2 and not arrayFind(arWeekSecondPlace, nWeekID)){ // second place
			rc.stWeekSecondPlace[nWeekID][nUserID] = 1;
			arrayAppend(arWeekSecondPlace, nWeekID);
		}
		// increase this users season wins
		if( not structKeyExists(rc.stSeasonWins, nUserID) ){
			rc.stSeasonWins[nUserID] = arStandings[itm].getNWins();
		} else {
			rc.stSeasonWins[nUserID] = rc.stSeasonWins[nUserID] + arStandings[itm].getNWins();
		}
	}
	// sort the seasonWins
	rc.arStandings = structSort(rc.stSeasonWins, "numeric", "desc");
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

}
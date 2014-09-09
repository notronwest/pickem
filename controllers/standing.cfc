component accessors="true" extends="model.base" {

property name="standingService";
property name="standingGateway";
property name="userGateway";
property name="weekGateway";

public void function home(rc){
	// get the standings records ordered by week
	var arStandings = variables.standingGateway.getSeason(rc.sSeason);
	var itm = 1;
	var nWeekID = 0;
	var nUserID = 0;
	rc.stWeekWins = {};
	rc.stWeekWinners = {};
	rc.stUsers = {};
	rc.stSeasonWins = {};
	rc.arStandings = [];
	// get the weeks
	rc.arWeeks = variables.weekGateway.getSeason(rc.sSeason);
	// loop through the standings and build the data for each week
	for( itm; itm lte arrayLen(arStandings); itm++ ){
		// setup this week
		nWeekID = arStandings[itm].getNWeekID();
		nUserID = arStandings[itm].getNUserID();
		// build structure for users
		if( not structKeyExists(rc.stUsers, nUserID) ){
			rc.stUsers[nUserID] = variables.userGateway.get(nUserID);
		}
		// store the wins for this user for this week
		if( not structKeyExists(rc.stWeekWins, nUserID) ){
			rc.stWeekWins[nUserID] = {};
		}
		// store this users wins
		rc.stWeekWins[nUserID][nWeekID] = arStandings[itm].getNWins();
		// store the winners
		if( not structKeyExists(rc.stWeekWinners, nWeekID) ){
			rc.stWeekWinners[nWeekID] = {};
		}
		// if this user was the winner for this week
		if( arStandings[itm].getNPlace() eq 1 ){
			rc.stWeekWinners[nWeekID][nUserID] = 1;
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
	//if( structKeyExists(rc, "doCalculate") ){
		variables.standingService.calculateWinners(rc.nWeekID, rc.sSeason);
		rc.sMessage = "Winners calculated";
		variables.framework.setView("main.message");
	//}
}
}
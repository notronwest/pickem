component accessors="true" extends="model.base" {

property name="gameGateway";
property name="gameService";
property name="teamService";
property name="weekGateway";
property name="standingService";

public void function before (rc){
	param name="rc.nWeekID" default="0";
	rc.oWeek = variables.weekGateway.get(rc.nWeekID);
	// get the list of weeks created for this year
	rc.arWeeks = variables.weekGateway.getSeason(rc.sSeason);
	// if we have a zero week get the current week
	if( rc.oWeek.getNWeekID() eq 0 ){
		arWeek = variables.weekGateway.getByDate(sSeason=rc.sSeason);
		if( arrayLen(arWeek) gt 0 ){
			rc.oWeek = arWeek[1];
			// reset weekID so other functions can use it
			rc.nWeekID = rc.oWeek.getNWeekID();
		}
	}
	// set picks due date
	rc.dtPicksDue = rc.oWeek.getDPicksDue() & " " & rc.oWeek.getTPicksDue();
	// see if there are any games
	rc.arWeekGames = variables.gameService.adminWeek(rc.nWeekID);
	// determine if the week is locked
	rc.bIsLocked = false;
	if( compare(rc.dtPicksDue, dateFormat(now(), 'yyyy-mm-dd') & " " & timeFormat(now(), 'hh:mm')) lte 0){
		rc.bIsLocked = true;
	}
}

public void function scoring(rc){
	param name="rc.bOverrideLock" default="false";
	if( rc.bOverrideLock ){
		rc.bIsLocked = false;
	}
}

public Void function saveWeek(rc){
	var itm = 1;
	rc.sMessage = "Games saved successfully";
	// convert the games to cf
	rc.arGames = deserializeJSON(rc.arGames);
	rc.arSavedGames = [];
	rc.bIsDialog = true;
	var stWeekGames = {};
	var arGamesToDelete = [];
	var lstGamesToDelete = "";
	try {
		// get the games that have already been saved for this week
		stWeekGames = variables.gameService.getGameStructForWeek(rc.nWeekID);
		// make a list of these games (this will be used to determine which games are missing e.g need delete)
		lstGamesToDelete = structKeyList(stWeekGames);
		// loop through the games and save the team (if needed)
		for( itm; itm lte arrayLen(rc.arGames); itm++ ){
			// get the game object (will return a new object if the gameID doesn't exist)
			oGame = variables.gameGateway.getByGameID((isNumeric(rc.arGames[itm].nGameID)) ? rc.arGames[itm].nGameID : 0);
			// if this game exists then remove it from the list of games to delete
			if( listFind(lstGamesToDelete, rc.arGames[itm].nGameID) gt 0 ){
				lstGamesToDelete = listDeleteAt(lstGamesToDelete, listFind(lstGamesToDelete, rc.arGames[itm].nGameID));
			}
			// save the home team
			oHomeTeam = variables.teamService.saveTeam(rc.arGames[itm].sHomeTeam, rc.arGames[itm].sHomeTeamURL);
			// add in the id
			rc.arGames[itm].nHomeTeamID = oHomeTeam.getNTeamID();
			// save the away team
			oAwayTeam = variables.teamService.saveTeam(rc.arGames[itm].sAwayTeam, rc.arGames[itm].sAwayTeamURL);
			// add in the id
			rc.arGames[itm].nAwayTeamID = oAwayTeam.getNTeamID();
			// add in the week
			rc.arGames[itm].nWeekID = rc.nWeekID;
			// update the order
			rc.arGames[itm].nOrder = itm;
			// save the game
			arrayAppend(rc.arSavedGames, variables.gameGateway.update(oGame, rc.arGames[itm]));
		}
		// once we are done the only games remaining will be those deleted
		arGamesToDelete = listToArray(lstGamesToDelete);
		for(itm=1; itm lte arrayLen(arGamesToDelete); itm++ ){
			variables.gameService.clearGameByGameID(arGamesToDelete[itm]);
		}
		// make sure we saved all of the games
		if( arrayLen(rc.arGames) neq arrayLen(rc.arSavedGames) ){
			throw("Error");
		}
	} catch ( any e ){
		// TODO: do some logging
		rc.sMessage = "Error saving games, please refresh and try again. #e.detail#";
		registerError("Error saving games", e);
	}
	variables.framework.setView("main.message");
}

public void function saveScores(rc){
	var bSaved = true;
	rc.bIsDialog = true;
	try{
		// convert the array
		rc.arGames = deserializeJSON(rc.arGames);
		// save the scores
		bSaved = variables.gameGateway.saveScores(rc.arGames);
		if( bSaved){
			// calculate winners for this week
			variables.standingService.calculateWinners(rc.nWeekID, rc.sSeason);
			rc.sMessage = "Scores saved";
		} else {
			rc.sMessage = "Error saving scores.  Please try again";
		}
		variables.framework.setView("main.message");
	} catch (any e){
		registerError("Error saving scores", e);
	}
}
}
component accessors="true" extends="model.baseController" {

property name="gameGateway";
property name="gameService";
property name="teamService";
property name="weekGateway";
property name="standingGateway";
property name="optionGateway";
property name="notifyService";

public void function before (rc){
	param name="rc.nWeekID" default="0";
	rc.oWeek = variables.weekGateway.get(rc.nWeekID);
	// get the list of weeks created for this year
	rc.arWeeks = variables.weekGateway.getSeason(rc.nCurrentSeasonID);
	// if we have a zero week get the current week
	if( rc.oWeek.getNWeekID() eq 0 ){
		arWeek = variables.weekGateway.getByDate(nSeasonID=rc.nCurrentSeasonID);
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
	rc.bIsAdminAction = true;
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
	var bInitialSetup = false;
	var arOption = [];
	try {
		// get the games that have already been saved for this week
		stWeekGames = variables.gameService.getGameStructForWeek(rc.nWeekID);
		// make a list of these games (this will be used to determine which games are missing e.g need delete)
		lstGamesToDelete = structKeyList(stWeekGames);
		// if we are in the initial setup then send out notification later
		if( listLen(lstGamesToDelete) eq 0 ){
			bInitialSetup = true;
		}
		// loop through the games and save the team (if needed)
		for( itm; itm lte arrayLen(rc.arGames); itm++ ){
			// get the game object (will return a new object if the gameID doesn't exist)
			oGame = variables.gameGateway.getByGameID((isNumeric(rc.arGames[itm].nGameID)) ? rc.arGames[itm].nGameID : 0);
			// if this game exists then remove it from the list of games to delete
			if( listFind(lstGamesToDelete, rc.arGames[itm].nGameID) gt 0 ){
				lstGamesToDelete = listDeleteAt(lstGamesToDelete, listFind(lstGamesToDelete, rc.arGames[itm].nGameID));
			}
			// if this game is completed - don't make any changes
			if( !oGame.getBGameIsFinal() eq 1 ){
				// save the home team
				oHomeTeam = variables.teamService.saveTeam(rc.arGames[itm].sHomeTeam, rc.arGames[itm].sHomeTeamURL, (structKeyExists(rc.arGames[itm], "nType")) ? rc.arGames[itm].nType : "");
				if( oHomeTeam.getNTeamID() gt 0 ){
					// add in the id
					rc.arGames[itm].nHomeTeamID = oHomeTeam.getNTeamID();
					// save the away team
					oAwayTeam = variables.teamService.saveTeam(rc.arGames[itm].sAwayTeam, rc.arGames[itm].sAwayTeamURL, (structKeyExists(rc.arGames[itm], "nType")) ? rc.arGames[itm].nType : "");
					if( oAwayTeam.getNTeamID() > 0 ){
						// add in the id
						rc.arGames[itm].nAwayTeamID = oAwayTeam.getNTeamID();
						// add in the week
						rc.arGames[itm].nWeekID = rc.nWeekID;
						// update the order
						rc.arGames[itm].nOrder = itm;
						// save the game
						arrayAppend(rc.arSavedGames, variables.gameGateway.update(oGame, rc.arGames[itm]));
					}
				}
			} else { // save the game so we can track it
				arrayAppend(rc.arSavedGames, oGame);
			}
		}
		// once we are done the only games remaining will be those deleted
		arGamesToDelete = listToArray(lstGamesToDelete);
		for(itm=1; itm lte arrayLen(arGamesToDelete); itm++ ){
			variables.gameService.clearGameByGameID(arGamesToDelete[itm]);
		}
		// update all of the games with the rankings
		variables.gameService.updateGamesWithRankings(rc.nWeekID, rc.nCurrentSeasonID);
		// make sure we saved all of the games
		if( arrayLen(rc.arGames) neq arrayLen(rc.arSavedGames) ){
			throw("Error");
		} else if ( bInitialSetup ){
			// send out notifications for all users about the beginning of the week
			arOption = variables.optionGateway.getByCodeKey("gamesAvailable");
			if( arrayLen(arOption) gt 0 ){
// ****** NEEDS ATTENTION *******
if( compareNoCase(rc.oCurrentLeague.getSKey(), "pickem") eq 0){
				variables.notifyService.processNotification(arOption[1], rc.oWeek);
}
			}
		}
	} catch ( any e ){
		// TODO: do some logging
		rc.sMessage = "Error saving games, please refresh and try again. #e.detail#";
		registerError("Error saving games", e);
	}
	// forward back to the set week page
	//variables.framework.redirect("week.setWeekGames",'nWeekID,sMessage');
	variables.framework.setView("manager:main.message");
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
			variables.standingGateway.updateStandings(rc.nWeekID, rc.nCurrentSeasonID);
			rc.sMessage = "Scores saved";
		} else {
			rc.sMessage = "Error saving scores.  Please try again";
		}
		variables.framework.setView("main.message");
	} catch (any e){
		registerError("Error saving scores", e);
	}
}

/*
Author: 	
	Ron West
Name:
	$getGameScores
Summary:
	Gets the scores for this weeks games
Returns:
	Void
Arguments:
	Void
History:
	2014-09-12 - RLW - Created
*/
public void function getGameScores(rc){
	param name="rc.bProcess" default="false";
	try{
		// send week games to service to get games scores
		if( rc.bProcess ){
			rc.arGameScores = variables.gameService.getGameScores(rc.arWeekGames);
		}
		// update the standings
		variables.standingGateway.updateStandings(rc.nWeekID, rc.nCurrentSeasonID);
	} catch (any e){
		registerError("Error trying to get the game scores", e);
	}
}

/*
Author: 	
	Ron West
Name:
	$isDateValid
Summary:
	Determines if the passed in date/time is valid
Returns:
	Void
Arguments:
	Void
History:
	2014-12-21 - RLW - Created
*/
public void function isDateValid(rc){
	param name="rc.dtToCheck" default="";
	rc.aResult = variables.commonService.isValidDateTime(rc.dtToCheck);
	variables.framework.setView("main.serialize");
}
}
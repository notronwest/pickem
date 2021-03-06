component accessors="true" extends="model.baseController" {

property name="pickGateway";
property name="pickService";
property name="gameService";
property name="weekGateway";
property name="userGateway";
property name="gameGateway";
property name="statService";
property name="weekService";

public void function before(rc){
	// default all to a dialog
	rc.bIsDialog = true;
	rc.bUserHasPicks = false;
	rc.bUserAutoPicked = false;
	rc.bIsLocked = false;
	rc.bCorrectNumberOfPicks = true;
	// default the week
	param name="rc.nWeekID" default="0";
	param name="rc.stWeeklyTeamResults" default="#{}#";
	param name="rc.bOverrideLock" default="false";
	param name="rc.bCanSetPicks" default="false";
	param name="rc.oPick" default="false";

	// see if they are on the pick screen
	if( compareNoCase(variables.framework.getFullyQualifiedAction(), "manager:pick.set") eq 0 ){
		rc.bCanSetPicks = true;
	}
	// if we don't have a week set
	if( rc.nWeekID eq 0 ){
		// try to determine this week
		arTmpWeek = variables.weekGateway.getByDate(nSeasonID=rc.nCurrentSeasonID);
		if( arrayLen(arTmpWeek) gt 0 ){
			rc.nWeekID = arTmpWeek[1].getNWeekID();
		}
	}
	// get the details for this week
	rc.oWeek = variables.weekGateway.get(rc.nWeekID);
	// get the list of weeks created for this year
	rc.arWeeks = variables.weekGateway.getSeason(rc.nCurrentSeasonID);
	// get this weeks games
	rc.arWeekGames = variables.gameService.adminWeek(rc.nWeekID, false, false);
	// determine if picks are still open
	rc.dtPicksDue = rc.oWeek.getDPicksDue() & " " & rc.oWeek.getTPicksDue();

	// see if the picks are locked for this week
	if( compare(variables.dbService.dbDateTimeFormat(rc.dtPicksDue), variables.dbService.dbDateTimeFormat() ) lte 0){
		rc.bIsLocked = true;
	}

	try{
		// get this weeks picks for the current user
		rc.stUserWeek = variables.pickService.getUserWeek(rc.nWeekID, rc.nCurrentUser);
		// check to see if this user has picks already
		if( listLen(structKeyList(rc.stUserWeek.stPicks)) ){
			rc.bUserHasPicks = true;
			// check to see if this user has ALL of their picks
			if( listLen(structKeyList(rc.stUserWeek.stPicks)) != arrayLen(rc.arWeekGames) ){
				rc.bCorrectNumberOfPicks = false;
			}
		}
		// check to see if the user had auto picks
		if( rc.stUserWeek.bAutoPick ){
			rc.bUserAutoPicked = true;
		}
	} catch (any e){
		registerError("Error setting up picks", e);
	}

	// get the weekly stats
	//rc.stWeeklyTeamResults = variables.weekService.getTeamResults(rc.nWeekID);
}

public void function after(rc){
	if( rc.bManualOverridePicks ){
		rc.bIsLocked = false;
	}
}

public void function set(rc){
	param name="rc.bSaved" default="false";
	rc.bShowPageLevelAds = true;

	// if there are no games then lock the week
	if( arrayLen(rc.arWeekGames) eq 0 ){
		rc.bIsLocked = true;
	}

	// set as page
	rc.bIsDialog = false;
}

public void function save(rc){
	var nGameID = "";
	var oPick = "";
	var stPicks = {};
	rc.sMessage = "Picks saved";
	var oGame = '';
	try{
		if( !rc.bIsLocked or rc.bManualOverridePicks ){
			// convert picks
			stPicks = deserializeJSON(rc.stPicks);
// ********* ONLY FOR NFLUnderdog AND NFLPerfection ************
if( compareNoCase(rc.stLeagueSettings.UIKey, "NFLUnderdog") eq 0
	or compareNoCase(rc.stLeagueSettings.UIKey, "NFLPerfection") eq 0 ){
	// delete all of the picks for this user prior to setting new ones
	variables.pickGateway.deleteUserWeek(rc.nWeekID, rc.nCurrentUser);

}
			// loop through the structure of picks and process them
			for( nGameID in stPicks ){
				// get the game details
				oGame = variables.gameGateway.get(nGameId);
				// only allow this pick to save if the game hasn't already started
				if( oGame.getSGameDateTime() < dateTimeFormat(now(), 'yyyy-mm-dd HH:mm:ss') ) {
				  continue;
				}
				// get a new pick object based on game and user
				oPick = variables.pickGateway.getByUserAndGame(rc.nCurrentUser, nGameID);
				// update the picks
				oPick = variables.pickGateway.update(oPick, { nGameID = nGameID, nTeamID = stPicks[nGameID], nWeekID = rc.nWeekID, nUserID = rc.nCurrentUser } );
			}
			// send e-mail to mark these picks if we aren't in dev
			if( !request.bIsDevelopment ){
				variables.pickService.sendInPicks(stPicks, rc.oWeek, rc.stUser);
			}
		}
	} catch (any e){
		registerError("Error saving picks for user", e);
		rc.sMessage = "Error saving picks, please try again";
	}
	variables.framework.setView("main.message");
}

public void function hasPicks(rc){
	param name="rc.stData" default="";
	param name="rc.nCheckWeekID" default="0";
	rc.bIsDialog = true;
	var arPicks = [];
	var bHasPicks = false;
	if( isJSON(rc.stData) ){
		rc.stData = deserializeJSON(rc.stData);
		// loop through each of the users and check to see if they have picks for this week
		for( nUserID in rc.stData){
			arPicks = variables.pickGateway.getUserWeek(rc.nCheckWeekID, nUserID);
			// if they have 20 picks then they are good
			if( arrayLen(arPicks) eq 20 ){
				bHasPicks = true;
			} else {
				bHasPicks = false;
			}
			rc.stData[nUserID] = bHasPicks;
		}
	}
	rc.aResult = rc.stData;
	variables.framework.setView(application.sSerializeView);
}

public void function bulk(rc){
	param name="rc.bDoSave" default="false";
	param name="rc.nWeekID" default="0";
	rc.bIsAdminAction = true;
	var itm = 1;
	var arSelections = [];
	rc.sMessage = "Error saving picks";
	rc.arPicks = [];
	rc.bIsDialog = false;
	// get a list of all of the users
	rc.arUsers = variables.userGateway.getAllSortByFirst();
	// get the list of weeks created for this year
	rc.arWeeks = variables.weekGateway.getSeason(rc.nCurrentSeasonID);
	// if we are saving
	if( rc.bDoSave ){
		arSelections = listToArray(rc.lstPicks);
		// get the list of ordered games
		rc.arGames = variables.gameService.buildOrderedArray(rc.nWeekID);
		// loop through the list of selected games and make picks
		for( itm; itm lte arrayLen(arSelections); itm++ ){
			arrayAppend(rc.arPicks, variables.pickGateway.update(
				variables.pickGateway.getUserGame(rc.arGames[arSelections[itm]].nGameID, rc.nUserID), {
				"nGameID" = rc.arGames[arSelections[itm]].nGameID,
				"nTeamID" = rc.arGames[arSelections[itm]].nTeamID,
				"nUserID" = rc.nUserID,
				"nWeekID" = rc.nWeekID
			}));
		}
		// if there were same amount of games as picks
		if( arrayLen(rc.arPicks) eq arrayLen(arSelections) ){
			rc.sMessage = "Picks saved";
		}
		variables.framework.setView("main.message");
		rc.bIsDialog = true;
	}
}

public void function compare(rc){
	param name="rc.nViewUserID" default="0";
	param name="rc.stViewUSer" default={};
	rc.bIsDialog = false;
	// get a list of all of the users
	rc.arUsers = variables.userGateway.getAllSortByFirst();
	// get this weeks picks for the user selected
	rc.stViewUserWeek = variables.pickService.getUserWeek(rc.nWeekID, rc.nViewUserID);
	// get this weeks picks for the current user
	rc.stUserWeek = variables.pickService.getUserWeek(rc.nWeekID, rc.nCurrentUser);
	// get the view user data
	rc.oViewUser = variables.userGateway.get(rc.nViewUserID);
}

public void function gameInfo(rc){
	param name="rc.nGameID" default="0";
	param name="rc.stGame" default="#{}#";
	param name="rc.stGameStats" default="#{}#";
	rc.bIsDialog = true;
	rc.oGame = variables.gameGateway.get(rc.nGameID);
	// if someone tries to access this view when the week isn't locked forward them back
	if( !rc.bIsLocked){
		variables.framework.redirect("pick.set");
	}
	if( !isNull(rc.oGame.getNGameID()) ){
		// get the details for this game
		rc.stGame = variables.gameService.buildGameStruct(rc.oGame);
		rc.stGameStats = variables.gameService.getGameStats(rc.oGame);
	}
}

public void function stats(rc){
	rc.stGame = variables.gameService.buildGameStruct(variables.gameGateway.get(rc.nGameID), true);
	// get the data for this game for this user
	rc.arGameStats = variables.statService.getGameStatsForUser(rc.stGame, rc.nCurrentUser, rc.nCurrentSeasonID);
	// get the data for these teams
	rc.arTeamStats = variables.statService.getGameStatsForTeams(rc.stGame, rc.nCurrentSeasonID);
	// set as page
	rc.bIsDialog = true;
}

public void function allWeekPicks(rc){
	rc.arWeekPicks = variables.pickGateway.getWeek(rc.nWeeKID);
	rc.stWeekGames = variables.gameService.getGameStructForWeek(rc.nWeekID);
	rc.bIsDialog = false;
}

}

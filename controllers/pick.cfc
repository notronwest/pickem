component accessors="true" extends="model.base" {

property name="pickGateway";
property name="pickService";
property name="gameService";
property name="weekGateway";
property name="userGateway";

public void function before(rc){
	// default all to a dialog
	rc.bIsDialog = true;
	// default the week
	param name="rc.nWeekID" default="0";
	// if we don't have a week set
	if( rc.nWeekID eq 0 ){
		// try to determine this week
		arTmpWeek = variables.weekGateway.getByDate(sSeason=rc.sSeason);
		if( arrayLen(arTmpWeek) gt 0 ){
			rc.nWeekID = arTmpWeek[1].getNWeekID();
		}
	}
	// get the details for this week
	rc.oWeek = variables.weekGateway.get(rc.nWeekID);
	// get the list of weeks created for this year
	rc.arWeeks = variables.weekGateway.getSeason(rc.sSeason);
	// set the side bar content
	rc.sSideBar = variables.framework.view("left/pick");	
	// get this weeks games
	rc.arWeekGames = variables.gameService.adminWeek(rc.nWeekID);
	// determine if picks are still open
	rc.dtPicksDue = rc.oWeek.getDPicksDue() & " " & rc.oWeek.getTPicksDue();
	rc.bIsLocked = false;
	if( compare(variables.dbService.dbDateTimeFormat(rc.dtPicksDue), variables.dbService.dbDateTimeFormat() ) lte 0){
		rc.bIsLocked = true;
	}
	// for now show scores when the week is locked
	rc.bShowScores = false;
	if( rc.bIsLocked ){
		rc.bShowScores = true;
	}
}

public void function set(rc){
	param name="rc.bSaved" default="false";
	rc.bUserHasPicks = false;
	try{
		// get this weeks picks for the current user
		rc.stUserWeek = variables.pickService.getUserWeek(rc.nWeekID, rc.nCurrentUser);
	} catch (any e){
		registerError("Error setting up picks", e);
	}
	// check to see if this user has picks already
	if( listLen(structKeyList(rc.stUserWeek.stPicks)) ){
		rc.bUserHasPicks = true;
	}
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
	try{
		// convert picks
		stPicks = deserializeJSON(rc.stPicks);
		// delete all of the picks for this user for this week
		variables.pickGateway.deleteUserWeek(rc.nWeekID, rc.nCurrentUser);
		// loop through the structure of picks and process them
		for( nGameID in stPicks ){
			// get a new pick object
			oPick = variables.pickGateway.get();
			// update the picks
			oPick = variables.pickGateway.update(oPick, { nGameID = nGameID, nTeamID = stPicks[nGameID], nWeekID = rc.nWeekID, nUserID = rc.nCurrentUser } );
		}
		// send e-mail
		variables.pickService.sendInPicks(stPicks, rc.oWeek, rc.stUser);
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

public void function bulk(){
	param name="rc.bDoSave" default="false";
	param name="rc.nWeekID" default="0";
	var itm = 1;
	var arSelections = [];
	rc.sMessage = "Error saving picks";
	rc.arPicks = [];
	rc.bIsDialog = false;
	// get a list of all of the users
	rc.arUsers = variables.userGateway.getAllSortByFirst();
	// get the list of weeks created for this year
	rc.arWeeks = variables.weekGateway.getSeason(rc.sSeason);
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

public void function compare(){
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

}
component accessors="true" extends="model.baseController" {

property name="weekGateway";
property name="weekService";
property name="sourceGateway";
property name="teamService";
property name="gameService";
property name="gameGateway";
property name="teamGateway";
property name="pickGateway";
property name="standingGateway";

public void function before(rc){
	param name="rc.nWeekID" default="0";
	param name="rc.bAdd" default="false";
	// get the list of weeks created for this year
	rc.arWeeks = variables.weekGateway.getSeason(rc.nCurrentSeasonID);
	// treat everything like a dialog unless stated
	rc.bIsDialog = true;
	// get details for the week
	rc.oWeek = variables.weekGateway.get(rc.nWeekID);
	// if we have a zero week get the current week
	if( rc.oWeek.getNWeekID() eq 0 and not rc.bAdd ){
		arWeek = variables.weekGateway.getByDate(nSeasonID=rc.nCurrentSeasonID);
		if( arrayLen(arWeek) gt 0 ){
			rc.oWeek = arWeek[1];
			// reset weekID so other functions can use it
			rc.nWeekID = rc.oWeek.getNWeekID();
		}
	}
	// get the games
	rc.arGames = variables.gameService.adminWeek(rc.nWeekID, rc.nCurrentSeasonID);
	rc.dtPicksDue = rc.oWeek.getDPicksDue() & " " & rc.oWeek.getTPicksDue();
	rc.bIsLocked = false;

	// see if the picks are locked for this week
	if( compare(variables.dbService.dbDateTimeFormat(rc.dtPicksDue), variables.dbService.dbDateTimeFormat() ) lte 0){
		rc.bIsLocked = true;
	}

}

public Void function getGames(rc){
	var itm = 1;
	var bGamesAreSelected = false;
	// get the details of the week
	var oWeek = weekGateway.get(rc.nWeekID);
	// check to see if this week already has games
	var arGames = variables.gameService.adminWeek(rc.nWeekID);
	// if we are in the current week and we have no games yet then get the source
	if( arrayLen(arGames) eq 0 ){
	 	arGames = variables.gameService.getAvailableGames(rc.stLeagueSettings.bHasNCAAGames, rc.stLeagueSettings.bHasNFLGames);	
	} else {
		bGamesAreSelected = true;
	}

	rc.stGames = {
		"arGames" = arGames,
		"bGamesAreSelected" = bGamesAreSelected
	};
}

public void function addEdit(rc){
	rc.oWeek = weekGateway.get(rc.nWeekID);
	rc.bIsDialog = false;
	// setup some default data
	if( rc.oWeek.getNWeekID() eq 0 ){
		// get the weeks
		arWeeks = weekGateway.getSeason(rc.nCurrentSeasonID);
		// set to the last week
		if( arrayLen(arWeeks) ){
			oLastWeek = arWeeks[arrayLen(arWeeks)];
		} else {
			oLastWeek = weekGateway.get();
		}
		rc.oWeek.setSName("Week " & (arrayLen(arWeeks) + 1));
		// if there isn't a valid start date set it equal to today
		if( isNull(oLastWeek.getDStartDate()) ){
			dtStart = now();
		} else {
			dtStart = dateAdd("d", 7, oLastWeek.getDStartDate());
		}
		if( isNull(oLastWeek.getDEndDate()) ){
			dtEnd = dateAdd("d", 7, now());
		} else {
			dtEnd = dateAdd("d", 7, oLastWeek.getDEndDate());
		}
		if( isNull(oLastWeek.getDPicksDue()) ){
			dtPicks = dateAdd("d", 7, now());
		} else {
			dtPicks = dateAdd("d", 7, oLastWeek.getDPicksDue());
		}
		if( isNull(oLastWeek.getTPicksDue()) ){
			tPicks = "09:00";
		} else {
			tPicks = timeFormat(oLastWeek.getTPicksDue(), "hh:mm");
		}
		// set default values
		rc.oWeek.setDStartDate(dateFormat(dtStart, "yyyy-mm-dd"));
		rc.oWeek.setDEndDate(dateFormat(dtEnd, "yyyy-mm-dd"));
		rc.oWeek.setDPicksDue(dateFormat(dtPicks, "yyyy-mm-dd"));
		rc.oWeek.setTPicksDue(tPicks);
		rc.oWeek.setLstSports("nfl,ncaa");
		rc.oWeek.setNWeekNumber(arrayLen(arWeeks) + 1);
	}
}

public void function save(rc){
	param name="rc.nBonus" default="0";
	param name="rc.lstSports" default="NCAA,NFL";
	param name="rc.nBonus" default="0";
	rc.bIsDialog = false;
	oWeek = variables.weekGateway.update((rc.oWeek.getNWeekID() eq 0) ? entityNew("week") : rc.oWeek, { sName = rc.sName, dStartDate = rc.dStartDate, dEndDate = rc.dEndDate, lstSports = rc.lstSports, nSeasonID = rc.nCurrentSeasonID, nBonus = rc.nBonus, dPicksDue = rc.dPicksDue, tPicksDue = timeFormat(rc.tPicksDue, "HH:mm"), nWeekNumber = rc.nWeekNumber });
	// update the standings for this weeks games
	//variables.gameService.updateStandings(rc.oWeek.getNWeekID());
	rc.sMessage = "Week saved";
	variables.framework.redirect("week.manage", "all");
}

public void function delete(rc){
	param name="rc.aResult" default="false";
	if( weekGateway.delete(rc.oWeek) ){
		// delete games for this week
		variables.gameGateway.deleteByWeek(rc.nWeekID);
		// delete picks for this week
		variables.pickGateway.deleteWeek(rc.nWeekID);
		// delete standings for this week
		variables.standingGateway.deleteByWeek(rc.nWeekID);
		rc.aResult = true;
	}
	variables.framework.redirect("week.manage");
}


public void function setWeekGames(rc){
	param name="rc.bOverrideLock" default="false";
	if( rc.nWeekID neq 0 ){
		// default picks
		rc.arPicks = [];
		// check to see if there are any games loaded already
		rc.arGames = variables.gameService.adminWeek(rc.nWeekID);

		if( arrayLen(rc.arGames) lt 1 ){
			// reset the view to allow them to set the games
			rc.sInnerView = variables.framework.view("week/setGames");
		} else {
			// reset the view to allow them to edit existing games
			rc.sInnerView = variables.framework.view("week/editGames");
		}
	}
	rc.bIsDialog = false;
	if( rc.bOverrideLock ){
		rc.bIsLocked = false;
	}
	rc.bIsAdminAction = true;
}

public void function addGame(rc){
	// get list of teams
	rc.arTeams = teamGateway.getAll();
}

public void function manage(rc){
	rc.bIsDialog = false;
	rc.arWeeks = variables.weekGateway.getSeason(rc.nCurrentSeasonID);
	rc.bIsAdminAction = true;
}

public void function getWeeklyTeamResults(rc){
	param name="rc.bForce" default="false";
	rc.stWeeklyTeamResults = variables.weekService.getTeamResults(rc.nWeekID, rc.bForce);
	rc.bIsDialog = false;
}

public void function getAPRankings(rc){
	variables.gameService.updateGamesWithRankings(rc.nWeekID, rc.nCurrentSeasonID);
	rc.bIsDialog = false;
}

public void function getRecords(rc){
	variables.gameService.updateGamesWithRecords(rc.nWeekID, rc.nCurrentSeasonID);
	rc.bIsDialog = false;
}

public void function makeAutoPicks(rc){
	// if the week is locked and we haven't done the autopicks yet
	if( rc.bIsLocked and !isNull(rc.oWeek.getNWeekID()) and (isNull(rc.oWeek.getBAutoPicksMade()) or !rc.oWeek.getBAutoPicksMade()) ){
		variables.weekService.makeAutoPicks(rc.nWeekID, rc.nCurrentSeasonID);
		// update the week status
		rc.oWeek = variables.weekGateway.update(rc.oWeek, { "bAutoPicksMade" = 1 });
	}
	rc.bIsDialog = false;
	rc.sMessage = "Auto picks made - [#rc.oWeek.getBAutoPicksMade()#] - #rc.oWeek.getNWeekID()# - #rc.bIsLocked#";
	variables.framework.setView("main.message");
}

}

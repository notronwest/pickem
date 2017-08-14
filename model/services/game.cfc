component accessors="true" extends="model.services.baseService" {

property name="gameGateway";
property name="pickGateway";
property name="teamGateway";
property name="teamService";
property name="weekService";

/*
Author:
	Ron West
Name:
	$clearGamesByWeek
Summary:
	Given a week, delete all of the games for that week
Returns:
	Void
Arguments:
	Numeric nWeekID
History:
	2012-09-12 - RLW - Created
*/
public Void function clearGamesByWeek( Required Numeric nWeekID ){
	try{
		// delete the actual games
		variables.gameGateway.deleteByWeek(arguments.nWeekID);
		// delete the user selections for this week
		variables.pickGateway.deleteWeek(arguments.nWeekID);
	} catch (any e){
		registerError("Error clearing out games for a week", e);
	}
}

/*
Author:
	Ron West
Name:
	$clearGameByGameID
Summary:
	Given a gamID, delete all of the games and picks
Returns:
	Void
Arguments:
	Numeric nGameID
History:
	2014-08-28 - RLW - Created
*/
public Void function clearGameByGameID( Required Numeric nGameID ){
	try{
		// delete the actual games
		variables.gameGateway.deleteByGame(arguments.nGameID);
		// delete the user selections for this week
		variables.pickGateway.deleteGame(arguments.nGameID);
	} catch (any e){
		registerError("Error clearing out games for a week", e);
	}
}

/*
Author:
	Ron West
Name:
	$adminWeek
Summary:
	Loads a game for the week to be administered
Returns:
	Void
Arguments:
	Numeric nWeekID
	Boolean bSortByTiebreak
	Boolean bAppendMascot
History:
	2012-09-12 - RLW - Created
	2015-10-13 - RLW - Added option to append mascot name to team name
*/
public Array function adminWeek( Required Numeric nWeekID, Boolean bSortByTiebreak = false, Boolean bAppendMascot = true ){
	try{
		var itm = 1;
		var arGames = "";
		var oHomeTeam = "";
		var oAwayTeam = "";
		var stGame = {};
		if( arguments.bSortByTiebreak ){
			arGames = variables.gameGateway.getByWeekSort(arguments.nWeekID, "abs(nTiebreak)");
		} else {
			arGames = variables.gameGateway.getByWeek(arguments.nWeekID, "nOrder");
		}
		// build the array that contains the proper structure
		for( itm; itm lte arrayLen(arGames); itm++ ){
			// reset the array with the new structure
			arGames[itm] = buildGameStruct(arGames[itm], arguments.bAppendMascot);
		}
	} catch (any e){
		registerError("Error setting up games for a week", e);
	}
	return arGames;
}

/*
Author:
	Ron West
Name:
	$buildGameStruct
Summary:
	Builds a simple structure with all of the data from the game
Returns:
	Struct stGame
Arguments:
	Game oGame
	Boolean bAppendMascot
History:
	2014-10-14 - RLW - Created
	2015-10-13 - RLW - Added option to append mascot name to team name
*/
public Struct function buildGameStruct( Required model.beans.game oGame, Boolean bAppendMascot = true ){
	var oHomeTeam = variables.teamGateway.get(arguments.oGame.getNHomeTeamID());
	var oAwayTeam = variables.teamGateway.get(arguments.oGame.getNAwayTeamID());
	var stGame = {
		"bGameIsNCAA" = (oHomeTeam.getNType() eq 1) ? true : false,
		"nGameID" = arguments.oGame.getNGameID(),
		"nHomeTeamID" = arguments.oGame.getNHomeTeamID(),
		"sHomeTeam" = oHomeTeam.getSName() & ((arguments.bAppendMascot) ? " " & oHomeTeam.getSMascot() : ""),
		"sHomeTeamMascot" = oHomeTeam.getSMascot(),
		"sHomeTeamURL" = oHomeTeam.getSURL(),
		"nHomeTeamRanking" = (isNull(arguments.oGame.getNHomeTeamRanking())) ? "" : arguments.oGame.getNHomeTeamRanking(),
		"sHomeTeamRecord" = (isNull(arguments.oGame.getSHomeTeamRecord())) ? "" : arguments.oGame.getSHomeTeamRecord(),
		"nAwayTeamID" = arguments.oGame.getNAwayTeamID(),
		"sAwayTeam" = oAwayTeam.getSName() & ((arguments.bAppendMascot) ? " " & oAwayTeam.getSMascot() : ""),
		"sAwayTeamMascot" = oAwayTeam.getSMascot(),
		"sAwayTeamURL" = oAwayTeam.getSURL(),
		"nAwayTeamRanking" = (isNull(arguments.oGame.getNAwayTeamRanking())) ? "" : arguments.oGame.getNAwayTeamRanking(),
		"sAwayTeamRecord" = (isNull(arguments.oGame.getSAwayTeamRecord())) ? "" : arguments.oGame.getSAwayTeamRecord(),
		"nType" = oHomeTeam.getNType(),
		"nSpread" = arguments.oGame.getNSpread(),
		"sSpreadFavor" = arguments.oGame.getSSpreadFavor(),
		"nHomeScore" = (isNull(arguments.oGame.getNHomeScore())) ? "" : arguments.oGame.getNHomeScore(),
		"nAwayScore" = (isNull(arguments.oGame.getNAwayScore())) ? "" : arguments.oGame.getNAwayScore(),
		"nTiebreak" = arguments.oGame.getNTiebreak(),
		"sSpreadOriginal" = arguments.oGame.getSSpreadOriginal(),
		"sGameDateTime" = (isNull(arguments.oGame.getSGameDateTime()) ) ? "" : arguments.oGame.getSGameDateTime(),
		"dtLock" = (isNull(arguments.oGame.getDtLock()) ) ? "" : arguments.oGame.getDtLock(),
		"nWinner" = (isNull(arguments.oGame.getNWinner())) ? 0 : arguments.oGame.getNWinner(),
		"nOrder" = arguments.oGame.getNOrder(),
		"sGameStatus" = (isNull(arguments.oGame.getSGameStatus()))? "" : arguments.oGame.getSGameStatus(),
		"bGameIsFinal" = (isNull(arguments.oGame.getBGameIsFinal())) ? 0 : arguments.oGame.getBGameIsFinal()
	};
	return stGame;
}

/*
Author:
	Ron West
Name:
	$buildOrderedArray
Summary:
	Creates an ordered array for this weeks games
Returns:
	Array arGames
Arguments:
	Numeric nWeekID
History:
	2012-09-12 - RLW - Created
*/
public Array function buildOrderedArray( Numeric nWeekID = 0 ){
	var itm = 1;
	// get the ordered games for this week
	var arGamesSorted = adminWeek(arguments.nWeekID);
	var arGames = [];
	// loop through the games and build the array of games
	for( itm; itm lte arrayLen(arGamesSorted); itm++ ){
		// append each team with the game id
		if( compareNoCase(arGamesSorted[itm].sSpreadFavor, "home") eq 0 ){
			arrayAppend(arGames, { "nTeamID" = arGamesSorted[itm].nHomeTeamID, "nGameID" = arGamesSorted[itm].nGameID });
			arrayAppend(arGames, { "nTeamID" = arGamesSorted[itm].nAwayTeamID, "nGameID" = arGamesSorted[itm].nGameID });
		} else {
			arrayAppend(arGames, { "nTeamID" = arGamesSorted[itm].nAwayTeamID, "nGameID" = arGamesSorted[itm].nGameID });
			arrayAppend(arGames, { "nTeamID" = arGamesSorted[itm].nHomeTeamID, "nGameID" = arGamesSorted[itm].nGameID });
		}
	}
	return arGames;
}

/*
Author:
	Ron West
Name:
	$getGameStructByWeek
Summary:
	Creates a structure of games indexed by game ID
Returns:
	Struct stGames
Arguments:
	Numeric nWeekID
History:
	2014-08-27 - RLW - Created
*/
public Struct function getGameStructForWeek( Required Numeric nWeekID ){
	// get the games for this week
	var arGames = variables.gameGateway.getByWeek(arguments.nWeekID);
	var stGames = {};
	var itm =1;
	// loop through the games and save them to the struct
	for(itm; itm lte arrayLen(arGames); itm ++ ){
		structInsert(stGames, arGames[itm].getNGameID(), buildGameStruct(arGames[itm]));
	}
	return stGames;
}

/*
Author:
	Ron West
Name:
	$getGameScores
Summary:
	Based on the games sent it - goes and gets the scores
Returns:
	Array arScores
Arguments:
	Array arGames
History:
	2014-09-12 - RLW - Created
*/
public Array function getGameScores( Required Array arGames){
	var itm = 1;
	var oHomeTeam = "";
	var oAwayTeam = "";
	var stURLResults = {};
	var stGameData = {};
	// loop through the games and get the score
	try{
		for( itm; itm lte arrayLen(arGames); itm++ ){
			// if this game doesn't have a winner yet and the game date is today or greater
			if( variables.dbService.dbDateFormat(arGames[itm].sGameDateTime) lte variables.dbService.dbDayBegin() and (!isNumeric(arguments.arGames[itm].bGameIsFinal) or arguments.arGames[itm].bGameIsFinal eq 0) ){
				// get the home team name
				oHomeTeam = variables.teamGateway.get(arGames[itm].nHomeTeamID);
				oAwayTeam = variables.teamGateway.get(arGames[itm].nAwayTeamID);
				stGameData = callScoreAPI(variables.teamService.getTeamNameArray(oHomeTeam), variables.teamService.getTeamNameArray(oAwayTeam), arGames[itm].sGameDateTime);
				// if we have game status then update the array for this game
				if( structKeyExists(stGameData, "stGameStatus") and len(stGameData.nHomeScore) and len(stGameData.nAwayScore) ){
					// update the scores
					arGames[itm].nHomeScore = stGameData.nHomeScore;
					arGames[itm].nAwayScore = stGameData.nAwayScore;
					// update the status
					arGames[itm].sGameStatus = (stGameData.stGameStatus.bGameIsFinal eq 1) ? "Final" : stGameData.stGameStatus.nGameQuarter & " " & stGameData.stGameStatus.sGameTime;
					arGames[itm].bGameIsFinal = stGameData.stGameStatus.bGameIsFinal;
				}
			}
		}
		// save the games
		variables.gameGateway.saveScores(arGames);
	} catch (any e){
		registerError(e.message, e);
		// need to do e-mail or something
	}
	return arGames;
}

/*
Author:
	Ron West
Name:
	$callScoreAPI
Summary:
	Search Yahoo to get the scores
Returns:
	Struct stGameData
Arguments:
	Array arHomeTeamName
	Array arAwayTeamName
	String dtGame
	Boolean bIsHomeTeam
History:
	2015-09-09 - RLW - Created
*/
public Struct function callScoreAPI(Required Array arHomeTeamName, Required Array arAwayTeamName, Required String dtGame){
	var stResponse = {};
	var stGameData = {};
	var stSearchResults = variables.commonService.getURL("http://localhost:3000/get-scores", 5, { "lstHomeTeam" = arrayToList(arguments.arHomeTeamName, "|"), "lstAwayTeam" = arrayToList(arguments.arAwayTeamName, "|"), "dtGame" = dateFormat(arguments.dtGame, "yyyymmdd")});
	// if we have a valid response
	if( find("200", stSearchResults.statusCode) gt 0 and isJSON(stSearchResults.fileContent.toString()) ){
		stResponse = deserializeJSON(stSearchResults.fileContent.toString());
		// make sure the API call was successful
		if( find(200, stResponse.stResults.sStatus) ){
			// get the game data
			stGameData = stResponse.stResults.stGameData;
		} else {
			// API called failed
		}
	} else {
		// need logging
	}
	return stGameData;
}

/*
Author:
	Ron West
Name:
	$getGameStats
Summary:
	Get the game stats for the game
Returns:
	Struct stGameStats
Arguments:
	Game oGame
History:
	2014-10-19 - RLW - Created
*/
public Struct function getGameStats( Required model.beans.game oGame ){
	var stGameStats = {
		arHomeTeam = variables.pickGateway.getPicksByGameAndTeam(arguments.oGame.getNGameID(), arguments.oGame.getNHomeTeamID()),
		arAwayTeam = variables.pickGateway.getPicksByGameAndTeam(arguments.oGame.getNGameID(), arguments.oGame.getNAwayTeamID())//,
		//nHomeATS = variables.pickGateway.getTeamATS(arguments.oGame.getNHomeTeamID()),
		//nAwayATS = variables.pickGateway.getTeamATS(arguments.oGame.getNAwayTeamID())
	};
	return stGameStats;
}

/*
Author:
	Ron West
Name:
	$reassignTeam
Summary:
	Reassigns a team from one to another
Returns:
	Boolean bSuccess
Arguments:
	Numeric nOldTeamID
	Numeric nNewTeamID
History:
	2015-09-25 - RLW - Created
*/
public Boolean function reassignTeam( Required Numeric nOldTeamID, Required Numeric nNewTeamID ){
	// get the games for this team
	var arGames = variables.gameGateway.getTeamGames(nOldTeamID);
	var itm = 1;
	var bSuccess = true;
	try{
		for(itm; itm lte arrayLen(arGames); itm++ ){
			// update either the home or away game
			if( arGames[itm].getNHomeTeamID() eq arguments.nOldTeamID){
				arGames[itm].setNHomeTeamID(arguments.nNewTeamID);
			} else {
				arGames[itm].setNAwayTeamID(arguments.nNewTeamID);
			}
			variables.gameGateway.save(arGames[itm]);
		}
	} catch (any e){
		bSuccess = false;
		logError("Error trying to switch games for team #arguments.nOldTeamID# to #arguments.nNewTeamID#", e);
	}
	return bSuccess;
}

/*
Author:
	Ron West
Name:
	$buildTeamRankings
Summary:
	Builds a structure with the team rankings
Returns:
	Struct stRankings
Arguments:
	Numeric nWeekID
	Numeric nSeasonID
History:
	2015-10-09 - RLW - Created
*/
public Struct function buildTeamRankings(){
	// get the standings for this week
	var arStandingsFromSource = variables.weekService.getRankings();
	var itm = 1;
	var arTeam = [];
	var stRankings = {};
	// loop over the rankings and load the team
	for(itm; itm lte arrayLen(arStandingsFromSource); itm++ ){
		// see if this has a team
		arTeam = variables.teamGateway.getByExactName(arStandingsFromSource[itm]);
		// if this has a team then see if this team is in a game this week
		if( arrayLen(arTeam) gt 0 and arTeam[1].getNType() eq 1 ){
			stRankings[itm] = arTeam[1].getNTeamID();
		}
	}
	return stRankings;
}

/*
Author:
	Ron West
Name:
	$updateGamesWithRankings
Summary:
	Updates the rankings for this week
Returns:
	Boolean bUpdated
Arguments:
	Numeric nWeekID
	Numeric nSeasonID
History:
	2015-10-09 - RLW - Created
*/
public Boolean function updateGamesWithRankings( Required Numeric nWeekID, Required Numeric nSeasonID ){
	var bUpdated = true;
	// get the structure of rankings
	var stRankings = buildTeamRankings();
	var stGameData = {};
	var sRanking = "";
	var arGame = [];
	// loop through the rankings to see if the team has any games
	for( sRanking in stRankings ){
		// see if this team is involved with any games this week
		arGame = variables.gameGateway.getTeamGamesByWeek(stRankings[sRanking], arguments.nWeekID, arguments.nSeasonID);
		if( arrayLen(arGame) gt 0 ){
			// reset game data
			stGameData = {};
			// see if this team is home or away
			if( arGame[1].getNHomeTeamID() eq stRankings[sRanking] ){
				stGameData.nHomeTeamRanking = sRanking;
			} else {
				stGameData.nAwayTeamRanking = sRanking;
			}
			// update the game with the rankings
			variables.gameGateway.update(arGame[1], stGameData);
		}
	}
	return bUpdated;
}

/*
Author:
	Ron West
Name:
	$updateGamesWithRecords
Summary:
	Updates the team records for this week
Returns:
	Boolean bUpdated
Arguments:
	Numeric nWeekID
	Numeric nSeasonID
History:
	2015-11-01 - RLW - Created
*/
public Boolean function updateGamesWithRecords( Required Numeric nWeekID, Required Numeric nSeasonID){
	bSuccess = true;
	// get the games for this week
	var arGames = adminWeek(arguments.nWeekID, arguments.nSeasonID, false, false);
	var itm = 1;
	var stGameData = {};
	for( itm; itm lte arrayLen(arGames); itm++){
		// reset game data
		stGameData = {};
		// get the record for the home team
		if( len(arGames[itm].sHomeTeamRecord) eq 0 ){
			stGameData.sHomeTeamRecord = variables.teamService.getCurrentRecord(arGames[itm].sHomeTeam & " " & arGames[itm].sHomeTeamMascot);
		}
		// get the record for the away team
		if( len(arGames[itm].sAwayTeamRecord) eq 0 ){
			stGameData.sAwayTeamRecord = variables.teamService.getCurrentRecord(arGames[itm].sAwayTeam & " " & arGames[itm].sAwayTeamMascot);
		}
		if( listLen(structKeyList(stGameData)) gt 0 ){
			// save the game
			variables.gameGateway.update(variables.gameGateway.get(arGames[itm].nGameID), stGameData);
		}
	}
	return bSuccess;
}

/*
Author:
	Ron West
Name:
	$getAvailableGames
Summary:
	Retrieves the available games for the site
Returns:
	Array arGameData
Arguments:
	Numeric nWeekID
History:
	2016-09-07 - RLW - Created
*/
public array function getAvailableGames( Boolean bGetNCAAGames = true, Boolean bGetNFLGames = true ){
	var arGameData = [];
	var stGameResults = {};
	//var sNCAAScheduleURL = "http://www.donbest.com/ncaaf/odds/";
	//var sNFLScheduleURL = "http://www.donbest.com/nfl/odds/";
	var sNCAAScheduleURL = "http://www.vegasinsider.com/college-football/scoreboard/";
	var sNFLScheduleURL = "http://www.vegasinsider.com/nfl/scoreboard/";
	var arGameScheduleURL = [];
	if( arguments.bGetNCAAGames ){
		arrayAppend(arGameScheduleURL, sNCAAScheduleURL);
	}
	if( arguments.bGetNFLGames ){
		arrayAppend(arGameScheduleURL, sNFLScheduleURL);
	}
	var itm = 1;
	var x = 1;
	for( itm; itm lte arrayLen(arGameScheduleURL); itm++ ){
		// get game raw data
		stGameResults = variables.commonService.getURL("http://localhost:3000/get-games?sScheduleURL=" & arGameScheduleURL[itm], 25);
		// if we have a valid response
		if( find("200", stGameResults.statusCode) gt 0 and isJSON(stGameResults.fileContent.toString()) ){
			stResponse = deserializeJSON(stGameResults.fileContent.toString());
			// make sure the API call was successful
			if( find(200, stResponse.stResults.sStatus) ){
				// add games (fixing up dates)
				for(x=1; x lte arrayLen(stResponse.stResults.arGameData); x++ ){
					if( structKeyExists(stResponse.stResults.arGameData[x], "sGameDateTime") ){
						// sometimes gametime has crappy names
						sGameDateTime = listLast(sGameDateTime, "-");
						sGameDateTime = dateFormat(stResponse.stResults.arGameData[x].sGameDateTime, 'yyyy-mm-dd') & " " & timeFormat(stResponse.stResults.arGameData[x].sGameDateTime, 'HH:mm');
					} else {
						sGameDateTime = "";
					}
					// requires lock date
					stResponse.stResults.arGameData[x]["dtLock"] = sGameDateTime;
					stResponse.stResults.arGameData[x].sGameDateTime = sGameDateTime;
					// add in team league
					if( findNoCase("/college", arGameScheduleURL[itm]) ){
						stResponse.stResults.arGameData[x]["nType"] = 1;
					} else {
						stResponse.stResults.arGameData[x]["nType"] = 2;
					}
					arrayAppend(arGameData, stResponse.stResults.arGameData[x]);
				}

			} else {
				// API called failed
			}
		} else {
			// need logging
		}
	}
	return arGameData;
}

/*
Author:
	Ron West
Name:
	$hasGameStarted
Summary:
	Checks to see if a given game has started
Returns:
	Boolean bGameHasStarted
Arguments:
	Numeric nGameID
History:
	2016-09-11 - RLW - Created
*/
public boolean function hasGameStarted( Required numeric nGameID, Required String dtNow ){
	var oGame = variables.gameGateway.get(arguments.nGameID);
	var bGameHasStarted = false;
	if( !isNull(oGame.getNGameID()) and variables.dbService.dbDateTimeFormat(oGame.getSGameDateTime()) lte arguments.dtNow ){
		bGameHasStarted = true;
	}
	return bGameHasStarted;
}

}

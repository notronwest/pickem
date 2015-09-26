component accessors="true" extends="model.services.baseService" {

property name="gameGateway";
property name="pickGateway";
property name="teamGateway";
property name="teamService";

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
History:
	2012-09-12 - RLW - Created
*/
public Array function adminWeek( Required Numeric nWeekID, Boolean bSortByTiebreak = false ){
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
			arGames[itm] = buildGameStruct(arGames[itm]);
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
History:
	2014-10-14 - RLW - Created
*/
public Struct function buildGameStruct( Required model.beans.game oGame ){
	var oHomeTeam = variables.teamGateway.get(arguments.oGame.getNHomeTeamID());
	var oAwayTeam = variables.teamGateway.get(arguments.oGame.getNAwayTeamID());
	var stGame = {
		"nGameID" = arguments.oGame.getNGameID(),
		"nHomeTeamID" = arguments.oGame.getNHomeTeamID(),
		"sHomeTeam" = oHomeTeam.getSName(),
		"sHomeTeamURL" = oHomeTeam.getSURL(),
		"nAwayTeamID" = arguments.oGame.getNAwayTeamID(),
		"sAwayTeam" = oAwayTeam.getSName(),
		"sAwayTeamURL" = oAwayTeam.getSURL(),
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
		structInsert(stGames, arGames[itm].getNGameID(), {
			"nHomeTeamID" = arGames[itm].getNHomeTeamID(),
			"nAwayTeamID" = arGames[itm].getNAwayTeamID(),
			"sSpreadFavor" = arGames[itm].getSSpreadFavor(),
			"nSpread" = arGames[itm].getNSpread()
		});
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

}

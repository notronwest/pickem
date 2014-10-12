component accessors="true" extends="model.services.baseService" {

property name="gameGateway";
property name="pickGateway";
property name="teamGateway";

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
			arGames = variables.gameGateway.getByWeekSort(arguments.nWeekID, "abs(nOrder),abs(nTiebreak)");
		} else {
			arGames = variables.gameGateway.getByWeek(arguments.nWeekID);
		}
		// build the array that contains the proper structure
		for( itm; itm lte arrayLen(arGames); itm++ ){
			oHomeTeam = variables.teamGateway.get(arGames[itm].getNHomeTeamID());
			oAwayTeam = variables.teamGateway.get(arGames[itm].getNAwayTeamID());
			stGame = {
				"nGameID" = arGames[itm].getNGameID(),
				"nHomeTeamID" = arGames[itm].getNHomeTeamID(),
				"sHomeTeam" = oHomeTeam.getSName(),
				"sHomeTeamURL" = oHomeTeam.getSURL(),
				"nAwayTeamID" = arGames[itm].getNAwayTeamID(),
				"sAwayTeam" = oAwayTeam.getSName(),
				"sAwayTeamURL" = oAwayTeam.getSURL(),
				"nSpread" = arGames[itm].getNSpread(),
				"sSpreadFavor" = arGames[itm].getSSpreadFavor(),
				"nHomeScore" = (isNull(arGames[itm].getNHomeScore())) ? "" : arGames[itm].getNHomeScore(),
				"nAwayScore" = (isNull(arGames[itm].getNAwayScore())) ? "" : arGames[itm].getNAwayScore(),
				"nTiebreak" = arGames[itm].getNTiebreak(),
				"sSpreadOriginal" = arGames[itm].getSSpreadOriginal(),
				"sGameDateTime" = arGames[itm].getSGameDateTime(),
				"nWinner" = (isNull(arGames[itm].getNWinner())) ? 0 : arGames[itm].getNWinner(),
				"nOrder" = arGames[itm].getNOrder(),
				"sGameStatus" = (isNull(arGames[itm].getSGameStatus()))? "" : arGames[itm].getSGameStatus(),
				"bGameIsFinal" = (isNull(arGames[itm].getBGameIsFinal())) ? 0 : arGames[itm].getBGameIsFinal()
			};
			// reset the array with the new structure
			arGames[itm] = stGame;
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
	var oTeam = "";
	var stURLResults = {};
	var sPageContent = "";
	var arScores = [];
	var sScoreBoxBegin = "akp_target";
	var sScoreBoxEnd = "_Xg vk_gy";
	var sGameStatusBegin = '<span class="vk_gy">';
	var sGameStatusEnd = '</span>';
	var sGameStatus = "";
	var sScoreBegin = '<div class="_UMb"><div class="vk_txt">&nbsp;</div><div>';
	var sScoreEnd = "</div>";
	var sHomeScoreBegin = '<div class="_wZc _fZc">';
	var sHomeScoreEnd = '</div>';
	var sAwayScoreBegin = '<div class="_wZc _fZc">';
	var sAwayScoreEnd = '</div>';
	var sHomeScore = '';
	var sAwayScore = '';
	var sScore = "";
	var nStart = 0;
	var nEnd = 0;
	var sScoreBox = "";
	// loop through the games and get the score
	try{
		for( itm; itm lte arrayLen(arGames); itm++ ){
			// if this game is today and we don't have a winner yet
			if( (!isNumeric(arguments.arGames[itm].bGameIsFinal) or arguments.arGames[itm].bGameIsFinal eq 0) and arguments.arGames[itm].sGameDateTime lte variables.dbService.dbDateTimeFormat() ){
				// get the away team name
				oTeam = variables.teamGateway.get(arGames[itm].nAwayTeamID);
				// if we have a valid team name
				if( len(oTeam.getSName()) gt 0 ){
					// get the page from Google
					stURLResults = variables.commonService.getURL("https://www.google.com/search?q=#oTeam.getSName()#&oq=pitts&aqs=chrome.0.69i59j69i57j0l4.1622j0j9&sourceid=chrome&es_sm=119&ie=UTF-8");
					// if we have a valid document
					if( findNoCase("200",stURLResults.statusCode) ){
						// get the score box
						sScoreBox = variables.commonService.parseToFindString(stURLResults.fileContent.toString(), sScoreBoxBegin, sScoreBoxEnd);
						// if we have a score box to work with
						if( len(sScoreBox) gt 0 ){
							// get the status of the game
							sGameStatus = variables.commonService.parseToFindString(sScoreBox, sGameStatusBegin, sGameStatusEnd);
							// if there was a status for the game
							if( len(sGameStatus) gt 0 ){
								arGames[itm].sGameStatus = sGameStatus;
								// if the game is final then set it to final
								if( compareNoCase(sGameStatus, "Final") eq 0 ){
									arGames[itm].bGameIsFinal = 1;
								}
								// get the score (old way)
								sScore = variables.commonService.parseToFindString(sScoreBox, sScoreBegin, sScoreEnd);
								// if there was a score here
								if( len(sScore) gt 0 ){
									// set away score
									arGames[itm].nAwayScore = trim(listFirst(sScore, "-"));
									// set home score
									arGames[itm].nHomeScore = trim(listLast(sScore, "-"));
									// save the game
									variables.gameGateway.saveScores([arGames[itm]]);
								} else {
									// try the new scoring mechanism
									sAwayScore = variables.commonService.parseToFindString(sScoreBox, sAwayScoreBegin, sAwayScoreEnd);
									if( len(sAwayScore) ){
										// delete that section so the home score can be retrieved
										sScoreBox = replaceNoCase(sScoreBox, sAwayScoreBegin, "");
										// get the home score
										sHomeScore = variables.commonService.parseToFindString(sScoreBox, sHomeScoreBegin, sHomeScoreEnd);
										if( len(sHomeScore) ){
											arGames[itm].nAwayScore = trim(sAwayScore);
											arGames[itm].nHomeScore = trim(sHomeScore);
										}
										else {
											structInsert(arGames[itm], "sMessage", "The new way produced no scores either");
										}
									} else {
										// there was no score even though the game was final
										structInsert(arGames[itm], "sMessage", "No Score Found - even though we should have");
									}
								}
							} else {
								// could not find the game status
								structInsert(arGames[itm], "sMessage", "No Game Status");
							}
						} else {
							// could not find the game data
							structInsert(arGames[itm], "sMessage", "No Game Data");
						}
					} else {
						throw( message="google did not like your query");
					}
				}
			}
		}
	} catch (any e){
		registerError("Error retrieving game data for team: ", e);
		// need to do e-mail or something
	}
	return arGames;
}

}
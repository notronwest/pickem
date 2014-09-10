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
			arGames = variables.gameGateway.getByWeekSort(arguments.nWeekID, "abs(nOrder),abs(sTiebreak)");
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
				"sTiebreak" = arGames[itm].getSTiebreak(),
				"sSpreadOriginal" = arGames[itm].getSSpreadOriginal(),
				"sGameDateTime" = arGames[itm].getSGameDateTime(),
				"nWinner" = arGames[itm].getNWinner(),
				"nOrder" = arGames[itm].getNOrder()
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
public Numeric function determineWinner( Required Numeric nHomeTeamID, Required Numeric nHomeScore, Required Numeric nAwayTeamID, Required Numeric nAwayScore, Required String nSpread, Required String sSpreadFavor ){
	var nWinner = 0;
	try {
		// determine the underdog and nFavorite
		if( compareNoCase(arguments.sSpreadFavor, "home") eq 0 ){
			nFavoriteScore = arguments.nHomeScore;
			nUnderdogScore = arguments.nAwayScore;
			if( nFavoriteScore > (nUnderdogScore + arguments.nSpread) ){
				nWinner = arguments.nHomeTeamID;
			} else {
				nWinner = arguments.nAwayTeamID;
			}
		} else {
			nFavoriteScore = arguments.nAwayScore;
			nUnderdogScore = arguments.nHomeScore;
			if( nFavoriteScore > (nUnderdogScore + arguments.nSpread) ){
				nWinner = arguments.nAwayTeamID;
			} else {
				nWinner = arguments.nHomeTeamID;
			}
		}
	} catch( any e ){
		registerError("Error determinig winner", e);
	}
	return nWinner;
}

}
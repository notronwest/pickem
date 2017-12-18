component accessors="true" extends="model.base" {

property name="gameService";

/*
Author:
	Ron West
Name:
	$get
Summary:
	Gets the game object
Returns:
	Game oGame
Arguments:
	Numeric nGameID
History:
	2012-09-12 - RLW - Created
*/
public model.beans.game function get( Numeric nGameID=0 ){
	var oGame = new model.beans.game();
	var arGame = [];
	if( arguments.nGameID != 0 ){
		arGame = entityLoad("game", arguments.nGameID);
		if( arrayLen(arGame) ){
			oGame = arGame[1];
		}
	}
	return oGame;
}

/*
Author:
	Ron West
Name:
	$update
Summary:
	Updates the game object with new data
Returns:
	Game oGame
Arguments:
	Game oGame
	Struct stData
History:
	2012-09-12 - RLW - Created
*/
public model.beans.game function update( Required model.beans.game oGame, Required Struct stData ){
	// set the bean into request scope
	request.oBean = arguments.oGame;
	try{
		var sKey = "";
		var lstIgnore = "nGameID";
		// loop through all of the fields in the structure and update the data
		for( sKey in arguments.stData ){
			if( not listFindNoCase(lstIgnore, sKey) ){
				// default tiebreak
				if( compareNoCase("nTiebreak", sKey) eq 0 and !len(stData[sKey]) ){
					stData[sKey] = 0;
				}
				include "set.cfm";
			}
		}
		// save the entity
		entitySave(request.oBean);
		ormFlush();
	} catch (any e){
		registerError("Error in update function to game", e);
	}
	return request.oBean;
}
/*
Author:
	Ron West
Name:
	$save
Summary:
	Saves the game entity
Returns:
	Game oGame
Arguments:
	Game oGame
History:
	2012-09-12 - RLW - Created
*/
public model.beans.game function save( Required model.beans.game oGame){
	try{
		entitySave(arguments.oGame);
		ormFlush();
	} catch (any e){
		registerError("Error in saving game bean", e);
	}
	return arguments.oGame;
}

/*
Author:
	Ron West
Name:
	$saveWinner
Summary:
	Saves the winner for a game
Returns:
	void
Arguments:
	Numeric nGameID
	Numeric nWinner
History:
	2012-09-12 - RLW - Created
*/
public void function saveWinner( Required Numeric nGameID, Required Numeric nWinner ){
	try{
		var oGame = get(arguments.nGameID);
		oGame.setNWinner(arguments.nWinner);
		save(oGame);
	} catch (any e){
		registerError("Error saving winner for game", e);
	}
}

/*
Author:
	Ron West
Name:
	$delete
Summary:
	Delete2 the game entity
Returns:
	Game oGame
Arguments:
	Game oGame
History:
	2012-09-12 - RLW - Created
*/
public void function delete( Required model.beans.game oGame ){
	try{
		entityDelete(arguments.oGame);
		ormFlush();
	} catch (any e){
		registerError("Error in deleting game bean", e);
	}
}
/*
Author:
	Ron West
Name:
	$deleteByWeek
Summary:
	Deletes games by week
Returns:
	Void
Arguments:
	Numeric nWeekID
History:
	2012-09-12 - RLW - Created
*/
public void function deleteByWeek( Required Numeric nWeekID ){
	var itm = 1;
	var arGames = getByWeek(arguments.nWeekID);
	try {
		// loop through all of the games and delete them
		for( itm; itm lte arrayLen(arGames); itm++ ){
			delete(arGames[itm]);
		}
	} catch (any e){
		registerError("Error in deleting games by week", e);
	}
}

/*
Author:
	Ron West
Name:
	$deleteByGame
Summary:
	Deletes a game by gameID
Returns:
	Void
Arguments:
	Numeric nGameID
History:
	2014-08-28 - RLW - Created
*/
public void function deleteByGame( Required Numeric nGameID ){
	var itm = 1;
	var oGame = getByGameID(arguments.nGameID);
	try {
			delete(oGame);
	} catch (any e){
		registerError("Error in deleting game using gameID", e);
	}
}
/*
Author:
	Ron West
Name:
	$getByWeek
Summary:
	Returns games for a given week
Returns:
	Void
Arguments:
	Numeric nWeekID
History:
	2012-09-12 - RLW - Created
*/
public array function getByWeek( Required Numeric nWeekID ){
	var arGames = [];
	try{
		arGames = ormExecuteQuery( "from game where nWeekID = :nWeekID order by nOrder", { nWeekID = "#arguments.nWeekID#" });
	} catch (any e){
		registerError("Error in getting by week", e);
	}
	return arGames;
}

/*
Author:
	Ron West
Name:
	$getByWeekSort
Summary:
	Returns games for a given week sorted
Returns:
	Void
Arguments:
	Numeric nWeekID
	String sSort
History:
	2012-09-12 - RLW - Created
*/
public array function getByWeekSort( Required Numeric nWeekID, String sSort = "nTiebreak" ){
	var arGames = [];
	try{
		arGames = ormExecuteQuery( "from game where nWeekID = :nWeekID order by #arguments.sSort#", { nWeekID = "#arguments.nWeekID#" });
	} catch (any e){
		registerError("Error in getting by week", e);
	}
	return arGames;
}

/*
Author:
	Ron West
Name:
	$saveScores
Summary:
	Saves the scores for the game
Returns:
	Boolean bSaved
Arguments:
	Array arGames
History:
	2012-09-12 - RLW - Created
*/
public Boolean function saveScores( Required Array arGames ){
	var itm = 1;
	var oGame = "";
	var bSaved = true;
	try{
		// loop through the games and save each one
		for(itm; itm lte arrayLen(arguments.arGames); itm++ ){
			oGame = get(arguments.arGames[itm].nGameID);
			oGame.setNHomeScore(arguments.arGames[itm].nHomeScore);
			oGame.setNAwayScore(arguments.arGames[itm].nAwayScore);
			if( structKeyExists(arguments.arGames[itm], "sGameStatus") ){
				oGame.setSGameStatus(arguments.arGames[itm].sGameStatus);
			}
			if( structKeyExists(arguments.arGames[itm], "bGameIsFinal") ){
				oGame.setBGameIsFinal(arguments.arGames[itm].bGameIsFinal);
			}
			save(oGame);
		}
	} catch (any e){
		bSaved = false;
		registerError("Error saving scores", e);
	}
	return bSaved;
}

/*
Author:
	Ron West
Name:
	$getByGameID
Summary:
	Returns game for a given gameID
Returns:
	Game oGame
Arguments:
	Numeric nGameID
History:
	2014-08-28 - RLW - Created
*/
public model.beans.game function getByGameID( Required Numeric nGameID ){
	var arGames = [];
	var oGame = get();
	try{
		arGames = ormExecuteQuery( "from game where nGameID = :nGameID", { nGameID = "#arguments.nGameID#" });
		if( arrayLen(arGames) gt 0 ){
			oGame = arGames[1];
		}
	} catch (any e){
		registerError("Error in getting game by gameid", e);
	}
	return oGame;
}

/*
Author:
	Ron West
Name:
	$updateWinners
Summary:
	Updates games setting the winning team
Returns:
	void
Arguments:
	Numeric nWeekID
History:
	2014-09-10 - RLW - Created
*/
public void function updateWinners( Required Numeric nWeekID ){
	variables.dbService.runQuery("update game g1 join game g2 ON g1.nGameID = g2.nGameID
set g1.nWinner = calculateWinner(g2.nHomeTeamID,g2.nHomeScore,g2.nAwayTeamID,g2.nAwayScore,g2.nSpread,g2.sSpreadFavor)");
}

/*
Author:
	Ron West
Name:
	$getTeamGames
Summary:
	Returns a query for the teams games
Returns:
	Array arGames
Arguments:
	Numeric nTeamID
History:
	2014-10-24 - RLW - Created
*/
public Array function getTeamGames( Required Numeric nTeamID ){
	var arGames = ormExecuteQuery("from game where nHomeTeamID = :nTeamID or nAwayTeamID = :nTeamID", { nTeamID = arguments.nTeamID} );
	return arGames;
}

/*
Author:
	Ron West
Name:
	$getTeamGamesByWeek
Summary:
	Returns a query for the teams games this week
Returns:
	Array arGames
Arguments:
	Numeric nTeamID
	Numeric nWeekID
History:
	2015-10-09 - RLW - Created
*/
public Array function getTeamGamesByWeek( Required Numeric nTeamID, Required Numeric nWeekID ){
	var arGames = ormExecuteQuery("from game where (nHomeTeamID = :nTeamID or nAwayTeamID = :nTeamID) and nWeekID = :nWeekID", { nTeamID = arguments.nTeamID, nWeekID = arguments.nWeekID } );
	return arGames;
}

public array function getGamesNotFinishedThisWeek( String dtGame = now() ){
	var dtGameFormatted = dateFormat(arguments.dtGame, 'yyyy-mm-dd') & " " & '23:59:59';
	var dtGameThisWeek = dateFormat(dateAdd('w', -1, arguments.dtGame), 'yyyy-mm-dd') & " " & '00:00:01';
	var arGames = ormExecuteQuery("from game where sGameDateTime <= :dtGame and sGameDateTime >= :dtGameThisWeek and bGameIsFinal <> 1", { dtGame = dtGameFormatted , dtGameThisWeek = dtGameThisWeek } );
	return arGames;
}

}

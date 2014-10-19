component accessors="true" extends="model.base" {

/*
Author: 	
	Ron West
Name:
	$get
Summary:
	Gets the pick object
Returns:
	Pick oPick
Arguments:
	Numeric nPickID
History:
	2012-09-12 - RLW - Created
*/
public model.beans.pick function get( Numeric nPickID=0 ){
	var oPick = new model.beans.pick();
	var arPick = [];
	try{
		if( arguments.nPickID != 0 ){
			arPick = entityLoad("pick", arguments.nPickID);
			if( arrayLen(arPick) gt 0 ){
				oPick = arPick[1];
			}
		}
	} catch (any e){
		registerError("Error getting pick", e);
	}
	return oPick;
}

/*
Author: 	
	Ron West
Name:
	$update
Summary:
	Updates the pick object with new data
Returns:
	Pick oPick
Arguments:
	Pick oPick
	Struct stPick
History:
	2012-09-12 - RLW - Created
*/
public model.beans.pick function update( Required model.beans.pick oPick, Required Struct stPick ){
	try{
		arguments.oPick.setNWeekID(arguments.stPick.nWeekID);
		arguments.oPick.setNGameID(arguments.stPick.nGameID);
		arguments.oPick.setNTeamID(arguments.stPick.nTeamID);
		arguments.oPick.setNUserID(arguments.stPick.nUserID);
		arguments.oPick = save(oPick);
	} catch (any e){
		registerError("Error updating pick", e);
	}
	return arguments.oPick;
}

/*
Author: 	
	Ron West
Name:
	$save
Summary:
	Saves the pick entity
Returns:
	Pick oPick
Arguments:
	Pick oPick
History:
	2012-09-12 - RLW - Created
*/
public model.beans.pick function save( Required model.beans.pick oPick){
	try{
		entitySave(arguments.oPick);
		ormFlush();
	} catch (any e){
		registerError("Error saving pick bean", e);
	}
	return arguments.oPick;
}

/*
Author: 	
	Ron West
Name:
	$saveWin
Summary:
	Marks a game as a win
Returns:
	Void
Arguments:
	Numeric nPickID
History:
	2012-09-12 - RLW - Created
*/
public void function saveWin( Required Numeric nPickID){
	try{
		var oPick = get(arguments.nPickID);
		oPick.setNWin(1);
		save(oPick);
	} catch (any e){
		registerError("Error saving win", e);
	}
}

/*
Author: 	
	Ron West
Name:
	$clearWin
Summary:
	Clears a game as a win (incase scores were entered incorrectly)
Returns:
	Void
Arguments:
	Numeric nPickID
History:
	2014-08-21 - RLW - Created
*/
public void function clearWin( Required Numeric nPickID){
	try{
		var oPick = get(arguments.nPickID);
		oPick.setNWin(0);
		save(oPick);
	} catch (any e){
		registerError("Error clearing win", e);
	}
}

/*
Author: 	
	Ron West
Name:
	$delete
Summary:
	Deletes the pick entity
Returns:
	Boolean bDeleted
Arguments:
	Pick oPick
History:
	2012-09-12 - RLW - Created
*/
public Boolean function delete( Required model.beans.pick oPick){
	var bDeleted = true;
	try{
		entityDelete(arguments.oPick);
		ormFlush();
	} catch (any e){
		registerError("Error deleting pick bean", e);
		bDeleted = false;
	}
	return bDeleted;
}

/*
Author: 	
	Ron West
Name:
	$getUserWeek
Summary:
	Gets all picks for a user for a week
Returns:
	Array arPicks
Arguments:
	Numeric nWeekID
	Numeric nUserID
History:
	2012-09-12 - RLW - Created
*/
public Array function getUserWeek( Required Numeric nWeekID, Required Numeric nUserID ){
	var arPicks = ormExecuteQuery( "from pick where nWeekID = :nWeekID and nUserID = :nUserID", { nWeekID = arguments.nWeekID, nUserID = arguments.nUserID } );
	return arPicks;
}

/*
Author: 	
	Ron West
Name:
	$getWeek
Summary:
	Gets all picks for a week
Returns:
	Array arPicks
Arguments:
	Numeric nWeekID
History:
	2012-09-12 - RLW - Created
*/
public Array function getWeek( Required Numeric nWeekID ){
	var arPicks = ormExecuteQuery( "from pick where nWeekID = :nWeekID", { nWeekID = arguments.nWeekID } );
	return arPicks;
}

/*
Author: 	
	Ron West
Name:
	$getByGameID
Summary:
	Gets all picks for a gameID
Returns:
	Array arPicks
Arguments:
	Numeric nGameID
History:
	2014-08-28 - RLW - Created
*/
public Array function getByGameID( Required Numeric nGameID ){
	var arPicks = ormExecuteQuery( "from pick where nGameID = :nGameID", { nGameID = arguments.nGameID } );
	return arPicks;
}

/*
Author: 	
	Ron West
Name:
	$deleteUserWeek
Summary:
	Deletes all picks for a user for a week
Returns:
	Boolean bCompleted
Arguments:
	Numeric nWeekID
	Numeric nUserID
History:
	2012-09-12 - RLW - Created
*/
public Boolean function deleteUserWeek( Required Numeric nWeekID, Required Numeric nUserID ){
	try{
		var bCompleted = false;
		var arPicks = getUserWeek(arguments.nWeekID, arguments.nUserID);
		var itm = 1;
		for( itm; itm lte arrayLen(arPicks); itm++ ){
			delete(arPicks[itm]);
		}
		bCompleted = true;
	} catch (any e){
		registerError("Error deleting picks for user", e);
	}
	return bCompleted;
}

/*
Author: 	
	Ron West
Name:
	$deleteWeek
Summary:
	Deletes all picks for a week
Returns:
	Boolean bCompleted
Arguments:
	Numeric nWeekID
History:
	2012-09-12 - RLW - Created
*/
public Boolean function deleteWeek( Required Numeric nWeekID ){
	try{
		var bCompleted = false;
		var arPicks = getWeek(arguments.nWeekID);
		var itm = 1;
		for( itm; itm lte arrayLen(arPicks); itm++ ){
			delete(arPicks[itm]);
		}
		bCompleted = true;
	} catch (any e){
		registerError("Error deleting picks for user", e);
	}
	return bCompleted;
}

/*
Author: 	
	Ron West
Name:
	$deleteGame
Summary:
	Deletes all picks for a game
Returns:
	Boolean bCompleted
Arguments:
	Numeric nGameID
History:
	2014-08-28 - RLW - Created
*/
public Boolean function deleteGame( Required Numeric nGameID ){
	try{
		var bCompleted = false;
		var arPicks = getByGameID(arguments.nGameID);
		var itm = 1;
		for( itm; itm lte arrayLen(arPicks); itm++ ){
			delete(arPicks[itm]);
		}
		bCompleted = true;
	} catch (any e){
		registerError("Error deleting picks for user", e);
	}
	return bCompleted;
}

/*
Author: 	
	Ron West
Name:
	$getUserGame
Summary:
	Retrieves the pick for this user for this game
Returns:
	Game oGame
Arguments:
	Numeric nGameID
	Numeric nUserID
History:
	2013-09-14 - RLW - Created
*/
public model.beans.pick function getUserGame( Required Numeric nGameID, Required Numeric nUserID){
	var arGame = ormExecuteQuery("from pick where nGameID = :nGameID and nUserID = :nUserID", { "nGameID" = arguments.nGameID, "nUserID" = arguments.nUserID });
	var oGame = get();
	if( arrayLen(arGame) gt 0 ){
		oGame = arGame[1];
	}
	return oGame;
}

/*
Author: 	
	Ron West
Name:
	$getByUser
Summary:
	Retrieves all the pick for this user
Returns:
	Array arPicks
Arguments:
	Numeric nUserID
History:
	2014-09-10 - RLW - Created
*/
public Array function getByUser( Required Numeric nUserID){
	var arPicks = ormExecuteQuery("from pick where nUserID = :nUserID", { "nUserID" = arguments.nUserID});
	return arPicks;
}

/*
Author: 	
	Ron West
Name:
	$getPicksByGameAndTeam
Summary:
	Determines how many picks were made for that team
Returns:
	Array arPicks
Arguments:
	Numeric nGameID
	Numeric nTeamID
History:
	2014-10-19 - RLW - Created
*/
public Array function getPicksByGameAndTeam( Required numeric nGameID, Required numeric nTeamID ){
	var arPicks = ormExecuteQuery("from pick where nGameID = :nGameID and nTeamID = :nTeamID", {
	nGameID = arguments.nGameID, nTeamID = arguments.nTeamID } );
	return arPicks;
}

}
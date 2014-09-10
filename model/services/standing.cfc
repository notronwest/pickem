component accessors="true" extends="model.services.baseService" {

property name="userGateway";
property name="gameGateway";
property name="pickGateway";
property name="gameService";
property name="standingGateway";
/*
Author: 	
	Ron West
Name:
	$calculateWinners
Summary:
	Calculates winners for the week
Returns:
	Void
Arguments:
	Numeric nWeekID
	String sSeason
History:
	2012-09-12 - RLW - Created
*/
public void function calculateWinners( Required Numeric nWeekID, Required String sSeason ){
	// get the games/scores for this week (ordered by tiebreak);
	var arGames = variables.gameService.adminWeek(arguments.nWeekID, true);
	var nTotalGames = arrayLen(arGames);
	// get all of the users
	var arUsers = variables.userGateway.getAll();
	var itm = 1;
	var x = 1;
	var y = 1;
	var z = 1;
	var stGames = {};
	var nUnderdogScore = 0;
	var nFavoriteScore = 0;
	var nWinner = 0;
	var arPicks = [];
	var nUserWins = "";
	var lstTiebreakGameID = "";
	var lstWinningGames = "";
	var nHighTiebreak = "";
	var oStanding = "";
	try{
		// loop through the games and set up the structure of the winning teams
		for( itm; itm lte arrayLen(arGames); itm++ ){
			// make sure there are scores for this game
			if( isNumeric(arGames[itm].nHomeScore) and isNumeric(arGames[itm].nAwayScore) ){
				// build list of tiebreaks
				if( arGames[itm].sTiebreak > 0 ){
					lstTiebreakGameID = listAppend(lstTiebreakGameID, arGames[itm].nGameID);
				}
				// store the winning games for use later
				structInsert(stGames, arGames[itm].nGameID, arGames[itm].nWinner);
			}
		}
		//writeOutput(lstTiebreakGameID);
		// loop through the users to process their wins
		for( x=1; x lte arrayLen(arUsers); x++ ){
			nUserWins = 0;
			nHighTiebreak = 0;
			bTrackTiebreak = true;
			lstWinningGames = "";
			// get the picks for this user
			arPicks = variables.pickGateway.getUserWeek(arguments.nWeekID, arUsers[x].getNUserID());
			// loop through their picks and save wins/loses
			for( y=1; y lte arrayLen(arPicks); y++ ){
				// update the pick for this user to clear out wins (incase there was a scoring error)
				variables.pickGateway.clearWin(arPicks[y].getNPickID());
				// make sure there was an actual winner determined for this game
				if( structKeyExists(stGames, arPicks[y].getNGameID()) ){
					// check to see if this pick was a win - and score it
					if( stGames[arPicks[y].getNGameID()] eq arPicks[y].getNTeamID() ){
						// store the wins for each user in the picks table
						variables.pickGateway.saveWin(arPicks[y].getNPickID());
						// increase the wins for this user
						nUserWins++;
						// set this win for this user
						lstWinningGames = listAppend(lstWinningGames, arPicks[y].getNGameID());
					}
				}
			}
			// loop through the tiebreaks to see how this user did
			for( z=1; z lte listLen(lstTiebreakGameID); z++ ){
				// check to see if this game is a tiebreak
				if( listFind(lstWinningGames, listGetAt(lstTiebreakGameID, z) ) ){
					// store the position in the list as this is the tiebreak number for this game
					nHighTiebreak = z;
				} else {
					// stop tracking tiebreaks because we found a loss
					break;
				}
			}
			// delete the current standings for this week for this user
			variables.standingGateway.deleteUserWeek( arUsers[x].getNUserID(), arguments.nWeekID);
			// store the number of wins and tiebreaks for this user for this week
			oStanding = variables.standingGateway.get();
			oStanding = variables.standingGateway.update( oStanding, {
				nWeekID = arguments.nWeekID,
				nUserID = arUsers[x].getNUserID(),
				nWins = nUserWins,
				nLosses = nTotalGames - nUserWins,
				nTiebreaks = nHighTiebreak,
				sSeason = arguments.sSeason
			});
		}
		// process the places for this week
		setPlaceWeek(arguments.nWeekID);
	} catch ( any e ){
		registerError("Error calculating winners for week #arguments.nWeekID#", e);
	}
}

/*
Author: 	
	Ron West
Name:
	$setPlaceWeek
Summary:
	Sets the weekly place
Returns:
	Void
Arguments:
	Numeric nWeekID
History:
	2012-09-12 - RLW - Created
*/
public void function setPlaceWeek( Required Numeric nWeekID ){
	// get the standings for the week (note these will be ordered in winning order)
	var arStandings = variables.standingGateway.getWeek(arguments.nWeekID);
	var itm = 1;
	var oStanding = "";
	var curPlace = 1;
	var curWins = 20;
	var curTiebreak = 10;
	// loop through the standings and store place
	for( itm; itm lte arrayLen(arStandings); itm++ ){
		// keep track of the current places wins and tiebreaks
		if( curWins neq arStandings[itm].getNWins() ){
			curPlace = itm;
		} else if( curTiebreak neq arStandings[itm].getNTiebreaks() ){
			curPlace = itm;
		}
		variables.standingGateway.savePlace(arStandings[itm].getNStandingID(), curPlace);
		curWins = arStandings[itm].getNWins();
		curTiebreak = arStandings[itm].getNTiebreaks();
	}
}

/*
Author: 	
	Ron West
Name:
	$deleteUserStandings
Summary:
	Deletes the standings for a user
Returns:
	Void
Arguments:
	Numeric nUserID
History:
	2014-09-10 - RLW - Created
*/
public void function deleteUserStandings( Required Numeric nUserID ){
	// get the standings
	var arStandings = variables.standingGateway.getByUser(arguments.nUserID);
	var itm = 1;
	for(itm; itm lte arrayLen(arStandings); itm++ ){
		variables.standingGateway.delete(arStandings[itm]);
	}
}
	
}
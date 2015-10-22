component accessors="true" extends="model.services.baseService" {

property name="statGateway";

/*
Author: 	
	Ron West
Name:
	$getGameStatsForUser
Summary:
	Creates statistics for the user based on the game situation
Returns:
	Array arStats
Arguments:
	Struct stGame
	Numeric nUserID
	Numeric nSeasonID
History:
	2015-10-07 - RLW - Created
*/
public Array function getGameStatsForUser( Required Struct stGame, Required Numeric nUserID, Required Numeric nSeasonID ){
	var arStats = [];
	var qryRecord = queryNew("");
	// record against the spread
	if( arguments.stGame.nSpread gt 13 ){
		qryRecord = variables.statGateway.getRecordBySpread(13, ">=", arguments.nUserID, stGame.nType, arguments.nSeasonID);
		if( qryRecord.recordCount gt 0 and ( qryRecord.nWins gt 0 or qryRecord.nLosses gt 0 ) ){
			arrayAppend(arStats, {
				"sLabel" = "Winner when the spread is more than 13",
				"sDescription" = "Your record picking games when the spread is more than 13",
				"qryRecord" = qryRecord
			});
		}
	} else {
		qryRecord = variables.statGateway.getRecordBySpread(13, "<=", arguments.nUserID, stGame.nType, arguments.nSeasonID);
		if( qryRecord.recordCount gt 0 and ( qryRecord.nWins gt 0 or qryRecord.nLosses gt 0 ) ){
			arrayAppend(arStats, {
				"sLabel" = "Winner when the spread is less than 13",
				"sDescription" = "Your record picking games when the spread is less than 13",
				"qryRecord" = qryRecord
			});
		}
	}
	// if the home team as a favorite
	if( compareNoCase(arguments.stGame.sSpreadFavor, "home") eq 0 ){
		qryReord = variables.statGateway.getRecordHomeTeamBySpread(arguments.stGame.nSpread, ">=", arguments.nUserID, stGame.nType, arguments.nSeasonID);
		if( qryRecord.recordCount gt 0 and ( qryRecord.nWins gt 0 or qryRecord.nLosses gt 0 ) ){
			arrayAppend(arStats, {
				"sLabel" = "Home team as a favorite by #arguments.stGame.nSpread# or more",
				"sDescription" = "Win/Loss when the home team as a favorite by #arguments.stGame.nSpread#",
				"qryRecord" = qryRecord
			});
		}
		/*arrayAppend(arStats, {
			"sLabel" = "Home team as a favorite",
			"sDescription" = "Win/Loss when the home team as a favorite",
			"qryRecord" = variables.statGateway.getRecordHomeTeamFavored(arguments.nUserID, stGame.nType, arguments.nSeasonID)
		});*/
		qryRecord = variables.statGateway.getRecordAwayTeamBySpread(arguments.stGame.nSpread, "<=", arguments.nUserID, stGame.nType, arguments.nSeasonID);
		if( qryRecord.recordCount gt 0 and ( qryRecord.nWins gt 0 or qryRecord.nLosses gt 0 ) ){
			arrayAppend(arStats, {
				"sLabel" = "Away team as an underdog by #arguments.stGame.nSpread# or more",
				"sDescription" = "Win/Loss when the away team as an underdog by #arguments.stGame.nSpread#",
				"qryRecord" = qryRecord
			});
		}
		/*arrayAppend(arStats, {
			"sLabel" = "Away team as an underdog",
			"sDescription" = "Win/Loss when the away team as an underdog",
			"qryRecord" = variables.statGateway.getRecordAwayTeamUnderdog(arguments.nUserID, stGame.nType, arguments.nSeasonID)
		});*/
	} else {
		qryRecord = variables.statGateway.getRecordAwayTeamBySpread(arguments.stGame.nSpread, ">=", arguments.nUserID, stGame.nType, arguments.nSeasonID);
		if( qryRecord.recordCount gt 0 and ( qryRecord.nWins gt 0 or qryRecord.nLosses gt 0 ) ){
			arrayAppend(arStats, {
				"sLabel" = "Away team as a favorite by #arguments.stGame.nSpread# or more",
				"sDescription" = "Win/Loss when the away team as a favorite by #arguments.stGame.nSpread#",
				"qryRecord" = qryRecord
			});
		}
		/*arrayAppend(arStats, {
			"sLabel" = "Away team as a favorite",
			"sDescription" = "Win/Loss when the away team as a favorite",
			"qryRecord" = variables.statGateway.getRecordAwayTeamFavored(arguments.nUserID, stGame.nType, arguments.nSeasonID)
		});*/
		qryRecord = variables.statGateway.getRecordHomeTeamBySpread(arguments.stGame.nSpread, "<=", arguments.nUserID, stGame.nType, arguments.nSeasonID);
		if( qryRecord.recordCount gt 0 and ( qryRecord.nWins gt 0 or qryRecord.nLosses gt 0 ) ){
			arrayAppend(arStats, {
				"sLabel" = "Home team as an underdog by #arguments.stGame.nSpread# or more",
				"sDescription" = "Win/Loss when the home team as an underdog by #arguments.stGame.nSpread#",
				"qryRecord" = qryRecord
			});
		}
		/*arrayAppend(arStats, {
			"sLabel" = "Home team as an underdog",
			"sDescription" = "Win/Loss when the home team as an underdog",
			"qryRecord" = variables.statGateway.getRecordHomeTeamUnderdog(arguments.nUserID, stGame.nType, arguments.nSeasonID)
		});*/
	}
	return arStats;
}

/*
Author: 	
	Ron West
Name:
	$getGameStatsForTeams
Summary:
	Creates statistics for the teams based on the game situation
Returns:
	Array arStats
Arguments:
	Struct stGame
	Numeric nSeasonID
History:
	2015-10-07 - RLW - Created
*/
public Array function getGameStatsForTeams( Required Struct stGame, Required Numeric nSeasonID ){
	var arStats = [];
	// get each teams record against the spread
	if( compareNoCase(arguments.stGame.sSpreadFavor, "home") eq 0 ){
		// as a favored home team 
		qryRecord = variables.statGateway.getTeamRecord(arguments.stGame.nHomeTeamID, arguments.stGame.nSpread, true, "home", arguments.nSeasonID);
		if( qryRecord.recordCount gt 0 and ( qryRecord.nWins gt 0 or qryRecord.nLosses gt 0 ) ){
			arrayAppend(arStats, {
				"sTeamName" = arguments.stGame.sHomeTeam,
				"sLabel" = "as a team favored by #arguments.stGame.nSpread# or more at home",
				"sDescription" = "The #arguments.stGame.sHomeTeam# at home as a favored team",
				"qryRecord" = qryRecord
			});
		}
		// as an underdog away team
		qryRecord = variables.statGateway.getTeamRecord(arguments.stGame.nAwayTeamID, arguments.stGame.nSpread, false, "away", arguments.nSeasonID);
		if( qryRecord.recordCount gt 0 and ( qryRecord.nWins gt 0 or qryRecord.nLosses gt 0 ) ){
			arrayAppend(arStats, {
				"sTeamName" = arguments.stGame.sAwayTeam,
				"sLabel" = "as an underdog by #arguments.stGame.nSpread# or more on the road",
				"sDescription" = "The #arguments.stGame.sAwayTeam# away as an underdog team",
				"qryRecord" = qryRecord
			});
		}
	} else { // when the away team is favored
		// as an underdog home team 
		qryRecord = variables.statGateway.getTeamRecord(arguments.stGame.nHomeTeamID, arguments.stGame.nSpread, false, "home", arguments.nSeasonID);
		if( qryRecord.recordCount gt 0 and ( qryRecord.nWins gt 0 or qryRecord.nLosses gt 0 ) ){
			arrayAppend(arStats, {
				"sTeamName" = arguments.stGame.sHomeTeam,
				"sLabel" = "as an underdog by #arguments.stGame.nSpread# or more at home",
				"sDescription" = "The #arguments.stGame.sHomeTeam# at home as an underdog team",
				"qryRecord" = qryRecord
			});
		}
		// as an favored away team
		qryRecord = variables.statGateway.getTeamRecord(arguments.stGame.nAwayTeamID, arguments.stGame.nSpread, true, "away", arguments.nSeasonID);
		if( qryRecord.recordCount gt 0 and ( qryRecord.nWins gt 0 or qryRecord.nLosses gt 0 ) ){
			arrayAppend(arStats, {
				"sTeamName" = arguments.stGame.sAwayTeam,
				"sLabel" = "as a team favored by #arguments.stGame.nSpread# or more on the road",
				"sDescription" = "The #arguments.stGame.sAwayTeam# away as a favored team",
				"qryRecord" = qryRecord
			});
		}
	}
	
	return arStats;
}

}
component accessors="true" extends="model.services.baseService" {

property name="teamGateway";

/*
Author: 	
	Ron West
Name:
	$saveTeam
Summary:
	Creates and gets the new team object
Returns:
	Team oTeam
Arguments:
	String sName
	String sURL
History:
	2012-09-12 - RLW - Created
*/
public model.beans.team function saveTeam( Required String sName, String sURL="" ){
	// store the team if it doesn't already exist
	var arTeam = variables.teamGateway.getByNameAndMascot(arguments.sName);
	var stTeam = { "sName" = arguments.sName };
	if( not arrayLen(arTeam) ){
		oTeam = teamGateway.get();
		if( len(arguments.sURL) ){
			structInsert(stTeam, "sURL", arguments.sURL);
		}
		// update the team object
		oTeam = teamGateway.update(oTeam, stTeam );
	} else { // return the team
		oTeam = arTeam[1];
	}
	return oTeam;
}

/*
Author: 	
	Ron West
Name:
	$findTeam
Summary:
	Builds an array of teams based on search criteria
Returns:
	Array arTeam
Arguments:
	String sName
History:
	2013-09-18 - RLW - Created
*/
public Array function findTeam( Required String sName ){
	var arTeams = variables.teamGateway.getByName(arguments.sName);
	var itm = 1;
	var arTeamNames = [];
	for(itm; itm lte arrayLen(arTeams); itm++ ){
		arrayAppend(arTeamNames, arTeams[itm].getSName());
	}
	return arTeamNames;
}

/*
Author: 	
	Ron West
Name:
	$getTeamNameArray
Summary:
	Given a team builds out an array of team names
Returns:
	Array arTeamName
Arguments:
	Team oTeam
History:
	2015-09-09 - RLW - Created
*/
public Array function getTeamNameArray( Required model.beans.team oTeam ){
	var arTeamName = [arguments.oTeam.getSName()];
	if( isNull(arguments.oTeam.getSMascot()) ){
		arguments.oTeam.setSMascot("");
	}
	arrayAppend(arTeamName, arguments.oTeam.getSName() & " " & arguments.oTeam.getSMascot());
	if( not isNull(arguments.oTeam.getSName2()) and len(arguments.oTeam.getSName2()) gt 0 ){
		arrayAppend(arTeamName, arguments.oTeam.getSName2() & " " & arguments.oTeam.getSMascot());
	}
	if( not isNull(arguments.oTeam.getSName3()) and len(arguments.oTeam.getSName3()) gt 0 ){
		arrayAppend(arTeamName, arguments.oTeam.getSName3() & " " & arguments.oTeam.getSMascot() );
	}
	if( not isNull(arguments.oTeam.getSName4()) and len(arguments.oTeam.getSName4()) gt 0 ){
		arrayAppend(arTeamName, arguments.oTeam.getSName4() & " " & arguments.oTeam.getSMascot());
	}
	return arTeamName;
}

/*
Author: 	
	Ron West
Name:
	$getCurrentRecord
Summary:
	Returns the current record of the team
Returns:
	String sRecord
Arguments:
	String sTeamName
History:
	2015-10-10 - RLW - Created
*/
public String function getCurrentRecord( Required String sTeamName ){
	var stRecordResults = variables.commonService.getURL("http://localhost:3000/get-record?sTeam=" & arguments.sTeamName);
	var stResponse = {};
	var sRecord = "";
	// if we have a valid response
	if( find("200", stRecordResults.statusCode) gt 0 and isJSON(stRecordResults.fileContent.toString()) ){
		stResponse = deserializeJSON(stRecordResults.fileContent.toString());
		// make sure the API call was successful
		if( find(200, stResponse.stResults.sStatus) ){
			// get the game data
			sRecord = stResponse.stResults.sRecord;
		} else {
			// API called failed
		}
	} else {
		// need logging
	}
	return sRecord;
}

/*
Author: 	
	Ron West
Name:
	$getResults
Summary:
	Returns the results for the specified team
Returns:
	Array arGames
Arguments:
	String sTeamName
History:
	2015-10-13 - RLW - Created
*/
public Array function getResults( Required String sTeamName ){
	var stAPIResults = variables.commonService.getURL("http://localhost:3000/get-results?sTeam=" & arguments.sTeamName, 25);
	var stResponse = {};
	var arResults = [];
	// if we have a valid response
	if( find("200", stAPIResults.statusCode) gt 0 and isJSON(stAPIResults.fileContent.toString()) ){
		stResponse = deserializeJSON(stAPIResults.fileContent.toString());
		// make sure the API call was successful
		if( find(200, stResponse.stResults.sStatus) ){
			// get the game data
			arResults = stResponse.stResults.arGames;
		} else {
			// API called failed
		}
	} else {
		// need logging
	}
	return arResults;
}

}
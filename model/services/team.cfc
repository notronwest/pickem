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
	var arTeam = variables.teamGateway.getByName(arguments.sName);
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

}
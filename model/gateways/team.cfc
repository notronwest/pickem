component accessors="true" extends="model.base" {

/*
Author: 	
	Ron West
Name:
	$get
Summary:
	Gets the team object
Returns:
	Team oTeam
Arguments:
	Numeric nTeamID
History:
	2012-09-12 - RLW - Created
*/
public model.beans.team function get( Numeric nTeamID=0 ){
	var oTeam = new model.beans.team();
	var arTeam = [];
	if( arguments.nTeamID != 0 ){
		arTeam = entityLoad("team", arguments.nTeamID);
		if( arrayLen(arTeam) gt 0 ){
			oTeam = arTeam[1];
		}
	}
	return oTeam;
}

/*
Author: 	
	Ron West
Name:
	$update
Summary:
	Updates the team object with new data
Returns:
	Team oTeam
Arguments:
	Team oTeam
	Struct stTeam
History:
	2012-09-12 - RLW - Created
*/
public model.beans.team function update( Required model.beans.team oTeam, Required Struct stTeam ){
	if( structKeyExists(arguments.stTeam, "sName2") and len(arguments.stTeam.sName2) gt 0 ){
		arguments.oTeam.setSName2(arguments.stTeam.sName2);
	}
	if( structKeyExists(arguments.stTeam, "sName3") and len(arguments.stTeam.sName3) gt 0 ){
		arguments.oTeam.setSName3(arguments.stTeam.sName3);
	}
	if( structKeyExists(arguments.stTeam, "sName4") and len(arguments.stTeam.sName4) gt 0 ){
		arguments.oTeam.setSName4(arguments.stTeam.sName4);
	}
	if( structKeyExists(arguments.stTeam, "sURL") and len(arguments.stTeam.sURL) gt 0 ){
		arguments.oTeam.setSURL(arguments.stTeam.sURL);
	}
	arguments.oTeam.setSName(arguments.stTeam.sName);
	arguments.oTeam = save(oTeam);
	return arguments.oTeam;
}
/*
Author: 	
	Ron West
Name:
	$save
Summary:
	Saves the team entity
Returns:
	Team oTeam
Arguments:
	Team oTeam
History:
	2012-09-12 - RLW - Created
*/
public model.beans.team function save( Required model.beans.team oTeam){
	entitySave(arguments.oTeam);
	ormFlush();
	return arguments.oTeam;
}


/*
Author: 	
	Ron West
Name:
	$getByName
Summary:
	Gets a team object by name
Returns:
	Array arTeam
Arguments:
	String sName
	String bSearchAlternatives
History:
	2012-09-12 - RLW - Created
*/
public Array function getByName( Required String sName, Boolean bSearchAlternatives=true ){
	var arTeam = [];
	if( arguments.bSearchAlternatives ){
		arTeam = ormExecuteQuery( "from team where sName like :sName or sName2 like :sName or sName3 like :sName", { sName = "%#arguments.sName#%" } );
	} else {
		arTeam = ormExecuteQuery( "from team where sName like :sName", { sName = "%#arguments.sName#%" } );
	}
	return arTeam;
}

/*
Author: 	
	Ron West
Name:
	$getAll
Summary:
	Gets all teams
Returns:
	Array arTeams
Arguments:
	Void
History:
	2012-09-12 - RLW - Created
*/
public Array function getAll(){
	var arTeams = ormExecuteQuery( "from team order by sName", {} );
	return arTeams;
}


}
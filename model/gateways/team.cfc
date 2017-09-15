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
	Struct stData
History:
	2012-09-12 - RLW - Created
*/
public model.beans.team function update( Required model.beans.team oTeam, Required Struct stData ){
	// set the bean into request scope
	request.oBean = arguments.oTeam;
	try{
		var sKey = "";
		var lstIgnore = "nTeamID";
		// loop through all of the fields in the structure and update the data
		for( sKey in arguments.stData ){
			if( not listFindNoCase(lstIgnore, sKey) ){
				include "set.cfm";
			}
		}
		// save the entity
		entitySave(request.oBean);
		ormFlush();
	} catch (any e){
		registerError("Error in update function to team", e);
	}
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
	$delete
Summary:
	Delete the team entity
Returns:
	Void
Arguments:
	Team oTeam
History:
	2015-10-25 - RLW - Created
*/
public void function delete( Required model.beans.team oTeam){
	entityDelete(arguments.oTeam);
	ormFlush();
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
public Array function getByName( Required String sName, Boolean bSearchAlternatives=true, String lstType = "1,2" ){
	var arTeam = [];
	if( arguments.bSearchAlternatives ){
		arTeam = ormExecuteQuery( "from team where sName like :sName or sName2 like :sName or sName3 like :sName and nType in (:lstType)", { sName = "#arguments.sName#%", lstType = listToArray(arguments.lstType) } );
	} else {
		arTeam = ormExecuteQuery( "from team where sName like :sName and nType in (:lstType)", { sName = "%#arguments.sName#%", lstType = listToArray(arguments.lstType) } );
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

/*
Author:
	Ron West
Name:
	$getByExactName
Summary:
	Gets a team object by name exactly matched
Returns:
	Array arTeam
Arguments:
	String sName
	String bSearchAlternatives
History:
	2015-10-09 - RLW - Created
*/
public Array function getByExactName( Required String sName, Boolean bSearchAlternatives=true ){
	var arTeam = [];
	if( arguments.bSearchAlternatives ){
		arTeam = ormExecuteQuery( "from team where sName = :sName or sName2 = :sName or sName3 = :sName", { sName = "#arguments.sName#" } );
	} else {
		arTeam = ormExecuteQuery( "from team where sName = :sName", { sName = "#arguments.sName#" } );
	}
	return arTeam;
}

/*
Author:
	Ron West
Name:
	$getByExactNameAndType
Summary:
	Gets a team object by name and league exactly matched
Returns:
	Array arTeam
Arguments:
	String sName
	String bSearchAlternatives
	String sType
History:
	2016-09-20 - RLW - Created
*/
public Array function getByExactNameAndType( Required String sName, Boolean bSearchAlternatives=true, String lstType = "1,2" ){
	var arTeam = [];
	if( arguments.bSearchAlternatives ){
		arTeam = ormExecuteQuery( "from team where (sName = :sName or sName2 = :sName or sName3 = :sName) and nType in (:lstType)", { sName = "#arguments.sName#", lstType = listToArray(arguments.lstType) } );
	} else {
		arTeam = ormExecuteQuery( "from team where sName = :sName and nType in (:lstType)", { sName = "#arguments.sName#", lstType = listToArray(arguments.lstType) } );
	}
	return arTeam;
}

/*
Author:
	Ron West
Name:
	$getByNameAndMascot
Summary:
	Gets a team object by name and mascot combination
Returns:
	Array arTeam
Arguments:
	String sName
History:
	2015-10-10 - RLW - Created
*/
public Array function getByNameAndMascot( Required String sName ){
	var qryTeam = variables.dbService.runQuery("select * from team
where concat(sName, ' ', sMascot) = '#arguments.sName#'
or concat(sName2, ' ', sMascot) = '#arguments.sName#'
or concat(sName3, ' ', sMascot) = '#arguments.sName#'
or concat(sName4, ' ', sMascot) = '#arguments.sName#'");
	var arTeam = [];
	if( qryTeam.recordCount gt 0 ){
		arTeam = [get(qryTeam.nTeamID)];
	}
	return arTeam;
}

}

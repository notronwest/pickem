component accessors="true" extends="model.base" {

property name="pickService";
property name="standingService";

/*
Author:
	Ron West
Name:
	$get
Summary:
	Gets the user object
Returns:
	User oUser
Arguments:
	Numeric nUserID
History:
	2012-09-12 - RLW - Created
*/
public model.beans.user function get( Numeric nUserID=0 ){
	var oUser = new model.beans.user();
	var arUser = [];
	try{
		if( arguments.nUserID != 0 ){
			arUser = entityLoad("user", arguments.nUserID);
			if( arrayLen(arUser) gt 0 ){
				oUser = arUser[1];
			}
		}
	} catch (any e){
		registerError("Error getting user", e);
	}
	return oUser;
}

/*
Author:
	Ron West
Name:
	$update
Summary:
	Updates the user object with new data
Returns:
	User oUser
Arguments:
	User oUser
	Struct stData
History:
	2012-09-12 - RLW - Created
*/
public model.beans.user function update( Required model.beans.user oUser, Required Struct stData ){
	// set the bean into request scope
	request.oBean = arguments.oUser;
	try{
		var sKey = "";
		var lstIgnore = "nUserID";
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
		registerError("Error in update function to user", e);
	}
	return request.oBean;
}

/*
Author:
	Ron West
Name:
	$saveUsername
Summary:
	Updates the username for the user with given id
Returns:
	User oUser
Arguments:
	Numeric nUserID
	String sUsername
History:
	2012-09-12 - RLW - Created
*/
public model.beans.user function saveUsername( Required Numeric nUserID, Required String sUsername ){
	var oUser = get(arguments.nUserID);
	try{
		if( oUser.getNUserID() neq 0 ){
			oUser.setSUsername(arguments.sUsername);
			arguments.oUser = save(oUser);
		}
	} catch (any e){
		registerError("Error saving username for user", e);
	}
	return oUser;
}

/*
Author:
	Ron West
Name:
	$savePassword
Summary:
	Updates the password for the user with given id
Returns:
	User oUser
Arguments:
	Numeric nUserID
	String sPassword
History:
	2012-09-12 - RLW - Created
*/
public model.beans.user function savePassword( Required Numeric nUserID, Required String sPassword ){
	var oUser = get(arguments.nUserID);
	try{
		if( oUser.getNUserID() neq 0 ){
			oUser.setSPassword(arguments.sPassword);
			arguments.oUser = save(oUser);
		}
	} catch (any e){
		registerError("Error saving password for user", e);
	}
	return oUser;
}

/*
Author:
	Ron West
Name:
	$save
Summary:
	Saves the user entity
Returns:
	User oUser
Arguments:
	User oUser
History:
	2012-09-12 - RLW - Created
*/
public model.beans.user function save( Required model.beans.user oUser){
	try{
		entitySave(arguments.oUser);
		ormFlush();
	} catch (any e){
		registerError("Error saving user bean", e);
	}
	return arguments.oUser;
}

/*
Author:
	Ron West
Name:
	$delete
Summary:
	Deletes the user entity
Returns:
	Boolean bDeleted
Arguments:
	User oUser
History:
	2012-09-12 - RLW - Created
*/
public Boolean function delete( Required model.beans.user oUser){
	var bDeleted = true;
	try{
		// delete picks
		variables.pickService.deleteUserPicks(arguments.oUser.getNUserID());
		// delete standings
		variables.standingService.deleteUserStandings(arguments.oUser.getNUserID());
		entityDelete(arguments.oUser);

		ormFlush();
	} catch (any e){
		registerError("Error deleting user bean", e);
		bDeleted = false;
	}
	return bDeleted;
}

/*
Author:
	Ron West
Name:
	$getAll
Summary:
	Gets all users
Returns:
	Array arUsers
Arguments:
	String lstActive
History:
	2012-09-12 - RLW - Created
	2015-09-15 - RLW - Added option to show active/inactive/all users
*/
public Array function getAll( String lstActive = "0,1"){
	var arUsers = ormExecuteQuery( "from user where bActive in (:lstActive) order by sLastName", { lstActive = listToArray(arguments.lstActive) } );
	return arUsers;
}

/*
Author:
	Ron West
Name:
	$getAll
Summary:
	Gets all users
Returns:
	Array arUsers
Arguments:
	Numeric nSeasonID
	String lstActive
History:
	2016-08-26 - RLW - Created
*/
public Array function getBySeason( Required numeric nSeasonID, String lstActive = "0,1"){
	var qryUsers = variables.dbService.runQuery("
		SELECT us.nUserID
		FROM userSeason us
		JOIN user u
		ON us.nUserID = u.nUserID
		WHERE us.nSeasonID = #arguments.nSeasonID#
		AND us.bActive in (#arguments.lstActive#)
		AND u.bActive in (#arguments.lstActive#)
		ORDER BY u.sLastName, u.sFirstName
	");
	var itm = 1;
	var arUsers = [];
	for(itm; itm lte qryUsers.recordCount; itm++ ){
		arrayAppend(arUsers, get(qryUsers.nUserID[itm]));
	}
	return arUsers;
}

/*
Author:
	Ron West
Name:
	$getAllSortByFirst
Summary:
	Gets all users
Returns:
	Array arUsers
Arguments:
	Boolean bIncludeInactive
History:
	2012-09-12 - RLW - Created
	2015-08-23 - RLW - Added support for not returning users that are inactive
*/
public Array function getAllSortByFirst( Boolean bIncludeInactive = true ){
	var arUsers = [];
	if( arguments.bIncludeInactive ){
		arUsers = ormExecuteQuery( "from user order by sFirstName");
	} else {
		arUsers = ormExecuteQuery( "from user where bActive = 1 order by sFirstName" );
	}
	return arUsers;
}

/*
Author:
	Ron West
Name:
	$getByUsernamePassword
Summary:
	Gets by username and password
Returns:
	Array arUser
Arguments:
	String sUsername
	String sPassword
	Numeric bActive
History:
	2012-09-12 - RLW - Created
	2015-08-24 - RLW - Added optional flag to exclude active users
*/
public Array function getByUsernamePassword( Required String sUsername, Required String sPassword){
	var arUser = ormExecuteQuery( "from user where sUsername = :sUsername and sPassword = :sPassword and bActive = 1", { sUsername = "#arguments.sUsername#", sPassword = "#arguments.sPassword#" } );
	return arUser;
}

/*
Author:
	Ron West
Name:
	$getByEmail
Summary:
	Gets by the email for the user
Returns:
	Array arUser
Arguments:
	String sEmail
History:
	2014-08-26 - RLW - Created
*/
public Array function getByEmail( Required String sEmail ){
	var arUser = ormExecuteQuery( "from user where sEmail = :sEmail", { sEmail = "#arguments.sEmail#" } );
	return arUser;
}
}

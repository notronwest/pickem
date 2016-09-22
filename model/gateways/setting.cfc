component accessors="true" extends="model.base" {
	
/*
Author: 	
	Ron West
Name:
	$get
Summary:
	Gets the setting object
Returns:
	Setting oSetting
Arguments:
	Numeric nSettingID
History:
	2014-09-18 - RLW - Created
*/
public model.beans.setting function get( Numeric nSettingID=0 ){
	var oSetting = new model.beans.setting();
	var arSetting = [];
	if( arguments.nSettingID != 0 ) {
		arSetting = entityLoad("setting", arguments.nSettingID);
		if( arrayLen(arSetting) gt 0 ){
			oSetting = arSetting[1];
		}
	}
	return oSetting;
}

/*
Author: 	
	Ron West
Name:
	$update
Summary:
	Updates the setting object with new data
Returns:
	Setting oSetting
Arguments:
	Setting oSetting
	Struct stSetting
History:
	2014-09-18 - RLW - Created
*/
public model.beans.setting function update( Required model.beans.setting oSetting, Required Struct stData ){
	var sKey = "";
	// set the bean into request scope
	request.oBean = arguments.oSetting;
	// loop through all of the fields in the structure and update the data
	for( sKey in arguments.stData ){
		include "set.cfm";
	}
	// save the entity
	entitySave(request.oBean);
	ormFlush();
	return request.oBean;
}
/*
Author: 	
	Ron West
Name:
	$save
Summary:
	Saves the setting entity
Returns:
	Setting oSetting
Arguments:
	Setting oSetting
History:
	2014-09-18 - RLW - Created
*/
public model.beans.setting function save( Required model.beans.setting oSetting){
	entitySave(arguments.oSetting);
	ormFlush();
	return arguments.oSetting;
}

/*
Author: 	
	Ron West
Name:
	$delete
Summary:
	Deletes the setting entity
Returns:
	Boolean bDeleted
Arguments:
	Setting oSetting
History:
	2014-09-18 - RLW - Created
*/
public Boolean function delete( Required model.beans.setting oSetting){
	var bDeleted = true;
	try{
		entityDelete(arguments.oSetting);
		ormFlush();
	} catch (any e){
		registerError("Error deleting setting bean", e);
		bDeleted = false;
	}
	return bDeleted;
}

/*
Author: 	
	Ron West
Name:
	$getByUser
Summary:
	Retrieves a users settings
Returns:
	Array arSettings
Arguments:
	Numeric nUserID
History:
	2014-09-18 - RLW - Created
*/
public Array function getByUser( Required Numeric nUserID ){
	var arSettings = ormExecuteQuery("from setting where nUserID = :nUserID", { "nUserID" = arguments.nUserID} );
	return arSettings;
}

/*
Author: 	
	Ron West
Name:
	$getUserSetting
Summary:
	Retrieves a particular setting for a user
Returns:
	Setting oSetting
Arguments:
	Numeric nUserID
	Numeric nOptionID
History:
	2014-09-18 - RLW - Created
*/
public model.beans.setting function getUserSetting( Required Numeric nUserID, Required Numeric nOptionID ){
	var oSetting = get();
	var arSettings = ormExecuteQuery("from setting where nUserID = :nUserID and nOptionID = :nOptionID", { "nUserID" = arguments.nUserID, "nOptionID" = arguments.nOptionID } );
	if( arrayLen(arSettings) gt 0 ){
		oSetting = arSettings[1];
	}
	return oSetting;
}

/*
Author: 	
	Ron West
Name:
	$getUsersByOption
Summary:
	Retrieves all of the user settings who have this option
Returns:
	Array arSettings
Arguments:
	Numeric nOptionID
	Numeric nSeasonID
History:
	2014-09-19 - RLW - Created
	2016-09-21 - RLW - Updated to use seasonID (for leagues) and make sure they are active
*/
public Array function getUsersByOption( Required Numeric nOptionID, Required Numeric nSeasonID ){
	var qryUserSettings = variables.dbService.runQuery( "
		SELECT nSettingID
		FROM setting s
		JOIN user u
		ON s.nUserID = u.nUserID
		JOIN userSeason us
		ON s.nUserID = us.nUserID
		AND s.nOptionID = #arguments.nOptionID#
		AND s.sValue <> ''
		AND u.bActive = 1
		AND us.nSeasonID = #arguments.nSeasonID#
		AND us.bActive = 1
	" );
	var arSettings = [];
	var itm = 1;
	for( itm; itm lte qryUserSettings.recordCount; itm++ ){
		arrayAppend(arSettings, get(qryUserSettings.nSettingID[itm]));
	}
	//var arSettings = ormExecuteQuery("from setting where nOptionID = :nOptionID and sValue <> ''", { "nOptionID" = arguments.nOptionID });
	return arSettings;
}

}
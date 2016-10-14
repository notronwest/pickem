component accessors="true" extends="model.base" {
	
/*
Author: 	
	Ron West
Name:
	$get
Summary:
	Gets the notify object
Returns:
	Notify oNotify
Arguments:
	Numeric nNotifyID
History:
	2014-09-18 - RLW - Created
*/
public model.beans.notify function get( nNotifyID=0 ){
	var oNotify = new model.beans.notify();
	var arNotify = [];
	if( isNumeric(arguments.nNotifyID) ) {
		arNotify = entityLoad("notify", arguments.nNotifyID);
		if( arrayLen(arNotify) gt 0 ){
			oNotify = arNotify[1];
		}
	}
	return oNotify;
}

/*
Author: 	
	Ron West
Name:
	$update
Summary:
	Updates the notify object with new data
Returns:
	Notify oNotify
Arguments:
	Notify oNotify
	Struct stNotify
History:
	2014-09-18 - RLW - Created
*/
public model.beans.notify function update( Required model.beans.notify oNotify, Required Struct stData ){
	var sKey = "";
	// set the bean into request scope
	try{
		request.oBean = arguments.oNotify;
		// loop through all of the fields in the structure and update the data
		for( sKey in arguments.stData ){
			include "set.cfm";
		}
		// save the entity
		entitySave(request.oBean);
		ormFlush();
	} catch (any e){
		registerError("Error saving notification", e);
	}
	return request.oBean;
}
/*
Author: 	
	Ron West
Name:
	$save
Summary:
	Saves the notify entity
Returns:
	Notify oNotify
Arguments:
	Notify oNotify
History:
	2014-09-18 - RLW - Created
*/
public model.beans.notify function save( Required model.beans.notify oNotify){
	entitySave(arguments.oNotify);
	ormFlush();
	return arguments.oNotify;
}

/*
Author: 	
	Ron West
Name:
	$delete
Summary:
	Deletes the notify entity
Returns:
	Boolean bDeleted
Arguments:
	Notify oNotify
History:
	2014-09-18 - RLW - Created
*/
public Boolean function delete( Required model.beans.notify oNotify){
	var bDeleted = true;
	try{
		entityDelete(arguments.oNotify);
		ormFlush();
	} catch (any e){
		registerError("Error deleting notify bean", e);
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
	Retrieves all notifications
Returns:
	Array arNotifications
Arguments:
	String sLeagueID
History:
	2014-09-18 - RLW - Created
	2016-10-13 - RLW - Added support for leagues
*/
public Array function getAll( Required String sLeagueID ){
	var arNotifications = [];
	var qryNotify = variables.dbService.runQuery("
			SELECT n.nNotifyID
			FROM notify n
			LEFT JOIN `option` o
			ON n.nOptionID = o.nOptionID
			WHERE o.sLeagueID = '#arguments.sLeagueID#'
		");
	var itm = 1;
	for( itm; itm lte qryNotify.recordCount; itm++ ){
		arrayAppend(arNotifications, get(qryNotify.nNotifyID[itm]));
	}
	return arNotifications;
}

/*
Author: 	
	Ron West
Name:
	$getByOption
Summary:
	Retrieves all notifications based on the passed in option
Returns:
	Array arNotifications
Arguments:
	Numeric nOptionID
History:
	2014-09-18 - RLW - Created
*/
public Array function getByOption( Required Numeric nOptionID ){
	var arNotifications = ormExecuteQuery("from notify where nOptionID = :nOptionID", { "nOptionID" = arguments.nOptionID });
	return arNotifications;
}

}
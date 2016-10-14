component accessors="true" extends="model.base" {
	
/*
Author: 	
	Ron West
Name:
	$get
Summary:
	Gets the option object
Returns:
	Option oOption
Arguments:
	Numeric nOptionID
History:
	2014-09-18 - RLW - Created
*/
public model.beans.option function get( Numeric nOptionID=0 ){
	var oOption = new model.beans.option();
	var arOption = [];
	if( arguments.nOptionID != 0 ) {
		arOption = entityLoad("option", arguments.nOptionID);
		if( arrayLen(arOption) gt 0 ){
			oOption = arOption[1];
		}
	}
	return oOption;
}

/*
Author: 	
	Ron West
Name:
	$update
Summary:
	Updates the option object with new data
Returns:
	Option oOption
Arguments:
	Option oOption
	Struct stOption
History:
	2014-09-18 - RLW - Created
*/
public model.beans.option function update( Required model.beans.option oOption, Required Struct stData ){
	var sKey = "";
	// set the bean into request scope
	request.oBean = arguments.oOption;
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
	Saves the option entity
Returns:
	Option oOption
Arguments:
	Option oOption
History:
	2014-09-18 - RLW - Created
*/
public model.beans.option function save( Required model.beans.option oOption){
	entitySave(arguments.oOption);
	ormFlush();
	return arguments.oOption;
}

/*
Author: 	
	Ron West
Name:
	$delete
Summary:
	Deletes the option entity
Returns:
	Boolean bDeleted
Arguments:
	Option oOption
History:
	2014-09-18 - RLW - Created
*/
public Boolean function delete( Required model.beans.option oOption){
	var bDeleted = true;
	try{
		entityDelete(arguments.oOption);
		ormFlush();
	} catch (any e){
		registerError("Error deleting option bean", e);
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
	Retrieves all options
Returns:
	Array arOptions
Arguments:
	String sLeagueID
History:
	2014-09-18 - RLW - Created
	2016-10-12 - RLW - Updated to use season/league settings
*/
public Array function getAll( Required String sLeagueID ){
	var arOptions = ormExecuteQuery("from option where sLeagueID = :sLeagueID order by nOrder", { sLeagueID = arguments.sLeagueID });
	return arOptions;
}

/*
Author: 	
	Ron West
Name:
	$getAllForNotification
Summary:
	Retrieves all options that have notification abilites
Returns:
	Array arOptions
Arguments:
	String sLeagueID
History:
	2014-09-19 - RLW - Created
	2016-10-13 - RLW - Updated to take league into consideration
*/
public Array function getAllForNotification( Required String sLeagueID){
	var arOptions = ormExecuteQuery("from option where bCanNotify = 1 and sLeagueID = :sLeagueID order by nOrder", { sLeagueID = arguments.sLeagueID });
	return arOptions;
}

/*
Author: 	
	Ron West
Name:
	$getByLabel
Summary:
	Retrieves all options based on the label
Returns:
	Array arOptions
Arguments:
	String sLabel
	String sLeagueID
History:
	2014-09-18 - RLW - Created
	2016-10-13 - RLW - Updated to allow for multiple types per league
*/
public Array function getByLabel( Required String sLabel, Required String sLeagueID ){
	var arOptions = ormExecuteQuery("from option where sLabel = :sLabel and sLeagueID = :sLeagueID order by nOrder", { "sLabel" = arguments.sLabel, "sLeagueID" = arguments.sLeagueID });
	return arOptions;
}

/*
Author: 	
	Ron West
Name:
	$getByCodeKey
Summary:
	Retrieves all options based on the codeKey
Returns:
	Array arOptions
Arguments:
	String sCodeKey
	String sLeagueID
History:
	2014-09-18 - RLW - Created
	2106-10-12 - RLW - Updated to support different leagues
*/
public Array function getByCodeKey( Required String sCodeKey, Required String sLeagueID ){
	var arOptions = ormExecuteQuery("from option where sCodeKey = :sCodeKey and sLeagueID = :sLeagueID order by nOrder", { "sCodeKey" = arguments.sCodeKey, "sLeagueID" = arguments.sLeagueID });
	return arOptions;
}

}
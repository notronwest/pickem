component accessors="true" extends="model.base" {

/*
Author: 	
	Ron West
Name:
	$get
Summary:
	Gets the seasonPayout object
Returns:
	Week oSeasonPayout
Arguments:
	Numeric nSeasonPayout
History:
	2012-09-12 - RLW - Created
*/
public model.beans.seasonPayout function get( Any nSeasonPayoutID=0 ){
	var oSeasonPayout = entityNew("seasonPayout");
	if( len(arguments.nSeasonPayoutID) gt 0 and arguments.nSeasonPayoutID > 0 ){
		oSeasonPayout = entityLoadByPK("seasonPayout", arguments.nSeasonPayoutID);
		if( isNull(oSeasonPayout) ){
			oSeasonPayout = entityNew("seasonPayout");
		}
	}
	return oSeasonPayout;
}


/*
Author: 	
	Ron West
Name:
	$update
Summary:
	Updates the seasonPayout object with new data
Returns:
	SeasonPayout oSeasonPayout
Arguments:
	SeasonPayout oSeasonPayout
	Struct stData
History:
	2012-09-12 - RLW - Created
*/
public model.beans.seasonPayout function update( Required model.beans.seasonPayout oSeasonPayout, Required Struct stData ){
	// set the bean into request scope
	request.oBean = arguments.oSeasonPayout;
	try{
		var sKey = "";
		var lstIgnore = "nSeasonPayoutID";
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
		registerError("Error in update function to seasonPayout", e);
	}
	return request.oBean;
}

/*
Author: 	
	Ron West
Name:
	$save
Summary:
	Saves the seasonPayout entity
Returns:
	Week oSeasonPayout
Arguments:
	Week oSeasonPayout
History:
	2012-09-12 - RLW - Created
*/
public model.beans.seasonPayout function save( Required model.beans.seasonPayout oSeasonPayout){
	entitySave(arguments.oSeasonPayout);
	ormFlush();
	return arguments.oSeasonPayout;
}

/*
Author: 	
	Ron West
Name:
	$delete
Summary:
	Delete the seasonPayout entity
Returns:
	Week oSeasonPayout
Arguments:
	Week oSeasonPayout
History:
	2012-09-12 - RLW - Created
*/
public Boolean function delete( Required model.beans.seasonPayout oSeasonPayout){
	entityDelete(arguments.oSeasonPayout);
	ormFlush();
	return true;
}

/*
Author: 	
	Ron West
Name:
	$getBySeason
Summary:
	Gets the current payouts for the season
Returns:
	Array arSeasonPayouts
Arguments:
	Void
History:
	2015-08-23 - RLW - Created
*/
public Array function getBySeason( Required Numeric nSeasonID){
	var arSeasonPayouts = ormExecuteQuery("from seasonPayout where nSeasonID = :nSeasonID", { "nSeasonID" = arguments.nSeasonID });
	return arSeasonPayouts;
}

/*
Author: 	
	Ron West
Name:
	$getInUse
Summary:
	Returns an array of payouts that are currently in use
Returns:
	Array arPayouts
Arguments:
	Void
History:
	2015-08-23 - RLW - Created
*/
public Array function getInUse( Numeric nSeasonID = rc.nCurrentSeasonID ){
	return ormExecuteQuery("select nPayoutID from seasonPayout where nSeasonID = :nSeasonID", { "nSeasonID" = arguments.nSeasonID });	
}


}
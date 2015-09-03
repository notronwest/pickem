component accessors="true" extends="model.base" {

/*
Author: 	
	Ron West
Name:
	$get
Summary:
	Gets the payout object
Returns:
	Week oPayout
Arguments:
	Numeric nPayout
History:
	2012-09-12 - RLW - Created
*/
public model.beans.payout function get( Any nPayoutID=0 ){
	var oPayout = entityNew("payout");
	if( len(arguments.nPayoutID) gt 0 and arguments.nPayoutID > 0 ){
		oPayout = entityLoadByPK("payout", arguments.nPayoutID);
		if( isNull(oPayout) ){
			oPayout = entityNew("payout");
		}
	}
	return oPayout;
}


/*
Author: 	
	Ron West
Name:
	$update
Summary:
	Updates the payout object with new data
Returns:
	Payout oPayout
Arguments:
	Payout oPayout
	Struct stData
History:
	2012-09-12 - RLW - Created
*/
public model.beans.payout function update( Required model.beans.payout oPayout, Required Struct stData ){
	// set the bean into request scope
	request.oBean = arguments.oPayout;
	try{
		var sKey = "";
		var lstIgnore = "nPayoutID";
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
		registerError("Error in update function to payout", e);
	}
	return request.oBean;
}

/*
Author: 	
	Ron West
Name:
	$save
Summary:
	Saves the payout entity
Returns:
	Week oPayout
Arguments:
	Week oPayout
History:
	2012-09-12 - RLW - Created
*/
public model.beans.payout function save( Required model.beans.payout oPayout){
	entitySave(arguments.oPayout);
	ormFlush();
	return arguments.oPayout;
}

/*
Author: 	
	Ron West
Name:
	$delete
Summary:
	Delete the payout entity
Returns:
	Week oPayout
Arguments:
	Week oPayout
History:
	2012-09-12 - RLW - Created
*/
public Boolean function delete( Required model.beans.payout oPayout){
	entityDelete(arguments.oPayout);
	ormFlush();
	return true;
}

/*
Author: 	
	Ron West
Name:
	$getAll
Summary:
	Gets all available payouts
Returns:
	Array arPayouts
Arguments:
	Void
History:
	2015-08-23 - RLW - Created
*/
public Array function getAll(){
	var arPayouts = ormExecuteQuery("from payout");
	return arPayouts;
}
/*
Author: 	
	Ron West
Name:
	$getExcludingList
Summary:
	Gets all payouts not found in the given list
Returns:
	Array arPayouts
Arguments:
	Void
History:
	2015-08-23 - RLW - Created
*/
public Array function getExcludingList( Array arPayouts = []){
	return ormExecuteQuery("from payout where nPayoutID not in (:lstNPayout)", { "lstNPayout" = arPayouts} );
}
}
component accessors="true" extends="model.base" {

/*
Author: 	
	Ron West
Name:
	$get
Summary:
	Gets the subscription object
Returns:
	Week oSubscription
Arguments:
	Numeric nSubscription
History:
	2012-09-12 - RLW - Created
*/
public model.beans.subscription function get( Any nSubscriptionID=0 ){
	var oSubscription = entityNew("subscription");
	if( len(arguments.nSubscriptionID) and arguments.nSubscriptionID != 0 ){
		oSubscription = entityLoadByPK("subscription", arguments.nSubscriptionID);
		if( isNull(oSubscription) ){
			oSubscription = entityNew("subscription");
		}
	}
	return oSubscription;
}


/*
Author: 	
	Ron West
Name:
	$update
Summary:
	Updates the subscription object with new data
Returns:
	Subscription oSubscription
Arguments:
	Subscription oSubscription
	Struct stData
History:
	2012-09-12 - RLW - Created
*/
public model.beans.subscription function update( Required model.beans.subscription oSubscription, Required Struct stData ){
	// set the bean into request scope
	request.oBean = arguments.oSubscription;
	try{
		var sKey = "";
		var lstIgnore = "nSubscriptionID";
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
		registerError("Error in update function to subscription", e);
	}
	return request.oBean;
}

/*
Author: 	
	Ron West
Name:
	$save
Summary:
	Saves the subscription entity
Returns:
	Week oSubscription
Arguments:
	Week oSubscription
History:
	2012-09-12 - RLW - Created
*/
public model.beans.subscription function save( Required model.beans.subscription oSubscription){
	entitySave(arguments.oSubscription);
	ormFlush();
	return arguments.oSubscription;
}

/*
Author: 	
	Ron West
Name:
	$delete
Summary:
	Delete the subscription entity
Returns:
	Week oSubscription
Arguments:
	Week oSubscription
History:
	2012-09-12 - RLW - Created
*/
public Boolean function delete( Required model.beans.subscription oSubscription){
	entityDelete(arguments.oSubscription);
	ormFlush();
	return true;
}

/*
Author: 	
	Ron West
Name:
	$getByUserAndSeason
Summary:
	Gets subscriptions for a user and season
Returns:
	Array arSubscriptions
Arguments:
	Void
History:
	2015-08-19 - RLW - Created
*/
public Array function getByUserAndSeason( Required Numeric nUserID, Required Numeric nSeasonID){
	var arSubscriptions = ormExecuteQuery("from subscription where nUserID = :nUserID and nSeasonID = :nSeasonID", { nUserID = arguments.nUserID, nSeasonID = arguments.nSeasonID });
	return arSubscriptions;
}

/*
Author: 	
	Ron West
Name:
	$getSubscriptionsPaid
Summary:
	Gets the current total subscriptions paid for the season
Returns:
	Numeric nSubscriptionPaid
Arguments:
	Numeric nSeasonID
History:
	2015-08-21 - RLW - Created
*/
public Numeric function getSubscriptionsPaid( Required Numeric nSeasonID ){
	var arSubscriptionPaid = ormExecuteQuery("select sum(nAmount) from subscription where nSeasonID = :nSeasonID", { nSeasonID = arguments.nSeasonID });
	return arSubscriptionPaid[1];
}

}
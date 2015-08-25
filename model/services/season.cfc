component accessors="true" extends="model.services.baseService" {

property name="subscriptionGateway";
property name="seasonGateway";

/*
Author: 	
	Ron West
Name:
	$updatePurse
Summary:
	Updates the purse for the current season object
Returns:
	Void
Arguments:
	Numeric nCurrentSeasonID
History:
	2015-08-21 - RLW - Created
*/
public void function updatePurse( Required Numeric nSeasonID ){
	// get the current season
	var oSeason = variables.seasonGateway.get(arguments.nSeasonID);
	// get the current subscriptions collected for this season
	var nSubscriptionsPaid = variables.subscriptionGateway.getSubscriptionsPaid(arguments.nSeasonID);
	// update the current season
	variables.seasonGateway.update(oSeason, { "nTotalPurse" = nSubscriptionsPaid });
}

}
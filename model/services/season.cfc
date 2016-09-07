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

/*
Author: 	
	Ron West
Name:
	$getCurrentSeason
Summary:
	Returns the current season
Returns:
	Void
Arguments:
	String sLeagueID
History:
	2016-08-26 - RLW - Created
*/
public model.beans.season function getCurrentSeason( Required String sLeagueID){
	var oSeason = variables.seasonGateway.getCurrentSeason(arguments.sLeagueID);
	if( isNull(oSeason.getNSeasonID()) ){
		// create a new season
		oSeason = variables.seasonGateway.update(oSeason, {
			sName = Year(now()) & "-" & Year(dateAdd("y", 1, now())),
			sLeagueID = arguments.sLeagueID
		});
	}
	return oSeason;
}

}
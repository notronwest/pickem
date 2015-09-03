component accessors="true" extends="model.services.baseService" {

property name="seasonPayoutGateway";
property name="payoutGateway";

/*
Author: 	
	Ron West
Name:
	$getPayouts
Summary:
	Creates an array of the current payouts (with payout names)
Returns:
	Void
Arguments:
	Numeric nSeasonID
History:
	2015-08-23 - RLW - Created
*/
public Array function getPayouts( Numeric nSeasonID = rc.nCurrentSeasonID ){
	// get the current payouts
	var arSeasonPayouts = variables.seasonPayoutGateway.getBySeason(arguments.nSeasonID);
	var itm = 1;
	// loop through the current season payouts and combine the payout details
	for( itm; itm lte arrayLen(arSeasonPayouts); itm++ ){
		arSeasonPayouts[itm].oPayout = variables.payoutGateway.get(arSeasonPayouts[itm].getNPayoutID());
	}
	return arSeasonPayouts;
}

/*
Author: 	
	Ron West
Name:
	$getAvailablePayouts
Summary:
	Creates an array of the available payouts (ones that haven't been assigned already)
Returns:
	Array arPayouts
Arguments:
	Numeric nSeasonID
History:
	2015-08-23 - RLW - Created
*/
public Array function getAvailablePayouts( Numeric nSeasonID = rc.nCurrentSeasonID ){
	var arPayoutsInUse = variables.seasonPayoutGateway.getInUse(arguments.nSeasonID);
	var arPayouts = [];
	if( arrayLen(arPayoutsInUse) ){
		arPayouts = variables.payoutGateway.getExcludingList(arPayoutsInUse);
	} else {
		arPayouts = variables.payoutGateway.getAll();
	}
	return arPayouts;
}

/*
Author: 	
	Ron West
Name:
	$getAssignedPurse
Summary:
	Returns the amount of money currently assigned for this season
Returns:
	Numeric nAssignedPurse
Arguments:
	Numeric nSeasonID
History:
	2015-08-23 - RLW - Created
*/
public Numeric function getAssignedPurse( Numeric nSeasonID = rc.nCurrentSeasonID ){
	var arSeasonPayouts = variables.seasonPayoutGateway.getBySeason(arguments.nSeasonID);
	var itm = 1;
	var nAssignedPurse = 0;
	for(itm; itm lte arrayLen(arSeasonPayouts); itm++ ){
		nAssignedPurse = nAssignedPurse + arSeasonPayouts[itm].getNAmount();
	}
	return nAssignedPurse;
}

/*
Author: 	
	Ron West
Name:
	$organizedByType
Summary:
	Returns the season payouts orgaznized by type
Returns:
	Struct stSeasonPayouts
Arguments:
	Numeric nSeasonID
History:
	2015-08-23 - RLW - Created
*/
public Struct function organizedByType(Numeric nSeasonID = rc.nCurrentSeasonID){
	var arSeasonPayouts = variables.seasonPayoutGateway.getBySeason(arguments.nSeasonID);
	var stSeasonPayouts = {
		"season" = [], "weekly" = [], "finalWeek" = []
	};
	var itm = 1;
	var stData = {};
	for(itm; itm lte arrayLen(arSeasonPayouts); itm++ ){
		// build simpler structure
		stData = {
			"nSeasonPayoutID" = arSeasonPayouts[itm].getNSeasonPayoutID(),
			"nPayoutID" = arSeasonPayouts[itm].getNPayoutID(),
			"sPayoutType" = arSeasonPayouts[itm].oPayout.getSType(),
			"nPlace" = arSeasonPayouts[itm].oPayout.getNPlace(),
			"sName" = arSeasonPayouts[itm].oPayout.getSName(),
			"sDescription" = (isNull(arSeasonPayouts[itm].oPayout.getSDescription())) ? "" : arSeasonPayouts[itm].oPayout.getSDescription(),
			"nAmount" = arSeasonPayouts[itm].getNAmount()
		};
		arrayAppend(stSeasonPayouts[arSeasonPayouts[itm].oPayout.getSType()], stData);
	}
	return stSeasonPayouts;
}

}
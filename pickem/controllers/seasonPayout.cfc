component accessors="true" extends="model.baseController" {

property name="seasonPayoutGateway";
property name="seasonPayoutService";
property name="payoutGateway";

/*
Author: 	
	Ron West
Name:
	$before
Summary:
	Makes sure users are admins
Returns:
	Void
Arguments:
	Void
History:
	2015-08-21 - RLW - Created
*/
public void function before (rc){
	param name="rc.nSeasonPayoutID" default="0";
	rc.oSeasonPayout = variables.seasonPayoutGateway.get(rc.nSeasonPayoutID);
	rc.arSeasonPayouts = variables.seasonPayoutService.getPayouts(rc.nCurrentSeasonID);
	rc.nAssignedPurse = variables.seasonPayoutService.getAssignedPurse(rc.nCurrentSeasonID);
	// if we have a valid season payout get the name of the payout
	if( not isNull(rc.oSeasonPayout.getNPayoutID()) ){
		rc.oPayout = variables.payoutGateway.get(rc.oSeasonPayout.getNPayoutID());
	}
}

/*
Author: 	
	Ron West
Name:
	$addEdit
Summary:
	Sets up the add/edit season payout dialog
Returns:
	Void
Arguments:
	Void
History:
	2015-08-23 - RLW - Created
*/
public void function addEdit(rc){
	// make sure the user is an admin
	if( not rc.stUser.bIsAdmin ){
		variables.framework.redirect("main.notAuthorized");
	}
	// get all of the payouts that aren't in use
	rc.arAvailablePayouts = variables.seasonPayoutService.getAvailablePayouts(rc.nCurrentSeasonID);
}

/*
Author: 	
	Ron West
Name:
	$save
Summary:
	Saves the seasonPayout
Returns:
	Void
Arguments:
	Void
History:
	2015-08-21 - RLW - Created
*/
public void function save(rc){
	param name="rc.bRedirect" default="true";
	rc.sMessage = "Season payout updated";
	// make sure the user is an admin
	if( not rc.stUser.bIsAdmin ){
		variables.framework.redirect("main.notAuthorized");
	}
	try{
		// if we are adding then change message
		if( rc.nSeasonPayoutID eq 0 ){
			rc.sMessage = "SeasonPayout created successfully";
		}
		// save the seasonPayout
		rc.oSeasonPayout = variables.seasonPayoutGateway.update(rc.oSeasonPayout, rc);
		// if we are redirecting back to the listing
		if( rc.bRedirect ){
			// send them back to the listing of seasons
			variables.framework.redirect("seasonPayout.listing");
		}
		
	} catch (any e){
		registerError("Error saving seasonPayout", e);
		rc.sType = "create";
		variables.framework.setView("seasonPayout.error");
	}
	
}

/*
Author: 	
	Ron West
Name:
	$delete
Summary:
	Deletes the seasonPayout
Returns:
	Void
Arguments:
	Void
History:
	2015-08-21 - RLW - Created
*/
public void function delete(rc){
	rc.sMessage = "SeasonPayout deleted successfully";
	rc.sType = "delete";
	// make sure the user is an admin
	if( not rc.stUser.bIsAdmin ){
		variables.framework.redirect("main.notAuthorized");
	}
	try{
		if( rc.nSeasonPayoutID != 0 ){
			rc.oSeasonPayout = variables.seasonPayoutGateway.delete(rc.oSeasonPayout);
			variables.framework.redirect("seasonPayout.listing");
		}
	} catch (any e){
		registerError("Error deleting seasonPayout", e);
	}
	variables.framework.setView("seasonPayout.error");
}

/*
Author: 	
	Ron West
Name:
	$details
Summary:
	Renders the details for the payouts
Returns:
	Void
Arguments:
	Void
History:
	2015-09-02 - RLW - Created
*/
public void function details(rc){
	rc.stSeasonPayouts = variables.seasonPayoutService.organizedByType(rc.nCurrentSeasonID);
}

}
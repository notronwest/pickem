component accessors="true" extends="model.baseController" {

property name="payoutGateway";
property name="seasonPayoutGateway";

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
	param name="rc.nPayoutID" default="0";
	param name="rc.nSeasonPayoutID" default="0";
	// make sure the user is an admin
	if( not rc.stUser.bIsAdmin ){
		variables.framework.redirect("main.notAuthorized");
	}
	rc.oPayout = variables.payoutGateway.get(rc.nPayoutID);
	rc.oSeasonPayout = variables.seasonPayoutGateway.get(rc.nSeasonPayoutID);
	rc.arSeasonPayouts = variables.seasonPayoutGateway.getBySeason(rc.nCurrentSeasonID);
}

/*
Author: 	
	Ron West
Name:
	$save
Summary:
	Saves the payout
Returns:
	Void
Arguments:
	Void
History:
	2015-08-21 - RLW - Created
*/
public void function save(rc){
	rc.sMessage = "Payout updated";
	try{
		// if we are adding then change message
		if( rc.nPayoutID eq 0 ){
			rc.sMessage = "Payout created successfully";
		}
		// save the payout
		rc.oPayout = variables.payoutGateway.update(rc.oPayout, rc);
		// send them back to the listing of seasons
		variables.framework.redirect("payout.listing");
		
	} catch (any e){
		registerError("Error saving payout", e);
		rc.sType = "create";
		variables.framework.setView("payout.error");
	}
	
}

/*
Author: 	
	Ron West
Name:
	$delete
Summary:
	Deletes the payout
Returns:
	Void
Arguments:
	Void
History:
	2015-08-21 - RLW - Created
*/
public void function delete(rc){
	rc.sMessage = "Payout deleted successfully";
	rc.sType = "delete";
	try{
		if( rc.nPayoutID != 0 ){
			rc.oPayout = variables.payoutGateway.delete(rc.oPayout);
			variables.framework.redirect("payout.listing");
		}
	} catch (any e){
		registerError("Error deleting payout", e);
	}
	variables.framework.setView("payout.error");
}

/*
Author: 	
	Ron West
Name:
	$listing
Summary:
	Creates listing of available payouts
Returns:
	Void
Arguments:
	Void
History:
	2015-08-23 - RLW - Created
*/
public void function listing(rc){
	rc.arPayouts = variables.payoutGateway.getAll();
}
}
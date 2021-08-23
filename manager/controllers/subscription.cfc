component accessors="true" extends="model.baseController" {

property name="userGateway";
property name="userService";
property name="subscriptionGateway";
property name="seasonService";
property name="optionGateway";
property name="notifyService";

public void function before (rc){
	// default the user to the current user
	param name="rc.nUserID" default="#rc.nCurrentUser#";
	param name="rc.nSubscriptionID" default="0";
	// if the user isn't an admin user kick them
	if( !rc.stUser.bIsAdmin ){
		variables.framework.redirect("security:main.restricted");
	}
	// default all calls to a dialog
	rc.bIsDialog = false;
	rc.oUser = variables.userGateway.get(rc.nUserID);
	rc.oSubscription = variables.subscriptionGateway.get(rc.nSubscriptionID);
}

public void function save(rc){
	try{
		if( structKeyExists(rc, "nAmount") ){
			// if this is a new subscription make sure the subscription doesn't already exist
			if( rc.nSubscriptionID eq 0 ){
				arSubscription = variables.subscriptionGateway.getByUserAndSeason(rc.nUserID, rc.nCurrentSeasonID);
				if( arrayLen(arSubscription) gt 0 ){
					variables.framework.redirect(action="user.listing", queryString="sMessage=Sorry, a subscription record already exists for user #rc.oUser.getSFirstName()# #rc.oUser.getSLastName()#, please try again.");
				}
			}
			// save the main user
			rc.oSubscription = variables.subscriptionGateway.update(rc.oSubscription, {
				"nSeasonID" = rc.nCurrentSeasonID,
				"nAmount" = rc.nAmount,
				"dtPaid" = rc.dtPaid,
				"sPaymentType" = rc.sPaymentType,
				"nUserID" = rc.nUserID
			});
			// recalculate this seasons purse
			variables.seasonService.updatePurse(rc.nCurrentSeasonID);
			// send out an email
			var subscriptionPaidOption = variables.optionGateway.getByCodeKey('subscriptionPaid', rc.sCurrentLeagueID);
			if ( arrayLen(subscriptionPaidOption) ) {
				variables.notifyService.doNotification( subscriptionPaidOption[1], rc.oUser, rc.sCurrentLeagueID);
			}
			// redirect to the listing
			variables.framework.redirect(action="user.listing", queryString="sMessage=Subscription saved for #rc.oUser.getSFirstName()# #rc.oUser.getSLastName()#");
		}
	} catch (any e){
		registerError("Error saving subscription", e);
		rc.sMessage = "Error saving subscription, please try again";
		variables.framework.setView("subscription.addEdit");
	}
	
}

public void function noPayNoPlay(rc){
	rc.arImages = directoryList(expandPath('/assets/images/nopaynoplay'), false, "name");
}

}
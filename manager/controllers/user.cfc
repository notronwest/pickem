component accessors="true" extends="model.baseController" {

property name="userGateway";
property name="userService";

public void function before (rc){
	// default the user to the current user
	param name="rc.nUserID" default="#rc.nCurrentUser#";
	param name="rc.bProfileSaved" default="false";
	param name="rc.bAddNew" default="false";
	param name="rc.bAdminIsUser" default="false";
	// if the user isn't an admin and the user id suplied is different than the current user kick them
	if( !rc.stUser.bIsAdmin and (rc.nCurrentUser neq rc.stUser.nUserID or rc.bAddNew) ){
		variables.framework.redirect("security:main.restricted");
	} else if( rc.stUser.bIsAdmin and rc.nUserID eq rc.stUser.nUserID ){
		rc.bAdminIsUser = true;
	}
	// default all calls to a dialog
	rc.bIsDialog = false;
	// if this is an add then clear user id
	if( rc.bAddNew ){
		rc.nUserID = 0;
	}
	rc.oUser = variables.userGateway.get(rc.nUserID);
}

public void function listing(rc){
	rc.arUsers = variables.userService.getAllWithSubscriptions(rc.nCurrentSeasonID);
	rc.bIsAdminAction = true;
}

public void function addEdit(rc){
	rc.sAction = "";
	rc.bShowProfile = "true";
	rc.bShowCredentials = "true";
	if( rc.stUser.bIsAdmin ){
		rc.bIsAdminAction = true;
	}
}

public void function save(rc){
	var oUser = "";
	var stUserData = {};
	var sPassword = "";
	var bIsNewUser = (rc.nUserID eq 0) ? true : false;
	param name="rc.bIsAdmin" default="0";
	param name="rc.sNickname" default="";
	param name="rc.bActive" default="1";
	rc.sMessage = "User updates";
	try{
		// make sure the name has length
		if( not len(rc.sFirstName) gt 0 or not len(rc.sLastName) gt 0 ){
			variables.framework.redirect(action="user.addEdit", queryString="sMessage=Please enter a valid first name and last name");
		}
		// if we are adding then change message
		if( bIsNewUser ){
			sMessage = "User created successfully";
		}
		// do the actual save
		oUser = variables.userService.handleSave(rc.oUser, rc, rc.stUser.bIsAdmin, bIsNewUser);
		// if the user is an admin redirect the user to the listing
		if( rc.stUser.bIsAdmin ){
			variables.framework.redirect('user.listing');
			rc.bIsAdminAction = true;
		} else {
			sMessage = "Profile saved successfully";
			variables.framework.setView('manager:user.addEdit');
		}
	} catch (any e){
		registerError("Error saving user", e);
		rc.sType = "create";
		variables.framework.setView("user.error");
	}
	
}

public void function delete(rc){
	rc.oUser = userGateway.get(rc.nUserID);
	rc.sMessage = "User deleted successfully";
	rc.sType = "delete";
	try{
		if( rc.nUserID != 0 ){
			rc.oUser = userGateway.delete(rc.oUser);
			variables.framework.redirect("user.listing", "all");
		}
	} catch (any e){
		registerError("Error deleting user", e);
	}
	variables.framework.setView("user.error");
}

public void function impersonate(rc){
	param name="rc.nImpersonateUser" default="0";
	rc.sMessage = "You cannot impersonate this user";
	// make sure that the user is an admin
	if( rc.stUser.bIsAdmin and rc.nImpersonateUser > 0 ){
		session.nImpersonateUser = rc.nImpersonateUser;
		rc.sMessage = "You are now impersonating this user";
	} else if ( rc.stUser.bIsAdmin ){
		// cancel impersonation
		session.nImpersonateUser = 0;
		// cancel overriding picks
		session.bManualOverridePicks = false;
		rc.sMessage = "User impersonation cancelled";
	}
	variables.framework.setView('main.message');
	rc.bIsDialog = true;
}

public void function emailUserForm(rc){
	// get all of the users
	rc.arUsers = variables.userGateway.getBySeason(rc.nCurrentSeasonID, 1);
	rc.bIsAdminAction = true;
}

public void function emailList(rc){
	// get all of the users
	rc.arUsers = variables.userGateway.getAllSortByFirst(false);
	rc.bIsAdminAction = true;
}

public void function sendEmail(rc){
	param name="rc.sMessage" default="";
	param name="rc.lstEmail" default="";
	param name="rc.sSubject" default="Pickem site e-mail";
	var itm = 1;
	var arEmail = [];
	var sNewMessage = "";
	try{
		if( len(rc.sMessage) gt 0 and len(rc.lstEmail) gt 0 ){
			arEmail = listToArray(rc.lstEmail);
			// replace all of the codes with the value for the user
			for(itm; itm lte arrayLen(arEmail); itm++ ){
				sNewMessage = variables.userService.applyEmailMask(rc.sMessage, arEmail[itm]);
				variables.commonService.sendEmail(arEmail[itm], rc.sSubject, sNewMessage);
			}
			rc.sMessage = "Email sent.";
			variables.framework.setView("main.message");
		} else {
			throw( message="The values for the message and/or email list were blank");
		}

	} catch ( any e ){
		registerError("Error sending user email", e);
	}
}

public void function register(rc){
	// make sure this user doesn't already exist
	var arUser = variables.userGateway.getByEmail(rc.sEmail);
	if( arrayLen(arUser) gt 0 ){
		variables.framework.redirect(action="security:main.login", queryString="sMessage=That E-mail already exists. Please try again or go to login&sMessageType=register");
	}
	// get a password for this user
	var sPassword = variables.commonService.generatePassword();
	// setup the user
	var stUser = {
		"sUserName" = rc.sEmail,
		"sPassword" = sPassword,
		"sEmail" = rc.sEmail,
		"bActive" = 1,
		"bChangePassword" = 1
	};
	// save the user
	var oUser = variables.userGateway.update(variables.userGateway.get(), stUser);
	// send out e-mail
	variables.userService.sendNewUserEmail(rc.sEmail, sPassword, rc.oCurrentLeague);
}

public void function changePassword(rc){
	param name="rc.bProcess" default="false";
	if( rc.bProcess and compareNoCase(rc.sCurrentPassword, rc.oUser.getSPassword()) eq 0 ){
		rc.sMessage = "Password changed";
		// save the password
		variables.userGateway.update(rc.oUser, {sPassword = rc.sPassword, bChangePassword = 0});
		// redirect to account
		variables.framework.setView('user.addEdit');
		// reset this users session
		session.bChangePassword = 0;
	} else if( rc.bProcess and compareNoCase(rc.sCurrentPassword, rc.oUser.getSPassword()) neq 0 ) {
		rc.sMessage = "Sorry please confirm your original password and try again";
	}
}

}
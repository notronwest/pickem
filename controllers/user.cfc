component accessors="true" extends="model.base" {

property name="userGateway";
property name="userService";

public void function before (rc){
	// default the user to the current user
	param name="rc.nUserID" default="#rc.nCurrentUser#";
	param name="rc.bProfileSaved" default="false";
	param name="rc.bAddNew" default="false";
	// if the user isn't an admin and the user id suplied is different than the current user kick them
	if( !rc.stUser.bIsAdmin and (rc.nCurrentUser neq rc.stUser.nUserID or rc.bAddNew) ){
		variables.framework.redirect("security.restricted");
	}
	// default all calls to a dialog
	rc.bIsDialog = false;
	// if this is an add then clear user id
	if( rc.bAddNew ){
		rc.nUserID = 0;
	}
	rc.oUser = userGateway.get(rc.nUserID);
}

public void function listing(rc){
	rc.arUsers = userGateway.getAll();
	rc.bIsAdminAction = true;
}

public void function addEdit(rc){
	rc.sAction = "";
	rc.bShowProfile = "true";
	rc.bShowCredentials = "true";
	if( rc.bIsAdmin ){
		rc.bIsAdminAction = true;
	}
}

public void function save(rc){
	var oUser = "";
	param name="rc.bIsAdmin" default="0";
	rc.sMessage = "User updates";
	try{
		// if we are adding then change message
		if( rc.nUserID eq 0 ){
			rc.sMessage = "User created successfully";
		}
		// get this users object
		oUser = userGateway.get(rc.nUserID);
		if( structKeyExists(rc, "sFirstName") ){
			// save the main user
			oUser = userGateway.update(oUser, {
				"sFirstName" = rc.sFirstName,
				"sLastName" = rc.sLastName,
				"sEmail" = rc.sEmail,
				"sUsername" = rc.sUsername,
				"sPassword" = rc.sPassword,
				"bIsAdmin" = rc.bIsAdmin
			});
		}
		if( structKeyExists(rc, "sUsername") ){
			// save the username
			oUser = userGateway.saveUsername(oUser.getNUserID(), rc.sUsername);
			// save password
			oUser = userGateway.savePassword(oUser.getNUserID(), rc.sPassword);
		}
		// if the user is an admin redirect the user to the listing
		if( rc.stUser.bIsAdmin ){
			variables.framework.redirect('user.listing');
			rc.bIsAdminAction = true;
		} else {
			rc.oUser = oUser;
			rc.bProfileSaved = true;
			variables.framework.setView('user.addEdit');
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
		rc.sMessage = "User impersonation cancelled";
	}
	variables.framework.setView('main.message');
	rc.bIsDialog = true;
}

public void function emailUserForm(rc){
	// get all of the users
	rc.arUsers = variables.userGateway.getAllSortByFirst();
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

public void function forgotPassword(rc){

/*
Hi [firstname],

Welecome to Pickem, the companion to your favorite spreadsheet. Below you will find your credentials for accessing the new Pickem web site at [siteurl].

Username: [username]
Password: [password]

From the site you can make your picks easily from your desktop, tablet or mobile phone.

Good Luck!


*/
	
}
}
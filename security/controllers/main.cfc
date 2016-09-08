component accessors="true" extends="model.baseController" {

property name="userGateway";
property name="userService";
property name="subscriptionGateway";
property name="settingService";
property name="userSeasonGateway";

public void function before(rc){
	param name="rc.sActionAfterLogin" default="manager:standing.home";
	rc.bIsDialog = false;

}

public void function checkAuthorization(rc){
	// set the session scope into rc
	rc.stUser = session;
	// if the user has to change their password
	if( structKeyExists(rc.stUser, "bChangePassword")
		and rc.stUser.bChangePassword eq 1
		and compareNoCase(variables.framework.getFullyQualifiedAction(), "manager:user.changePassword") neq 0 ){
		variables.framework.redirect("manager:user.changePassword");
	// if the user has to assign their profile information and we aren't tring to change their password
	} else if ( structKeyExists(rc.stUser, "bSetProfile")
		and rc.stUser.bSetProfile eq 1
		and compareNoCase(variables.framework.getFullyQualifiedAction(), "manager:user.changePassword") neq 0
		and compareNoCase(variables.framework.getFullyQualifiedAction(), "manager:user.addEdit") neq 0 and comparenoCase(variables.framework.getFullyQualifiedAction(), "manager:user.save") neq 0 ) { 
		// redirect them to edit their profile
		variables.framework.redirect(action="manager:user.addEdit", queryString="sMessage=You must enter a valid name for your account");
	}
	// force all users to login - unless they know the api code
	if( compare(request.sAPIKey, rc.sAPIKey) neq 0
		and session.nUserID eq 0
		and arrayFindNoCase(application.arUnsecuredActions, variables.framework.getFullyQualifiedAction()) eq 0 ){
		// set the action for after logging in
		rc.sActionAfterLogin = request.action;
		// if they have logged in before we know they are valid so send direct
		if( rc.bHasLoggedIn ){
			variables.framework.redirect("security:main.login");	
		} else { // could be a new user
			variables.framework.redirect(action="security:main.login", queryString="bIsNewUser=true");
		}
		
	}
	// set the current user
	rc.nCurrentUser = rc.stUser.nUserID;

	// if this is an admin look for a session variable for impersonation
	if( rc.stUser.bIsAdmin and structKeyExists(session, "nImpersonateUser") and session.nImpersonateUser > 0 ){
		rc.nCurrentUser = session.nImpersonateUser;
	}
}

public void function authenticate(rc){
	var arUser = [];
	var bLoggedIn = false;
	rc.sMessageType = "warning";
	var oUserSeason = "";
	try{

		rc.sMessage = "Login failed - please provide a valid username/password combination";
		rc.sMessageType = "login";
		// if they have passed in a username and password
		if( structKeyExists(rc, "sUsername")
			and len(rc.sUsername) gt 0
			and structKeyExists(rc, "sPassword") 
			and len(rc.sPassword) > 0 ){
			// authenticate the user
			arUser = variables.userGateway.getByUsernamePassword(rc.sUsername, rc.sPassword);
			if( arrayLen(arUser) ){
				// see if this user has a valid subscription
				/*if( arrayLen(variables.subscriptionGateway.getByUserAndSeason(arUser[1].getNUserID(), rc.nCurrentSeasonID)) eq 0 and arUser[1].getBIsAdmin() neq 1 ){
					variables.framework.redirect("subscription.noPayNoPlay");
				}*/
				// build the session
				setupSession(arUser);
				rc.sMessage = "Login successful";
				variables.userService.updateLastLogin(session.nUserID);
				bLoggedIn = true;

				// set cookie so the user doesn't receive the "sign up" message
				getPageContext().getResponse().addHeader("Set-Cookie", "bHasLoggedIn=true;path=/;HTTPOnly");

				// check to see if the user has a profile
				if( len(arUser[1].getSFirstName()) eq 0 or len(arUser[1].getSLastName()) eq 0 ){
					session.bSetProfile = 1;
				}
				// check to see if this user has a valid entry into this season (if not add it)
				oUserSeason = variables.userSeasonGateway.get({
					nUserID = session.nUserID,
					nSeasonID = rc.nCurrentSeasonID
				});
				if( isNull(oUserSeason.getSUserSeasonID()) ){
					variables.userSeasonGateway.update(variables.userSeasonGateway.get(), {
						nUserID = session.nUserID,
						nSeasonID = rc.nCurrentSeasonID,
						bActive = 1
					});
				}
			}
		}
	} catch (any e){
		registerError("Error authenticating", e);
	}
	if( !bLoggedIn ){
		variables.framework.setView("security:main.login");
	} else {
		variables.framework.redirect(rc.sActionAfterLogin);
	}

}

public void function setupSession(arUser){
	try{
		session.nUserID = arUser[1].getNUserID();
		session.sEmail = arUser[1].getSEmail();
		session.bChangePassword = arUser[1].getBChangePassword();
		if( arUser[1].getBIsAdmin() eq 1 ){
			session.bIsAdmin = true;
		} else {
			session.bIsAdmin = false;
		}
		// load preferences
		session.stSettings = variables.settingService.readableUserSettings(arUser[1].getNUserID());
	} catch (any e){
		registerError("Error setting up session", e);
	}
}

public void function logout(){
	session.nUserID = 0;
	// set message for login window
	rc.sMessage = "Logged out";
	variables.framework.redirect('manager:standing.home', 'sMessage');
}

public void function forgotPassword(rc){
	param name="rc.sEmail" default="";
	param name="rc.bProcess" default="false";
	var arUser = [];
	var sPassword = "";
	var sMessage = "";
	if( rc.bProcess ){
		arUser = variables.userGateway.getByEmail(rc.sEmail);
		sPassword = variables.commonService.generatePassword();
		if( arrayLen(arUser) ){
			// save the user with new password and force to change
			variables.userGateway.update(arUser[1], { sPassword = sPassword, bChangePassword = 1 } );
			// send them an e-mail
			sMessage = "You have asked to have your password reset. We have created the following temporary password for you: #sPassword#

Use the above password in combination with your e-mail address to get back into the action.

#request.stLeagueSettings[rc.oCurrentLeague.getSKey()].sProductionURL#";

			variables.commonService.sendEmail(rc.sEmail, "#rc.oCurrentLeague.getSName()# password reset", sMessage);
			// set new login message
			rc.sMessage = "An e-mail has been sent with a temporary password";
			// redirect to login
			variables.framework.setView('security:main.login');
		} else {
			rc.sMessage = "Sorry couldn't find an account with that e-mail please try again";
		}
	}
}
}
component accessors="true" extends="model.base" {

property name="userGateway";
property name="userService";

public void function before(rc){
	param name="rc.sActionAfterLogin" default="standing.home";
	rc.bIsDialog = false;

}

public void function checkAuthorization(rc){
	// set the session scope into rc
	rc.stUser = session;
	// if the user has to change their password
	if( structKeyExists(rc.stUser, "bChangePassword") and rc.stUser.bChangePassword eq 1 and compareNoCase(variables.framework.getFullyQualifiedAction(), "user.changePassword") neq 0 ){
		variables.framework.redirect("user.changePassword");
	}
	// force all users to login
	if( session.nUserID eq 0
		and arrayFindNoCase(application.arUnsecuredActions, variables.framework.getFullyQualifiedAction()) eq 0 ){
		// set the action for after logging in
		rc.sActionAfterLogin = request.action;
		// if they have logged in before we know they are valid so send direct
		if( rc.bHasLoggedIn ){
			variables.framework.redirect("security.login");	
		} else { // could be a new user
			variables.framework.redirect(action="security.login", queryString="bIsNewUser=true");
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
	try{

		rc.sMessage = "Login failed - please provide a valid username/password combination";
		rc.sMessageType = "login";
		if( structKeyExists(rc, "sUsername") and len(rc.sUsername) gt 0 and structKeyExists(rc, "sPassword") and len(rc.sPassword) > 0 ){
			arUser = variables.userGateway.getByUsernamePassword(rc.sUsername, rc.sPassword);
			if( arrayLen(arUser) ){
				// build the session
				setupSession(arUser);
				rc.sMessage = "Login successful";
				variables.userService.updateLastLogin(session.nUserID);
				bLoggedIn = true;

				// set cookie so the user doesn't receive the "sign up" message
				getPageContext().getResponse().addHeader("Set-Cookie", "bHasLoggedIn=true;path=/;HTTPOnly");
			}
		}
	} catch (any e){
		registerError("Error authenticating", e);
	}
	if( !bLoggedIn ){
		variables.framework.setView("security.login");
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
	} catch (any e){
		registerError("Error setting up session", e);
	}
}

public void function logout(){
	session.nUserID = 0;
	// set message for login window
	rc.sMessage = "Logged out";
	variables.framework.redirect('standing.home', 'sMessage');
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

http://pickem.inquisibee.com";

			variables.commonService.sendEmail(rc.sEmail, "Pickem password reset", sMessage);
			// set new login message
			rc.sMessage = "An e-mail has been sent with a temporary password";
			// redirect to login
			variables.framework.setView('security.login');
		} else {
			rc.sMessage = "Sorry couldn't find an account with that e-mail please try again";
		}
	}
}
}
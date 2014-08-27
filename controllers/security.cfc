component accessors="true" extends="model.base" {

property name="userGateway";
property name="userService";

public void function before(rc){
	rc.bIsDialog = false;
}

public void function checkAuthorization(rc){
	// set the session scope into rc
	rc.stUser = session;
	// force all users to login
	if( session.nUserID eq 0 and variables.framework.getFullyQualifiedAction() neq "security.login" and variables.framework.getFullyQualifiedAction() neq "security.authenticate" ){
		variables.framework.redirect("security.login");
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
	try{
		rc.sMessage = "Login failed - please provide a valid username/password combination";
		if( structKeyExists(rc, "sUsername") and len(rc.sUsername) gt 0 and structKeyExists(rc, "sPassword") and len(rc.sPassword) > 0 ){
			arUser = variables.userGateway.getByUsernamePassword(rc.sUsername, rc.sPassword);
			if( arrayLen(arUser) ){
				setupSession(arUser);
				rc.sMessage = "Login successful";
				variables.userService.updateLastLogin(session.nUserID);
			}
		}
	} catch (any e){
		registerError("Error authenticating", e);
	}
	variables.framework.setView("main.message");
	rc.bIsDialog = true;
}

public void function setupSession(arUser){
	try{
		session.nUserID = arUser[1].getNUserID();
		session.sEmail = arUSer[1].getSEmail();
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
	variables.framework.redirect('standing.home');
}
}
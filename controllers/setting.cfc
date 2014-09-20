component accessors="true" extends="model.base" {

property name="userGateway";
property name="userService";
property name="settingService";
property name="optionGateway";
property name="framework";

public void function before (rc){
	// default messaging
	rc.sMessage = "";
	rc.sMessageType = "info";
	// default the user to the current user
	param name="rc.nUserID" default="#rc.nCurrentUser#";
	// if the user isn't an admin and the user id suplied is different than the current user kick them
	if( !rc.stUser.bIsAdmin and (rc.nCurrentUser neq rc.stUser.nUserID) ){
		variables.framework.redirect("security.restricted");
	}
	// get the user info
	rc.oUser = userGateway.get(rc.nUserID);
	// get the user settings
	rc.stSettings = variables.settingService.userSettings(rc.nUserID);
	// get available options
	rc.arOptions = variables.optionGateway.getAll();
}

public void function save (rc){
	rc.sMessage = "Settings saved";
	rc.sMessageType = "info";
	variables.settingService.saveUserSettings(rc, rc.nUserID);
	// get the user settings
	rc.stSettings = variables.settingService.userSettings(rc.nUserID);
	variables.framework.setView('setting.set');
}

}
component accessors="true" extends="model.base" {

property name="teamGateway";
property name="teamService";

public void function before (rc){
	// default the controllers as dialogs
	rc.bIsDialog = true;
}

public void function add(rc){
	rc.sMessage = "Team added successfully";
	try{
		if( structKeyExists(rc, "sName") and len(rc.sName) gt 0 and structKeyExists(rc, "sURL") and len(rc.sURL) gt 0 ){
			teamService.saveTeam(rc.sName, rc.sURL);
		}
	} catch ( any e ){
		registerError("Error adding team via controller", e);
		rc.sMessage = "Error adding team";
	}
	variables.framework.setView("main.message");
}

/*
Author: 	
	Ron West
Name:
	$searchForTeam
Summary:
	Searches for a team
Returns:
	Void
Arguments:
	Void
History:
	2012-09-18 - RLW - Created
*/
public void function searchForTeam(rc){
	param name="rc.term" default="foo";
	rc.aResult = variables.teamService.findTeam(rc.term);
	// serialize result
	variables.framework.setView(application.sSerializeView);
}

}
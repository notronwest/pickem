component accessors="true" extends="model.base" {

property name="teamGateway";
property name="teamService";

public void function before (rc){
	param name="rc.nTeamID" default="0";
	// default the controllers as dialogs
	rc.bIsDialog = false;
	// make sure the user is an admin
	if( not rc.stUser.bIsAdmin ){
		variables.fw.redirect("main.notAuthorized");
	}
	rc.oTeam = variables.teamGateway.get(rc.nTeamID);
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
	$listing
Summary:
	Gets all of the teams for display
Returns:
	Void
Arguments:
	Void
History:
	2015-08-08 - RLW - Created
*/
public void function listing (rc){
	rc.arTeams = variables.teamGateway.getAll();
}

/*
Author: 	
	Ron West
Name:
	$save
Summary:
	Saves the team
Returns:
	Void
Arguments:
	Void
History:
	2015-08-08 - RLW - Created
*/
public void function save(rc){
	var oTeamSaved = "";
	rc.sMessage = "Team updated";
	try{
		// if we are adding then change message
		if( rc.nTeamID eq 0 ){
			rc.sMessage = "Team created successfully";
		}
		// save the team
		oTeamSaved = variables.teamGateway.update(rc.oTeam, rc);
		// send them back to the listing
		variables.framework.redirect("team.listing");
		
	} catch (any e){
		registerError("Error saving team", e);
		rc.sType = "create";
		variables.framework.setView("team.error");
	}
	
}

/*
Author: 	
	Ron West
Name:
	$delete
Summary:
	Deletes the team
Returns:
	Void
Arguments:
	Void
History:
	2015-08-08 - RLW - Created
*/
public void function delete(rc){
	rc.sMessage = "Team deleted successfully";
	rc.sType = "delete";
	try{
		if( rc.nTeamID != 0 ){
			rc.oTeam = variables.teamGateway.delete(rc.oTeam);
			variables.framework.redirect("team.listing");
		}
	} catch (any e){
		registerError("Error deleting team", e);
	}
	variables.framework.setView("team.error");
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
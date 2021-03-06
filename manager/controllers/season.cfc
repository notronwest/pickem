component accessors="true" extends="model.baseController" {

property name="seasonGateway";
property name="leagueGateway";
//property name="seasonService";


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
	2015-08-08 - RLW - Created
*/
public void function before (rc){
	param name="rc.nSeasonID" default="0";
	// make sure the user is an admin
	if( not rc.stUser.bIsAdmin ){
		variables.framework.redirect("main.notAuthorized");
	}
	rc.oSeason = variables.seasonGateway.get(rc.nSeasonID);
	// get array of leagues
	rc.arLeagues = variables.leagueGateway.getAll();
}

/*
Author: 	
	Ron West
Name:
	$listing
Summary:
	Gets all of the seasons for display
Returns:
	Void
Arguments:
	Void
History:
	2015-08-08 - RLW - Created
*/
public void function listing (rc){
	rc.arSeasons = variables.seasonGateway.getAll();
}

/*
Author: 	
	Ron West
Name:
	$save
Summary:
	Saves the season
Returns:
	Void
Arguments:
	Void
History:
	2015-08-08 - RLW - Created
*/
public void function save(rc){
	var oSeasonSaved = "";
	rc.sMessage = "Season updated";
	try{
		// if we are adding then change message
		if( rc.nSeasonID eq 0 ){
			rc.sMessage = "Season created successfully";
		}
		// make sure dates are stored correctly
		rc.dtStart = (len(rc.dtStart) ? dateFormat(rc.dtStart, "yyyy-mm-dd") : "");
		rc.dtEnd = (len(rc.dtStart) ? dateFormat(rc.dtEnd, "yyyy-mm-dd") : "");
		// save the season
		oSeasonSaved = variables.seasonGateway.update(rc.oSeason, rc);
		// send them back to the listing
		variables.framework.redirect("season.listing");
		
	} catch (any e){
		registerError("Error saving season", e);
		rc.sType = "create";
		variables.framework.setView("season.error");
	}
	
}

/*
Author: 	
	Ron West
Name:
	$delete
Summary:
	Deletes the season
Returns:
	Void
Arguments:
	Void
History:
	2015-08-08 - RLW - Created
*/
public void function delete(rc){
	rc.sMessage = "Season deleted successfully";
	rc.sType = "delete";
	try{
		if( rc.nSeasonID != 0 ){
			rc.oSeason = variables.seasonGateway.delete(rc.oSeason);
			variables.framework.redirect("season.listing");
		}
	} catch (any e){
		registerError("Error deleting season", e);
	}
	variables.framework.setView("season.error");
}


}
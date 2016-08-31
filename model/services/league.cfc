component accessors="true" extends="model.services.baseService" {
property name="leagueGateway";

/*
Author: 	
	Ron West
Name:
	$getLeague
Summary:
	Returns the league or creates it
Returns:
	Void
Arguments:
	String sLeagueID
History:
	2016-08-26 - RLW - Created
*/
public model.beans.league function getLeague( Required String sName){
	var oLeague = variables.leagueGateway.get({ sName = arguments.sName});
	if( isNull(oLeague.getSLeagueID()) ){
		// create a new league
		oLeague = variables.leagueGateway.update(oLeague, {
			sName = arguments.sName
		});
	}
	return oLeague;
}

}
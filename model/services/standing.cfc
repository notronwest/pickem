component accessors="true" extends="model.services.baseService" {

property name="standingGateway";

/*
Author: 	
	Ron West
Name:
	$deleteUserStandings
Summary:
	Deletes the standings for a user
Returns:
	Void
Arguments:
	Numeric nUserID
History:
	2014-09-10 - RLW - Created
*/
public void function deleteUserStandings( Required Numeric nUserID ){
	// get the standings
	var arStandings = variables.standingGateway.getByUser(arguments.nUserID);
	var itm = 1;
	for(itm; itm lte arrayLen(arStandings); itm++ ){
		variables.standingGateway.delete(arStandings[itm]);
	}
}
	
}
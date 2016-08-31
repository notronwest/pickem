
component entityname="season" persistent="true" table="season" output="false" extends="model.baseORMBean" {
	property name="nSeasonID" fieldtype="ID" generator="identity";
	property name="sName" fieldtype="column" ormtype="string" length="2000";
	property name="dtStart" fieldtype="column" ormtype="string" length="19";
	property name="dtEnd" fiedtype="column" ormtype="string" length="19";
	property name="nSubscriptionAmount" fiedtype="column" ormtype="int";
	property name="nTotalPurse" fiedtype="column" ormtype="int";
	property name="nTotalCost" fiedtype="column" ormtype="int";
	property name="sPaymentText" fieldtype="column" ormtype="string";
	property name="sLeagueID" fieldtype="column" ormtype="string" length="32";

	// override the get total purse function to return the amount minus the total cost
	public Numeric function getNCalculatedPurse(){
		return ((structKeyExists(variables, "nTotalPurse")) ? variables.nTotalPurse : 0) - ((structKeyExists(variables, "nTotalCost")) ? variables.nTotalCost : 0);
	}
}
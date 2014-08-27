
component entityname="standing" persistent="true" table="standing" output="false" {
	property name="nStandingID" fieldtype="ID" generator="identity";
	property name="nWeekID" fieldtype="column" ormtype="int";
	property name="nWins" fieldtype="column" ormtype="int";
	property name="nLosses" fieldtype="column" ormtype="int";
	property name="nTiebreaks" fieldtype="column" ormtype="int";
	property name="nUserID" fieldtype="column" ormtype="int";
	property name="nPlace" fieldtype="column" ormtype="int";
	property name="sSeason" fieldtype="column" ormtype="string" length="20";
	/**
	* @output false
	*/
	public Numeric function getNStandingID(){
		if( not structKeyExists(variables, "nStandingID") ){
			variables.nStandingID = 0;
		}
		return variables.nStandingID;
	}
}
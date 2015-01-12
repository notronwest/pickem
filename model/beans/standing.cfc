
component entityname="standing" persistent="true" table="standing" output="false" {
	property name="nStandingID" fieldtype="ID" generator="identity";
	property name="nWeekID" fieldtype="column" ormtype="int";
	property name="nWins" fieldtype="column" ormtype="int";
	property name="nLosses" fieldtype="column" ormtype="int";
	property name="nHighestTiebreak" fieldtype="column" ormtype="int";
	property name="nUserID" fieldtype="column" ormtype="int";
	property name="nPlace" fieldtype="column" ormtype="int";
	property name="bHasPicks" fieldtype="column" ormtype="int";
	property name="sSeason" fieldtype="column" ormtype="string" length="20";

	property name="week" fieldtype="many-to-one" cfc="week" fkcolumn="nWeekID" insert="false" update="false";
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
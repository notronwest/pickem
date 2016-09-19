
component entityname="standing" persistent="true" table="standing" output="false" extends="model.baseORMBean" {
	property name="nStandingID" fieldtype="ID" generator="identity";
	property name="nWeekID" fieldtype="column" ormtype="int";
	property name="nPoints" fieldtype="column" ormtype="double";
	property name="nWins" fieldtype="column" ormtype="int";
	property name="nLosses" fieldtype="column" ormtype="int";
	property name="nHighestTiebreak" fieldtype="column" ormtype="int";
	property name="nTiebreak2" fieldtype="column" ormtype="int";
	property name="nTiebreak3" fieldtype="column" ormtype="int";
	property name="nTiebreak4" fieldtype="column" ormtype="int";
	property name="nTiebreak5" fieldtype="column" ormtype="int";
	property name="nTiebreak6" fieldtype="column" ormtype="int";
	property name="nTiebreak7" fieldtype="column" ormtype="int";
	property name="nTiebreak8" fieldtype="column" ormtype="int";
	property name="nTiebreak9" fieldtype="column" ormtype="int";
	property name="nTiebreak10" fieldtype="column" ormtype="int";
	property name="nUserID" fieldtype="column" ormtype="int";
	property name="nPlace" fieldtype="column" ormtype="int";
	property name="bHasPicks" fieldtype="column" ormtype="int";
	property name="bAutoPick" fieldtype="column" ormtype="int";
	property name="sSeason" fieldtype="column" ormtype="string";
	property name="nSeasonID" fieldtype="column" ormtype="int";

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
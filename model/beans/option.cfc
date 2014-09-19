
component entityname="option" persistent="true" table="option" output="false" {
	property name="nOptionID" fieldtype="ID" generator="identity";
	property name="sShortName" fieldtype="column" ormtype="string" length="100";
	property name="bCanNotify" fieldtype="column" ormtype="int";
	/*
		sSchedule:
			"hourly,daily,weekly"
	*/
	property name="sSchedule" fieldtype="column" ormtype="string" length="2000";
	property name="sCodeKey" fieldtype="column" ormtype="string" length="100";
	property name="sLabel" fieldtype="column" ormtype="string" length="1000";
	/*
		nType:
			(1) checkbox
			(2) radio
			(3) selection

	*/
	property name="nType" fieldtype="column" ormtype="int";
	property name="sOptions" fieldtype="column" ormtype="string" length="4000";
	property name="nOrder" fieldtype="column" ormtype="int";
	
	/**
	* @output false
	*/
	public Numeric function getNOptionID(){
		if( not structKeyExists(variables, "nOptionID") ){
			variables.nOptionID = 0;
		}
		return variables.nOptionID;
	}
}
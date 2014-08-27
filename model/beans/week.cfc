
component entityname="week" persistent="true" table="week" output="false" {
	property name="nWeekID" fieldtype="ID" generator="identity";
	property name="sName" fieldtype="column" ormtype="string" length="2000";
	property name="dPicksDue" fiedtype="column" ormtype="string" length="19";
	property name="tPicksDue" fiedtype="column" ormtype="string" length="5";
	property name="dStartDate" fieldtype="column" ormtype="string" length="19";
	property name="dEndDate" fieldtype="column" ormtype="string" length="19";
	property name="lstSports" fieldtype="column" ormtype="string" length="100";
	property name="nBonus" fieldtype="column" ormtype="string" length="1" dbdefault="0";
	property name="sSeason" fieldtype="column" ormtype="string" length="50";

	/**
	* @output false
	*/
	public Numeric function getNWeekID(){
		if( not structKeyExists(variables, "nWeekID") ){
			variables.nWeekID = 0;
		}
		return variables.nWeekID ;
	}
}
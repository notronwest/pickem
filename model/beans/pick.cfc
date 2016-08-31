
component entityname="pick" persistent="true" table="pick" output="false" extends="model.baseORMBean" {
	property name="nPickID" fieldtype="ID" generator="identity";
	property name="nWeekID" fieldtype="column" ormtype="int";
	property name="nGameID" fieldtype="column" ormtype="int";
	property name="nTeamID" fieldtype="column" ormtype="int";
	property name="nUserID" fieldtype="column" ormtype="int";
	property name="bAuto" fieldtype="column" ormtype="int";
	property name="nWin" fieldtype="column" ormtype="string" length="1" dbdefault="0";
	/**
	* @output false
	*/
	public Numeric function getNPickID(){
		if( not structKeyExists(variables, "nPickID") ){
			variables.nPickID = 0;
		}
		return variables.nPickID;
	}
}
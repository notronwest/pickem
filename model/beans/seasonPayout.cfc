
component entityname="seasonPayout" persistent="true" table="seasonPayout" output="false" extends="model.baseORMBean" {
	property name="nSeasonPayoutID" fieldtype="ID" generator="identity";
	property name="nSeasonID" fieldtype="column" ormtype="int";
	property name="nPayoutID" fieldtype="column" ormtype="int";
	property name="nAmount" fieldtype="column" ormtype="int";
	
	/**
	* @output false
	*/
	public Numeric function getNSeasonPayoutID(){
		if( not structKeyExists(variables, "nSeasonPayoutID") ){
			variables.nSeasonPayoutID = 0;
		}
		return variables.nSeasonPayoutID;
	}
}
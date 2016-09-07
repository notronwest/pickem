component entityname="team" persistent="true" table="team" output="false" extends="model.baseORMBean" {
	property name="nTeamID" fieldtype="ID" generator="identity";
	property name="sName" fieldtype="column" ormtype="string" length="2000";
	property name="sName2" fieldtype="column" ormtype="string" length="2000";
	property name="sName3" fieldtype="column" ormtype="string" length="2000";
	property name="sName4" fieldtype="column" ormtype="string" length="2000";
	property name="sMascot" fieldtype="column" ormtype="string" length="2000";
	property name="sURL" fieldtype="column" ormtype="string" length="2000";
	property name="nDonBestID" fieldtype="column" ormtype="int";
	property name="nType" fieldtype="column" ormtype="int";

	/**
	* @output false
	*/
	public Numeric function getNTeamID(){
		if( not structKeyExists(variables, "nTeamID") ){
			variables.nTeamID = 0;
		}
		return variables.nTeamID;
	}
}
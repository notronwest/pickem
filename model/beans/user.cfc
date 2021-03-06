
component entityname="user" persistent="true" table="user" output="false" extends="model.baseORMBean" {
	property name="nUserID" fieldtype="ID" generator="identity";
	property name="sFirstName" fieldtype="column" ormtype="string" length="2000";
	property name="sLastName" fieldtype="column" ormtype="string" length="2000";
	property name="sEmail" fieldtype="column" ormtype="string" length="2000";
	property name="sUsername" fieldtype="column" ormtype="string" length="2000";
	property name="sPassword" fieldtype="column" ormtype="string" length="2000";
	property name="dLastLogin" fieldtype="column" ormtype="string" length="19";
	property name="bActive" fieldtype="column" ormtype="string" length="1" dbdefault="1";
	property name="bIsAdmin" fieldtype="column" ormtype="string" length="1" dbdefault="0";
	property name="bChangePassword" fieldtype="column" ormtype="string" length="1" dbdefault="0";
	property name="sNickname" fieldtype="column" ormtype="string" length="2000";
	/**
	* @output false
	*/
	public Numeric function getNUserID(){
		if( not structKeyExists(variables, "nUserID") ){
			variables.nUserID = 0;
		}
		return variables.nUserID;
	}

	public String function getFullName(){
		return variables.sFirstName & " " & variables.sLastName;
	}
}
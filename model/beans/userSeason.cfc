
component entityname="userSeason" persistent="true" table="userSeason" output="false" extends="model.baseORMBean" {
	property name="sUserSeasonID" type="string" fieldtype="ID" generator="assigned" length="32";
	property name="nSeasonID" fieldtype="column" ormtype="int";
	property name="nUserID" fieldtype="column" ormtype="int";
	property name="bActive" fieldtype="column" ormtype="int";

}
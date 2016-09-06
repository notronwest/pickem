
component entityname="league" persistent="true" table="league" output="false" extends="model.baseORMBean" {
	property name="sLeagueID" type="string" fieldtype="ID" generator="assigned" length="32";
	property name="sName" fieldtype="column" ormtype="string" length="2000";
	property name="sKey" fieldtype="column" ormtype="string" length="20";
	property name="bActive" fieldtype="column" ormtype="int";
}
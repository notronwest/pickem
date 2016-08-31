
component entityname="league" persistent="true" table="league" output="false" extends="model.baseORMBean" {
	property name="sLeagueID" type="string" fieldtype="ID" generator="assigned" length="32";
	property name="sName" fieldtype="column" ormtype="string" length="2000";
}

component entityname="setting" persistent="true" table="setting" output="false" {
	property name="nSettingID" fieldtype="ID" generator="identity";
	property name="nOptionID" fieldtype="column" ormtype="int";
	property name="nUserID" fieldtype="column" ormtype="int";
	property name="sValue" fieldtype="column" ormtype="string" length="1000";
}
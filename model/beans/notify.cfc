
component entityname="notify" persistent="true" table="notify" output="false" {
	property name="nNotifyID" fieldtype="ID" generator="identity";
	property name="nOptionID" fieldtype="column" ormtype="int";
	property name="sSubject" fieldtype="column" ormtype="string" length="1000";
	property name="sMessage" fieldtype="column" ormtype="string" length="4000";
	property name="sFrom" fieldtype="column" ormtype="string" length="1000";
	/**
	* @output false
	*/
}
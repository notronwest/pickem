
component entityname="season" persistent="true" table="season" output="false" {
	property name="nSeasonID" fieldtype="ID" generator="identity";
	property name="sName" fieldtype="column" ormtype="string" length="2000";
	property name="dtStart" fieldtype="column" ormtype="string" length="19";
	property name="dtEnd" fiedtype="column" ormtype="string" length="19";
}
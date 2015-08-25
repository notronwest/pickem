
component entityname="payout" persistent="true" table="payout" output="false" {
	property name="nPayoutID" fieldtype="ID" generator="identity";
	property name="sName" fieldtype="column" ormtype="string" length="255";
	property name="nDefaultPercent" fieldtype="column" ormtype="int";
	property name="sType" fieldtype="column" ormtype="string" length="100";
	property name="nPlace" fieldtype="column" ormtype="int";
}
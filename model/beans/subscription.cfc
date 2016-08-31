
component entityname="subscription" persistent="true" table="subscription" output="false" extends="model.baseORMBean" {
	property name="nSubscriptionID" fieldtype="ID" generator="identity";
	property name="nUserID" fieldtype="column" ormtype="int";
	property name="nSeasonID" fieldtype="column" ormtype="int";
	property name="nAmount" fieldtype="column" ormtype="int";
	property name="dtPaid" fieldtype="column" ormtype="string" length="19";
	property name="sPaymentType" fieldtype="column" ormtype="string" length="255";
	/**
	* @output false
	*/
	public Numeric function getNSubscriptionID(){
		if( not structKeyExists(variables, "nSubscriptionID") ){
			variables.nSubscriptionID = 0;
		}
		return variables.nSubscriptionID;
	}
}
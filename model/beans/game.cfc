
component entityname="game" persistent="true" table="game" output="false" {
	property name="nGameID" fieldtype="ID" generator="identity";
	property name="nWeekID" fieldtype="column" ormtype="int";
	property name="nHomeTeamID" fieldtype="column" ormtype="int";
	property name="nAwayTeamID" fieldtype="column" ormtype="int";
	property name="nHomeTeamRanking" fieldtype="column" ormtype="int";
	property name="nAwayTeamRanking" fieldtype="column" ormtype="int";
	property name="sHomeTeamRecord" fieldtype="column" ormtype="string" length="10";
	property name="sAwayTeamRecord" fieldtype="column" ormtype="string" length="10";
	property name="sSpreadOriginal" fieldtype="column" ormtype="string" length="5";
	property name="nSpread" fieldtype="column" ormtype="double";
	property name="sSpreadFavor" fieldtype="column" ormtype="string" length="10";
	property name="nHomeScore" fieldtype="column" ormtype="int";
	property name="nAwayScore" fieldtype="column" ormtype="int";
	property name="nTiebreak" fieldtype="column" ormtype="string" length="2" dbDefault="0";
	property name="sGameDateTime" fieldtype="column" ormtype="String" length="19";
	property name="dtLock" fieldtype="column" ormtype="String" length="19";
	property name="nWinner" fieldtype="column" ormtype="int" length="1";
	property name="nOrder" fieldtype="column" ormtype="int" length="1";
	property name="bGameIsFinal" fieldtype="column" ormtype="int" length="1" dbDefault="0";
	property name="sGameStatus" fieldtype="column" ormtype="String" length="100";
	/**
	* @output false
	*/
	public Numeric function getNGameID(){
		if( not structKeyExists(variables, "nGameID") ){
			variables.nGameID = 0;
		}
		return variables.nGameID;
	}
}
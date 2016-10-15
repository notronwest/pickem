component accessors="true" extends="model.services.baseService" {

property name="optionGateway";

/*
Author: 	
	Ron West
Name:
	$buildOptions
Summary:
	Builds all of the necessary options
Returns:
	Void
Arguments:
	Void
History:
	2014-09-18 - RLW - Created
*/
public void function buildOptions(){
	var itm = 1;
	var arOption = [];
	/*
		nType:
			(1) checkbox
			(2) radio
			(3) selection

	*/
	var arOptions = [{
			"bCanNotify" = 1,
			"sSchedule" = "weekly",
			"sCodeKey" = "beforeNoPicks",
			"sShortName" = "Before games - No Picks",
			"sLabel" = "Remind me to make my picks prior to the start of the first game if I haven't set my picks",
			"nType" = 1,
			"sOptions" = "",
			"nOrder" = 1,
			"sLeagueID" = "C898E8A7BF7D0F9875845AF3AD01A0FE"
		},{ 
			"bCanNotify" = 1,
			"sSchedule" = "weekly",
			"sShortName" = "Always before games",
			"sCodeKey" = "alwaysBeforeGames",
			"sLabel" = "Always remind me to review my picks prior to the start of the first game",
			"nType" = 1,
			"sOptions" = "",
			"nOrder" = 2,
			"sLeagueID" = "C898E8A7BF7D0F9875845AF3AD01A0FE"
		},{
			"bCanNotify" = 1,
			"sShortName" = "Games Available",
			"sLabel" = "Notify me when games become available",
			"nType" = 1,
			"sCodeKey" = "gamesAvailable",
			"sOptions" = "",
			"nOrder" = 3,
			"sLeagueID" = "C898E8A7BF7D0F9875845AF3AD01A0FE"
		},{
			"bCanNotify" = 0,
			"sShortName" = "Notify by",
			"sLabel" = "Notify me by:",
			"nType" = 3,
			"sCodeKey" = "notificationType",
			"sOptions" = '{ "options" : [{ "sValue" : "e-mail", "sOption" : "E-mail" }] }',
			"nOrder" = 4,
			"sLeagueID" = "C898E8A7BF7D0F9875845AF3AD01A0FE"
		},{
			"bCanNotify" = 0,
			"sShortName" = "Timezone",
			"sLabel" = "Timezone:",
			"nType" = 3,
			"sCodeKey" = "timezone",
			"sOptions" = '{ "options" : [ { "sValue" : "Pacific", "sOption" : "Pacific" }, { "sValue" : "Eastern", "sOption" : "Eastern" }] }',
			"nOrder" = 5,
			"sLeagueID" = "C898E8A7BF7D0F9875845AF3AD01A0FE"
		},{
			"bCanNotify" = 0,
			"sShortName" = "Autopick",
			"sLabel" = "Autopick:",
			"nType" = 3,
			"sCodeKey" = "autopick",
			"sOptions" = '{ "options" : [ { "sValue" : "None", "sOption" : "None" }, { "sValue" : "Favorite", "sOption" : "Pick all favorites" }, { "sValue" : "Underdog", "sOption" : "Pick all underdogs" }, { "sValue" : "Home", "sOption" : "Pick all home teams" }, { "sValue" : "Away", "sOption" : "Pick all away teams" }, { "sValue" : "Random", "sOption" : "Pick random" } ] }',
			"nOrder" = 6,
			"sLeagueID" = "C898E8A7BF7D0F9875845AF3AD01A0FE"
		},
		{
			"bCanNotify" = 1,
			"sSchedule" = "weekly",
			"sCodeKey" = "beforeNoPicks",
			"sShortName" = "Before games - No Picks",
			"sLabel" = "Remind me to make my picks prior to the start of the first game if I haven't set my picks",
			"nType" = 1,
			"sOptions" = "",
			"nOrder" = 7,
			"sLeagueID" = "C89C3370A58C1E6B62588C46C647CFC6"
		},{ 
			"bCanNotify" = 1,
			"sSchedule" = "weekly",
			"sShortName" = "Always before games",
			"sCodeKey" = "alwaysBeforeGames",
			"sLabel" = "Always remind me to review my picks prior to the start of the first game",
			"nType" = 1,
			"sOptions" = "",
			"nOrder" = 8,
			"sLeagueID" = "C89C3370A58C1E6B62588C46C647CFC6"
		},{
			"bCanNotify" = 1,
			"sShortName" = "Games Available",
			"sLabel" = "Notify me when games become available",
			"nType" = 1,
			"sCodeKey" = "gamesAvailable",
			"sOptions" = "",
			"nOrder" = 9,
			"sLeagueID" = "C89C3370A58C1E6B62588C46C647CFC6"
		},{
			"bCanNotify" = 0,
			"sShortName" = "Notify by",
			"sLabel" = "Notify me by:",
			"nType" = 3,
			"sCodeKey" = "notificationType",
			"sOptions" = '{ "options" : [{ "sValue" : "e-mail", "sOption" : "E-mail" }] }',
			"nOrder" = 10,
			"sLeagueID" = "C89C3370A58C1E6B62588C46C647CFC6"
		},{
			"bCanNotify" = 0,
			"sShortName" = "Timezone",
			"sLabel" = "Timezone:",
			"nType" = 3,
			"sCodeKey" = "timezone",
			"sOptions" = '{ "options" : [ { "sValue" : "Pacific", "sOption" : "Pacific" }, { "sValue" : "Eastern", "sOption" : "Eastern" }] }',
			"nOrder" = 11,
			"sLeagueID" = "C89C3370A58C1E6B62588C46C647CFC6"
		},{
			"bCanNotify" = 0,
			"sShortName" = "Autopick",
			"sLabel" = "Autopick:",
			"nType" = 3,
			"sCodeKey" = "autopick",
			"sOptions" = '{ "options" : [ { "sValue" : "None", "sOption" : "None" }, { "sValue" : "mondaydog", "sOption" : "Monday Night Dog" } ] }',
			"nOrder" = 12,
			"sLeagueID" = "C89C3370A58C1E6B62588C46C647CFC6"
		},
		{
			"bCanNotify" = 1,
			"sSchedule" = "weekly",
			"sCodeKey" = "beforeNoPicks",
			"sShortName" = "Before games - No Picks",
			"sLabel" = "Remind me to make my picks prior to the start of the first game if I haven't set my picks",
			"nType" = 1,
			"sOptions" = "",
			"nOrder" = 7,
			"sLeagueID" = "C89DE23DE0BE12F927789325F2AB9672"
		},{ 
			"bCanNotify" = 1,
			"sSchedule" = "weekly",
			"sShortName" = "Always before games",
			"sCodeKey" = "alwaysBeforeGames",
			"sLabel" = "Always remind me to review my picks prior to the start of the first game",
			"nType" = 1,
			"sOptions" = "",
			"nOrder" = 8,
			"sLeagueID" = "C89DE23DE0BE12F927789325F2AB9672"
		},{
			"bCanNotify" = 1,
			"sShortName" = "Games Available",
			"sLabel" = "Notify me when games become available",
			"nType" = 1,
			"sCodeKey" = "gamesAvailable",
			"sOptions" = "",
			"nOrder" = 9,
			"sLeagueID" = "C89DE23DE0BE12F927789325F2AB9672"
		},{
			"bCanNotify" = 0,
			"sShortName" = "Notify by",
			"sLabel" = "Notify me by:",
			"nType" = 3,
			"sCodeKey" = "notificationType",
			"sOptions" = '{ "options" : [{ "sValue" : "e-mail", "sOption" : "E-mail" }] }',
			"nOrder" = 10,
			"sLeagueID" = "C89DE23DE0BE12F927789325F2AB9672"
		},{
			"bCanNotify" = 0,
			"sShortName" = "Timezone",
			"sLabel" = "Timezone:",
			"nType" = 3,
			"sCodeKey" = "timezone",
			"sOptions" = '{ "options" : [ { "sValue" : "Pacific", "sOption" : "Pacific" }, { "sValue" : "Eastern", "sOption" : "Eastern" }] }',
			"nOrder" = 11,
			"sLeagueID" = "C89DE23DE0BE12F927789325F2AB9672"
		}
	];
	// loop through the options and add them if they don't exist
	for( itm; itm lte arrayLen(arOptions); itm++ ){
		// check to see if this option exists
		arOption = variables.optionGateway.getByLabel(arOptions[itm].sLabel, arOptions[itm].sLeagueID);
		// add this option
		if( arrayLen(arOption) eq 0 ){
			variables.optionGateway.update(variables.optionGateway.get(), arOptions[itm]);
		} else { // update this option
			variables.optionGateway.update(arOption[1], arOptions[itm]);
		}
	}
}

/*
Author: 	
	Ron West
Name:
	$getOptions
Summary:
	Builds a simple structure of options
Returns:
	Struct stOptions
Arguments:
	String sLeagueID
History:
	2014-09-19 - RLW - Created
	2016-10-12 - RLW - Added support for league
*/
public Struct function getOptions(Required String sLeagueID){
	var arOptions = variables.optionGateway.getAll(arguments.sLeagueID);
	var stOptions = {};
	var itm = 1;
	for(itm; itm lte arrayLen(arOptions); itm++){
		structInsert(stOptions, arOptions[itm].getNOptionID(),
		{
			"sShortName" = arOptions[itm].getSShortName(),
			"sLabel" = arOptions[itm].getSLabel(),
			"sOptions" = arOptions[itm].getSOptions(),
			"bCanNotify" = arOptions[itm].getBCanNotify(),
			"nType" = arOptions[itm].getNType(),
			"nOrder" = arOptions[itm].getNOrder()
		});
	}
	return stOptions;
}

}
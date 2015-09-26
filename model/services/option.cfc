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
			"nOrder" = 1
		},{ 
			"bCanNotify" = 1,
			"sSchedule" = "weekly",
			"sShortName" = "Always before games",
			"sCodeKey" = "alwaysBeforeGames",
			"sLabel" = "Always remind me to review my picks prior to the start of the first game",
			"nType" = 1,
			"sOptions" = "",
			"nOrder" = 2
		},{
			"bCanNotify" = 0,
			"sShortName" = "Notify by",
			"sLabel" = "Notify me by:",
			"nType" = 3,
			"sCodeKey" = "notificationType",
			"sOptions" = '{ "options" : [{ "sValue" : "e-mail", "sOption" : "E-mail" }] }',
			"nOrder" = 3
		},{
			"bCanNotify" = 0,
			"sShortName" = "Timezone",
			"sLabel" = "Timezone:",
			"nType" = 3,
			"sCodeKey" = "timezone",
			"sOptions" = '{ "options" : [ { "sValue" : "Pacific", "sOption" : "Pacific" }, { "sValue" : "Eastern", "sOption" : "Eastern" }] }',
			"nOrder" = 4
		},{
			"bCanNotify" = 0,
			"sShortName" = "Autopick",
			"sLabel" = "Autopick:",
			"nType" = 3,
			"sCodeKey" = "autopick",
			"sOptions" = '{ "options" : [ { "sValue" : "None", "sOption" : "None" }, { "sValue" : "Favorites", "sOption" : "Pick all favorites" }, { "sValue" : "Underdogs", "sOption" : "Pick all underdogs" }, { "sValue" : "Random", "sOption" : "Pick random" } ] }',
			"nOrder" = 5
		}
	];
	// loop through the options and add them if they don't exist
	for( itm; itm lte arrayLen(arOptions); itm++ ){
		// check to see if this option exists
		arOption = variables.optionGateway.getByLabel(arOptions[itm].sLabel);
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
	Void
History:
	2014-09-19 - RLW - Created
*/
public Struct function getOptions(){
	var arOptions = variables.optionGateway.getAll();
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
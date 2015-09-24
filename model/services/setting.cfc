component accessors="true" extends="model.services.baseService" {

property name="settingGateway";
property name="optionGateway";

/*
Author: 	
	Ron West
Name:
	$userSettings
Summary:
	Creates an easy structure of settings for this user
Returns:
	Struct stSettings
Arguments:
	Numeric nUserID
History:
	2014-09-18 - RLW - Created
*/
public Struct function userSettings( Required Numeric nUserID ){
	var arOptions = [];
	var arOSettings = [];
	var itm = 1;
	var stSettings = {};
	try{
		arOptions = variables.optionGateway.getAll();
		arOSettings = variables.settingGateway.getByUser(arguments.nUserID);
		// build default structure of settings from the options
		for(itm; itm lte arrayLen(arOptions); itm++){
			structInsert(stSettings, arOptions[itm].getNOptionID(), "");
		}
		// loop through user settings and update settings
		for(itm=1; itm lte arrayLen(arOSettings); itm++){
			if( structKeyExists(stSettings, arOSettings[itm].getNOptionID()) ){
				stSettings[arOSettings[itm].getNOptionID()] = arOSettings[itm].getSValue();
			}
		}
	} catch (any e){
		registerError("Error trying to get settings for user: #arguments.nUserID#", e);
	}
	return stSettings;
}

/*
Author: 	
	Ron West
Name:
	$readableUserSettings
Summary:
	Creates an easy to read structure of settings for this user
Returns:
	Struct stSettings
Arguments:
	Numeric nUserID
History:
	2015-09-23 - RLW - Created
*/
public Struct function readableUserSettings( Required Numeric nUserID ){
	var arOptions = [];
	var arOSettings = [];
	var itm = 1;
	var stSettings = {};
	try{
		// get this users settings
		arOSettings = variables.settingGateway.getByUser(arguments.nUserID);

		// loop through user settings and update settings
		for(itm=1; itm lte arrayLen(arOSettings); itm++){
			// get the details for this setting
			oOption = variables.optionGateway.get(arOSettings[itm].getNOptionID());
			// store this option in the settings
			stSettings[oOption.getSCodeKey()] = arOSettings[itm].getSValue();
		}
	} catch (any e){
		registerError("Error trying to get settings for user: #arguments.nUserID#", e);
	}
	return stSettings;
}

/*
Author: 	
	Ron West
Name:
	$saveUserSettings
Summary:
	Loops through the form structure and saves the users options
Returns:
	Void
Arguments:
	Struct stForm
	Numeric nUserID
History:
	2014-09-18 - RLW - Created
*/
public void function saveUserSettings( Required Struct stForm, Required Numeric nUserID ){
	// get the current settings for this user
	var stSettings = userSettings(arguments.nUserID);
	var nOptionID = 1;
	var oSetting = "";
	var oOption = "";
	try{
		for( nOptionID in stSettings ){
			// get this users settings for this option
			oSetting = variables.settingGateway.getUserSetting(arguments.nUserID, nOptionID);
			oOption = variables.optionGateway.get(nOptionID);
			// update the value if it exists in the form struct and we have a different value
			if( structKeyExists(arguments.stForm, nOptionID) ){
				// update the value
				oSetting.setSValue(arguments.stForm[nOptionID]);
			} else if( oOption.getNType() eq 1){
				// if we have a checkbox then we need to clear the value
				oSetting.setSValue("");
			}
			// if this is a new setting set the correct values
			if( isNull(oSetting.getNOptionID()) ){
				oSetting.setNOptionID(nOptionID);
				oSetting.setNUserID(arguments.nUserID);
			}
			variables.settingGateway.save(oSetting);
			// update the session variable
			session.stSettings = readableUserSettings(arguments.nUserID);
		}
	} catch (any e){
		registerError("Error trying to save user settings for: #arguments.nUserID#", e);
	}
}

/*
Author: 	
	Ron West
Name:
	$getUsersNotificationSetting
Summary:
	Returns the notification settings for this user
Returns:
	String sNotificationSetting
Arguments:
	Numeric nUserID
History:
	2014-09-19 - RLW - Created
*/
public String function getUsersNotificationSetting( Required Numeric nUserID ){
	var arOption = variables.optionGateway.getByCodeKey("notificationType");
	var stSettings = {};
	var sNotificationSetting = "";
	var itm = 1;
	try{
		if( arrayLen(arOption) gt 0 ){
			stSettings = userSettings(arguments.nUserID);
			if( structKeyExists(stSettings, arOption[1].getNOptionID()) ){
				sNotificationSetting = stSettings[arOption[1].getNOptionID()];
			}
		}
	} catch (any e){
		registerError("Error trying to get notification setting for user: #arguments.nUserID#", e);
	}
	return sNotificationSetting;
}

}
component accessors="true" extends="model.services.baseService" {

property name="settingGateway";
property name="optionGateway";
property name="notifyGateway";
property name="userGateway";
property name="pickService";
property name="settingService";
property name="userService";
property name="seasonGateway";

/*
Author: 	
	Ron West
Name:
	$notificationsBySchedule
Summary:
	Runs the notifications based on schedule
Returns:
	Array arNotifications
Arguments:
	Week oWeek
	Boolean bForceNotification
	Numeric nSeasonID
History:
	2014-09-19 - RLW - Created
	2016-09-21 - RLW - Added seasonID to track notifications for different leagues
*/
public Array function notificationsBySchedule( Required model.beans.week oWeek, Required Numeric nSeasonID, Boolean bForceNotification = false ){
	var oSeason = variables.seasonGateway.get(arguments.nSeasonID);
	// get all options that have notificaiton ability
	var arNotifyOptions = variables.optionGateway.getAllForNotification(oSeason.getSLeagueID());
	var itm = 1;
	var dtPicksDue = "";
	var arCompletedNotifications = [];
	try{
		// handle each of the notificaiton types
		for(itm; itm lte arrayLen(arNotifyOptions); itm++ ){
			switch( arNotifyOptions[itm].getSSchedule() ){
				// hourly
				case "hourly":
					// to do
					break;

				case "daily":
					// to do
					break;

				case "weekly":
					dtPicksDue = arguments.oWeek.getDPicksDue() & " " & arguments.oWeek.getTPicksDue();
					// make sure we are a few hours from the start of the weeks games
					if( ( dtPicksDue lte variables.dbService.dbDateTimeFormat(dateAdd("h", 12, now())) and dtPicksDue gte variables.dbService.dbDateTimeFormat(dateAdd("h", 11, now())) ) or arguments.bForceNotification ){
						// handle processing for this notification type
						arrayAppend(arCompletedNotifications, processNotification(arNotifyOptions[itm], arguments.oWeek, arguments.nSeasonID));
					}
			}
		}
	} catch (any e){
		registerError("Error trying to run the scheduled notifications", e);
	}
	return arCompletedNotifications;
}

/*
Author: 	
	Ron West
Name:
	$processNotification
Summary:
	Handles what to do with this notification
Returns:
	Option oOption
Arguments:
	Option oOption
	Week oWeek
	Numeric nSeasonID
History:
	2014-09-19 - RLW - Created
*/
public model.beans.option function processNotification( Required model.beans.option oOption, Required model.beans.week oWeek, Required Numeric nSeasonID ){
	// get all of the users with this setting
	var arUserNotifications = variables.settingGateway.getUsersByOption(arguments.oOption.getNOptionID(), arguments.nSeasonID);
	// get the notification details for this option
	var oNotification = variables.notifyGateway.getByOption(arguments.oOption.getNOptionID())[1];
	var oSeason = variables.seasonGateway.get(arguments.nSeasonID);
	var itm = 1;
	var oUser = "";
	var stPicks = {};
	var oUser = "";
	var nUserID = "";
	try{
		// determine what to do based on the hard coded key
		switch(arguments.oOption.getSCodeKey()){
			// handle users without picks
			case "beforeNoPicks":
				// loop through each user
				for( itm; itm lte arrayLen(arUserNotifications); itm++ ){
					nUserID = arUserNotifications[itm].getNUserID();
					// check to see if they have picks
					if( !variables.pickService.userHasPicks(arguments.oWeek.getNWeekID(), nUserID) ){
						// get this users info
						oUser = variables.userGateway.get(nUserID);
						doNotification(oNotification, oUser, oSeason.getSLeagueID());
					}
				}
			break;
			// handle everyone that wants a notification anyways
			case "alwaysBeforeGames":
			case "gamesAvailable":
				// loop through each user
				for( itm; itm lte arrayLen(arUserNotifications); itm++ ){
					nUserID = arUserNotifications[itm].getNUserID();
					// get this users info
					oUser = variables.userGateway.get(nUserID);	
					// doNotification
					doNotification(oNotification, oUser, oSeason.getSLeagueID());
				}
			break;
		}
	} catch (any e){
		registerError("Error trying to process a notification", e);
	}
	return arguments.oOption;
}

/*
Author: 	
	Ron West
Name:
	$doNotification
Summary:
	Sends out the notifications
Returns:
	void
Arguments:
	Option oOption
	User oUser
History:
	2014-09-19 - RLW - Created
	2016-10-12 - RLW - Updated to support leagues
*/
public void function doNotification( Required model.beans.notify oNotify, Required model.beans.user oUser, Required String sLeagueID){
	try{
		// determine what type of notification we are doing
		switch(variables.settingService.getUsersNotificationSetting(arguments.oUser.getNUserID(), arguments.sLeagueID)){
			case "e-mail":
				// send out notification
				variables.commonService.sendEmail(
					arguments.oUser.getSEmail(),
					arguments.oNotify.getSSubject(),
					variables.userService.applyEmailMask(arguments.oNotify.getSMessage(), arguments.oUser.getSEmail()),
					arguments.oNotify.getSFrom()
				);
				// log this for now
				registerError("Emailing - #arguments.oUser.getSEmail()# with notification - #arguments.oNotify.getSSubject()#");
			break;
			// add additional notification types here
		}
	} catch (any e){
		registerError("Error trying to send notification", e);
	}
}
}
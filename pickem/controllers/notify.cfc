component accessors="true" extends="model.baseController" {

property name="userGateway";
property name="userService";
property name="settingService";
property name="optionService";
property name="framework";
property name="notifyGateway";
property name="weekGateway";
property name="notifyService";

public void function before (rc){
	param name="rc.nWeekID" default="0";
	param name="rc.nNotifyID" default="0";
	// get notification
	rc.oNotification = variables.notifyGateway.get(rc.nNotifyID);
	// get details for the week
	rc.oWeek = variables.weekGateway.get(rc.nWeekID);
	// if we have a zero week get the current week
	if( rc.oWeek.getNWeekID(rc.nCurrentSeasonID) eq 0 ){
		arWeek = variables.weekGateway.getByDate(nSeasonID=rc.nCurrentSeasonID);
		if( arrayLen(arWeek) gt 0 ){
			rc.oWeek = arWeek[1];
			// reset weekID so other functions can use it
			rc.nWeekID = rc.oWeek.getNWeekID();
		}
	}
	rc.bIsAdminAction = true;
}

public void function save (rc){
	rc.oNotification = variables.notifyGateway.update((isNull(rc.oNotification.getNNotifyID())) ? variables.notifyGateway.get() : rc.oNotification, {
		sSubject = rc.sSubject,
		nOptionID = rc.nOptionID,
		sFrom = rc.sFrom,
		sMessage = rc.sMessage
	});
	variables.framework.setView('notify.listing');
}

public void function after (rc){
	// get available options
	rc.stOptions = variables.optionService.getOptions();
	// get available notifications
	rc.arNotifications = variables.notifyGateway.getAll();
}

public void function delete (rc){
	variables.notifyGateway.delete(rc.oNotification);
	variables.framework.setView('notify.listing');
}

public void function notificationsBySchedule(rc){
 	param name="rc.bForceNotification" default="false";
	rc.arNotificationsRun = variables.notifyService.notificationsBySchedule(rc.oWeek, rc.bForceNotification);
}

}
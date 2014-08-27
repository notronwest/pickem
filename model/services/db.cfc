component accessors="true" extends="model.services.baseService" {
/*
Author: 	
	Ron West
Name:
	$dbDateTimeFormat
Summary:
	Returns a date formatted for db searching
Returns:
	String dtFormatted
Arguments:
	String dtDate
	String dtTime
History:
	2013-05-12 - RLW - Created
*/
public String function dbDateTimeFormat( String dtDate = now() ){
	return dateFormat(arguments.dtDate, "yyyy-mm-dd") & " " & timeFormat(arguments.dtDate, "HH:mm:ss");
}

/*
Author: 	
	Ron West
Name:
	$dbDateFormat
Summary:
	Returns a date formatted for db searching
Returns:
	String dtFormatted
Arguments:
	String dtDate
	String dtTime
History:
	2013-05-12 - RLW - Created
*/
public String function dbDateFormat( String dtDate =  now() ){
	return dateFormat(arguments.dtDate, "yyyy-mm-dd");
}

/*
Author: 	
	Ron West
Name:
	$dbDayBegin
Summary:
	Returns the date/time for the beginning of a day
Returns:
	String dtFormatted
Arguments:
	String dtDate
History:
	2013-05-12 - RLW - Created
*/
public String function dbDayBegin( String dtDate =  now() ){
	return dbDateFormat(createDateTime(year(arguments.dtDate), month(arguments.dtDate), day(arguments.dtDate), "00", "00", "00" ));
}

/*
Author: 	
	Ron West
Name:
	$dbDayEnd
Summary:
	Returns the date/time for the end of a day
Returns:
	String dtFormatted
Arguments:
	String dtDate
History:
	2013-05-12 - RLW - Created
*/
public String function dbDayEnd( String dtDate = now() ){
	return dbDateFormat(createDateTime(year(arguments.dtDate), month(arguments.dtDate), day(arguments.dtDate), "23", "59", "59" ));
}

}
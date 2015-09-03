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

/*
Author: 	
	Ron West
Name:
	$runQuery
Summary:
	Runs the specified query
Returns:
	Query qryResults
Arguments:
	String sSQL
History:
	2014-09-10 - RLW - Created
*/
public Query function runQuery( Required String sSQL ){
	var oQueryService = new query();
	var oQueryResults = "";
	var qryResults = queryNew("");
	try{
		oQueryService.setDatasource(request.dsn);
		oQueryService.setName("qryResult");
		oQueryResults = oQueryService.execute(sql=arguments.sSQL);
		qryResults = oQueryResults.getResult();
		// if there are no results
		if( isNull(qryResults) ){
			qryResults = queryNew("");
		}
	} catch (any e){
		registerError("Error running query: #arguments.sSQL#", e);
	}
	return qryResults;
}

/*
Author: 	
	Ron West
Name:
	$runStoredProc
Summary:
	Runs a stored procedure
Returns:
	Query qryResults
Arguments:
	String sStoredProc
	Array arParams
History:
	2014-09-13 - RLW - Created
*/
public void function runStoredProc( Required String sStoredProc, Array arParams = [] ){
	request.sStoredProc = arguments.sStoredProc;
	request.arParams = arguments.arParams;
	try{
		include "storedProc.cfm";
	} catch(any e){
		registerError("Error running stored procedure: #arguments.sStoredProc#", e);
	}
}

/*
Author: 	
	Ron West
Name:
	$backupDB
Summary:
	Backups a database
Returns:
	Void
Arguments:
	String sDB
	String sUsername
	String sPassword
History:
	2015-09-02 - RLW - Created
*/
public void function backupDB( String sDB = "pickem", String sUsername = request.sDBUsername, String sPassword = request.sDBPassword){
	request.sArguments = "-u #arguments.sUsername# -p#arguments.sPassword# #arguments.sDB#";
	request.sExecute = "mysqldump";
	request.sOutputFile = "#request.sDBBackupDirectory##arguments.sDB#.sql";
	include "cfexecute.cfm";
}

}
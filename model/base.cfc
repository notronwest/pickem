component accessors="true" {
	property name="commonService";
	property name="framework";
	property name="dbService";

	public void function registerError( Required String sMessage, stCFCatch = {} ){
	var sLogFile = "#expandPath(request.sLogURL)##dateFormat(now(), 'yyyymmdd')#.errors.log";
	var dTimeStamp = dateFormat(now(), "yyyy-mm-dd") & " " & timeFormat(now(), "hh:mm:ss");
	var sLogEntry = "";
	savecontent variable="sLogEntry" { writeOutput("
-----------------
Entry Date/Time: #dTimeStamp#
    Comment: #arguments.sMessage#
	");}
	if(structKeyExists(arguments.stCFCatch, "stackTrace")){
		savecontent variable="sLogEntry" { writeOutput("#sLogEntry#
Stack Trace: 
#stCFCatch.stackTrace#
		");}
	}
	if( not fileExists(sLogFile)){
		fileWrite(sLogFile, sLogEntry);
	} else {
		// open an instance of the log file
		oLogFile = fileOpen(sLogFile, "append");
		// append the new message
		fileWriteLine(oLogFile, sLogEntry);
		// close the file
		fileClose(oLogFile);
	}
}
}
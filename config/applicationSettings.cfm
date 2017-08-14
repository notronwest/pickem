<cfscript>
	this.name="pickem";
	this.sessionmanagement = true;
	this.sessiontimeout = createTimeSpan(1,0,0,0);
	this.dsn = "inqsports";
	// if we have datasources to define
	if( listLen(structKeyList(request.datasources)) ){
		this.datasources = request.datasources;
	}
</cfscript>

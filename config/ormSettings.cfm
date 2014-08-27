<cfscript>
	arORM = ['model/beans'];
	this.ormenabled = true;
	this.ormsettings = {
		datasource = this.dsn,
		dbcreate = "update",
		dialect = 'MySQL',	
		logSQL = true,
		skipCFCWithError = false,
		useDBForMapping = true
		//cfcLocation = arOrm
	};
</cfscript>
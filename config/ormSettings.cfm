<cfscript>
	arORM = ['model/beans'];
	this.ormenabled = true;
	this.ormsettings = {
		datasource = this.dsn,
		dbcreate = "update",
		dialect = 'MySQL',
		logSQL = (request.bIsDevelopment) ? true : false,
		skipCFCWithError = false,
		useDBForMapping = true,
		showSQL = "true",
		cfcLocation = ["model/beans"]
	};
</cfscript>

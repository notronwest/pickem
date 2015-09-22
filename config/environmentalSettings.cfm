<cfscript>
	// global request variables
	request.stJenkinsAPIKeys = {
		"sBackupWeekly" = "rRAMrXXWrEPkA2d3NXVwX"
	};
	request.sJenkinsAuthToken = "bafc2176c03237ccc32b8c85c6e64016";
	// specific variables
	switch (cgi.http_host){

		// development
		case "pickem.local":
			request.sLogURL = "/data/logs/";
			request.bReloadOnEveryRequest = true;
			request.sAdminEmail = "ron@inquisibee.com";
			request.bIsDevelopment = true;
			request.sSiteURL = 'http://pickem.local/';
			request.dsn = "pickem";
			request.sLocalIP = "127.0.0.1";
			request.sAPIKey="AP9aCMwPrkAfsbWsDtVtHEUTqBnsGkZTKAJU6ZAG,U";
			request.sDBBackupDirectory = "#expandPath('/data/weeklydbbackup/')#";
			request.sDBUsername = "notronwest";
			request.sDBPassword = "atp3ace!";
			break;
		// development
		case "dev.pickem.inquisibee.com":
			request.sLogURL = "/data/logs/";
			request.bReloadOnEveryRequest = false;
			request.sAdminEmail = "ron@inquisibee.com";
			request.bIsDevelopment = false;
			request.sSiteURL = 'http://dev.pickem.inquisibee.com/';
			request.dsn = "dev.pickem";
			request.sLocalIP = "54.68.81.199";
			request.sAPIKey="AP9aCMwPrkAfsbWsDtVtHEUTqBnsGkZTKAJU6ZAG,U";
			request.sDBBackupDirectory = "#expandPath('/data/weeklydbbackup/')#";
			request.sDBUsername = "notronwest";
			request.sDBPassword = "1nquisib33";
			break;
		// production
		case "pickem.inquisibee.com":
		case "pickem.inquisibee.com:80":
		case "www.pickem.inquisibee.com":
			request.sLogURL = "/data/logs/";
			request.bReloadOnEveryRequest = false;
			//request.sAdminEmail = "footballpicksaaa@gmail.com";
			request.sAdminEmail = "pickem@inquisibee.com";
			request.bIsDevelopment = false;
			request.sSiteURL = 'http://pickem.inquisibee.com/';
			request.dsn = "pickem";
			request.sLocalIP = "54.68.81.199";
			request.sAPIKey="AP9aCMwPrkAfsbWsDtVtHEUTqBnsGkZTKAJU6ZAG,U";
			request.sDBBackupDirectory = "#expandPath('/data/weeklydbbackup/')#";
			request.sDBUsername = "notronwest";
			request.sDBPassword = "1nquisib33";
			break;
			
	}
</cfscript>
<cfscript>
	// global request variables
	request.stJenkinsAPIKeys = {
		"sBackupWeekly" = "rRAMrXXWrEPkA2d3NXVwX"
	};
	request.sJenkinsAuthToken = "bafc2176c03237ccc32b8c85c6e64016";
	request.sLeagueKey = "pickem";
	// specific variables
	switch (cgi.http_host){

		// development
		case "pickem.local":
			request.sLogURL = "/data/logs/";
			request.bReloadOnEveryRequest = true;
			request.sAdminEmail = "ron@inquisibee.com";
			request.bIsDevelopment = true;
			request.bIsStaging = false;
			request.sSiteURL = 'http://pickem.local/';
			request.dsn = "inqsports";
			request.sLocalIP = "127.0.0.1";
			request.sAPIKey="AP9aCMwPrkAfsbWsDtVtHEUTqBnsGkZTKAJU6ZAG,U";
			request.sDBBackupDirectory = "#expandPath('/data/weeklydbbackup/')#";
			request.sDBUsername = "notronwest";
			request.sDBPassword = "atp3ace!";
			break;
		// development
		case "underdog.local":
			request.sLogURL = "/data/logs/";
			request.bReloadOnEveryRequest = true;
			request.sAdminEmail = "ron@inquisibee.com";
			request.bIsDevelopment = true;
			request.bIsStaging = false;
			request.sSiteURL = 'http://pickem.local/';
			request.dsn = "inqsports";
			request.sLocalIP = "127.0.0.1";
			request.sAPIKey="AP9aCMwPrkAfsbWsDtVtHEUTqBnsGkZTKAJU6ZAG,U";
			request.sDBBackupDirectory = "#expandPath('/data/weeklydbbackup/')#";
			request.sDBUsername = "notronwest";
			request.sDBPassword = "atp3ace!";
			request.sLeagueKey = "NFLUnderdog";
			break;
		// development
		case "nflperfect.local":
			request.sLogURL = "/data/logs/";
			request.bReloadOnEveryRequest = true;
			request.sAdminEmail = "ron@inquisibee.com";
			request.bIsDevelopment = true;
			request.bIsStaging = false;
			request.sSiteURL = 'http://pickem.local/';
			request.dsn = "inqsports";
			request.sLocalIP = "127.0.0.1";
			request.sAPIKey="AP9aCMwPrkAfsbWsDtVtHEUTqBnsGkZTKAJU6ZAG,U";
			request.sDBBackupDirectory = "#expandPath('/data/weeklydbbackup/')#";
			request.sDBUsername = "notronwest";
			request.sDBPassword = "atp3ace!";
			request.sLeagueKey = "NFLPerfect";
			break;
		// development
		case "dev.pickem.inquisibee.com":
			request.sLogURL = "/data/logs/";
			request.bReloadOnEveryRequest = false;
			request.sAdminEmail = "ron@inquisibee.com";
			request.bIsDevelopment = false;
			request.bIsStaging = true;
			request.sSiteURL = 'http://dev.pickem.inquisibee.com/';
			request.dsn = "dev.inqsports";
			this.dsn = "dev.inqsports"; // reset the dsn for the application
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
			request.bIsStaging = false;
			request.sSiteURL = 'http://pickem.inquisibee.com/';
			request.dsn = "inqsports";
			request.sLocalIP = "54.68.81.199";
			request.sAPIKey="AP9aCMwPrkAfsbWsDtVtHEUTqBnsGkZTKAJU6ZAG,U";
			request.sDBBackupDirectory = "#expandPath('/data/weeklydbbackup/')#";
			request.sDBUsername = "notronwest";
			request.sDBPassword = "1nquisib33";
			break;
			
	}
</cfscript>
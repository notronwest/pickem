<cfscript>
	// datasource default
	request.datasources = {};
	// global request variables
	request.stJenkinsAPIKeys = {
		"sBackupWeekly" = "rRAMrXXWrEPkA2d3NXVwX"
	};
	request.sJenkinsAuthToken = "bafc2176c03237ccc32b8c85c6e64016";
	request.sLeagueKey = "pickem";
	request.sPHPURL = "http://pickem.inquisibee.com/";
	// specific variables
	switch (cgi.http_host){

		// development
		case "pickem.local":
		case "pickem.local:8052":
			// dynamically define datasources here
			request.datasources["inqsports"]		= {
				class: 'org.gjt.mm.mysql.Driver',
				connectionString: 'jdbc:mysql://db:3306/inqsports?useUnicode=true&useLegacyDatetimeCode=true&allowMultiQueries=true&useSSL=false',
				username = "inqsports",
				password = "1nquisib33"
			};
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
			request.sPHPURL = "http://php/";
			break;
		// development
		case "nflunderdog.local":
		case "nflunderdog.local:8052":
			// dynamically define datasources here
			request.datasources["inqsports"]		= {
				class: 'org.gjt.mm.mysql.Driver',
				connectionString: 'jdbc:mysql://db:3306/inqsports?useUnicode=true&useLegacyDatetimeCode=true&allowMultiQueries=true&useSSL=false',
				username = "inqsports",
				password = "1nquisib33"
			};
			request.sLogURL = "/data/logs/";
			request.bReloadOnEveryRequest = true;
			request.sAdminEmail = "ron@inquisibee.com";
			request.bIsDevelopment = true;
			request.bIsStaging = false;
			request.sSiteURL = 'http://nfldog.local/';
			request.dsn = "inqsports";
			request.sLocalIP = "127.0.0.1";
			request.sAPIKey="AP9aCMwPrkAfsbWsDtVtHEUTqBnsGkZTKAJU6ZAG,U";
			request.sDBBackupDirectory = "#expandPath('/data/weeklydbbackup/')#";
			request.sDBUsername = "notronwest";
			request.sDBPassword = "atp3ace!";
			request.sLeagueKey = "NFLUnderdog";
			request.sSiteURL = 'http://pickem.local/';
			break;
		// development
		case "nfldog.local":
		case "nfldog.local:8052":
			// dynamically define datasources here
			request.datasources["inqsports"]		= {
				class: 'org.gjt.mm.mysql.Driver',
				connectionString: 'jdbc:mysql://db:3306/inqsports?useUnicode=true&useLegacyDatetimeCode=true&allowMultiQueries=true&useSSL=false',
				username = "inqsports",
				password = "1nquisib33"
			};
			request.sLogURL = "/data/logs/";
			request.bReloadOnEveryRequest = true;
			request.sAdminEmail = "ron@inquisibee.com";
			request.bIsDevelopment = true;
			request.bIsStaging = false;
			request.sSiteURL = 'http://nfldog.local/';
			request.dsn = "inqsports";
			request.sLocalIP = "127.0.0.1";
			request.sAPIKey="AP9aCMwPrkAfsbWsDtVtHEUTqBnsGkZTKAJU6ZAG,U";
			request.sDBBackupDirectory = "#expandPath('/data/weeklydbbackup/')#";
			request.sDBUsername = "notronwest";
			request.sDBPassword = "atp3ace!";
			request.sLeagueKey = "NFLDog";
			request.sSiteURL = 'http://pickem.local/';
			break;
		// development
		case "nflperfection.local":
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
			request.sLeagueKey = "NFLPerfection";
			request.sSiteURL = 'http://pickem.local/';
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

		case "nflperfection.inquisibee.com":
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
			request.sLeagueKey = "NFLPerfection";
			break;

		case "nflunderdog.inquisibee.com":
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
			request.sLeagueKey = "NFLUnderdog";
			break;

		case "nfldog.inquisibee.com":
			request.sLogURL = "/data/logs/";
			request.bReloadOnEveryRequest = false;
			request.sAdminEmail = "nfldog@inquisibee.com";
			request.bIsDevelopment = false;
			request.bIsStaging = false;
			request.sSiteURL = 'http://nfldog.inquisibee.com/';
			request.dsn = "inqsports";
			request.sLocalIP = "54.68.81.199";
			request.sAPIKey="AP9aCMwPrkAfsbWsDtVtHEUTqBnsGkZTKAJU6ZAG,U";
			request.sDBBackupDirectory = "#expandPath('/data/weeklydbbackup/')#";
			request.sDBUsername = "notronwest";
			request.sDBPassword = "1nquisib33";
			request.sLeagueKey = "NFLDog";
			break;

	}
</cfscript>

<cfscript>
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
			break;
		// production
		case "pickem.inquisibee.com":
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
			break;
			
	}
</cfscript>
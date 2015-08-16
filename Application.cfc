component extends="framework" {
	
	include "config/applicationSettings.cfm";
	include "config/environmentalSettings.cfm";
	include "config/ormSettings.cfm";
	include "config/fw1Settings.cfm";

	/**
	* establishes the main variables for the application
	*/
	public void function setupApplication(){
		// build the bean factory
		setBeanFactory( new ioc("/model,/controllers") );
		
		application.dataDirectory = expandPath("/data/");
		application.sSerializeView = "main.serialize";
		// load all of the teams into memory
		application.qryTeams = entityToQuery(getBeanFactory().getBean("teamGateway").getAll());
		// unsecured actions
		application.arUnsecuredActions = [
			"security.forgotPassword",
			"security.login",
			"security.authenticate",
			"user.register",
			"user.changePassword"];
	}

	/** 
	* establishes the main request procedures
	*/
	public void function setupRequest(rc){
		if( structKeyExists(rc, "reload") ){
			setupApplication();
		}
		param name="rc.bHasLoggedIn" default="false";
		// this code could maybe go somewhere else (maybe a userSettings.cfm in config??)
		if( structKeyExists(cookie, "bHasLoggedIn") and cookie.bHasLoggedIn ){
			rc.bHasLoggedIn = true;
		}
		controller( 'security.checkAuthorization' );
	}

	/**
	* runs before anything in any of the controllers
	*/
	public void function before(rc){
		param name="rc.sAPIKey" default="";
		// default a message (used in a lot of different dialogs)
		param name="rc.sMessage" default="";
		rc.dDateNow = dateFormat(now(), 'yyyy-mm-dd');
		rc.tTimeNow = timeFormat(now(), 'HH:mm');
		rc.dNow = rc.dDateNow & " " & rc.tTimeNow;
		// default the season
		rc.nSeasonID = 2;
		rc.bIsDialog = false;
		rc.bIsMobile = getBeanFactory().getBean("commonService").isMobileView();
		rc.bIsAdminAction = false;
	}

	public void function after(rc){
		// get some more info about the current user
		rc.oCurrentUser = getBeanFactory().getBean("userGateway").get(rc.nCurrentUser);
	}

	/**
	* allows for manipulation of view
	*/
	public void function setupView(){
	
	}

	/**
	* establishes the default session variables
	*/
	public void function setupSession(){
		session.nUserID = 0;
		session.bIsAdmin = 1;
	}

	/** 
	* handles errors
	*/
	public void function onError(exception, event){
		writeDump(arguments.exception);
	}

}
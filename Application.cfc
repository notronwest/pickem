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
		application.arUnsecuredActions = ["user.forgotPassword"];
	}

	/** 
	* establishes the main request procedures
	*/
	public void function setupRequest(rc){
		if( structKeyExists(rc, "reload") ){
			setupApplication();
		}
		controller( 'security.checkAuthorization' );
	}

	/**
	* runs before anything in any of the controllers
	*/
	public void function before(rc){
		rc.dDateNow = dateFormat(now(), 'yyyy-mm-dd');
		rc.tTimeNow = timeFormat(now(), 'HH:mm');
		rc.dNow = rc.dDateNow & " " & rc.tTimeNow;
		// default the season
		rc.sSeason = "2014-2015";
		rc.bIsDialog = false;
		rc.bIsMobile = getBeanFactory().getBean("commonService").isMobileView();
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
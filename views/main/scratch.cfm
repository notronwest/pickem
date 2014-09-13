<!--- //<cfscript>
	//oGateway = new model.gateway.user();
	//writeDump(oGateway.getByUsernamePassword("rwest", "password"));
	/*g = entityNew("game");
	g.setNWeekID(7);
	entitySave(g);*/
	/*oTeamGateway = new model.gateway.team();
	oTeam = oTeamGateway.get();
	oTeam.setSName("South Carolina Gamecocks");
	oTeam.setSURL("http://sports.yahoo.com/ncaaf/teams/ssi/");
	oTeamGateway.save(oTeam);
	oTeam = oTeamGateway.get();
	oTeam.setSName("North Carolina Tarheels");
	oTeam.setSURL("");
	oTeamGateway.save(oTeam);*/
	//oGateway = new model.services.game();
	//writeDump(oGateway.buildOrderedArray(1));
</cfscript>
<cfset javaSystem = createObject("java", "java.lang.System") /> 
<cfset jProps = javaSystem.getProperties() /> 
<cfset jProps.setProperty("mail.pop3.socketFactory.class", "javax.net.ssl.SSLSocketFactory") /> 
<cfset jProps.setproperty("mail.pop3.port",995) /> 
<cfset jProps.setProperty("mail.pop3.socketFactory.port", 995) />

<cfpop action="GETALL" name="getMail" server="pop.gmail.com" username="dilemo" password="atp3ace!" port="995" maxrows="20" timeout="90">

<cfdump var="#getMail#"> --->
<cfscript>
	//stPicks = { 159 = 83, 160 = 81, 161 = 106 };
	o = getBeanFactory().getBean("dbService");
	writeDump(o.runStoredProc("updateStandings", {"nInWeekID" = 23, "sInSeason" = "2014-2015"}));
</cfscript>
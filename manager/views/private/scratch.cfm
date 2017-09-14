
<cfscript>
	o = getBeanFactory().getBean("gameService");
	writeDump(o.getAvailableGames());
	return;

	o = getBeanFactory().getBean("leagueGateway").get({ "sKey" = "NFLDog"});
	transaction{
		o.setSName("NFL Dog");
		o.setSKey("NFLDog");
		o.setBActive(1);
		o.save();
		transactionCommit();
	}
	return;
</cfscript>

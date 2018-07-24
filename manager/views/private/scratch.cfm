<cfscript>
	o = getBeanFactory().getBean("weekService");
	writeDump(o.makeAutoPicks(181, 9));
	return;


	o = getBeanFactory().getBean("gameService");
	arWeek  = o.adminWeek(179)
	writeDump(o.getGameScores(arWeek));
	return;


	o = getBeanFactory().getBean("gameService");
	writeDump(o.callScoreAPI("Oklahoma State"));
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

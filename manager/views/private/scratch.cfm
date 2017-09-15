
<cfscript>
	o = getBeanFactory().getBean("teamGateway");
	writeDump(o.getByName("Boise State"));
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

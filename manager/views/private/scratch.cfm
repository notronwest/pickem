
<cfscript>
	o = getBeanFactory().getBean("leagueGateway").get({ "sKey" = "NFLDog"});
	transaction{
		o.setSName("NFL Dog");
		o.setSKey("NFLDog");
		o.setBActive(1);
		o.save();
		transactionCommit();
	}
</cfscript>

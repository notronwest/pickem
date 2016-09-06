<cfscript>
	season = getBeanFactory().getBean("seasonGateway").get();
	season = getBeanFactory().getBean("seasonGateway").update(season, {
		"sName" = "NFL Perfect Challenge",
		"sKey" = "NFLPerfect"
	});
	writeDump(season);
</cfscript>
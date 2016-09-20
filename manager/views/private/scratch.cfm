
<cfscript>
	writeDump(getBeanFactory().getBean("teamService").saveTeam("Minnesota", "", 1));
	writeDump(getBeanFactory().getBean("teamGateway").getByExactNameAndType("Minnesota", true, 1));
</cfscript>
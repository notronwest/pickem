
<cfscript>
	writeDump(getBeanFactory().getBean("gameService").getAvailableGames(false,true));
</cfscript>
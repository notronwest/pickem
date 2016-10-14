
<cfscript>
	writeDump(getBeanFactory().getBean("settingService").readableUserSettings(65, rc.sCurrentLeagueID));
</cfscript>
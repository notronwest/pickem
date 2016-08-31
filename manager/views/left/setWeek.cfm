<cfoutput>
<button id="add" class="btn btn-inverse btn-small">Add Week</button>
<h5>Season: #rc.nCurrentSeasonID#</h5>
<ul>
	<cfloop from="1" to="#arrayLen(rc.arWeeks)#" index="local.itm">
		<cfif rc.nWeekID eq rc.arWeeks[itm].getNWeekID()>
			<cfset class = "active">
		<cfelse>
			<cfset class = "link">
		</cfif>
		<li class="#class#"><a href="#buildURL('week.setWeekGames?nWeekID=#rc.arWeeks[local.itm].getNWeekID()#')#">#rc.arWeeks[local.itm].getSName()#</a></li>
	</cfloop>
</ul></cfoutput>
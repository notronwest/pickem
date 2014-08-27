<cfoutput>
<h5>#rc.sSeason#</h5>
<ul>
	<cfloop from="1" to="#arrayLen(rc.arWeeks)#" index="local.itm">
		<cfif rc.nWeekID eq rc.arWeeks[local.itm].getNWeekID()>
			<cfset class = "active">
		<cfelse>
			<cfset class = "link">
		</cfif>
		<li class="#class#"><a href="#buildURL('pick.set?nWeekID=#rc.arWeeks[local.itm].getNWeekID()#')#">#rc.arWeeks[local.itm].getSName()#</a></li>
	</cfloop>
</ul></cfoutput>
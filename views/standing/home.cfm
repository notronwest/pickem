<section id="content">
<cfset local.sPlace = 1>
<cfset local.sCurrentWins = 0>
<cfoutput>
	<table id="standings" class="table table-striped">
		<thead>
			<th>Player</th>
			<!--- // <th>Money</th> --->
			<th>Wins</th>
			<!--- // <th>Losses</th> --->
			<th>Rank</th>
			<!--- // loop through the weeks --->
			<cfloop from="1" to="#arrayLen(rc.arWeeks)#" index="itm">
				<th data-week-id="#rc.arWeeks[itm].getNWeekID()#">Week ###itm#</th>
			</cfloop>
		</thead>
		<tbody>
			<!--- // loop through the season standings --->
			<cfloop from="1" to="#arrayLen(rc.arStandings)#" index="local.itm">
				<cfscript>
					// store current userID
					local.nUserID = rc.arStandings[local.itm];
					// determine what place the current user is in
					if( rc.stSeasonWins[local.nUserID] neq local.sCurrentWins ){
						local.sPlace = local.itm;
					}
					local.stUserWins = rc.stWeekWins[local.nUserID];
					if( listLen(structKeyList(local.stUserWins)) gt 0 ){
						local.arWeeks = listToArray(structKeyList(local.stUserWins));	
					} else {
						local.arWeeks = [];
					}
				</cfscript>
				<tr>
					<td><a href="#buildURL('pick.compare')#&nViewUserID=#local.nUserID#"> #rc.stUsers[local.nUserID].getSFirstName()# #rc.stUsers[local.nUserID].getSLastName()#</a></td>
					<!--- // <td></td> --->
					<td>#rc.stSeasonWins[local.nUserID]#</td>
					<!--- // <td></td> --->
					<td>#local.sPlace#</td>
					<!--- // loop through the week wins for this user --->
					<cfloop from="#arrayLen(local.arWeeks)#" to="1" step="-1" index="local.x">
						<cfset local.nWeekID = local.arWeeks[local.x]>
						<td<cfif structKeyExists(rc.stWeekWinners[local.nWeekID], local.nUserID)> class="highlight"</cfif>>#local.stUserWins[local.nWeekID]#</td>
					</cfloop>
					<cfif arrayLen(local.arWeeks) lt arrayLen(rc.arWeeks)>
						<td>0</td>
					</cfif>
					<cfset local.sCurrentWins = rc.stSeasonWins[local.nUserID]>
				</tr>
			</cfloop>
		</tbody>
	</table>
</cfoutput>
</section>
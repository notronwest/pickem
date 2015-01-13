<section id="content">
<cfscript>
	local.sPlace = 1;
	local.sCurrentWins = 0;
</cfscript>
<cfoutput>
	<div class="table-responsive">
		<table id="standings" class="table hover order-column">
			<thead>
				<th>Player</th>
				<!--- // <th>Money</th> --->
				<th>Wins</th>
				<!--- // <th>Losses</th> --->
				<th>Rank</th>
				<!--- // loop through the weeks --->
				<cfloop from="#arrayLen(rc.arWeeks)#" to="1" step="-1" index="itm">
					<th data-week-id="#rc.arWeeks[itm].getNWeekID()#">Week #rc.arWeeks[itm].getNWeekNumber()#</th>
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
							local.arWeeks = listToArray(listSort(structKeyList(local.stUserWins), "numeric", "asc"));
						} else {
							local.arWeeks = [];
						}
					</cfscript>
					<tr<cfif rc.nCurrentUser eq local.nUserID> class="highlight-user"</cfif>>
						<td><a href="#buildURL('pick.compare')#&nViewUserID=#local.nUserID#"> #rc.stUsers[local.nUserID].getSFirstName()# #rc.stUsers[local.nUserID].getSLastName()#</a></td>
						<!--- // <td></td> --->
						<td>#rc.stSeasonWins[local.nUserID]#</td>
						<!--- // <td></td> --->
						<td>#local.sPlace#</td>
						<cfif arrayLen(local.arWeeks) lte arrayLen(rc.arWeeks)>
							<cfloop from="1" to="#(arrayLen(rc.arWeeks) - arrayLen(local.arWeeks))#" index="local.z"><td>0</td></cfloop>
						</cfif>
						<!--- // loop through the week wins for this user --->
						<cfloop from="#arrayLen(local.arWeeks)#" to="1" step="-1" index="local.y">
							<cfset local.nWeekID = local.arWeeks[local.y]>
							<td<cfif structKeyExists(rc.stWeekWinners[local.nWeekID], local.nUserID)> class="highlight-first" data-order="1000001"<cfelseif structKeyExists(rc.stWeekSecondPlace[local.nWeekID], local.nUserID)> class="highlight-second" data-order="1000000"<cfelse> data-order="#local.stUserWins[local.nWeekID]#"</cfif>>#local.stUserWins[local.nWeekID]#
							<cfif structKeyExists(rc.stWeekWinners[local.nWeekID], local.nUserID)><span class="fa fa-trophy"></span></cfif>
							<cfif structKeyExists(rc.stWeekNoPicks, local.nWeekID) and isArray(rc.stWeekNoPicks[local.nWeekID]) and arrayFind(rc.stWeekNoPicks[local.nWeekID], local.nUserID)><span class="fa fa-frown-o"></span></cfif>
						</td>
						</cfloop>
						<cfset local.sCurrentWins = rc.stSeasonWins[local.nUserID]>
					</tr>
				</cfloop>
			</tbody>
		</table>
	</div>
	<div class="right">
		<table class="table-bordered dataTable">
			<tbody>
				<tr>
					<td><span class="fa fa-trophy highlight-first"> 1st</span></td>
					<td><span class="highlight-second"> 2nd</span></td>
					<td><span class="fa fa-frown-o"> No picks</span></td>
				</tr>
			</tbody>
		</table>
	</div>
</cfoutput>
</section>
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
				<tr id="fullResultsHeader">
					<td></td>
					<td></td>
					<td></td>
					<cfloop from="#arrayLen(rc.arWeeks)#" to="1" step="-1" index="itm">	
						<td data-order="0">
							<a href="#buildURL('standing.fullResults')#&nWeekID=#rc.arWeeks[itm].getNWeekID()#">full results</a>
						</td>
					</cfloop>
				</tr>
				<!--- // loop through the season standings --->
				<cfloop from="1" to="#arrayLen(rc.arStandings)#" index="local.itm">
					<cfscript>
						// store current userID
						local.nUserID = rc.arStandings[local.itm];
						// determine what place the current user is in
						if( rc.stSeasonWins[local.nUserID] neq local.sCurrentWins ){
							local.sPlace = local.itm;
						}
						local.stUserWeekData = rc.stWeekData[local.nUserID];
						local.arUserTiebreak = rc.stWeekTiebreak[local.nUserID];
						if( listLen(structKeyList(local.stUserWeekData)) gt 0 ){
							local.arWeeks = listToArray(listSort(structKeyList(local.stUserWeekData), "numeric", "asc"));
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
						<!--- // loop through the week wins for this user --->
						<cfloop from="#arrayLen(rc.arWeeks)#" to="1" step="-1" index="local.y">
							<cfscript>
								if( !structKeyExists(local.stUserWeekData, rc.arWeeks[local.y].getNWeekNumber()) ){
									stUserWeekData[rc.arWeeks[local.y].getNWeekNumber()] = {
										"nPlace" = 0,
										"Wins" = 0
									};
									//arrayAppend(local.arWeeks, 0);
								}
								local.nWeekID = rc.arWeeks[local.y].getNWeekNumber();
							</cfscript>

							<td data-order="#local.stUserWeekData[local.nWeekID].nPlace#">#local.stUserWeekData[local.nWeekID].wins#

							<span class="badge"><cfif local.stUserWeekData[local.nWeekID].nPlace eq 1>1<cfelseif local.stUserWeekData[local.nWeekID].nPlace eq 2>2<cfelseif rc.arWeeks[local.y].getNWeekNumber() eq 19 and local.stUserWeekData[local.nWeekID].nPlace eq 3>3</cfif></span>

							<!--- // handle no picks or auto picks --->
							<cfif structKeyExists(rc.stWeekNoPicks, local.nWeekID) and isArray(rc.stWeekNoPicks[local.nWeekID]) and arrayFind(rc.stWeekNoPicks[local.nWeekID], local.nUserID)><span class="fa fa-frown-o"></span></cfif>
							<cfif structKeyExists(rc.stWeekAutoPick, local.nWeekID) and isArray(rc.stWeekAutoPick[local.nWeekID]) and arrayFind(rc.stWeekAutoPick[local.nWeekID], local.nUserID)>(a)</cfif>
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
					<td>(a) = auto picked
				</tr>
			</tbody>
		</table>
	</div>
</cfoutput>
</section>
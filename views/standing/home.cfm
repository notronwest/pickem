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
						<td>
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
						local.stUserWins = rc.stWeekWins[local.nUserID];
						local.arUserTiebreak = rc.stWeekTiebreak[local.nUserID];
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
							<cfscript>
								bIsFirst = false;
								bIsSecond = false;
								local.nWeekID = local.arWeeks[local.y];
								// determine if this user is a winner
								if( structKeyExists(rc.stWeekWinners[local.nWeekID], local.nUserID) ){
									bIsFirst = true;
								} else if( structKeyExists(rc.stWeekSecondPlace[local.nWeekID], local.nUserID) ){
									bIsSecond = true;
								}
							</cfscript>

							<td<cfif bIsFirst> class="highlight-first" data-order="1000001"<cfelseif bIsSecond> class="highlight-second" data-order="1000000"<cfelse> data-order="#local.stUserWins[local.nWeekID]#"</cfif>>#local.stUserWins[local.nWeekID]#
							<cfif bIsFirst>
								<span class="fa fa-trophy"></span>
							</cfif>
							<cfif bIsFirst or bIsSecond or rc.bDebugTiebreak neq 0>
								(#((structKeyExists(local.arUserTiebreak, local.nWeekID) and arrayLen(local.arUserTiebreak[local.nWeekID]) gt 0) ? '<span title="' & local.arUserTiebreak[local.nWeekID].toString() & '">' & local.arUserTiebreak[local.nWeekID][1] & '</span>' : "")#)
							</cfif>
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
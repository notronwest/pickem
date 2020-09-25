<section id="content">
<cfoutput>
	<div class="table-responsive">
		<table id="weekResults" class="table hover order-column">
			<thead>
				<th></th>
				<th>Wins</th>
				<!--- // loop through the games for this week --->
				<cfloop from="1" to="#arrayLen(rc.arWeekGames)#" index="local.itm">
					<cfscript>
						// build more user friendly versions of teams
						switch(listLen(rc.arWeekGames[local.itm].sHomeTeam, " ") >= 2){
							case true:
								local.sHomeTeam = listFirst(rc.arWeekGames[local.itm].sHomeTeam, " ") & " " & listGetAt(rc.arWeekGames[local.itm].sHomeTeam, 2, " ");
								break;
							default:
								local.sHomeTeam = rc.arWeekGames[local.itm].sHomeTeam;
						}
						// build more user friendly versions of teams
						switch(listLen(rc.arWeekGames[local.itm].sAwayTeam, " ") >= 2){
							case true:
								local.sAwayTeam = listFirst(rc.arWeekGames[local.itm].sAwayTeam, " ") & " " & listGetAt(rc.arWeekGames[local.itm].sAwayTeam, 2, " ");
								break;
							default:
								local.sAwayTeam = rc.arWeekGames[local.itm].sAwayTeam;
						}
					</cfscript>
					<th>#local.sHomeTeam# vs. #local.sAwayTeam#</th>
				</cfloop>
			</thead>
			<tbody>
				<!--- // loop through the results --->
				<cfloop from="1" to="#arrayLen(rc.arFullResults)#" index="local.itm">
					<tr>
						<td><cfif rc.arFullResults[local.itm].nPlace neq 4030000>#rc.arFullResults[local.itm].nPlace#.</cfif>#rc.arFullResults[local.itm].sFullName#</td>
						<td>#listLen(rc.arFullResults[local.itm].lstWins)#</td>
						<!--- // loop through the weeks and get the wins/losses --->
						<cfloop from="1" to="#arrayLen(rc.arWeekGames)#" index="local.x">	
							<cfif rc.arWeekGames[local.x].bGameIsFinal>
								<td<cfif listFind(rc.arFullResults[local.itm].lstWins, rc.arWeekGames[local.x].nGameID)> class="win"<cfelse> class="loss"</cfif>>
									<cfif listFind(rc.arFullResults[local.itm].lstWins, rc.arWeekGames[local.x].nGameID)><span class="fa  fa-check"></span><cfelse><span class="fa  fa-times"></span></cfif>
								</td>
							<cfelse>
								<td class="no-status">n/a</td>
							</cfif>
						</cfloop>
					</tr>
				</cfloop>
			</tbody>
		</table>
	</div>
</cfoutput>
</section>
<cfoutput>
<div class="panel panel-default" data-id="#rc.oWeek.getNWeekID()#">
	<div class="panel-heading">
		<h2>Current Scores</h2>
	</div>
	<div class="panel-body">
		<h1>#rc.oWeek.getSName()#</h1>
		<div id="games">
			<div class="table-responsive">
				<table class="table">
					<thead>
						<th>Favorite</th>
						<th>Score</th>
						<th>Underdog</th>
						<th>Score</th>
						<th>Game Message</th>
					</thead>
					<tbody>
						<cfloop from="1" to="#arrayLen(rc.arWeekGames)#" index="local.itm">
							<tr class="game" data-id="#rc.arWeekGames[local.itm].nGameID#">
								<cfif rc.arWeekGames[local.itm].sSpreadFavor eq "home">
									<td><label class="home">#rc.arWeekGames[local.itm].sHomeTeam# <span class="badge">+#rc.arWeekGames[local.itm].nSpread#</span></label></td>
									<td>#rc.arWeekGames[local.itm].nHomeScore#</td>
									<td><label>#rc.arWeekGames[local.itm].sAwayTeam#</label></td>
									<td>#rc.arWeekGames[local.itm].nAwayScore#</td>
								<cfelse>
									<td><label>#rc.arWeekGames[local.itm].sAwayTeam# <span class="badge">+#rc.arWeekGames[local.itm].nSpread#</span></label></td>
									<td>#rc.arWeekGames[local.itm].nAwayScore#</td>
									<td><label class="home">#rc.arWeekGames[local.itm].sHomeTeam#</label></td>
									<td>#rc.arWeekGames[local.itm].nHomeScore#</td>
								</cfif>
								<td><cfif structKeyExists(rc.arWeekGames[local.itm], "sMessage")>#rc.arWeekGames[local.itm].sMessage#<cfelse>#rc.arWeekGames[itm].sGameStatus#</cfif></td>
							<tr>
						</cfloop>
					</tbody>
				</table>
			</div>
		</div>
	</div>
</div>
</cfoutput>
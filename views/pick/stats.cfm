<cfoutput>
	<div id="admin" class="panel panel-default">
		<div class="panel-heading text-right">
			<form class="form-inline" role="form">
				<div class="form-group">
					<select id="nGameID" class="input-sm" size="1">
					<cfloop from="1" to="#arrayLen(rc.arWeekGames)#" index="local.itm">
						<option value="#rc.arWeekGames[local.itm].nGameID#"<cfif rc.nGameID eq rc.arWeekGames[local.itm].nGameID> selected="selected"</cfif>>
							#rc.arWeekGames[local.itm].sAwayTeam# at #rc.arWeekGames[local.itm].sHomeTeam#
						</option>
					</cfloop>
					</select>
					<button type="button" class="stats btn btn-default btn-sm">Go</button>
				</div>
			</form>
		</div>
		<div class="panel-body">
			<h3 data-id="#rc.nGameID#"><cfif len(rc.stGame.nAwayTeamRanking) gt 0>(#rc.stGame.nAwayTeamRanking#) </cfif>#rc.stGame.sAwayTeam#<cfif len(rc.stGame.sAwayTeamRecord) gt 0> (#rc.stGame.sAwayTeamRecord#)</cfif> at <cfif len(rc.stGame.nHomeTeamRanking) gt 0>(#rc.stGame.nHomeTeamRanking#) </cfif>#rc.stGame.sHomeTeam#<cfif len(rc.stGame.sHomeTeamRecord) gt 0> (#rc.stGame.sHomeTeamRecord#)</cfif></h3>
			<h4>Game Date/Time: #dateFormat(rc.stGame.sGameDateTime, 'dddd mmmm d')# @ #timeFormat(rc.stGame.sGameDateTime, 'h:mm')# <cfif timeFormat(rc.stGame.sGameDateTime, 'HH') gte 12>PM<cfelse>AM</cfif></h4>
			<h4><cfif compareNoCase(rc.stGame.sSpreadFavor, "home") eq 0>#rc.stGame.sHomeTeam# (home)<cfelse>#rc.stGame.sAwayTeam# (away)</cfif> are favored by #rc.stGame.nSpread# points</h4>
			<div class="row">
				<div class="col-md-8">
					<h3>Team stats</h3>
					<ul class="list-group">
						<cfloop from="1" to="#arrayLen(rc.arTeamStats)#" index="local.itm">
							<li class="list-group-item<cfif rc.arTeamStats[local.itm].qryRecord.recordCount eq 0> alert alert-warning<cfelseif rc.arTeamStats[local.itm].qryRecord.nWinsAgainstSpread gt rc.arTeamStats[local.itm].qryRecord.nLossesAgainstSpread> alert alert-success<cfelse> alert alert-danger</cfif>">
								The #rc.arTeamStats[local.itm].sTeamName# are 
								<cfif rc.arTeamStats[local.itm].qryRecord.recordCount gt 0>#rc.arTeamStats[local.itm].qryRecord.nWinsAgainstSpread# - #rc.arTeamStats[local.itm].qryRecord.nLossesAgainstSpread#<cfelse>Have no record</cfif> #lCase(rc.arTeamStats[local.itm].sLabel)#.
						</cfloop>
					</ul>
				</div>
			</div>
			<div class="row">
				<div class="col-md-8">
					<h3>Your stats</h3>
					<ul class="list-group">
						<cfloop from="1" to="#arrayLen(rc.arGameStats)#" index="local.itm">
							<li class="list-group-item<cfif rc.arGameStats[local.itm].qryRecord.recordCount eq 0> alert alert-warning<cfelseif rc.arGameStats[local.itm].qryRecord.nWins gt rc.arGameStats[local.itm].qryRecord.nLosses> alert alert-success<cfelse> alert alert-danger</cfif>">
								<cfif rc.arGameStats[local.itm].qryRecord.recordCount gt 0>You are #rc.arGameStats[local.itm].qryRecord.nWins# - #rc.arGameStats[local.itm].qryRecord.nLosses#<cfelse>You have no record</cfif> picking the #lCase(rc.arGameStats[local.itm].sLabel)# in <cfif rc.stGame.nType eq 1>NCAA<cfelse>NFL</cfif> games.
						</cfloop>
					</ul>
				</div>
			</div>
  			<div class="row">
				<div class="col-md-3">
					<h3>Previous games</h3>
					<h4>#rc.stGame.sAwayTeam#<cfif len(rc.stGame.sAwayTeamRecord) gt 0> (#rc.stGame.sAwayTeamRecord#)</cfif></h4>
					<cfif structKeyExists(rc.stWeeklyTeamResults, rc.stGame.nAwayTeamID)>
						<cfloop from="1" to="#arrayLen(rc.stWeeklyTeamResults[rc.stGame.nAwayTeamID])#" index="local.itm">
							<ul class="list-group">
								<cfscript>
									local.nWinner = 2;
									if( rc.stWeeklyTeamResults[rc.stGame.nAwayTeamID][local.itm][1].nScore gt rc.stWeeklyTeamResults[rc.stGame.nAwayTeamID][local.itm][2].nScore ){
										local.nWinner = 1;
									}
								</cfscript>
								<cfloop from="1" to="#arrayLen(rc.stWeeklyTeamResults[rc.stGame.nAwayTeamID][local.itm])#" index="local.x">
									<li class="list-group-item<cfif local.nWinner eq local.x> list-group-item-info</cfif>">
										#rc.stWeeklyTeamResults[rc.stGame.nAwayTeamID][local.itm][local.x].sTeamName#
										<span class="badge">
											#rc.stWeeklyTeamResults[rc.stGame.nAwayTeamID][local.itm][local.x].nScore#
										</span>
									</li>
								</cfloop>
							</ul>
						</cfloop>
					</cfif>
					<h4>#rc.stGame.sHomeTeam#</h4>
					<cfif structKeyExists(rc.stWeeklyTeamResults, rc.stGame.nHomeTeamID)>
						<cfloop from="1" to="#arrayLen(rc.stWeeklyTeamResults[rc.stGame.nHomeTeamID])#" index="local.itm">
							<ul class="list-group">
								<cfscript>
									local.nWinner = 2;
									if( rc.stWeeklyTeamResults[rc.stGame.nHomeTeamID][local.itm][1].nScore gt rc.stWeeklyTeamResults[rc.stGame.nHomeTeamID][local.itm][2].nScore ){
										local.nWinner = 1;
									}
								</cfscript>
								<cfloop from="1" to="#arrayLen(rc.stWeeklyTeamResults[rc.stGame.nHomeTeamID][local.itm])#" index="local.x">
									<li class="list-group-item<cfif local.nWinner eq local.x> list-group-item-info</cfif>">
										#rc.stWeeklyTeamResults[rc.stGame.nHomeTeamID][local.itm][local.x].sTeamName#
										<span class="badge">
											#rc.stWeeklyTeamResults[rc.stGame.nHomeTeamID][local.itm][local.x].nScore#
										</span>
									</li>
								</cfloop>
							</ul>
						</cfloop>
					</cfif>
				</div>
			</div>
		</div>
	</div>
</cfoutput>	
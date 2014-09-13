<cfoutput>
	<div id="picks" class="panel panel-default" data-id="#rc.oWeek.getNWeekID()#">
		<div class="panel-heading text-right">
			<form class="form-inline">
				<div class="input-group">
					<select id="sWeekURL" class="form-control input-sm" size="1">
					<cfloop from="1" to="#arrayLen(rc.arWeeks)#" index="local.itm">
						<option value="#buildURL('pick.set')#&nWeekID=#rc.arWeeks[local.itm].getNWeekID()#"<cfif rc.oWeek.getNWeekID() eq rc.arWeeks[local.itm].getNWeekID()> selected="selected"</cfif>>
							#rc.arWeeks[local.itm].getSName()# (#dateFormat(rc.arWeeks[local.itm].getDStartDate(), "mm/dd")# - #dateFormat(rc.arWeeks[local.itm].getDEndDate(), "mm/dd")#)
						</option>
					</cfloop>
					</select>
					<span class="input-group-btn">
        				<button class="btn btn-default change-week btn-sm" type="button">Go</button>
      				</span>
				</div>
			</form>
		</div>
		<div class="panel-body">
			<!--- // if the week is locked --->
			<cfif rc.bIsLocked>
				<div class="alert alert-warning">
					<h3>This week is locked and no changes to your picks can be made at this time.</h3>
				</div>
			</cfif>
			<h1>#rc.oWeek.getSName()#</h1>
			<p>
				<cfif !rc.bIsLocked>Picks can be made up until #getBeanFactory().getBean("commonService").dateTimeFormat(rc.dtPicksDue)#</cfif>
			</p>
			<div class="text-left">
				<cfif listLen(rc.stUserWeek.lstWins)>
					<span class="alert-info">Total wins this week: #listLen(rc.stUserWeek.lstWins)#</span>
				</cfif>
			</div>
			<div>
				<a href="javascript:;" class="help">Help</a>
				<div class="help hide">
					<h5>Picks</h5>
					<ol>
						<li>Use this section to make your picks for the upcoming week</li>
						<li>Click "Change Picks/Make Picks" if you would like to change/make your picks
						<li>Once you are "Making changes", simply click on the team that you would like to win each matchup. Once clicked the team name will highlight in green.</li>
						<li>NOTE: the Favorite will have a negative number in their box. This signifies how many points your pick must either win by or lose by (depending on if you pick the Favorite or Underdog)
						<li>Once you have made your picks, click the "Save Picks" button</li>
						<li>You will be able to make unlimited changes to your picks up until the time that the picks are frozen for the week (noted at the top of the page)</li>
					</ol>
				</div>
			</div>
			<cfif !rc.bIsLocked><div class="text-right page-controls">
				<button class="make-changes btn btn-default btn-small" title="Click here to make changes to your picks" type="button"><cfif rc.bUserHasPicks>Change Picks<cfelse>Make Picks</cfif></button>
				<button class="cancel btn btn-default btn-small hidden" type="button">Cancel</button>
				<button class="save btn btn-default btn-small hidden" type="button">Save Picks</button>
			</div></cfif>
			<div class="table-responsive">
				<table class="table">
					<thead>
						<th></th>
						<th class="picks">Pick (home team in CAPS)</th>
						<th class="change hidden">Favorite</th>
						<th class="change hidden">Underdog</th>
						<th>Game Date</th>
						<cfif rc.bShowScores><th title="Your picks score is first">Score</th></cfif>
					</thead>
					<tbody>
						<cfloop from="1" to="#arrayLen(rc.arWeekGames)#" index="local.itm">
							<!--- // determine who gets pick class --->
							<cfscript>
								sHomeClass = "btn-default";
								sAwayClass = "btn-default";
								sPick = "";
								bIsWinner = false;
								bWinnerCrowned = false;
								if( structKeyExists(rc.stUserWeek.stPicks, rc.arWeekGames[local.itm].nGameID)
									and rc.stUserWeek.stPicks[rc.arWeekGames[local.itm].nGameID] eq rc.arWeekGames[local.itm].nHomeTeamID ){
									sHomeClass = "btn-success pick";
									sPick = "home";
								} else if ( structKeyExists(rc.stUserWeek.stPicks, rc.arWeekGames[local.itm].nGameID)
									and rc.stUserWeek.stPicks[rc.arWeekGames[local.itm].nGameID] eq rc.arWeekGames[local.itm].nAwayTeamID ) {
									sAwayClass = "btn-success pick";
									sPick = "away";
								}
								// determine if this pick was a winner
								if ( rc.arWeekGames[local.itm].bGameIsFinal ){
									// we have a winner
									bWinnerCrowned = true;
									if( not isNull(rc.arWeekGames[local.itm].nWinner) and rc.arWeekGames[local.itm].nWinner eq rc.stUserWeek.stPicks[rc.arWeekGames[local.itm].nGameID]){
										bIsWinner = true;
									}
								}
							</cfscript>
							<tr class="game" data-id="#rc.arWeekGames[local.itm].nGameId#">
								<td>#local.itm#</td>
								<!--- // if the favor is on the home team --->
								<cfif rc.arWeekGames[local.itm].sSpreadFavor eq "home">
									<!--- // display the current pick --->
									<td class="picks">
										<cfif len(sPick)>
											<!--- // if they picked the home team then add the "+" --->
											<cfif compareNoCase(sPick, "home") eq 0>
												<button class="home disabled<cfif bIsWinner> btn-success<cfelseif bWinnerCrowned> btn-danger</cfif>">
													#rc.arWeekGames[local.itm].sHomeTeam# <span class="badge">-#rc.arWeekGames[local.itm].nSpread#</span>
												</button>
											<cfelse>
												<button class="disabled<cfif bIsWinner> btn-success<cfelseif bWinnerCrowned> btn-danger</cfif>">
													#rc.arWeekGames[local.itm].sAwayTeam# <span class="badge">+#rc.arWeekGames[local.itm].nSpread#</span>
												</button>
											</cfif>
										<cfelse>No Pick</cfif>
									</td>
									<!--- // handle writing the controls to make changes --->
									<td class="change hidden"><button type="button" class="btn btn-sm home #sHomeClass#" data-id="#rc.arWeekGames[local.itm].nHomeTeamID#">#rc.arWeekGames[local.itm].sHomeTeam# <span class="badge">-#rc.arWeekGames[local.itm].nSpread#</span></button></td>
									<td class="change hidden" class="change"><button type="button" class="btn btn-sm #sAwayClass#" data-id="#rc.arWeekGames[local.itm].nAwayTeamID#">#rc.arWeekGames[local.itm].sAwayTeam#</button></td>
								<cfelse>
									<!--- // display the current pick --->
									<td class="picks">
										<cfif len(sPick)>
											<!--- // if they picked the home team then add the "+" --->
											<cfif compareNoCase(sPick, "home") eq 0>
												<button class="home disabled<cfif bIsWinner> btn-success<cfelseif bWinnerCrowned> btn-danger</cfif>">
													#rc.arWeekGames[local.itm].sHomeTeam# <span class="badge">+#rc.arWeekGames[local.itm].nSpread#</span>
												</button>
											<cfelse>
												<button class="disabled<cfif bIsWinner> btn-success<cfelseif bWinnerCrowned> btn-danger</cfif>">
													#rc.arWeekGames[local.itm].sAwayTeam# <span class="badge">-#rc.arWeekGames[local.itm].nSpread#</span>
												</button>
											</cfif>
										<cfelse>No Pick</cfif>
									</td>
									<!--- // handle writing the controls to make changes --->
									<td class="change hidden"><button type="button" class="btn btn-sm #sAwayClass#" data-id="#rc.arWeekGames[local.itm].nAwayTeamID#">#rc.arWeekGames[local.itm].sAwayTeam# <span class="badge">-#rc.arWeekGames[local.itm].nSpread#</span></button></td>
									<td class="change hidden"><button class="btn btn-sm home #sHomeClass#" data-id="#rc.arWeekGames[local.itm].nHomeTeamID#">#rc.arWeekGames[local.itm].sHomeTeam#</button></td>
								</cfif>
								<td>#dateFormat(rc.arWeekGames[local.itm].sGameDateTime, "mm/dd/yyyy")#</td>
								<cfif rc.bShowScores><td>
									<!--- // show the picks score first --->
									<cfif structKeyExists(rc.stUserWeek.stPicks, rc.arWeekGames[local.itm].nGameID) and rc.stUserWeek.stPicks[rc.arWeekGames[local.itm].nGameID] eq rc.arWeekGames[local.itm].nHomeTeamID>
										#rc.arWeekGames[local.itm].nHomeScore# - #rc.arWeekGames[local.itm].nAwayScore# (#rc.arWeekGames[local.itm].sGameStatus#)
									<cfelse>
										#rc.arWeekGames[local.itm].nAwayScore# - #rc.arWeekGames[local.itm].nHomeScore# (#rc.arWeekGames[local.itm].sGameStatus#)
									</cfif>
								</td></cfif>
							</tr>
						</cfloop>
					</tbody>	
				</table>
			</div>
			<cfif !rc.bIsLocked><div class="text-right page-controls">
				<button class="make-changes btn btn-default btn-small" title="Click here to make changes to your picks" type="button"><cfif rc.bUserHasPicks>Change Picks<cfelse>Make Picks</cfif></button>
				<button class="cancel btn btn-default btn-small hidden" type="button">Cancel</button>
				<button class="save btn btn-default btn-small hidden" type="button">Save Picks</button>
			</div></cfif>
		</div>
	</div>
</cfoutput>
<!--- // put up message for picks saved --->
<cfif rc.bSaved><script> $(function(){ setMessage("Picks Saved"); });</script></cfif>
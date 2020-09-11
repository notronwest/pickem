<cfparam name="local.bShowGameStatus" default="true">
<cfparam name="local.sCurrentGame" default="NCAA">
<cfparam name="local.bShowDetails" default="true">
<cfparam name="local.bIsCompare" default="false">
<cfoutput>
	<cfloop from="1" to="#arrayLen(local.arWeekGames)#" index="local.itm">
		<!--- // determine who gets pick class --->
		<cfscript>
			stGame = local.arWeekGames[local.itm];
			sGamesDividerClass = "";
			// determine if we have changed to NFL games
			if( !stGame.bGameIsNCAA and compareNoCase(sCurrentGame, "NCAA") eq 0 ){
				sGamesDividerClass = " games-divider";
				sCurrentGame = "NFL";
			}
			// set game date/time
			sGameDate = listFirst(stGame.sGameDateTime, " ");
			sGameTime = listLast(stGame.sGameDateTime, " ");
			// if they want to see the setting in pacific time
			if( structKeyExists(rc.stUser, "stSettings")
				and structKeyExists(rc.stUser.stSettings, "timezone")
				and compareNoCase(rc.stUser.stSettings.timezone, "Pacific") eq 0 ){
				arGameTime = listToArray(sGameTime, ":");
				sGameTime = arGameTime[1] - 3 & ":" & arGameTime[2];
			}
			bPick = 0;
			bPickIsLocked = false;
			// determine who the pick is
			if( structKeyExists(local.stPicks, local.arWeekGames[local.itm].nGameID) ){
				bPick = local.stPicks[local.arWeekGames[local.itm].nGameID];
			}
			stHome = {
				"sName" = (stGame.bGameIsNCAA) ? stGame.sHomeTeam : stGame.sHomeTeamMascot,
				"nID" = stGame.nHomeTeamID,
				"nScore" = stGame.nHomeScore,
				"nRanking" = stGame.nHomeTeamRanking,
				"sRecord" = stGame.sHomeTeamRecord,
				"bIsHome" = true,
				"bIsWinning" = false,
				"sClass" = "btn-default"
			};
			stAway = {
				"sName" = (stGame.bGameIsNCAA) ? stGame.sAwayTeam : stGame.sAwayTeamMascot,
				"nID" = stGame.nAwayTeamID,
				"nScore" = stGame.nAwayScore,
				"nRanking" = stGame.nAwayTeamRanking,
				"sRecord" = stGame.sAwayTeamRecord,
				"bIsHome" = false,
				"bIsWinning" = false,
				"sClass" = "btn-default"
			};
			// determine favored team
			nFavoredTeam = ( compareNoCase(stGame.sSpreadFavor, "home") eq 0 ) ? stHome.nID : stAway.nID;
			// determine the rendering for the teams
			stFavorite = ( compareNoCase(stGame.sSpreadFavor, "home") eq 0 ) ? stHome : stAway;
			stUnderdog = ( compareNoCase(stGame.sSpreadFavor, "home") eq 0 ) ? stAway : stHome;
			stPick = ( bPick eq stHome.nID ) ? stHome : stAway;
			stNotPick = ( bPick eq stHome.nID ) ? stAway : stHome;
			// determine who is winning
			if( len(stGame.sGameStatus) gt 0 ){
				if( nFavoredTeam eq stPick.nID and (stPick.nScore - stGame.nSpread) > stNotPick.nScore ){
					stPick.bIsWinning = true;
				} else if ( nFavoredTeam eq stNotPick.nID and (stNotPick.nScore - stGame.nSpread) < stPick.nScore ){
					stPick.bIsWinning = true;
				}
				bPickIsLocked = true;
			}
			// determine if this pick is locked
			if( isDate(stGame.dtLock) and stGame.dtLock < rc.dNow ){
				bPickIsLocked = true;
			}
			// if we are allowing manual overrides - allow pick
			if( rc.stUser.bIsAdmin and rc.bManualOverridePicks ){
				bPickIsLocked = false;
			}
			local.showGame = false;
			if( !local.bIsCompare || (local.bIsCompare and bPickIsLocked) ) {
				local.bShowGame = true;
			}
		</cfscript>
		<cfif local.showGame>
			<tr class="game#((bPickIsLocked) ? ' locked' : '')#" data-id="#rc.arWeekGames[local.itm].nGameId#" data-nWeekID="#rc.nWeekID#">
				<cfif local.bShowDetails>
					<td>
						<cfif bPickIsLocked>&nbsp;<span class="fa fa-lock"></span></cfif>
					</td>
					<td>#stGame.nTiebreak#</td>
				</cfif>
				<!--- // render picks --->
				<td class="picks">
					<cfif rc.bIsLocked><span class="fa fa-info-circle fa-lg game-info icons"></span><cfelse><span class="fa fa-bar-chart-o fa-lg stats-info icons"></span></cfif>
					<button type="button" disabled="disabled" class="btn btn-xs
						#((stPick.bIsHome) ? 'home' : '')#
						<cfif stGame.bGameIsFinal>
							#((stPick.bIsWinning) ? ' btn-success' : ' btn-danger')#
						<cfelseif len(stGame.sGameStatus) gt 0>
							#((stPick.bIsWinning) ? ' btn-info' : ' btn-warning')#
						<cfelse>
							btn-default
						</cfif>">
						<cfif len(stPick.nRanking) gt 0>(#stPick.nRanking#) </cfif>#stPick.sName# #((len(stPick.sRecord) gt 0 ) ? "(" & stPick.sRecord & ")" : "")#
						<span class="badge">
							#(stPick.nID eq nFavoredTeam) ? '-' : '+'# #stGame.nSpread#
						</span>
					</button>
				</td>
				<cfif rc.bCanSetPicks>
					<td class="picks">
						<button type="button" disabled="disabled" class="btn btn-xs btn-sm btn-default #((stNotPick.bIsHome) ? 'home' : '')#">
							<cfif len(stNotPick.nRanking) gt 0>(#stNotPick.nRanking#) </cfif>#stNotPick.sName# #((len(stNotPick.sRecord) gt 0 ) ? "(" & stNotPick.sRecord & ")" : "")#
						</button>
					</td>
					<!--- // render controls --->
					<td class="change hidden">
						<span class="fa fa-bar-chart-o fa-lg stats-info icons"></span>
						<button data-id="#stFavorite.nID#" type="button" class="btn btn-xs #((stFavorite.bIsHome) ? 'home' : '')##((stFavorite.nID eq bPick) ? ' pick btn-success' : ' btn-default')#">
							<cfif len(stFavorite.nRanking) gt 0>(#stFavorite.nRanking#) </cfif>#stFavorite.sName# #((len(stFavorite.sRecord) gt 0 ) ? "(" & stFavorite.sRecord & ")" : "")#
							<span class="badge">
								#(stFavorite.nID eq nFavoredTeam) ? '-' : '+'# #stGame.nSpread#
							</span>
						</button>
					</td>
					<td class="change hidden">
						<button data-id="#stUnderdog.nID#" type="button" class="btn btn-xs #((stUnderdog.bIsHome) ? 'home' : '')##((stUnderdog.nID eq bPick) ? ' pick  btn-success' : ' btn-default')#">
							<cfif len(stUnderdog.nRanking) gt 0>(#stUnderdog.nRanking#) </cfif>#stUnderdog.sName# #((len(stUnderdog.sRecord) gt 0 ) ? "(" & stUnderdog.sRecord & ")" : "")#
						</button>
					</td>
				</cfif>
				<cfif local.bShowGameStatus>
					<td>
						<cfif len(stGame.sGameStatus) gt 0>
							#stPick.nScore# - #stNotPick.nScore# (#stGame.sGameStatus#)
						<cfelse>
							#dateFormat(sGameDate, "mm/dd/yyyy")#<cfif len(sGameTime) gt 0> #timeFormat(sGameTime, "hh:mm")# <cfif listFirst(sGameTime, ":") gt 11>PM<cfelse>AM</cfif> (<cfif structKeyExists(rc.stUser, "stSettings")
					and structKeyExists(rc.stUser.stSettings, "timezone")
					and compareNoCase(rc.stUser.stSettings.timezone, "Pacific") eq 0>PT<cfelse>ET</cfif>)</cfif>
						</cfif>
					</td>
				</cfif>
			</tr>
		</cfif>
		<!--- // <cfif local.itm eq 10>
			<tr>
				<td colspan="6" class="in-pick-ad">
					<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
					<ins class="adsbygoogle"
					     style="display:block"
					     data-ad-format="fluid"
					     data-ad-layout-key="-ej+6g-17-bz+qf"
					     data-ad-client="ca-pub-1027916687663589"
					     data-ad-slot="2382193092"></ins>
					<script>
    					 (adsbygoogle = window.adsbygoogle || []).push({});
					</script>
				</td>
			</tr>
		</cfif> --->
	</cfloop>
</cfoutput>

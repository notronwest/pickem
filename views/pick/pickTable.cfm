<cfoutput>
	<cfloop from="1" to="#arrayLen(rc.arWeekGames)#" index="local.itm">
		<!--- // determine who gets pick class --->
		<cfscript>
			stGame = rc.arWeekGames[local.itm];
			bPick = 0;
			// determine who the pick is
			if( structKeyExists(rc.stUserWeek.stPicks, rc.arWeekGames[local.itm].nGameID) ){
				bPick = rc.stUserWeek.stPicks[rc.arWeekGames[local.itm].nGameID];
			}
			stHome = {
				"sName" = stGame.sHomeTeam,
				"nID" = stGame.nHomeTeamID,
				"nScore" = stGame.nHomeScore,
				"bIsHome" = true,
				"bIsWinning" = false,
				"sClass" = "btn-default"
			};
			stAway = {
				"sName" = stGame.sAwayTeam,
				"nID" = stGame.nAwayTeamID,
				"nScore" = stGame.nAwayScore,
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
			}
		</cfscript>
		<tr class="game" data-id="#rc.arWeekGames[local.itm].nGameId#">
			<td>#local.itm#</td>
			<!--- // render picks --->
			<td class="picks">
				<button type="button" disabled="disabled" class="btn btn-xs
					#((stPick.bIsHome) ? 'home' : '')#
					<cfif stGame.bGameIsFinal>
						#((stPick.bIsWinning) ? ' btn-success' : ' btn-danger')#
					<cfelseif len(stGame.sGameStatus) gt 0>
						#((stPick.bIsWinning) ? ' btn-info' : ' btn-warning')#
					<cfelse>
						btn-default
					</cfif>">
					#stPick.sName#
					<span class="badge">
						#(stPick.nID eq nFavoredTeam) ? '-' : '+'# #stGame.nSpread#
					</span>
				</button>
			</td>
			<td class="picks">
				<button type="button" disabled="disabled" class="btn btn-xs btn-sm btn-default #((stNotPick.bIsHome) ? 'home' : '')#">
					#stNotPick.sName#
				</button>
			</td>
			<!--- // render controls --->
			<td class="change hidden">
				<button data-id="#stFavorite.nID#" type="button" class="btn btn-xs #((stFavorite.bIsHome) ? 'home' : '')##((stFavorite.nID eq bPick) ? ' pick btn-success' : ' btn-default')#">
					#stFavorite.sName#
					<span class="badge">
						#(stFavorite.nID eq nFavoredTeam) ? '-' : '+'# #stGame.nSpread#
					</span>
				</button>
			</td>
			<td class="change hidden">
				<button data-id="#stUnderdog.nID#" type="button" class="btn btn-xs #((stUnderdog.bIsHome) ? 'home' : '')##((stUnderdog.nID eq bPick) ? ' pick  btn-success' : ' btn-default')#">
					#stUnderdog.sName#
				</button>
			</td>
			<td>
				<cfif len(stGame.sGameStatus) gt 0>
					#stPick.nScore# - #stNotPick.nScore#
				<cfelse>
					#dateFormat(stGame.sGameDateTime, "mm/dd/yyyy")#
				</cfif>
			</td>
		</tr>
<!--- // 
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
--->
	</cfloop>
</cfoutput>
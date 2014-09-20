<cfparam name="local.bShowGameStatus" default="true">
<cfoutput>
	<cfloop from="1" to="#arrayLen(local.arWeekGames)#" index="local.itm">
		<!--- // determine who gets pick class --->
		<cfscript>
			stGame = local.arWeekGames[local.itm];
			bPick = 0;
			// determine who the pick is
			if( structKeyExists(local.stPicks, local.arWeekGames[local.itm].nGameID) ){
				bPick = local.stPicks[local.arWeekGames[local.itm].nGameID];
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
			<cfif compareNoCase(getFullyQualifiedAction(), "pick.set") eq 0>
				<td>#local.itm#</td>
			</cfif>
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
			<cfif compareNoCase(getFullyQualifiedAction(), "pick.set") eq 0>
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
			</cfif>
			<cfif local.bShowGameStatus>
				<td>
					<cfif len(stGame.sGameStatus) gt 0>
						#stPick.nScore# - #stNotPick.nScore# (#stGame.sGameStatus#)
					<cfelse>
						#dateFormat(stGame.sGameDateTime, "mm/dd/yyyy")#
					</cfif>
				</td>
			</cfif>
		</tr>
	</cfloop>
</cfoutput>
<cfparam name="local.bShowGameStatus" default="true">
<cfparam name="local.sCurrentGame" default="NCAA">
<cfparam name="local.bShowDetails" default="true">
<cfoutput>
	<cfif !listLen(structKeyList(local.stPicks))>
		<tr id="userPick">
			<td><h4>You have not made a pick for this week yet.</h4><td>
			<td colspan="4"></td>
		</tr>
	</cfif>
	<cfloop from="1" to="#arrayLen(local.arWeekGames)#" index="local.itm">
		<!--- // determine who gets pick class --->
		<cfscript>
			stGame = local.arWeekGames[local.itm];
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
				"sName" = stGame.sHomeTeam,
				"sMascot" = stGame.sHomeTeamMascot,
				"nID" = stGame.nHomeTeamID,
				"nScore" = stGame.nHomeScore,
				"nRanking" = stGame.nHomeTeamRanking,
				"sRecord" = stGame.sHomeTeamRecord,
				"bIsHome" = true,
				"bIsWinning" = false,
				"sClass" = "btn-default"
			};
			stAway = {
				"sName" = stGame.sAwayTeam,
				"sMascot" = stGame.sAwayTeamMascot,
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
				if( nFavoredTeam eq stPick.nID and stPick.nScore > stNotPick.nScore ){
					stPick.bIsWinning = true;
				} else if ( nFavoredTeam eq stNotPick.nID and stNotPick.nScore < stPick.nScore ){
					stPick.bIsWinning = true;
				}
				bPickIsLocked = true;
			}
			// determine if this pick is locked
			if( isDate(stGame.dtLock) and stGame.dtLock < rc.dNow ){
				bPickIsLocked = true;
			}
		</cfscript>

		<cfif bPick>
			<!--- // show the current pick --->
			<tr id="userPick">
				<td>
					Current Pick:<br/>
					<strong style="text-decoration:underline;" class="#((stUnderdog.bIsHome) ? 'home' : '')#">#stUnderdog.sName# #stUnderdog.sMascot# (-#stGame.nSpread#)</strong>
					vs. <span class="#((stFavorite.bIsHome) ? 'home' : '')#" style="font-weight: 100;">#stFavorite.sName# #stFavorite.sMascot#</span>
					<br/>
					<button disabled="disabled" class="btn <cfif stGame.bGameIsFinal>
						#((stPick.bIsWinning) ? ' btn-success' : ' btn-danger')#
					<cfelseif len(stGame.sGameStatus) gt 0>
						#((stPick.bIsWinning) ? ' btn-info' : ' btn-warning')#
					</cfif>">
						<cfif len(stGame.sGameStatus) gt 0>
								#stPick.nScore# - #stNotPick.nScore# (#stGame.sGameStatus#)
							<cfelse>
								#dateFormat(sGameDate, "mm/dd/yyyy")#
								<cfif len(sGameTime) gt 0>
									#timeFormat(sGameTime, "hh:mm")# <cfif listFirst(sGameTime, ":") gt 11>PM<cfelse>AM</cfif> (<cfif structKeyExists(rc.stUser, "stSettings")
						and structKeyExists(rc.stUser.stSettings, "timezone")
						and compareNoCase(rc.stUser.stSettings.timezone, "Pacific") eq 0>PT<cfelse>ET</cfif>)
								</cfif>
							</cfif>
					</button>
				</td>
				<td colspan="4"></td>
			</tr>
		</cfif>

		<!--- // build controls for picks --->
		<tr class="hidden game" data-id="#rc.arWeekGames[local.itm].nGameId#" data-nWeekID="#rc.nWeekID#">
			<!--- // <cfif local.bShowDetails>
				<td>
					<cfif bPickIsLocked>&nbsp;<span class="fa fa-lock"></span></cfif>
				</td>
				<td></td>
			</cfif> --->
			<!--- // render controls --->
			<td class="change">
				<button data-id="#stUnderdog.nID#" type="button" class="btn btn-xs #((stUnderdog.bIsHome) ? 'home' : '')##((stUnderdog.nID eq bPick) ? ' pick  btn-success' : ' btn-default')#">
					<cfif len(stUnderdog.nRanking) gt 0>(#stUnderdog.nRanking#) </cfif>#stUnderdog.sMascot# #((len(stUnderdog.sRecord) gt 0 ) ? "(" & stUnderdog.sRecord & ")" : "")#
				</button>
			</td>
			<td class="change">
				<!--- // hide charts for now 
				<span class="fa fa-bar-chart-o fa-lg stats-info icons"></span>
				--->
				<button disabled="disabled" class="btn btn-xs">
					#stFavorite.sMascot# #((len(stFavorite.sRecord) gt 0 ) ? "(" & stFavorite.sRecord & ")" : "")#
					<span class="badge">
						#(stFavorite.nID eq nFavoredTeam) ? '-' : '+'# #stGame.nSpread#
					</span>
				</button>
			</td>
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
	</cfloop>
</cfoutput>
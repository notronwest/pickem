<cfoutput>
<div id="setWeek" class="panel panel-default" data-id="#rc.oWeek.getNWeekID()#">
	<div class="panel-heading text-right">
		<form class="form-inline">
			<div class="input-group">
				<select id="sWeekURL" class="form-control input-sm" size="1">
					<cfloop from="1" to="#arrayLen(rc.arWeeks)#" index="local.itm">
						<option value="#buildURL('game.scoring')#&nWeekID=#rc.arWeeks[local.itm].getNWeekID()#"<cfif rc.oWeek.getNWeekID() eq rc.arWeeks[local.itm].getNWeekID()> selected="selected"</cfif>>
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
				<h3>This week is currently locked.  Would you like to override this lock to add/delete games?</h3>
				<blockquote>Note: deleting games that existed in the past could disrupt picks made by users</blockquote>
				<div class="input-group">
					<button id="overrideLock" class="btn btn-default btn-sm" data-url="#buildURL('game.scoring')#&nWeekID=#rc.oWeek.getNWeekID()#&bOverrideLock=true">Override Lock</button>
				</div>
			</div>
		<cfelse>
			<h1>#rc.oWeek.getSName()#</h1>
			<div id="games">
				<div class="text-right">
					<button class="save-scores btn btn-default btn-small" type="button">Save Scores</button>
					<!--- //<button class="calculate btn btn-default btn-small" type="button">Calculate</button> --->
				</div>
				<div class="table-responsive">
					<table class="table">
						<thead>
							<th>Favorite</th>
							<th>Score</th>
							<th>Underdog</th>
							<th>Score</th>
						</thead>
						<tbody>
							<cfloop from="1" to="#arrayLen(rc.arWeekGames)#" index="local.itm">
								<tr class="game" data-id="#rc.arWeekGames[local.itm].nGameID#">
									<cfif rc.arWeekGames[local.itm].sSpreadFavor eq "home">
										<td><label class="home">#rc.arWeekGames[local.itm].sHomeTeam# <span class="badge">+#rc.arWeekGames[local.itm].nSpread#</span></label></td>
										<td><input type="number" class="score control-sm home" data-id="#rc.arWeekGames[local.itm].nHomeTeamID#" value="#rc.arWeekGames[local.itm].nHomeScore#"></td>
										<td><label>#rc.arWeekGames[local.itm].sAwayTeam#</label></td>
										<td><input type="number" class="score control-sm away" data-id="#rc.arWeekGames[local.itm].nAwayTeamID#" value="#rc.arWeekGames[local.itm].nAwayScore#"></td>
									<cfelse>
										<td><label>#rc.arWeekGames[local.itm].sAwayTeam# <span class="badge">+#rc.arWeekGames[local.itm].nSpread#</span></label></td>
										<td><input type="number" class="score control-sm away" data-id="#rc.arWeekGames[local.itm].nAwayTeamID#" value="#rc.arWeekGames[local.itm].nAwayScore#"></td>
										<td><label class="home">#rc.arWeekGames[local.itm].sHomeTeam#</label></td>
										<td><input type="number" class="score control-sm home" data-id="#rc.arWeekGames[local.itm].nHomeTeamID#" value="#rc.arWeekGames[local.itm].nHomeScore#"></td>
									</cfif>
								<tr>
							</cfloop>
						</tbody>
					</table>
				</div>
				<div class="text-right">
					<button class="save-scores btn btn-default btn-small" type="button">Save Scores</button>
					<!--- // <button class="calculate btn btn-default btn-small" type="button">Calculate</button> --->
				</div>
			</div>
		</cfif>
	</div>
</div>
</cfoutput>
<div class="text-right"><a href="javascript:;" class="help">Help</a></div>
<div class="help hide">
	<h5>Scoring</h5>
	<ol>
		<li>Once the week is completed, come to this screen (again selecting the week you want to set scores for).</li>
		<li>Fill in the scores and click "Save Scores"</li>
		<li>The page will refresh click "Calculate" - this will calculate the scoring for the week</li>
		<li>Click on "standings" and you should see the updated week</li>
	</ol>
</div>
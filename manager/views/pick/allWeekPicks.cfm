<cfoutput>
	<div id="allPicks" class="panel panel-default" data-id="#rc.oWeek.getNWeekID()#">
		<div class="panel-heading text-right">
			<h4>All Picks #rc.oWeek.getSName()# <a href="javascript:window.print()"><span class="print fa fa-print"></span></a></h4>
			<form class="form-inline" role="form">
				<div class="form-group">
					<select id="sWeekURL" class="input-sm" size="1">
					<cfloop from="1" to="#arrayLen(rc.arWeeks)#" index="local.itm">
						<option value="#buildURL('pick.allWeekPicks')#&nWeekID=#rc.arWeeks[local.itm].getNWeekID()#"<cfif rc.oWeek.getNWeekID() eq rc.arWeeks[local.itm].getNWeekID()> selected="selected"</cfif>>
							#rc.arWeeks[local.itm].getSName()# (#dateFormat(rc.arWeeks[local.itm].getDStartDate(), "mm/dd")# - #dateFormat(rc.arWeeks[local.itm].getDEndDate(), "mm/dd")#)
						</option>
					</cfloop>
					</select>
        			<button class="btn btn-default change-week btn-sm" type="button">Go</button>
				</div>
			</form>
		</div>
		<div class="panel-body">
			<p><button id="backToMyPicks" class="btn btn-sm btn-default" type="button"><-- Back to my picks</button></p>
			<cfif !rc.bIsLocked>
				<div class="alert alert-warning">
					<h6>Come back after #getBeanFactory().getBean("commonService").dateTimeFormat(rc.dtPicksDue)# to see everyone's picks for this week.</h6>
				</div>
			<cfelse>
				<div class="table-responsive">
					<table id="allPicks" class="table hover order-column">
						<thead>
							<th>User</th>
							<th>Pick</th>
							<th>Spread</th>
							<th>Status</th>
						</thead>
						<tbody>
							<cfloop from="1" to="#arrayLen(rc.arWeekPicks)#" index="itm">
								<cfscript>
									stGame = rc.stWeekGames[rc.arWeekPicks[itm].getNGameID()];
									sClass = "default";
									if( compareNoCase(stGame.sSpreadFavor, "home") eq 0 ){
										sPick = stGame.sAwayTeam;
										sScore = stGame.nAwayScore & "-" & stGame.nHomeScore;
										// is the game winning
										if( stGame.nAwayScore gt stGame.nHomeScore ){
											sClass = "info";
										} else if ( !len(stGame.sGameStatus) ) {
											sClass = "warning";
										}
										if( stGame.nAwayScore gt stGame.nHomeScore and stGame.bGameIsFinal ){
											sClass = "success";
										} else if ( stGame.nAwayScore lte stGame.nHomeScore and stGame.bGameIsFinal ){
											sClass = "danger";
										}
									} else {
										sPick = stGame.sHomeTeam;
										sScore = stGame.nHomeScore & "-" & stGame.nAwayScore;
										// is the game winning
										if( stGame.nHomeScore gt stGame.nAwayScore ){
											sClass = "info";
										} else if ( !len(stGame.sGameStatus) ) {
											sClass = "warning";
										}

										if( stGame.nHomeScore gt stGame.nAwayScore and stGame.bGameIsFinal ){
											sClass = "success";
										} else if ( stGame.nHomeScore lte stGame.nAwayScore and stGame.bGameIsFinal ){
											sClass = "danger";
										}
									}
								</cfscript>
								<tr class="alert-#sClass#">
									<td>#getBeanFactory().getBean("userGateway").get(rc.arWeekPicks[itm].getNUserID()).getFullName()#</td>
									<td>#sPick#</td>
									<td>#stGame.nSpread#</td>
									<td><cfif len(stGame.sGameStatus)>#sScore#<cfelse>#stGame.sGameDateTime#</cfif></td>
								</tr>
							</cfloop>
						</tbody>
					</table>
				</div>
			</cfif>
		</div>
	</div>
	<script>var #toScript(rc.stUserWeek.stPicks, "stPicks")#</script>
</cfoutput>
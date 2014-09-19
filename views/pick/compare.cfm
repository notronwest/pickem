<cfoutput>
	<div id="admin" class="panel panel-default">
		<div class="panel-heading text-right">
			<form class="form-inline">
				<div class="form-group">
					<select id="sWeekURL" class="form-control input-sm" size="1">
					<cfloop from="1" to="#arrayLen(rc.arWeeks)#" index="local.itm">
						<option value="#buildURL('pick.set')#&nWeekID=#rc.arWeeks[local.itm].getNWeekID()#"<cfif rc.oWeek.getNWeekID() eq rc.arWeeks[local.itm].getNWeekID()> selected="selected"</cfif>>
							#rc.arWeeks[local.itm].getSName()# (#dateFormat(rc.arWeeks[local.itm].getDStartDate(), "mm/dd/yyyy")# - #dateFormat(rc.arWeeks[local.itm].getDEndDate(), "mm/dd/yyyy")#)
						</option>
					</cfloop>
					</select>
					<span class="form-group-btn">
						<button type="button" class="change-week btn btn-default btn-sm">Go</button>
					</span>
				</div>
			</form>
		</div>
		<div class="panel-body">
			<h1 data-id="#rc.oWeek.getNWeekID()#">#rc.oWeek.getSName()#</h1>
			<div class="row">
				<!--- // their picks --->
				<div class="col-md-6">
					<label for="nUserID">Pick a different user:</label>
					<div class="form-group">
					    <select class="form-control input-sm" id="nUserID">
					      <option value="" data-id="0">Select</option>
					      <cfloop from="1" to="#arrayLen(rc.arUsers)#" index="local.itm">
					        <option value="#rc.arUsers[local.itm].getNUserID()#" data-id="#rc.arUsers[local.itm].getNUserID()#"<cfif rc.nViewUserID eq rc.arUsers[local.itm].getNUserID()> selected="selected"</cfif>>#rc.arUsers[local.itm].getSFirstName()# #rc.arUsers[local.itm].getSLastName()# (#rc.arUsers[local.itm].getSEmail()#)</option>
					      </cfloop>
					    </select>
					    <span class="form-group-btn">
					    	<button id="compare" type="button" class="btn btn-default btn-sm">Compare</button>
					    </span>
					</div>
				</div>
			</div>
  			<!--- // if its locked then show the picks --->
  			<cfif rc.bIsLocked>
				<!--- // loop through the games and determine which ones this user won --->
				<div class="row">
					<!--- // their picks --->
					<div class="col-md-6">
						<h3>#rc.oViewUser.getSFirstName()#'s Picks</h3>
						<ul class="list-group">
							<cfloop from="1" to="#arrayLen(rc.arWeekGames)#" index="itm">
								<cfscript>
									bHasWinner = structKeyExists(rc.arWeekGames[itm], "nWinner");
									bHasPick = structKeyExists(rc.stViewUserWeek.stPicks, rc.arWeekGames[itm].nGameID);
									sClass = "none";
									bWasHomeTeam = 0;
									bHomeSpread = "-" & rc.arWeekGames[itm].nSpread;
									if( bHasPick ){
										sPick = rc.arWeekGames[itm].sHomeTeam;	
									} else {
										sPick = "N/A";
									}
									
									// determine the users pick
									if( bHasPick and rc.stViewUserWeek.stPicks[rc.arWeekGames[itm].nGameID] eq rc.arWeekGames[itm].nAwayTeamID ){
										sPick = rc.arWeekGames[itm].sAwayTeam;
									}
									// determine the spread
									if( compareNoCase(rc.arWeekGames[itm].sSpreadFavor, "home") ){
										bHomeSpread = "+" & rc.arWeekGames[itm].nSpread;
									}
									// determine whether or not they won
									if( structKeyExists(rc.stViewUSerWeek, "lstWins") and listFind(rc.stViewUserWeek.lstWins, rc.arWeekGames[itm].nGameID) ){
										sClass = "success";
									} else if( rc.arWeekGames[itm].bGameIsFinal ){
										sClass = "danger";
									} else {
										sClass = "default";
									}
								</cfscript>
								
								<li class="list-group-item list-group-item-#sClass#">
										<cfif bWasHomeTeam>
											#uCase(sPick)#
										<cfelse>
											#sPick#
										</cfif>
									 	<cfif bHasPick><span class="badge">#bHomeSpread#</span></cfif>
								</li>
							</cfloop>
						</ul>
					</div>
					<!--- // your picks --->
					<div class="col-md-6">
						<h3>Your Picks</h3>
						<ul class="list-group">
							<cfloop from="1" to="#arrayLen(rc.arWeekGames)#" index="itm">
								<cfscript>
									sHasWinner = structKeyExists(rc.arWeekGames[itm], "nWinner");
									sClass = "none";
									bWasHomeTeam = 0;
									bHomeSpread = "-" & rc.arWeekGames[itm].nSpread;
									sPick = rc.arWeekGames[itm].sHomeTeam;
									// determine the users pick
									if( rc.stUserWeek.stPicks[rc.arWeekGames[itm].nGameID] eq rc.arWeekGames[itm].nAwayTeamID ){
										sPick = rc.arWeekGames[itm].sAwayTeam;
									}
									// determine the spread
									if( compareNoCase(rc.arWeekGames[itm].sSpreadFavor, "home") ){
										bHomeSpread = "+" & rc.arWeekGames[itm].nSpread;
									}
									// determine whether or not they won
									if( listFind(rc.stUserWeek.lstWins, rc.arWeekGames[itm].nGameID) ){
										sClass = "success";
									} else if( rc.arWeekGames[itm].bGameIsFinal ){
										sClass = "danger";
									} else {
										sClass = "default";
									}
								</cfscript>
								
								<li class="list-group-item list-group-item-#sClass#">
										<cfif bWasHomeTeam>
											#uCase(sPick)#
										<cfelse>
											#sPick#
										</cfif>
									 	<span class="badge">#bHomeSpread#</span>
								</li>
							</cfloop>
						</ul>
					</div>
				</div>
			<cfelse>
				<p>&nbsp;</p>
				<div class="alert alert-warning" role="alert">
					<p>Sorry, you cannot compare untill the week picks are locked at #getBeanFactory().getBean("commonService").dateTimeFormat(rc.dtPicksDue)#.</p>
				</div>
			</cfif>
		</div>
	</div>
</cfoutput>
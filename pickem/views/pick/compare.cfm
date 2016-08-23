<cfoutput>
	<div id="admin" class="panel panel-default">
		<div class="panel-heading text-right">
			<form class="form-inline" role="form">
				<div class="form-group">
					<select id="sWeekURL" class="input-sm" size="1">
					<cfloop from="1" to="#arrayLen(rc.arWeeks)#" index="local.itm">
						<option value="#buildURL('pick.compare')#&nWeekID=#rc.arWeeks[local.itm].getNWeekID()#&nViewUserID=#rc.nViewUserID#"<cfif rc.oWeek.getNWeekID() eq rc.arWeeks[local.itm].getNWeekID()> selected="selected"</cfif>>
							#rc.arWeeks[local.itm].getSName()# (#dateFormat(rc.arWeeks[local.itm].getDStartDate(), "mm/dd")# - #dateFormat(rc.arWeeks[local.itm].getDEndDate(), "mm/dd")#)
						</option>
					</cfloop>
					</select>
					<button type="button" class="change-week btn btn-default btn-sm">Go</button>
				</div>
			</form>
		</div>
		<div class="panel-body">
			<h3 data-id="#rc.oWeek.getNWeekID()#">#rc.oWeek.getSName()#</h3>
			<div class="row">
				<form class="form-inline" role="form">
					<!--- // their picks --->
					<div class="col-md-6">
						<label for="nUserID">Pick a different user:</label>
						<div class="form-group">
						    <select class="input-xs" id="nUserID">
						      <option value="" data-id="0">Select</option>
						      <cfloop from="1" to="#arrayLen(rc.arUsers)#" index="local.itm">
						        <option value="#rc.arUsers[local.itm].getNUserID()#" data-id="#rc.arUsers[local.itm].getNUserID()#"<cfif rc.nViewUserID eq rc.arUsers[local.itm].getNUserID()> selected="selected"</cfif>>#rc.arUsers[local.itm].getSFirstName()# #rc.arUsers[local.itm].getSLastName()# (#rc.arUsers[local.itm].getSEmail()#)</option>
						      </cfloop>
						    </select>
					    	<button id="compare" type="button" class="btn btn-default btn-xs">Compare</button>
						</div>
					</div>
				</form>
			</div>
  			<!--- // if its locked then show the picks --->
  			<cfif rc.bIsLocked>
				<!--- // loop through the games and determine which ones this user won --->
				<div class="row">
					<div class="table-responsive">
						<table class="table">
							<thead>
								<tr>
									<th><h4>#rc.oViewUser.getSFirstName()#'s Picks</h4>
										<h5>Wins:<button class="alert-success btn btn-small" disabled="disabled"><strong>#listLen(rc.stViewUserWeek.lstWins)#</strong></button><cfif rc.stViewUserWeek.bAutoPick eq 1><button class="alert-info auto-picks btn btn-small" disabled="disabled"><em>Auto Picked</em></button></cfif></h5>
									</th> 
									<th><h4>Your Picks</h4>
										<h5>Wins:<button class="alert-success btn btn-small" disabled="disabled"><strong>#listLen(rc.stUserWeek.lstWins)#</strong></button><cfif rc.stUserWeek.bAutoPick eq 1><button class="alert-info auto-picks btn btn-small" disabled="disabled"><em>Auto Picked</em></button></cfif></h5>
									</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>											
										<table class="table">
											<cfscript>
												local.arWeekGames = rc.arWeekGames;
												local.stPicks = rc.stViewUserWeek.stPicks;
												// hide game status
												local.bShowGameStatus = false;
												// hide details
												local.bShowDetails = false;
												include "pickTable.cfm";
											</cfscript>
										</table>
									</td>
									<td>
										<table class="table">
											<cfscript>
												local.arWeekGames = rc.arWeekGames;
												local.stPicks = rc.stUserWeek.stPicks;
												// show game status
												local.bShowGameStatus = true;
												// hide details
												local.bShowDetails = false;
												include "pickTable.cfm";
											</cfscript>
										</table>
									</td>
								</tr>
							</tbody>
						</table>
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
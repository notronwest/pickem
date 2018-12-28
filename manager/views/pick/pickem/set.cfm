<cfoutput>
	<div id="picks" class="panel panel-default" data-id="#rc.oWeek.getNWeekID()#">
		<div class="panel-heading text-right">
			<h4>#rc.oWeek.getSName()# <a href="javascript:window.print()"><span class="print fa fa-print"></span></a></h4>
			<form class="form-inline" role="form">
				<div class="form-group">
					<select id="sWeekURL" class="input-sm" size="1">
					<cfloop from="1" to="#arrayLen(rc.arWeeks)#" index="local.itm">
						<option value="#buildURL('pick.set')#&nWeekID=#rc.arWeeks[local.itm].getNWeekID()#"<cfif rc.oWeek.getNWeekID() eq rc.arWeeks[local.itm].getNWeekID()> selected="selected"</cfif>>
							#rc.arWeeks[local.itm].getSName()# (#dateFormat(rc.arWeeks[local.itm].getDStartDate(), "mm/dd")# - #dateFormat(rc.arWeeks[local.itm].getDEndDate(), "mm/dd")#)
						</option>
					</cfloop>
					</select>
        			<button class="btn btn-default change-week btn-sm" type="button">Go</button>
				</div>
			</form>
		</div>
		<div class="panel-body">
			<!--- // if the week is locked and the user has no picks then don't show anything --->
			<cfif rc.bIsLocked and !rc.bUserHasPicks and !rc.bUserAutoPicked>
				<div class="alert alert-danger">
					Sorry, you did not make picks this week. When the week is over you will be awarded the lowest amount of correct picks.
				</div>
			<cfelse>
				<!--- // if the week is locked --->
				<cfif rc.bIsLocked>
					<div class="alert alert-warning">
						<h6>This week is locked and no changes to your picks can be made at this time.</h6>
					</div>
				</cfif>
				<cfif !rc.bCorrectNumberOfPicks>
					<div class="alert alert-danger">
						<h6>Something went wrong with your picks. Please try and make your picks again. If this error persists please contact us.</h6>
					</div>
				</cfif>
				<h4>Wins:<button class="alert-success btn btn-small" disabled="disabled"><strong>#listLen(rc.stUserWeek.lstWins)#</strong></button><cfif rc.bUserAutoPicked><button class="alert-info auto-picks btn btn-small" disabled="disabled"><em>Auto Picked: #rc.stUser.stSettings.autopick#</em></button></cfif></h4>

				<!--- // <h4><div class="text-left">
					<cfif listLen(rc.stUserWeek.lstWins)>
						<span class="alert-info">Total wins this week: #listLen(rc.stUserWeek.lstWins)#</span>
					</cfif>
				</div></h4> --->
				<cfif !rc.bIsLocked><p>
					Picks can be made up until #getBeanFactory().getBean("commonService").dateTimeFormat(rc.dtPicksDue)#
				</p></cfif>

				<div class="text-right">
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
							<th></th>
							<cfif rc.bUserHasPicks>
								<th class="picks">Pick (home team in CAPS)</th>
								<th class="picks">Opponent</td>
							<cfelse>
								<th class="picks">Away</th>
								<th class="picks">Home</td>
							</cfif>
							<th class="change hidden">Favorite (home team in CAPS)</th>
							<th class="change hidden">Underdog</th>
							<th>Game Status</th>
						</thead>
						<tbody>
							<cfscript>
								// set the games from the week
								local.arWeekGames = rc.arWeekGames;
								// set the picks for the user
								local.stPicks = rc.stUserWeek.stPicks;
								// start rows as ncaa
								local.sCurrentGame = "NCAA";
								// show detail
								local.bShowDetails = true;
								// include main table
								include "pickTable.cfm";
							</cfscript>
						</tbody>
					</table>
				</div>
				<cfif !rc.bIsLocked><div class="text-right page-controls">
					<button class="make-changes btn btn-default btn-small" title="Click here to make changes to your picks" type="button"><cfif rc.bUserHasPicks>Change Picks<cfelse>Make Picks</cfif></button>
					<button class="cancel btn btn-default btn-small hidden" type="button">Cancel</button>
					<button class="save btn btn-default btn-small hidden" type="button">Save Picks</button>
				</div></cfif>
				<cfif rc.bIsLocked>
					<div class="bs-callout bs-callout-info"><span class="fa fa-lock"></span> - indicates this pick is locked</div>
				</cfif>
			</cfif>
		</div>
	</div>
	<script>var #toScript(rc.stUserWeek.stPicks, "stPicks")#</script>
</cfoutput>
<!--- // put up message for picks saved --->
<cfif rc.bSaved><script> docReady(function(){ setMessage("Picks Saved"); });</script></cfif>

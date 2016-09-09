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
			<!--- // if the week is locked --->
			<cfif rc.bIsLocked>
				<div class="alert alert-warning">
					<h6>This week is locked and no changes to your picks can be made at this time.</h6>
				</div>
			</cfif>
			<h4>Points:<button class="alert-success btn btn-small" disabled="disabled"><strong>#listLen(rc.stUserWeek.lstWins)#</strong></button><cfif rc.bUserAutoPicked><button class="alert-info auto-picks btn btn-small" disabled="disabled"><em>Auto Picked: #rc.stUser.stSettings.autopick#</em></button></cfif></h4>

			<!--- // <h4><div class="text-left">
				<cfif listLen(rc.stUserWeek.lstWins)>
					<span class="alert-info">Total wins this week: #listLen(rc.stUserWeek.lstWins)#</span>
				</cfif>
			</div></h4> --->
			<cfif !rc.bIsLocked><p>
				Your pick can be made up until #getBeanFactory().getBean("commonService").dateTimeFormat(rc.dtPicksDue)#
			</p></cfif>

			<div class="table-responsive">
				<table class="table">
					<thead>
						<th></th>
						<th></th>
						<th>Underdog (home team in CAPS)</th>
						<th>Favorite</th>
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
							
							include "pickTable.cfm";
						</cfscript>
					</tbody>	
				</table>
			</div>
			<cfif !rc.bIsLocked><div class="page-controls">
				<button class="make-changes btn btn-default btn-small" title="Click here to make changes to your picks" type="button"><cfif rc.bUserHasPicks>Change Pick<cfelse>Make Pick</cfif></button>
				<button class="cancel btn btn-default btn-small hidden" type="button">Cancel</button>
				<button class="save btn btn-default btn-small hidden" type="button">Save Pick</button>
			</div></cfif>
			<div>
				<br/>
				<a href="javascript:;" class="help">Help</a>
				<div class="help hide">
					<h5>Picks</h5>
					<ol>
						<li>Use this section to make your pick for the upcoming week</li>
						<li>Click "Change Pick/Make Pick" if you would like to change/make your pick
						<li>Once you are "Making changes", simply click on the underdog team that you would like to win. Once clicked the team name will highlight in green.</li>
						<li>Once you have made your pick, click the "Save Pick" button</li>
						<li>You will be able to make unlimited changes to your pick up until the time that the picks are frozen for the week (noted at the top of the page)</li>
					</ol>
				</div>
			</div>
			<cfif rc.bIsLocked>
				<div class="bs-callout bs-callout-info"><span class="fa fa-lock"></span> - indicates this pick is locked</div>
			</cfif>
		</div>
	</div>
	<script>var #toScript(rc.stUserWeek.stPicks, "stPicks")#</script>
</cfoutput>
<!--- // put up message for picks saved --->
<cfif rc.bSaved><script> docReady(function(){ setMessage("Picks Saved"); });</script></cfif>
<cfif structKeyExists(rc.stGameStats, "arHomeTeam")>
	<cfoutput>
		<cfscript>
			local.bPicksMade = false;
			local.nHomeTeamPicks = arrayLen(rc.stGameStats.arHomeTeam);
			local.nAwayTeamPicks = arrayLen(rc.stGameStats.arAwayTeam);
			local.nTotalPicks = local.nHomeTeamPicks + local.nAwayTeamPicks;
			if( local.nTotalPicks gt 0 ){
				local.nHomeTeamPercentage = numberFormat((local.nHomeTeamPicks/local.nTotalPicks)*100, '__');
				local.nAwayTeamPercentage = numberFormat((local.nAwayTeamPicks/local.nTotalPicks)*100, '__');
				local.sHomeClass = "progress-bar-success";
				local.sAwayClass = "progress-bar-warning";
				if( local.nHomeTeamPercentage lt local.nAwayTeamPercentage ){
					local.sHomeClass = "progress-bar-warning";
					local.sAwayClass = "progress-bar-success";
				} else if ( local.nHomeTeamPercentage eq local.nAwayTeamPercentage ){
					local.sAwayClass = "progress-bar-success";
				}
				local.bPicksMade = true;
			}
		</cfscript>
		<div class="panel-body">
			<cfif local.bPicksMade>
				<div class="row">
					<div class="col-md-12">
						<h5>#rc.stGame.sGameDateTime#</h5>
					</div>
				</div>
				<div class="row">
					<div class="col-md-4">
						<h4>#rc.stGame.sAwayTeam# <span class="badge">
						#(rc.stGame.sSpreadFavor eq "away") ? '-' : '+'# #rc.stGame.nSpread#
					</span></h4>
					</div>
					<div class="col-md-8">
						<div class="progress">
						  <div class="progress-bar #local.sAwayClass#" role="progressbar" aria-valuenow="#local.nAwayTeamPercentage#" aria-valuemin="0" aria-valuemax="100" style="width: #local.nAwayTeamPercentage#%;">
						    #local.nAwayTeamPercentage#%
						  </div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-md-12">
						<h5>vs.</h5>
					</div>
				</div>
	  			<div class="row">
					<div class="col-md-4">
						<h4>#rc.stGame.sHomeTeam#</h4>
					</div>
					<div class="col-md-8">
						<div class="progress">
						  <div class="progress-bar #local.sHomeClass#" role="progressbar" aria-valuenow="#local.nHomeTeamPercentage#" aria-valuemin="0" aria-valuemax="100" style="width: #local.nHomeTeamPercentage#%;">
						    #local.nHomeTeamPercentage#%
						  </div>
						</div>
					</div>
				</div>
			<cfelse>
				Sorry no game stats available at this time
			</cfif>
		</div>
	</cfoutput>
<cfelse>
	Sorry no game stats available at this time
</cfif>
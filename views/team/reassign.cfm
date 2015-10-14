<cfoutput>
<div class="panel panel-default">
	<div class="panel-heading">Reassign Team</div>
	<div class="panel-body">
		<cfif arrayLen(rc.arGames) gt 0>
			<form id="reassign" action="#buildURL('team.reassign')#" method="post">
				<div class="alert alert-warning">The team #rc.oTeam.getSName()# is currently being used in #arrayLen(rc.arGames)# game(s). Before you can delete this team you will need to reassign this team to another team.</div>
				<div class="form-group">
					<label for="sName">New Team: </label>
					<select id="nNewTeamID" name="nNewTeamID" class="form-control" size="1">
						<option value="">Select</option>
						<cfloop from="1" to="#arrayLen(rc.arTeams)#" index="local.itm">
							<option value="#rc.arTeams[local.itm].getNTeamID()#">#rc.arTeams[local.itm].getSName()#</option>
						</cfloop>
					</select>
				</div>
				<div class="form-group text-right">
					<button type="button" class="delete btn btn-default">Reassign</button> <button type="button" class="cancel btn btn-default">Cancel</button>
				</div>
				<input type="hidden" id="nTeamID" name="nTeamID" value="#rc.oTeam.getNTeamID()#"/>
				<input type="hidden" id="sTeamName" value="#rc.oTeam.getSName()#"/>
				<input type="hidden" name="bProcess" value="true"/>
			</form>
		<cfelse>
			<form id="reassign" action="#buildURL('team.delete')#" method="post">
				<div class="alert alert-warning">The team #rc.oTeam.getSName()# isn't being used. You can simply delete it</div>
				<div class="form-group text-right">
					<button type="button" class="delete btn btn-default">Delete</button> <button type="button" class="cancel btn btn-default">Cancel</button>
				</div>
				<input type="hidden" id="nTeamID" name="nTeamID" value="#rc.oTeam.getNTeamID()#"/>
				<input type="hidden" id="sTeamName" value="#rc.oTeam.getSName()#"/>
				<input type="hidden" name="bProcess" value="true"/>
			</form>

		</cfif>
	</div>
</div>
</cfoutput>
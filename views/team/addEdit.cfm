<cfoutput><form id="addEditTeam" action="#buildURL('team.save')#" method="post">
<div class="panel panel-default">
	<div class="panel-heading"><cfif rc.oTeam.getNTeamID() eq 0>Add<cfelse>Edit</cfif> Team</div>
	<div class="panel-body">
		<div>
			<span class="hide error alert alert-warning"></span> 
				<div class="form-group">
					<label for="sName">Name: </label>
					<input type="text" id="sName" name="sName" class="form-control" value="#rc.oTeam.getSName()#"/>
				</div>
				<div class="form-group">
					<label for="sName2">Name: (alt1) </label>
					<input type="text" id="sName2" name="sName2" class="form-control" value="#rc.oTeam.getSName2()#"/>
				</div>
				<div class="form-group">
					<label for="sName3">Name: (alt2) </label>
					<input type="text" id="sName3" name="sName3" class="form-control" value="#rc.oTeam.getSName3()#"/>
				</div>
				<div class="form-group">
					<label for="sURL">URL: </label>
					<input type="text" id="sURL" name="sURL" class="form-control" value="#rc.oTeam.getSURL()#"/>
				</div>
				<div class="form-group text-right">
					<button type="button" class="save btn btn-default">Save</button> <button type="button" class="cancel btn btn-default">Cancel</button>
				</div>
			<input type="hidden" id="nTeamID" name="nTeamID" value="#rc.oTeam.getNTeamID()#"/>
		</div>
	</div>
</div></form>
</cfoutput>
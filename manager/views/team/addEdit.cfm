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
					<label for="sName2">Alternate Name: (e.g. Florida St.) </label>
					<input type="text" id="sName2" name="sName2" class="form-control" value="#rc.oTeam.getSName2()#"/>
				</div>
				<div class="form-group">
					<label for="sName3">Alternate Name: (e.g. Fl State.) </label>
					<input type="text" id="sName3" name="sName3" class="form-control" value="#rc.oTeam.getSName3()#"/>
				</div>
				<div class="form-group">
					<label for="sName4">Alternate Name: (e.g. Fl St.) </label>
					<input type="text" id="sName4" name="sName4" class="form-control" value="#rc.oTeam.getSName4()#"/>
				</div>
				<div class="form-group">
					<label for="sMascot">Mascot: (e.g. Seminoles)</label>
					<input type="text" id="sMascot" name="sMascot" class="form-control" value="#rc.oTeam.getSMascot()#"/>
				</div>
				<div class="form-group">
					<label for="sURL">URL: </label>
					<input type="text" id="sURL" name="sURL" class="form-control" value="#rc.oTeam.getSURL()#"/>
				</div>
				<div class="form-group">
					<label for="nDonBestID">Don Best ID: </label>
					<input type="text" id="nDonBestID" name="nDonBestID" class="form-control" value="#rc.oTeam.getNDonBestID()#"/>
				</div>
				<div class="form-group">
					<label for="nType">Type: </label>
					<select name="nType" id="nType" class="form-control">
						<option value="0">Select</option>
						<option value="1"<cfif rc.oTeam.getNType() eq 1> selected="selected"</cfif>>NCAA</option>
						<option value="2"<cfif rc.oTeam.getNType() eq 2> selected="selected"</cfif>>NFL</option>
					</select>
				</div>
				<div class="form-group text-right">
					<button type="button" class="save btn btn-default">Save</button> <button type="button" class="cancel btn btn-default">Cancel</button>
				</div>
			<input type="hidden" id="nTeamID" name="nTeamID" value="#rc.oTeam.getNTeamID()#"/>
		</div>
	</div>
</div></form>
</cfoutput>
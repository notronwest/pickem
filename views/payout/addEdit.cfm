<cfset local.nTotalPurse = rc.oCurrentSeason.getNTotalPurse()>
<cfoutput><form id="addEditPayout" action="#buildURL('payout.save')#" method="post">
<div class="panel panel-default">
	<div class="panel-heading"><cfif isNull(rc.oPayout.getNPayoutID())>Add<cfelse>Edit</cfif></div>
	<div class="panel-body">
		<div>
			<span class="hide error alert alert-warning"></span>
				<div class="form-group">
					<label for="sName">Name: </label>
					<input type="text" id="sName" name="sName" class="form-control" value="#rc.oPayout.getSName()#"/>
					<abbr>E.g. Second Place</abbr>
				</div>
				<div class="form-group">
					<label for="nDefaultPercent">Default Percentage: </label>
					<input type="text" id="nDefaultPercent" name="nDefaultPercent" class="form-control control-md" value="#rc.oPayout.getNDefaultPercent()#"/>
				</div>
				<div class="form-group">
					<label for="sType">Type: </label>
					<select name="sType" size="1" class="form-control">
						<option value="">--Select--</option>
						<option value="weekly"<cfif compareNoCase(rc.oPayout.getSType(), "weekly") eq 0> selected="selected"</cfif>>Weekly (awarded each week)</option>
						<option value="season"<cfif compareNoCase(rc.oPayout.getSType(), "season") eq 0> selected="selected"</cfif>>Season (awarded once a season)</option>
						<option value="finalWeek"<cfif compareNoCase(rc.oPayout.getSType(), "finalWeek") eq 0> selected="selected"</cfif>>Final Week (awarded in the final week)</option>
					</select>
				</div>
				<div class="form-group">
					<label for="nPlace">Place: </label>
					<input type="text" id="nPlace" name="nPlace" class="form-control control-md" value="#rc.oPayout.getNPlace()#"/>
					<abbr>E.g. 2</abbr>
				</div>
				<div class="form-group text-right">
					<button type="submit" class="save btn btn-default">Save</button> <button type="button" class="cancel btn btn-default">Cancel</button>
				</div>
			<input type="hidden" id="nPayoutID" name="nPayoutID" value="#rc.oPayout.getNPayoutID()#"/>
		</div>
	</div>
</div></form>
</cfoutput>
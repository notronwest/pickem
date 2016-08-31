<cfoutput><form id="addEditSeason" action="#buildURL('season.save')#" method="post">
<div class="panel panel-default">
	<div class="panel-heading"><cfif rc.oSeason.getNSeasonID() eq 0>Add<cfelse>Edit</cfif> Season</div>
	<div class="panel-body">
		<div>
			<span class="hide error alert alert-warning"></span>
				<div class="form-group">
					<label for="sLeagueID">League: </label>
					<select name="sLeagueID" id="sLeagueID" size="1" class="form-control">
						<cfloop from="1" to="#arrayLen(rc.arLeagues)#" index="local.itm">
							<option value="#rc.arLeagues[local.itm].getSLeagueID()#"<cfif rc.oSeason.getSLeagueID() eq rc.arLeagues[local.itm].getSLeagueID()> selected="selected"</cfif>>#rc.arLeagues[local.itm].getSName()#</option>
						</cfloop>
					</select>
				</div>
				<div class="form-group">
					<label for="sFirstName">Name: </label>
					<input type="text" id="sName" name="sName" class="form-control" value="#rc.oSeason.getSName()#"/>
				</div>
				<div class="form-group">
					<label for="nSubscriptionAmount">Subscription Amount: </label>
					<input type="text" id="nSubscriptionAmount" name="nSubscriptionAmount" class="form-control" value="#rc.oSeason.getNSubscriptionAmount()#"/>
				</div>
				<div class="form-group">
					<label for="nTotalCost">Total Cost: </label>
					<input type="text" id="nTotalCost" name="nTotalCost" class="form-control" value="#rc.oSeason.getNTotalCost()#"/>
				</div>
				<div class="form-group">
					<label for="dtStart">Start Date: </label>
					<input type="text" id="dtStart" name="dtStart" class="form-control date" value="#rc.oSeason.getDTStart()#"/>
				</div>
				<div class="form-group">
					<label for="dtEnd">End Date: </label>
					<input type="text" id="dtEnd" name="dtEnd" class="form-control date" value="#rc.oSeason.getDTEnd()#"/>
				</div>

				<div class="form-group">
					<label for="sPaymentText">Payment Text: </label>
					<input type="text" id="sPaymentText" name="sPaymentText" class="form-control" value="#rc.oSeason.getSPaymentText()#"/>
				</div>
				<div class="form-group text-right">
					<button type="button" class="save btn btn-default">Save</button> <button type="button" class="cancel btn btn-default">Cancel</button>
				</div>
			<input type="hidden" id="nSeasonID" name="nSeasonID" value="#rc.oSeason.getNSeasonID()#"/>
		</div>
	</div>
</div></form>
</cfoutput>
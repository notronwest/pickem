<cfset local.nTotalPurse = rc.oCurrentSeason.getNTotalPurse()>
<cfoutput><form id="addEditSeasonPayout" action="#buildURL('seasonPayout.save')#" method="post">
<div class="panel panel-default">
	<div class="panel-heading"><cfif isNull(rc.oSeasonPayout.getNSeasonPayoutID())>Add<cfelse>Edit</cfif></div>
	<div class="panel-body">
		<div>
			<div class="alert alert-info">#dollarFormat((rc.oCurrentSeason.getNTotalPurse() - rc.nAssignedPurse))# of the total purse of #dollarFormat(rc.oCurrentSeason.getNTotalPurse())# is available to be assigned</div>
			<span class="hide error alert alert-warning"></span>
			<div class="form-group">
				<label for="nPayoutID">Payout: </label>
				<cfif isNull(rc.oSeasonPayout.getNPayoutID())>
					<select name="nPayoutID" id="nPayoutID" size="1" class="form-control">
						<option value="">--Select--</option>
						<cfloop from="1" to="#arrayLen(rc.arAvailablePayouts)#" index="local.itm">
							<option value="#rc.arAvailablePayouts[local.itm].getNPayoutID()#" data-percent="#rc.arAvailablePayouts[local.itm].getNDefaultPercent()#"<cfif rc.arAvailablePayouts[local.itm].getNPayoutID() eq rc.oSeasonPayout.getNPayoutID()> selected="selected"</cfif>>#rc.arAvailablePayouts[local.itm].getSName()# (#rc.arAvailablePayouts[local.itm].getSType()#)</option>
						</cfloop>
					</select>
				<cfelse>
					<p class="form-control-static">#rc.oPayout.getSName()# (#rc.oPayout.getSType()#)</p>
				</cfif>
			</div>
			<div class="form-group">
				<label for="nAmount">Amount: </label>
				<input type="text" id="nAmount" name="nAmount" class="form-control control-md" value="#rc.oSeasonPayout.getNAmount()#"/>
				<abbr>E.g. 2</abbr>
			</div>
			<div class="form-group text-right">
				<button type="submit" class="save btn btn-default">Save</button> <button type="button" class="cancel btn btn-default">Cancel</button>
			</div>
			<input type="hidden" id="nSeasonPayoutID" name="nSeasonPayoutID" value="#rc.oSeasonPayout.getNSeasonPayoutID()#"/>
			<input type="hidden" id="nSeasonID" name="nSeasonID" value="#rc.oCurrentSeason.getNSeasonID()#"/>
		</div>
	</div>
</div></form>
</cfoutput>
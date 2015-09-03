<cfoutput>
	<input type="hidden" id="nPurse" value="#rc.oCurrentSeason.getNCalculatedPurse()#"/>
	<div id="admin" class="panel panel-default">
		<div class="panel-heading">
			Season SeasonPayouts - these are the payouts defined for this season
		</div>
		<div class="panel-body">
			<div class="text-right"><button class="add-seasonPayout btn btn-default btn-small" type="button">Add</button><button class="save-all btn btn-default btn-small hide" type="button">Save All</button></div>
			<cfif structKeyExists(rc, "sMessage") and len(rc.sMessage) gt 0><div class="alert alert-info alert-dismissable"><button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>#rc.sMessage#</div></cfif>
			<table class="users table">
				<thead>
					<tr>
						<th>Name</th>
						<th>Type</th>
						<th>Amount (Available - $ <span id="available"></span>)</th>
						<th>Adjust Amount</th>
						<th></th>
					</tr>
				</thead>
				<tbody>
					<tr class="allocated-too-much alert alert-danger hide">
						<td colspan="5">You have allocated to much to your payouts. Please adjust.</td>
					</tr>
					<tr class="remind-to-save alert alert-info hide">
						<td colspan="5">You have made changes to the amounts, please remember to click "Save All" above.</td>
					</tr>
					<tr class="saved alert alert-success hide">
						<td colspan="5">Your changes have been saved.</td>
					</tr>
					<cfloop from="1" to="#arrayLen(rc.arSeasonPayouts)#" index="local.itm">
						<tr>
							<td>#rc.arSeasonPayouts[local.itm].oPayout.getSName()#</td>
							<td>#rc.arSeasonPayouts[local.itm].oPayout.getSType()#</td>
							<td><input type="number" class="form-control control-md payout" data-id="#rc.arSeasonPayouts[local.itm].getNSeasonPayoutID()#" data-type="#rc.arSeasonPayouts[local.itm].oPayout.getSType()#" value="#rc.arSeasonPayouts[local.itm].getNAmount()#"/>
							</td>
							<td>
								<ul class="fa-ul">
									<li class="icons fa-li fa fa-plus-square increase"></li>
									<li class="icons fa-li fa fa-minus-square decrease"></li>
								</ul>
							</td>
							<td>
								<span class="fa fa-edit edit-seasonPayout icons fa-fw fa-lg" title="Edit Season Payout"></span>
								<span class="fa fa-trash-o delete-seasonPayout icons fa-fw fa-lg" title="Delete Season Payout"></span>
								<input type="hidden" class="nSeasonPayoutID" value="#rc.arSeasonPayouts[local.itm].getNSeasonPayoutID()#"/></td>
						</tr>
					</cfloop>
				</tbody>
			</table>
		</div>
	</div>
</cfoutput>
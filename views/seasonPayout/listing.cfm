<cfoutput>
	<div id="admin" class="panel panel-default">
		<div class="panel-heading">
			Season SeasonPayouts - these are the payouts defined for this season
		</div>
		<div class="panel-body">
			<div class="text-right"><button class="add-seasonPayout btn btn-default btn-small" type="button">Add</button></div>
			<cfif structKeyExists(rc, "sMessage") and len(rc.sMessage) gt 0><div class="alert alert-info alert-dismissable"><button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>#rc.sMessage#</div></cfif>
			<table class="users table">
				<thead>
					<tr>
						<th>Name</th>
						<th>Type</th>
						<th>Amount (Available - #dollarFormat(rc.oCurrentSeason.getNCalculatedPurse())#)</th>
						<th>Adjust Amount</th>
						<th></th>
					</tr>
				</thead>
				<tbody>
					<cfloop from="1" to="#arrayLen(rc.arSeasonPayouts)#" index="local.itm">
						<tr>
							<td>#rc.arSeasonPayouts[local.itm].oPayout.getSName()#</td>
							<td>#rc.arSeasonPayouts[local.itm].oPayout.getSType()#</td>
							<td><input type="number" class="form-control control-md payout" data-id="#rc.arSeasonPayouts[local.itm].oPayout.getNPayoutID()#" value="#rc.arSeasonPayouts[local.itm].getNAmount()#"/></td>
							<td>
								<ul class="fa-ul">
									<li class="fa-li fa fa-plus-square"></li>
									<li class="fa-li fa fa-minus-square"></li>
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
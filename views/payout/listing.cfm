<cfoutput>
	<div id="admin" class="panel panel-default">
		<div class="panel-heading">
			Available Payouts - define the payouts available for the system
		</div>
		<div class="panel-body">
			<div class="text-right"><button class="add-payout btn btn-default btn-small" type="button">Add</button><button class="set-payouts btn btn-default btn-small">Set Payouts for Season</button></div>
			<cfif structKeyExists(rc, "sMessage") and len(rc.sMessage) gt 0><div class="alert alert-info alert-dismissable"><button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>#rc.sMessage#</div></cfif>
			<table class="users table">
				<thead>
					<tr>
						<th>Name</th>
						<th>Default Percentage</th>
						<th>Type</th>
						<th>Place</th>
						<th></th>
					</tr>
				</thead>
				<tbody>
					<cfloop from="1" to="#arrayLen(rc.arPayouts)#" index="local.itm">
						<tr>
							<td>#rc.arPayouts[local.itm].getSName()#</td>
							<td>#rc.arPayouts[local.itm].getNDefaultPercent()#</td>
							<td>#rc.arPayouts[local.itm].getSType()#</td>
							<td>#rc.arPayouts[local.itm].getNPlace()#</td>
							<td>
								<span class="fa fa-edit edit-payout icons fa-fw fa-lg" title="Edit payout"></span>
								<span class="fa fa-trash-o delete-payout icons fa-fw fa-lg" title="Delete payout"></span>
								<input type="hidden" class="nPayoutID" value="#rc.arPayouts[local.itm].getNPayoutID()#"/></td>
						</tr>
					</cfloop>
				</tbody>
			</table>
		</div>
	</div>
</cfoutput>
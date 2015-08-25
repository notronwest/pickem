<cfoutput>
	<div id="admin" class="panel panel-default">
		<div class="panel-heading text-right">
			Seasons
		</div>
		<div class="panel-body">
			<div class="text-right"><button class="add-season btn btn-default btn-small" type="button">Add</button></div>
			<cfif structKeyExists(rc, "sMessage") and len(rc.sMessage) gt 0><div class="alert alert-info alert-dismissable"><button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>#rc.sMessage#</div></cfif>
			<table class="users table">
				<thead>
					<tr>
						<th>Name</th>
						<th>Total Purse</th>
						<th>Costs</th>
						<th>Start Date</th>
						<th>End Date</th>
						<th></th>
					</tr>
				</thead>
				<tbody>
					<cfloop from="1" to="#arrayLen(rc.arSeasons)#" index="local.itm">
						<tr>
							<td>#rc.arSeasons[local.itm].getSName()#</td>
							<td>#dollarFormat(rc.arSeasons[local.itm].getNTotalPurse())#</td>
							<td>#dollarFormat(rc.arSeasons[local.itm].getNTotalCost())#</td>
							<td>#rc.arSeasons[local.itm].getDTStart()#</td>
							<td>#rc.arSeasons[local.itm].getDTEnd()#</td>
							<td>
								<span class="fa fa-edit edit-season icons fa-fw fa-lg" title="Edit season"></span>
								<span class="fa fa-dollar payout-season icons fa-fw fa-lg" title="Payouts for this season"></span>
								<span class="fa fa-trash-o delete-season icons fa-fw fa-lg" title="Delete season"></span>
								<input type="hidden" class="nSeasonID" value="#rc.arSeasons[local.itm].getNSeasonID()#"/></td>
						</tr>
					</cfloop>
				</tbody>
			</table>
		</div>
	</div>
</cfoutput>
<div id="notifys" class="panel panel-default">
	<div class="panel-heading text-right">
		<h2 class="left">Manage Notifications<h2>
		<div class="form-group">
			<button type="button" class="add-notify btn btn-default btn-sm">Add Notification</button>
		</div>
	</div>
	<div class="panel-body">
		<div class="table-responsive">
			<table class="table">
				<thead>
					<tr>
						<th>Name</th>
						<th>Setting</th>
						<th></th>
					</tr>
				</thead>
				<tbody>
					<cfloop from="1" to="#arrayLen(rc.arNotifications)#" index="itm">
						<cfoutput><tr data-id="#rc.arNotifications[itm].getNNotifyID()#">
							<td>#rc.stOptions[rc.arNotifications[itm].getNOptionID()].sShortName#</td>
							<td class="notify-actions">
								<span class="fa fa-edit edit icons fa-fw fa-lg">&nbsp;</span><span class="fa fa-trash-o delete icons fa-fw fa-lg">&nbsp;</span>
							</td>
						</tr></cfoutput>
					</cfloop>
				</tbody>
			</table>
		</div>
	</div>
</div>
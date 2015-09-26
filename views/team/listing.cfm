<cfoutput>
	<div id="admin" class="panel panel-default">
		<div class="panel-heading text-right">
			Teams
		</div>
		<div class="panel-body">
			<div class="text-right"><button class="add-team btn btn-default btn-small" type="button">Add</button></div>
			<cfif structKeyExists(rc, "sMessage") and len(rc.sMessage) gt 0><div class="alert alert-info alert-dismissable"><button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>#rc.sMessage#</div></cfif>
			<div class="table-responsive">
				<table class="users table">
					<thead>
						<tr>
							<th>Name</th>
							<th>Alt 1</th>
							<th>Alt 2</th>
							<th>Type</th>
							<th></th>
						</tr>
					</thead>
					<tbody>
						<cfloop from="1" to="#arrayLen(rc.arTeams)#" index="local.itm">
							<tr>
								<td>#rc.arTeams[local.itm].getSName()#</td>
								<td>#rc.arTeams[local.itm].getSName2()#</td>
								<td>#rc.arTeams[local.itm].getSName3()#</td>
								<td><cfif rc.arTeams[local.itm].getNType() eq 1>NCAA<cfelseif rc.arTeams[local.itm].getNType() eq 2>NFL</cfif></td>
								<td>
									<span class="fa fa-edit edit-team icons fa-fw fa-lg" title="Edit team"></span>
									<span class="fa fa-trash-o delete-team icons fa-fw fa-lg" title="Delete team"></span>
									<input type="hidden" class="nTeamID" value="#rc.arTeams[local.itm].getNTeamID()#"/>
								</td>
							</tr>
						</cfloop>
					</tbody>
				</table>
			</div>
		</div>
	</div>
</cfoutput>
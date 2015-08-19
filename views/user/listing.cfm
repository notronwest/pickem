<div class="panel panel-default">
	<div class="panel-heading"><h3>Users</h3></div>
	<div class="panel-body">
		<div class="text-right"><button class="add-user btn btn-default btn-small" type="button">Add</button></div>
		<cfoutput>
		<cfif structKeyExists(rc, "sMessage") and len(rc.sMessage) gt 0><div class="alert alert-info alert-dismissable"><button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>#rc.sMessage#</div></cfif>
		<table class="users table">
			<thead>
				<tr>
					<th>Name</th>
					<th>E-mail</th>
					<th>Last Login</th>
					<th></th>
				</tr>
			</thead>
			<tbody>
				<cfloop from="1" to="#arrayLen(rc.arUsers)#" index="local.itm">
					<tr>
						<td>#rc.arUsers[local.itm].getSLastName()#, #rc.arUsers[local.itm].getSFirstName()#</td>
						<td>#rc.arUsers[local.itm].getSEmail()#</td>
						<td><cfif len(rc.arUsers[local.itm].getDLastLogin()) gt 0>#getBeanFactory().getBean("commonService").dateTimeFormat(rc.arUsers[local.itm].getDLastLogin())#</cfif>
						</td>
						<td>
							<span class="fa fa-edit edit-user icons fa-fw fa-lg" title="Edit user profile"></span>
							<span class="fa fa-trash-o delete-user icons fa-fw fa-lg" title="Delete user" data-email="#rc.arUsers[local.itm].getSEmail()#"></span>
							<span class="fa fa-user impersonate icons fa-fw fa-lg" title="Impersonate user"></span>	
							<span class="fa <cfif rc.arUsers[local.itm].nSubscriptionID eq 0>fa-thumbs-o-down<cfelse>fa-dollar</cfif> subscription icons fa-fw fa-lg" data-nSubscriptionID="#rc.arUsers[local.itm].nSubscriptionID#" title="Apply subscription payment"></span>
							<input type="hidden" class="nUserID" value="#rc.arUsers[local.itm].getNUserID()#"/>

						</td>
					</tr>
				</cfloop>
			</tbody>
		</table>
		</cfoutput>
	</div>
</div>
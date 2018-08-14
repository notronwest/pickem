<cfoutput><form id="reactivate" action="#buildURL('manager:user.saveReactivate')#" method="post">
<div class="panel panel-default">
	<div class="panel-heading">Reactivate User</div>
	<div class="panel-body">
		<div>
			<cfif len(rc.sMessage) gt 0>
				<div class="alert alert-info">
					#rc.sMessage#
				</div>
			</cfif>
			<div class="form-group">
				<label for="sEmail">Email: </label>
				<input type="text" id="sEmail" name="sEmail" class="form-control" value=""/>
			</div>
			<div class="form-group text-right">
				<button type="submit" class="save btn btn-default">Save</button><cfif rc.stUser.bIsAdmin><button type="button" class="cancel btn btn-default">Cancel</button></cfif>
			</div>
		</div>
	</div>
</div></form>
</cfoutput>

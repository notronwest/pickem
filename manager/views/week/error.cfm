<div class="panel panel-default">
	<div class="panel-heading">
		<h3 class="panel-title">Error</h3>
	</div>
	<div class="panel-body">
		<div class="well alert alert-warning">
			<cfswitch expression="#rc.sType#">
				<cfcase value="delete">
					Error deleting week
				</cfcase>
			</cfswitch>
		</div>
	</div>
	<div class="panel-footer text-right"><button type="button" class="save btn btn-primary btn-xs" id="loginUser">Login</button></div>
</div>
<div class="panel panel-default">
	<div class="panel-heading"><h3>Error</h3></div>
	<div class="panel-body">
		<cfswitch expression="#rc.sType#">
			<cfcase value="create">
				<p>There was an error creating the season, please try again</p>
			</cfcase>
		</cfswitch>
	</div>
</div>
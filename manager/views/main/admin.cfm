<cfoutput>
	<div id="admin" class="panel panel-default">
		<div class="panel-heading text-right">

		</div>
		<div class="panel-body">
			<div class="list-group">
				<cfif rc.stUser.bIsAdmin>
					<a class="list-group-item" href="#buildURL('week.manage')#"><h4>Manage Weeks</h4>
						<p>Allows you to setup the weeks for the season. Additionally, you can set the games and calculate the scoring for a particular week.</p></a>
					<a class="list-group-item" href="#buildURL('week.setWeekGames')#"><h4>Set Games</h4>
						<p>Use this to add games for each week.</p></a>
					<a class="list-group-item" href="#buildURL('game.scoring')#"><h4>Score Games</h4>
						<p>Once the games are completed, you can use this to add the scores into each game</p></a>
					<a class="list-group-item" href="#buildURL('team.listing')#"><h4>Teams</h4>
						<p>Add, Edit and Delete teams</p></a>
					<a class="list-group-item" href="#buildURL('user.listing')#"><h4>Users</h4>
						<p>Add, Edit and Delete users</p></a>
					<a class="list-group-item" href="#buildURL('notify.listing')#"><h4>Notifications</h4>
						<p>Manage the messaging for the notifications that go out to users.</p></a>
					<a class="list-group-item" href="#buildURL('pick.bulk')#"><h4>Bulk Picks</h4>
						<p>For those users that don't use the web interface, you can copy and paste their pick email content to set their picks</p></a>
					<a class="list-group-item" href="#buildURL('user.emailUserForm')#"><h4>Email Users</h4>
						<p>A form that allows you to easily select and email users.</p></a>
					<a class="list-group-item" href="#buildURL('user.emailList')#"><h4>Get Email address</h4>
						<p>A form that allows you to easily select users and get all email addresses.</p></a>
					<a class="list-group-item" href="#buildURL('season.listing')#"><h4>Seasons</h4>
						<p>Manage the seasons.</p></a>
					<a class="list-group-item" href="#buildURL('payout.listing')#"><h4>Available Payouts</h4>
						<p>Manage the list of available payouts for the season.</p></a>
					<a class="list-group-item" href="#buildURL('user.reactivate')#"><h4>Reactivate User</h4>
						<p>Reactivate a user who was previously using the site but skipped a year.</p></a>
            	</cfif>
		</div>
	</div>
</cfoutput>

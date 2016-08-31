<cfoutput>
<div class="panel panel-default">
	<div class="panel-heading">Season Payouts</div>
	<div class="panel-body">
		<h4>Weekly (awarded once a week)</h4>
		<ul class="list-group">
			<cfloop from="1" to="#arrayLen(rc.stSeasonPayouts['weekly'])#" index="local.itm">
				<li class="list-group-item">#rc.stSeasonPayouts['weekly'][itm].sName#
					<cfif len(#rc.stSeasonPayouts['weekly'][itm].sDescription#) gt 0>(#rc.stSeasonPayouts['weekly'][itm].sDescription#)</cfif>
					<span class="badge">#dollarFormat(rc.stSeasonPayouts['weekly'][itm].nAmount)#</span></li>
			</cfloop>
		</ul>
		<h4>Seasonal (awarded at the end of the season)</h4>
		<ul class="list-group">
			<cfloop from="1" to="#arrayLen(rc.stSeasonPayouts['season'])#" index="local.itm">
				<li class="list-group-item">#rc.stSeasonPayouts['season'][itm].sName#<span class="badge">#dollarFormat(rc.stSeasonPayouts['season'][itm].nAmount)#</span></li>
			</cfloop>
		</ul>
		<h4>Final Week (awarded for the last week of the season)</h4>
		<ul class="list-group">
			<cfloop from="1" to="#arrayLen(rc.stSeasonPayouts['finalWeek'])#" index="local.itm">
				<li class="list-group-item">#rc.stSeasonPayouts['finalWeek'][itm].sName#<span class="badge">#dollarFormat(rc.stSeasonPayouts['finalWeek'][itm].nAmount)#</span></li>
			</cfloop>
		</ul>
	</div>
</div>
</cfoutput>
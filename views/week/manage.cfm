<div id="weeks" class="panel panel-default">
	<div class="panel-heading text-right">
		<h2 class="left">Manage Weeks<h2>
		<div class="input-group">
			<button type="button" class="add-week btn btn-default btn-sm">Add Week</button>
		</div>
	</div>
	<div class="panel-body">
		<div class="table-responsive">
			<table class="table">
				<thead>
					<tr>
						<th>Name</th>
						<th>Start</th>
						<th>End</th>
						<th>Picks Due</th>
						<th></th>
					</tr>
				</thead>
				<tbody>
					<cfloop from="1" to="#arrayLen(rc.arWeeks)#" index="itm">
						<cfoutput><tr data-id="#rc.arWeeks[itm].getNWeekID()#">
							<td>#rc.arWeeks[itm].getSName()#</td>
							<td>#dateFormat(rc.arWeeks[itm].getDStartDate(), "mm/dd/yyyy")#</td>
							<td>#dateFormat(rc.arWeeks[itm].getDEndDate(), "mm/dd/yyyy")#</td>
							<td>#getBeanFactory().getBean("commonService").dateTimeFormat(rc.arWeeks[itm].getDPicksDue() & " " & rc.arWeeks[itm].getTPicksDue())#</td>
							<td class="week-actions">
								<span class="fa fa-edit edit icons fa-fw fa-lg">&nbsp;</span><span class="fa fa-trash-o delete icons fa-fw fa-lg">&nbsp;</span> [#rc.arWeeks[itm].getNWeekID()#]  (<a href="#buildURL('week.setWeek')#&nWeekID=#rc.arWeeks[itm].getNWeekID()#">Set Games</a> - <a href="#buildURL('standing.calculate')#&nWeekID=#rc.arWeeks[itm].getNWeekID()#">Calculate Winners</a>)
							</td>
						</tr></cfoutput>
					</cfloop>
				</tbody>
			</table>
		</div>
	</div>
</div>
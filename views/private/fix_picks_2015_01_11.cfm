<!--- // get all of the records for this week --->
<cfquery name="qryOldRecords" datasource="pickem">
	select * from pick2
	where nWeekID = 40
</cfquery>

<cfloop query="#qryOldRecords#">
	<!--- // see if this pick exists for this user --->
	<cfquery name="qryDoesExist" datasource="pickem">
		select nPickID
		from pick
		where nGameID = #qryOldRecords.nGameID#
		and nUserID = #qryOldRecords.nUserID#
	</cfquery>

	<!--- // if it doesn't exist - insert it --->
	<cfif qryDoesExist.recordCount eq 0>
		<cfquery name="insert" datasource="pickem">
			insert into pick (nGameID, nWeekID, nUserID, nTeamID, nWin)
			values (#qryOldRecords.nGameID#, #qryOldRecords.nWeekID#, #qryOldRecords.nUserID#, #qryOldRecords.nTeamID#, #qryOldRecords.nWin#)
		</cfquery>
		<cfcatch></cfcatch>
	</cfif>

</cfloop>
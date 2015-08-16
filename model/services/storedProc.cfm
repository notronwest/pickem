<cfstoredproc procedure="#request.sStoredProc#" datasource="#request.dsn#">
	<cfloop from="1" to="#arrayLen(request.arParams)#" index="itm">
		<cfif isNumeric(request.arParams[itm])>
			<cfprocparam cfsqltype="cf_sql_numeric" value="#request.arParams[itm]#">
		<cfelse>
			<cfprocparam cfsqltype="cf_sql_varchar" value="#request.arParams[itm]#">
		</cfif>
	</cfloop>
</cfstoredproc>
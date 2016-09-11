<cfif not rc.bIsDialog>
	<cfif fileExists(expandPath('/assets/js/#lCase(rc.oCurrentLeague.getSKey())#/') & 'week.js')>
		<cfoutput><script src="/assets/js/#lCase(rc.oCurrentLeague.getSKey())#/week.js"></script></cfoutput>
	<cfelse>
		<script src="/assets/js/week.min.js"></script>
	</cfif>
</cfif><cfoutput>#body#</cfoutput>
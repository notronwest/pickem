<cfif not rc.bIsDialog>
	<cfif fileExists(expandPath('/assets/js/#rc.oCurrentLeague.getSKey()#/') & 'week.js')>
		<cfoutput><script src="/assets/js/#rc.oCurrentLeague.getSKey()#/week.js"></script></cfoutput>
	<cfelse>
		<script src="/assets/js/week.min.js"></script>
	</cfif>
</cfif><cfoutput>#body#</cfoutput>
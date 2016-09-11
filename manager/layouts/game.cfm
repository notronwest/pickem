<cfif not rc.bIsDialog>
	<cfif fileExists(expandPath('/assets/js/#lCase(rc.oCurrentLeague.getSKey())#') & '/game.js')>
		<cfoutput><script src="/assets/js/#lCase(rc.oCurrentLeague.getSKey())#/game.js"></script></cfoutput>
	<cfelse>
		<script src="/assets/js/game.min.js"></script>
	</cfif>
</cfif><cfoutput>#body#</cfoutput>
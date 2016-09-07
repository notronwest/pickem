<cfif not rc.bIsDialog>
	<cfif fileExists(expandPath('/assets/js/#rc.oCurrentLeague.getSKey()#/') & 'pick.js')>
		<cfoutput><script src="/assets/js/#rc.oCurrentLeague.getSKey()#/pick.js"></script></cfoutput>
	<cfelse>
		<script src="/assets/js/pick.min.js"></script>
	</cfif>
</cfif><cfoutput>#body#</cfoutput>
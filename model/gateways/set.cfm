<!--- // make sure the function to set this data exists --->
<cfif isDefined("request.oBean.set#sKey#") or isDefined("request.oBean.add#sKey#")>
	<!--- // invoke dynamic set function --->
	<cfinvoke component="#request.oBean#" method="set#sKey#">
		<cfinvokeargument name="#sKey#" value="#arguments.stData[sKey]#">
	</cfinvoke>
</cfif>
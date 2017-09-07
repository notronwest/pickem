<cfscript>
	// TODO: need to separate league key from league type --->
	if( compareNoCase(rc.oCurrentLeague.getSKey(), "NFLDog") eq 0 ){
		sKey = "nflunderdog";
	} else {
		sKey = lCase(rc.oCurrentLeague.getSKey());
	}
</cfscript>
<cfinclude template="/manager/views/pick/#sKey#/set.cfm">

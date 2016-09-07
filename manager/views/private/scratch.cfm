<cfhttp method="get" url="http://www.nfl.com/liveupdate/scores/scores.json"/>
<cfscript>
	if( isJSON(cfhttp.fileContent) ){
		writeDump(deserializeJSON(cfhttp.fileContent));
	}
</cfscript>
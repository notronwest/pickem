component accessors="true" extends="model.base" {

property name="teamService";
	
variables.sNCAAOddsBaseURL ="http://rivals.yahoo.com/ncaa/football/odds";
variables.sNFLOddsBaseURL = "http://rivals.yahoo.com/nfl/odds";
variables.sNCAAScoresBaseURL = "http://sports.yahoo.com/ncaa/football/scoreboard";
variables.sNFLScoresBaseURL = "http://sports.yahoo.com/nfl/scoreboard";

/*
Author: 	
	Ron West
Name:
	$getRawSource
Summary:
	Loads a selected source for parsing
Returns:
	String sSource
Arguments:
	String sSourcePath
History:
	2012-09-12 - RLW - Created
*/	
public String function getRawSource( Numeric nWeek=1, String sType="odds", String sLeague="NCAA", Boolean bOverwrite=false ){
	var sRawSource = "";
	// build variable for the URL
	var sVariable = "s" & arguments.sLeague & arguments.sType & "BaseURL";
	var sURL = "";
	var sFilePath = application.dataDirectory;
	var sFileName = "";
	// set filename to get/store		
	sFileName = year(now()) & "_" & arguments.nWeek & ".source";
	// set path to store the file
	sFilePath = sFilePath & arguments.sType & "/" & arguments.sLeague & "/";
	// see if the file doesn't exists and we aren't trying to overwrite
	if( fileExists(sFilePath & sFileName) && not arguments.bOverwrite ){
		sRawSource = fileRead(sFilePath & sFileName);
	} else { // either the source didn't exist or we are overwriting
		if( structKeyExists(variables, sVariable) ){
			sURL = variables[sVariable];
			// determine if we are doing odds or scores
			switch (arguments.sType){
				// if this is scores then add on the week url parameters
				case "scores":
					sURL = sURL & "?w=" & nWeek & "c=ally=" & year(now());
			}
			// get the rawSource
			sRawSource = getHTTP(sURL);
			// if we got something and we are overwritting
			if( len(sRawSource) && arguments.bOverwrite ){
				// if the current file exists move it
				if( fileExists(sFilePath & sFileName) ){
					fileMove(sFilePath & sFileName, sFilePath & sFileName & "_#dateFormat(now(), 'yyyy_mm_dd')#_#timeFormat(now(), 'hh_mm.bak')#");
				}
				// store file
				fileWrite(sFilePath & sFileName, sRawSource);

			}
		}
	}
	return getDataTableFromSource(sRawSource);
}

/*
Author: 	
	Ron West
Name:
	$loadGames
Summary:
	Loads games from a source
Returns:
	Array arGames
Arguments:
	String sRawSource
History:
	2012-09-12 - RLW - Created
*/
public Array function loadGames( Required String sSource ){
	var arGames = [];
	var sDateBeginString = "<h4";
	var sDateEndString = "</h4";
	var sTeamKeyString = 'class="team"';
	var stOdds = {};
	var sHomeTeam = "";
	var sAwayTeam = "";
	var oHomeTeam = "";
	var oAwayTeam = "";
	var sGameDate = "";
	var sGameTime = "";
	// start the search in the main area
	var nPos = findNoCase(sDateBeginString, arguments.sSource, findNoCase("yui-main", arguments.sSource));
	var nEndPos = 1;
	var bFinished = false;
	// search for the first team
	//while( nEndPos > 0  ){
	for( itm=1; itm lte 3; itm++ ){
		// get the date
		nEndPos = findNoCase(sDateEndString, arguments.sSource, nPos);
		//writeOutput("<br/><hr/><br/>");
		//writeOutput("<br/>nEndPos: " & nEndPos);
		// if there is a next date
		if( nEndPos > 0 ){
			// get the date
			sGameDate = stripHTML(mid(arguments.sSource, nPos, nEndPos - nPos));
			//writeOutput("<br/>Date: " & sGameDate);
			// now that we have the date, start the search for the teams
			nPos = nEndPos;
			//writeOutput("<br/>Current Pos: " & nPos & " -- " & htmlEditFormat(mid(arguments.sSource, nPos, 25)));
			nNextDatePos = findNoCase(sDateBeginString, arguments.sSource, nPos );
			// if the next date isn't found, run the games at least once
			if( nNextDatePos == 0 ){
				nNextDatePos = len(arguments.sSource);
			}
			//writeOutput("<br/>Next Date: " & nNextDatePos);
			// process teams
			while( nNextDatePos > nPos ){
				// get the home team
				sHomeTeam = getTeamString(arguments.sSource, nPos);
				// reset the pos to get the next team
				nPos = findNoCase(sHomeTeam, arguments.sSource, nPos); 
				// get the away team
				sAwayTeam = getTeamString(arguments.sSource, nPos + 1);
				// reset the pos to get the odds
				nPos = findNoCase(sAwayTeam, arguments.sSource, nPos);
				// get the odds (reset to the next TD which will contain the odds)
				stOdds = getOdds(arguments.sSource, findNoCase("<td", arguments.sSource, nPos));
				// add the game data to the array
				arrayAppend(arGames, { "sGameDate" = sGameDate, "stHomeTeam" = buildTeamStruct(sHomeTeam), "stAwayTeam" = buildTeamStruct(sAwayTeam), "stOdds" = stOdds } );
				// find the next team
				nPos = findNoCase(sTeamKeyString, arguments.sSource, nPos );

				//writeOutput("<br/>" & sHomeTeam);
				//writeOutput("<br/>" & sAwayTeam);
				//writeOutput("<br/>Next Team: " & nPos);

				// if we don't have anymore teams
				if( nPos == 0 ){
					bFinished = true;
					break;
				} else if( nPos > nNextDatePos ){ // if the next team pos is greater than the next date start now
					nPos = nNextDatePos;
				}
			}
			if( bFinished ){
				break;
			}
		}
	}
	return arGames;
}

/*
Author: 	
	Ron West
Name:
	$getDataTableFromSource
Summary:
	Gets the core data from the source
Returns:
	String sData
Arguments:
	String sSource
History:
	2012-09-12 - RLW - Created
*/
public String function getDataTableFromSource( Required String sSource ){
	var sData = "";
	// start the search in the main area
	var nPos = findNoCase('<div class="bd"', arguments.sSource, findNoCase("yui-main", arguments.sSource));
	// find the <script tag that ends the table
	var nEndPos = findNoCase('<script', arguments.sSource, nPos);
	if( nEndPos ){
		sData = mid(arguments.sSource, nPos, nEndPos - nPos);
	}
	return sData;
}

/*
Author: 	
	Ron West
Name:
	$getListingForWeek
Summary:
	Builds a listing of the sources
Returns:
	Array arSources
Arguments:
	Numeric nWeek
	Boolean bIncludeBackups
History:
	2012-09-12 - RLW - Created
*/
public Array function getListing( Numeric nWeek=1, Boolean bIncludeBackups=false ){
	var arNCAASources = [];
	var arNFLSource = [];
	var arSources = [];
	var sFilter = "#year(now())#_#arguments.nWeek#.source";
	var arListing = [];
	if( arguments.bIncludeBackups ){
		sFilter = "#year(now())#_#arguments.nWeek#.source.*";
	}
	// get NCAA
	arNCAASources = directoryList(application.dataDirectory & "odds/ncaa/", false, "name", sFilter );
	if( arrayLen(arNCAASources) gt 0 ){
		arrayAppend(arSources, arNCAASources);
	}
	// get NFL
	arNFLSources = directoryList(application.dataDirectory & "odds/nfl/", false, "name", sFilter );
	if( arrayLen(arNFLSources) gt 0 ){
		arrayAppend(arSources, arNFLSources);
	}
	return arSources;	
}

/*
Author: 	
	Ron West
Name:
	$getTeamString
Summary:
	Given a string from a source get the anchor tag to the team
Returns:
	String sTeam
Arguments:
	String sSource
	Numeric nStartPos
History:
	2012-09-12 - RLW - Created
*/
public String function getTeamString( Required String sSource, Numeric nBeginPos ){
	var sTeam = arguments.sSource;
	var sTeamBeginString = "<a";
	var sTeamEndString = "</a>";
	// find the beginning of the home team
	var nPos = findNoCase(sTeamBeginString, sTeam, arguments.nBeginPos);
	var nEndPos = 0;
	if( nPos > 0 ){
		// find the end of the home team
		nEndPos = findNoCase(sTeamEndString, sTeam, nPos);
		if( nEndPos > 0 ){
			// send string to get team data
			sTeam = mid(sTeam, nPos, (nEndPos + len(sTeamEndString)) - nPos );
		}
	}
	return sTeam;
}

/*
Author: 	
	Ron West
Name:
	$buildTeamStruct
Summary:
	Given a string (presumably a anchor tag from the source) - build the structure for this team
Returns:
	Struct stTeam
Arguments:
	String sSource
	Boolean bSave
History:
	2012-09-12 - RLW - Created
*/
public Struct function buildTeamStruct( Required String sSource ){
	var stTeam = {};
	// find the href=
	var sHREFStringBegin = 'href="';
	var sHREFStringEnd = '"';
	var sHREF = "";
	// find the beginning of the href
	var nStartPos = findNoCase(sHREFStringBegin, arguments.sSource);
	var nEndPos = 0;
	var oTeam = "";
	// if there is an href then keep it
	if( nStartPos ){
		nEndPos = findNoCase(sHREFStringEnd, arguments.sSource, nStartPos + len(sHREFStringBegin) );
		if( nEndPos > 0 ){
			sHREF = mid(arguments.sSource, nStartPos + len(sHREFStringBegin), nEndPos - (nStartPos + len(sHREFStringBegin)) );
		}
	}
	// create/get the team object
	oTeam = variables.teamService.saveTeam(stripHTML(arguments.sSource), sHREF);
	// build the structure to return
	stTeam = {
		sName = oTeam.getSName(),
		sHREF = oTeam.getSURL(),
		nTeamID = oTeam.getNTeamID()
	};
	return stTeam;
}

/*
Author: 	
	Ron West
Name:
	$getOdds
Summary:
	Gets the odds
Returns:
	Struct sOdds
Arguments:
	String sSource
	Numeric nBeginPos
History:
	2012-09-13 - RLW - Created
*/
public Struct function getOdds ( Required String sSource, Required Numeric nBeginPos ){
	var stOdds = {};
	var sOdds = "";
	var sBeginOddsString = "<span";
	var sEndOddsString = "</span";
	var sOddType = "";
	var nEndPos = 0;
	// find the td for the odds
	var nPos = findNoCase(sBeginOddsString, arguments.sSource, nBeginPos);
	if( nPos > 0 ){
		nEndPos = findNoCase(sEndOddsString, arguments.sSource, nPos);
		if( nEndPos > 0 ){
			sOdds = mid(arguments.sSource, nPos, nEndPos - nPos);
			// see which odds we have
			if( findNoCase("top-line", sOdds) > 0 ){
				sOddType = "homeTeam";
			} else {
				sOddType = "awayTeam";
			}
			stOdds = {
				"sOddType" = sOddType,
				"sOdds" = replace(stripHTML(sOdds), "&frac12;", ".5")
			};
		}
	}
	return stOdds;
}

/*
Author: 	
	Ron West
Name:
	$stripHTML
Summary:
	Strips all of the HTML from the string
Returns:
	String sClean
Arguments:
	String sSource
History:
	2012-09-12 - RLW - Created
*/
public String function stripHTML( Required String sSource ){
	var sClean = trim(arguments.sSource);
	var nPos = findNoCase("<", sClean);
	var nEndPos = 0;
	while( nPos > 0 ){
		nEndPos = findNoCase(">", sClean, nPos);
		if( nEndPos > 0 ){
			sClean = removeChars(sClean, nPos, (nEndPos - nPos) + 1);
		}
		nPos = findNoCase("<", sClean);
	}
	return trim(sClean);
}



/*
Author: 	
	Ron West
Name:
	$getHTTP
Summary:
	Separates out the http process
Returns:
	String sResponse
Arguments:
	String sURL
History:
	2012-09-12 - RLW - Created
*/	
public String function getHTTP( required String sURL ){
	var sResponse = "";
	var result = "";
	if( len(arguments.sURL) ){
		httpService = new http();
		httpService.setMethod("get"); 
	    httpService.setCharset("utf-8");
	    httpService.setURL(arguments.sURL);
	    result = httpService.send().getPrefix();
	    if( findNoCase("200", result.statusCode) ){
	    	sResponse = result.fileContent;
		} else {
			writeDump(result);
		}
	 }
	return sResponse;
}

/*
Author: 	
	Ron West
Name:
	$verifySource
Summary:
	Verifies that the source is correct for the month
Returns:
	Boolean bIsValid
Arguments:
	String sSource
	Numeric nWeek
History:
	2012-09-12 - RLW - Created
*/
public Boolean function verifySource( String sSource="", Numeric nWeek=1 ){
	var bIsValid = true;

	return bIsValid;
}

}
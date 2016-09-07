<cfscript>
	request.stLeagueSettings = {
		"pickem" = {
			"bHasNCAAGames" = true,
			"bHasNFLGames" = true,
			"bHasNBAGames" = false,
			"sProductionURL" = "http://pickem.inquisibee.com"
		},
		"NFLPerfect" = {
			"bHasNCAAGames" = false,
			"bHasNFLGames" = true,
			"bHasNBAGames" = false,
			"sProductionURL" = "http://nflperfection.inquisibee.com"
		},
		"NFLUnderdog" = {
			"bHasNCAAGames" = false,
			"bHasNFLGames" = true,
			"bHasNBAGames" = false,
			"sProductionURL" = "http://nflunderdog.inquisibee.com"
		}
	};
</cfscript>
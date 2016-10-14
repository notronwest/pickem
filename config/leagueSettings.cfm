<cfscript>
	request.stLeagueSettings = {
		"pickem" = {
			"bHasNCAAGames" = true,
			"bHasNFLGames" = true,
			"bHasNBAGames" = false,
			"sProductionURL" = "http://pickem.inquisibee.com",
			"bHasUserPreferences" = true,
			"bShowPayouts" = true
		},
		"NFLPerfection" = {
			"bHasNCAAGames" = false,
			"bHasNFLGames" = true,
			"bHasNBAGames" = false,
			"sProductionURL" = "http://nflperfection.inquisibee.com",
			"bHasUserPreferences" = false,
			"bShowPayouts" = false
		},
		"NFLUnderdog" = {
			"bHasNCAAGames" = false,
			"bHasNFLGames" = true,
			"bHasNBAGames" = false,
			"sProductionURL" = "http://nflunderdog.inquisibee.com",
			"bHasUserPreferences" = true,
			"bShowPayouts" = false
		}
	};
</cfscript>
<cfscript>
	request.stLeagueSettings = {
		"pickem" = {
			"bHasNCAAGames" = true,
			"bHasNFLGames" = true,
			"bHasNBAGames" = false,
			"sProductionURL" = "http://pickem.inquisibee.com",
			"bHasUserPreferences" = true,
			"bShowPayouts" = true,
			"UIKey" = "pickem",
			"bCanAutoPick" = true
		},
		"NFLPerfection" = {
			"bHasNCAAGames" = false,
			"bHasNFLGames" = true,
			"bHasNBAGames" = false,
			"sProductionURL" = "http://nflperfection.inquisibee.com",
			"bHasUserPreferences" = true,
			"bShowPayouts" = false,
			"UIKey" = "nflperfection",
			"bCanAutoPick" = false
		},
		"NFLUnderdog" = {
			"bHasNCAAGames" = false,
			"bHasNFLGames" = true,
			"bHasNBAGames" = false,
			"sProductionURL" = "http://nflunderdog.inquisibee.com",
			"bHasUserPreferences" = true,
			"bShowPayouts" = false,
			"UIKey" = "nflunderdog",
			"bCanAutoPick" = false
		},
		"NFLDog" = {
			"bHasNCAAGames" = false,
			"bHasNFLGames" = true,
			"bHasNBAGames" = false,
			"sProductionURL" = "http://nfldog.inquisibee.com",
			"bHasUserPreferences" = true,
			"bShowPayouts" = false,
			"UIKey" = "nflunderdog",
			"bCanAutoPick" = false
		}
	};
</cfscript>

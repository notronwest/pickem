<cfscript>
	request.stLeagueSettings = {
		"pickem" = {
			"bHasNCAAGames" = true,
			"bHasNFLGames" = true,
			"bHasNBAGames" = false
		},
		"NFLPerfect" = {
			"bHasNCAAGames" = false,
			"bHasNFLGames" = true,
			"bHasNBAGames" = false
		},
		"NFLUnderdog" = {
			"bHasNCAAGames" = false,
			"bHasNFLGames" = true,
			"bHasNBAGames" = false
		}
	};
</cfscript>
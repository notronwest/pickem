<cfscript>
	leagueGateway = getBeanFactory().getBean("leagueGateway");
	seasonGateway = getBeanFactory().getBean("seasonGateway");
	userGateway = getBeanFactory().getBean("userGateway");
	userSeasonGateway = getBeanFactory().getBean("userSeasonGateway");

	// build pickem league
	league = leagueGateway.get({ "sName" = "pickem"});
	// update the seasons
	arSeasons = seasonGateway.getAll();
	for( itm=1; itm lte arrayLen(arSeasons); itm++ ){
		season = seasonGateway.update(arSeasons[itm], { sLeagueID=league.getSLeagueID()});
		// add all of the user records to each season
		arUsers = userGateway.getAll();
		for( x=1; x lte arrayLen(arUsers); x++ ){
			// make sure a record doesn't already exist for this
			if( isNull(userSeasonGateway.get({ nUserID=arUsers[x].getNUserID(), nSeasonID=arSeasons[itm].getNSeasonID()}).getSUserSeasonID()) ){
				// add record
				userSeasonGateway.update(userSeasonGateway.get(), {
					nSeasonID = arSeasons[itm].getNSeasonID(),
					nUserID = arUsers[x].getNUserID(),
					bActive = arUsers[x].getBActive()
				});
			}
		}

	}
	// build underdog league
	if( isNull(leagueGateway.get({ sName = "underdog"}).getSLeagueID()) ){
		league = leagueGateway.update(leagueGateway.get(), { "sName" = "NFL Underdog", "sKey" = "underdog"} );
	}

	// build NFLPick league
	if( isNull(leagueGateway.get({ sName = "nflpick"}).getSLeagueID()) ){
		league = leagueGateway.update(leagueGateway.get(), { "sName" = "NFL Pick", "sKey" = "nflPick"} );
	}
</cfscript>
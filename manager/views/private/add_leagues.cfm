<!--- // add league column to season --->
<cfquery name="qrySeason" datasource="#request.dsn#">
	select * from season
</cfquery>
<cfif !listFindNoCase(qrySeason.columnList, "sLeagueID")>
	<cfquery name="qryAlterSeason" datasource="#request.dsn#">
		alter table season
		add column sLeagueID nvarchar(32) not null,
		add column sPaymentText nvarchar(2000) null
	</cfquery>
</cfif>

<cfscript>
	leagueGateway = getBeanFactory().getBean("leagueGateway");
	seasonGateway = getBeanFactory().getBean("seasonGateway");
	userGateway = getBeanFactory().getBean("userGateway");
	userSeasonGateway = getBeanFactory().getBean("userSeasonGateway");

	// build pickem league
	league = leagueGateway.get({ "sName" = "pickem"});
	if( isNull(league.getSLeagueID()) ){
		league = leagueGateway.update(leagueGateway.get(), { "sName" = "pickem"} );
	}
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
		league = leagueGateway.update(leagueGateway.get(), { "sName" = "underdog"} );
	}

	// build NFLPick league
	if( isNull(leagueGateway.get({ sName = "nflpick"}).getSLeagueID()) ){
		league = leagueGateway.update(leagueGateway.get(), { "sName" = "nflpick"} );
	}
</cfscript>
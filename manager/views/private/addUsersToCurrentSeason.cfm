<cfscript>
    seasonGateway = getBeanFactory().getBean("seasonGateway");
	userSeasonGateway = getBeanFactory().getBean("userSeasonGateway");
    // get last years season
    lastYear = seasonGateway.getLastYearsSeason();
	// get all of the users from the previous season
    if( !lastYear.isNew() ){
    	arUsers = userSeasonGateway.getUsersForSeason(lastYear.getNSeasonID());
    	for( x=1; x lte arrayLen(arUsers); x++ ){
    		// make sure a record doesn't already exist for this
    		if( (userSeasonGateway.get({ nUserID=arUsers[x].getNUserID(), nSeasonID=rc.nCurrentSeasonID}).isNew()) ){
    			// add record
    			userSeasonGateway.update(userSeasonGateway.get(), {
    				nSeasonID = rc.nCurrentSeasonID,
    				nUserID = arUsers[x].getNUserID(),
    				bActive = arUsers[x].getBActive()
    			});
    		}
    	}
    }
</cfscript>

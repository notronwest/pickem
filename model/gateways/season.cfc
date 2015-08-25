component accessors="true" extends="model.base" {

/*
Author: 	
	Ron West
Name:
	$get
Summary:
	Gets the season object
Returns:
	Week oSeason
Arguments:
	Numeric nSeason
History:
	2012-09-12 - RLW - Created
*/
public model.beans.season function get( Any nSeasonID=0 ){
	var oSeason = entityNew("season");
	if( len(arguments.nSeasonID) and arguments.nSeasonID != 0 ){
		oSeason = entityLoadByPK("season", arguments.nSeasonID);
		if( isNull(oSeason) ){
			oSeason = entityNew("season");
		}
	}
	return oSeason;
}


/*
Author: 	
	Ron West
Name:
	$update
Summary:
	Updates the season object with new data
Returns:
	Season oSeason
Arguments:
	Season oSeason
	Struct stData
History:
	2012-09-12 - RLW - Created
*/
public model.beans.season function update( Required model.beans.season oSeason, Required Struct stData ){
	// set the bean into request scope
	request.oBean = arguments.oSeason;
	try{
		var sKey = "";
		var lstIgnore = "nSeasonID";
		// loop through all of the fields in the structure and update the data
		for( sKey in arguments.stData ){
			if( not listFindNoCase(lstIgnore, sKey) ){
				include "set.cfm";
			}
		}
		// save the entity
		entitySave(request.oBean);
		ormFlush();
	} catch (any e){
		registerError("Error in update function to season", e);
	}
	return request.oBean;
}

/*
Author: 	
	Ron West
Name:
	$save
Summary:
	Saves the season entity
Returns:
	Week oSeason
Arguments:
	Week oSeason
History:
	2012-09-12 - RLW - Created
*/
public model.beans.season function save( Required model.beans.season oSeason){
	entitySave(arguments.oSeason);
	ormFlush();
	return arguments.oSeason;
}

/*
Author: 	
	Ron West
Name:
	$delete
Summary:
	Delete the season entity
Returns:
	Week oSeason
Arguments:
	Week oSeason
History:
	2012-09-12 - RLW - Created
*/
public Boolean function delete( Required model.beans.season oSeason){
	entityDelete(arguments.oSeason);
	ormFlush();
	return true;
}


/*
Author: 	
	Ron West
Name:
	$getSeason
Summary:
	Get seasons by season
Returns:
	Array arSeason
Arguments:
	String nSeasonID
History:
	2012-09-12 - RLW - Created
*/
public Array function getSeason( Required String nSeasonID ){
	var arSeasons = ormExecuteQuery( "from season where nSeasonID = :nSeasonID order by nWeekNumber", { nSeasonID = "#arguments.nSeasonID#" } );
	return arSeasons;
}

/*
Author: 	
	Ron West
Name:
	$getAllSeasons
Summary:
	Gets all seasons
Returns:
	Array arSeasons
Arguments:
	Void
History:
	2015-08-08 - RLW - Created
*/
public Array function getAllSeasons(){
	var arSeasons = ormExecuteQuery("from season order by dtStart desc");
	return arSeasons;
}

}
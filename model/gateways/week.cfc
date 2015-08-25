component accessors="true" extends="model.base" {

/*
Author: 	
	Ron West
Name:
	$get
Summary:
	Gets the week object
Returns:
	Week oWeek
Arguments:
	Numeric nWeekID
History:
	2012-09-12 - RLW - Created
*/
public model.beans.week function get( Numeric nWeekID=0 ){
	var oWeek = new model.beans.week();
	var arWeek = [];
	if( arguments.nWeekID != 0 ){
		arWeek = entityLoad("week", arguments.nWeekID);
		if ( arrayLen(arWeek) gt 0 ){
			oWeek = arWeek[1];
		}
	}
	return oWeek;
}

/*
Author: 	
	Ron West
Name:
	$update
Summary:
	Updates the week object with new data
Returns:
	Week oWeek
Arguments:
	Week oWeek
	Struct stData
History:
	2012-09-12 - RLW - Created
*/
public model.beans.week function update( Required model.beans.week oWeek, Required Struct stData ){
	// set the bean into request scope
	request.oBean = arguments.oWeek;
	try{
		var sKey = "";
		var lstIgnore = "nWeekID";
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
		registerError("Error in update function to week", e);
	}
	return request.oBean;
}

/*
Author: 	
	Ron West
Name:
	$save
Summary:
	Saves the week entity
Returns:
	Week oWeek
Arguments:
	Week oWeek
History:
	2012-09-12 - RLW - Created
*/
public model.beans.week function save( Required model.beans.week oWeek){
	entitySave(arguments.oWeek);
	ormFlush();
	return arguments.oWeek;
}

/*
Author: 	
	Ron West
Name:
	$delete
Summary:
	Delete2 the week entity
Returns:
	Week oWeek
Arguments:
	Week oWeek
History:
	2012-09-12 - RLW - Created
*/
public Boolean function delete( Required model.beans.week oWeek){
	entityDelete(arguments.oWeek);
	ormFlush();
	return true;
}


/*
Author: 	
	Ron West
Name:
	$getSeason
Summary:
	Get weeks by season
Returns:
	Array arWeek
Arguments:
	String nSeasonID
History:
	2012-09-12 - RLW - Created
*/
public Array function getSeason( Required Numeric nSeasonID ){
	var arWeeks = ormExecuteQuery( "from week where nSeasonID = :nSeasonID order by nWeekNumber", { nSeasonID = "#arguments.nSeasonID#" } );
	return arWeeks;
}

/*
Author: 	
	Ron West
Name:
	$getWeekByDate
Summary:
	Get the week based on dates provided
Returns:
	Array arWeek
Arguments:
	String dtStart
	String dtEnd
	String nSeasonID
History:
	2012-09-12 - RLW - Created
*/
public Array function getByDate( String dtStart = dateFormat(now(), "yyyy-mm-dd"), String nSeasonID = "2013-2014" ){
	var arWeeks = ormExecuteQuery("from week where dStartDate <= :dtStart and dEndDate >= :dtStart and nSeasonID = :nSeasonID", { "dtStart" = arguments.dtStart, "nSeasonID" = arguments.nSeasonID });
	return arWeeks;
}

}
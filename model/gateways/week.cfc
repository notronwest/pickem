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
	Struct stWeek
History:
	2012-09-12 - RLW - Created
*/
public model.beans.week function update( Required model.beans.week oWeek, Required Struct stWeek ){
	// set data
	arguments.oWeek.setSName(arguments.stWeek.sName);
	arguments.oWeek.setDStartDate(arguments.stWeek.dStartDate);
	arguments.oWeek.setDEndDate(arguments.stWeek.dEndDate);
	arguments.oWeek.setLstSports(arguments.stWeek.lstSports);
	arguments.oWeek.setSSeason(arguments.stWeek.sSeason);
	arguments.oWeek.setNBonus(arguments.stWeek.nBonus);
	arguments.oWeek.setDPicksDue(arguments.stWeek.dPicksDue);
	arguments.oWeek.setTPicksDue(arguments.stWeek.tPicksDue);
	arguments.oWeek = save(oWeek);
	return arguments.oWeek;
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
	String sSeason
History:
	2012-09-12 - RLW - Created
*/
public Array function getSeason( Required String sSeason ){
	var arWeeks = ormExecuteQuery( "from week where sSeason = :sSeason order by nWeekNumber", { sSeason = "#arguments.sSeason#" } );
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
	String sSeason
History:
	2012-09-12 - RLW - Created
*/
public Array function getByDate( String dtStart = dateFormat(now(), "yyyy-mm-dd"), String sSeason = "2013-2014" ){
	var arWeeks = ormExecuteQuery("from week where dStartDate <= :dtStart and dEndDate >= :dtStart and sSeason = :sSeason", { "dtStart" = arguments.dtStart, "sSeason" = arguments.sSeason });
	return arWeeks;
}

}
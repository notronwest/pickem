component extends="model.baseGateway" accessors="true" {

/*
Author: 	
	Ron West
Name:
	$new
Summary:
	Creates a new instance of the entity
Returns:
	Any bean
Arguments:
	Void
History:
	2016-08-26 - RLW - Created
*/
public any function new(){
	return entityNew( getEntityName() );
}


/*
Author: 	
	Ron West
Name:
	$get
Summary:
	Returns an instance of the object
Returns:
	Any bean
Arguments:
	Any idOrFilter
History:
	2016-08-26 - RLW - Created
*/
public any function get( Any idOrFilter, boolean isReturnNewOnNotFound = true, boolean requireUnique = true ){
	if( !isNull( arguments.idOrFilter) ){
		if( isSimpleValue( arguments.idOrFilter) and len( arguments.idOrFilter) ){
			try{
				var entity = entityLoadByPK(getEntityName(), arguments.idOrFilter);
			} catch ( any e ){
				// debug
				rethrow;
			}
		} else if ( isStruct(arguments.idOrFilter) ){
			//structAppend( arguments.idOrFilter, { bActive = 1 }, false);
			try{
				var entity = entityLoad(getEntityName(), arguments.idOrFilter, arguments.requireUnique);
			} catch( any e ){
				//debug
				rethrow;
			}
		}

		if( !isNull(entity) ){
			return entity;
		}
	}
	if( isReturnNewOnNotFound ){
		return new();
	}
}

/*
Author: 	
	Ron West
Name:
	$update
Summary:
	Updates the  object with new data
Returns:
	Any object
Arguments:
	Any object
	Struct stData
History:
	2016-08-26 - RLW - Created
*/
public any function update( Required any oBean, Required Struct stData ){
	// set the bean into request scope
	request.oBean = arguments.oBean;
	try{
		var sKey = "";
		// loop through all of the fields in the structure and update the data
		for( sKey in arguments.stData ){
			if( compareNoCase(sKey, request.oBean.getEntityPK()) neq 0 ){
				include "gateways/set.cfm";
			}
		}
		// save the entity
		request.oBean.save();
		ormFlush();
	} catch (any e){
		registerError("Error in update function to #request.oBean.getEntityName()#", e);
	}
	return request.oBean;
}

public numeric function getCount(){
	arguments.countmode = true;
	return list(argumentCollection=arguments).itemCount;
}

/*
Author: 	
	Ron West
Name:
	$delete
Summary:
	Deletes the entity
Returns:
	Void
Arguments:
	Any object
History:
	2016-09-05 - RLW - Created
*/
public void function delete ( Required any oBean ){
	entityDelete(arguments.oBean);
	ormFlush();
}

// using the gateway name to get access to the bean name
public any function getEntityName(){
	if( !structKeyExists(variables, 'entityName') ){
		variables.entityName = replace(listLast(getMetadata(this).name, "."), "Gateway", "");
	}
	return variables.entityName;
}

}
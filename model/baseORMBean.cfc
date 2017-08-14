component extends="model.base" accessors="true" {

public any function save() {

	// if this is a newer bean with the string value
	if( compareNoCase(left(getEntityPK(), 1), "N") neq 0){
		getID = this['get' & getEntityPK()];

		if( isNull(getID()) or !len(trim(getID()))){
			setID = this['set' & getEntityPK()];
			setID(createFormattedUUID());
		}
	}
	entitySave(this);

	return this;
}

public boolean function isNew(){
	var bIsNew = true;
	var sID = javacast("null","");
	try {
		sID = invoke( this, 'get#getEntityPK()#');
	} catch (any e) {
		// error
		writeDump(e);
	}
	return isNull(sID);
}

public any function getEntityPK(){
	var sEntityPK = 'N' & getEntityName() & 'ID';
	// default to getN...ID()
	if( !structKeyExists(this, 'get' & sEntityPK) ){
		sEntityPK = 'S' & getEntityName() & 'ID';
	}
	return sEntityPK;
}

public any function getEntityName(){
	if(!structKeyExists(variables, 'entityName') ){
		variables.entityName = listLast(getMetadata(this).entityName, '.');
	}
	return variables.entityName;
}


}

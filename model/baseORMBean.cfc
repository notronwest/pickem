component extends="model.base" accessors="true" {
	
public any function save() {

	getID = this['get' & getEntityPK()];
	if( isNull(getID()) or !len(trom(getID()))){
		setID = this['set' & getEntityPK()];
		setID(createFormattedUUID());
	}

	entitySave(this);

	return this;
}

public any function getEntityPK(){
	var sEntityPK = 'n' & getEntityName() & 'ID';
	if( structKeyExists(this, 'getS' & getEntityName() & 'ID')){
		sEntityPK = 's' & getEntityName() & 'ID';
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
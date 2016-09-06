component extends="model.baseORMGateway" accessors="true"{


public array function getAll(){
	return ormExecuteQuery("from league order by sName");
}

public array function getByKey( Required String sKey ){
	return ormExecuteQuery("from league where sKey = :sKey", { sKey = arguments.sKey} );
}

}
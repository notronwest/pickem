component extends="model.baseORMGateway" accessors="true"{


public array function getAll(){
	return ormExecuteQuery("from league order by sName");
}

}
component accessors="true" extends="model.services.baseService" {
	/*
	Author: 	
		Ron West
	Name:
		$listSources
	Summary:
		Returns a list of the sources
	Returns:
		Array arSources
	Arguments:
		Void
	History:
		2012-09-12 - RLW - Created
	*/
	public String function listSources(){
		var oGateway = new model.gateway.sources();
		var arSources  = oGateway.getListing();
		return arSources;
	}
}
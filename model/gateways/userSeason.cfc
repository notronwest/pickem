component extends="model.baseORMGateway" accessors="true"{
	public array function getUsersForSeason( Required numeric nSeasonID ){
		var arUsers = ormExecuteQuery("from userSeason where nSeasonID = :nSeasonID and bActive = 1", {
			nSeasonID = arguments.nSeasonID
		});
		return arUsers;
	}

}

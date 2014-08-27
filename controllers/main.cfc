component accessors="true" extends="model.base" {

property name="weekGateway";
property name="gameService";
property name="userGateway";
property name="pickService";


public void function logReader(rc){
	rc.logPath = request.sLogURL;
	rc.logDir = expandPath(rc.logPath);
	if( structKeyExists(rc, "deleteFile") ){
		try{
			fileDelete(rc.logDir & rc.deleteFile);
			rc.fileDeleted = true;
		} catch (any e){
			registerError("Error deleting log file", e);
			rc.fileDeleted = false;
		}
	}
}

}
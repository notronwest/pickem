component accessors="true" extends="model.baseController" {

property name="optionService";
property name="framework";

public void function before (rc){
	param name="rc.bDeleteFirst" default="true";
}

public void function updateOptions(rc){
	// default messaging
	rc.sMessage = "Added options";
	//variables.optionService.deleteOptions();
	variables.optionService.buildOptions();
	variables.framework.setView('main.message');
}

}
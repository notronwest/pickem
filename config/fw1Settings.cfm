<cfscript>
	variables.framework = {
		enableGlobalRC = true,
		usingSubsystems = true,
		generateSES = false,
		defaultSubsystem = 'manager',
		defaultSection = 'standing',
		defaultItem = 'home',
		globalSubsystemLayout = "common",
		suppressImplicitService = true,
		reloadApplicationOnEveryRequest = request.bReloadOnEveryRequest
	};
</cfscript>
<cfexit>
<cfset sFilePath = "#expandPath('/')#users_2014.wddx">
<!--- // Create WDDX --->
<cfspreadsheet action="read" src="#expandPath('/')#google_20140825.xlsx" headerrow="1" query="qryContacts" excludeHeaderRow="true">
<cfwddx action = "cfml2wddx" input="#qryContacts#" output="qryWDDX">
<cffile action="write" file="#sFilePath#" output="#qryWDDX#">

<cffile action="read" file="#sFilePath#" variable="qryWDDX">
<cfwddx action="wddx2cfml" input="#qryWDDX#" output="qryContacts">

<cfdump var="#qryContacts#">
<cfscript>
	local.userGateway = getBeanFactory().getBean("userGateway");
	local.userService = getBeanFactory().getBean("userService");
	for( local.itm=1; local.itm lte qryContacts.recordCount; local.itm++ ){
		oUser = local.userGateway.update(local.userGateway.get(), {
			"sFirstName" = qryContacts.sFirstName[local.itm],
			"sLastName" = qryContacts.sLastName[local.itm],
			"sEmail" = qryContacts.sEmail[local.itm],
			"bIsAdmin" = (len(qryContacts.bIsAdmin[local.itm]) gt 0)? qryContacts.bIsAdmin[local.itm] : 0
		});
		local.userGateway.saveUsername( oUser.getNUserID(), qryContacts.sEmail[local.itm]);
		local.userGateway.savePassword( oUser.getNUserID(), local.userService.generatePassword());
	}
</cfscript>
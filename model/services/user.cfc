component accessors="true" extends="model.services.baseService" {

property name="userGateway";
property name="userService";
property name="subscriptionGateway";

/**
 * Generates a password the length you specify.
 * v2 by James Moberg.
 * 
 * @param numberOfCharacters      Lengh for the generated password. Defaults to 8. (Optional)
 * @param characterFilter      Characters filtered from result. Defaults to O,o,0,i,l,1,I,5,S (Optional)
 * @return Returns a string. 
 * @author Tony Blackmon (fluid@sc.rr.com) 
 * @version 2, February 8, 2010 
 */
public String function generatePassword() {
	var placeCharacter = "";
	var currentPlace=0;
	var group=0;
	var subGroup=0;
	var numberofCharacters = 8;
	var characterFilter = 'O,o,0,i,l,1,I,5,S';
	var characterReplace = repeatString(",", listlen(characterFilter)-1);
	if(arrayLen(arguments) gte 1) numberofCharacters = val(arguments[1]);
	if(arrayLen(arguments) gte 2) {
			characterFilter = listsort(rereplace(arguments[2], "([[:alnum:]])", "\1,", "all"),"textnocase");
	characterReplace = repeatString(",", listlen(characterFilter)-1);
	}
	while (len(placeCharacter) LT numberofCharacters) {
		group = randRange(1,4, 'SHA1PRNG');
		switch(group) {
			case "1":
				subGroup = rand();
			    switch(subGroup) {
					case "0":
						placeCharacter = placeCharacter & chr(randRange(33,46, 'SHA1PRNG'));
							break;
					case "1":
					placeCharacter = placeCharacter & chr(randRange(58,64, 'SHA1PRNG'));
						break;
				}
			case "2":
				placeCharacter = placeCharacter & chr(randRange(97,122, 'SHA1PRNG'));
				break;
			case "3":
				placeCharacter = placeCharacter & chr(randRange(65,90, 'SHA1PRNG'));
				break;
			case "4":
					placeCharacter = placeCharacter & chr(randRange(48,57, 'SHA1PRNG'));
			break;
		}

		if (listLen(characterFilter)) {
			placeCharacter = replacelist(placeCharacter, characterFilter, characterReplace);
		}
	}
	return placeCharacter;
}

public String function applyEmailMask( Required String sMessage, Required String sEmail){
	// get the user info for this e-mail
	var arUser = variables.userGateway.getByEmail(arguments.sEmail);
	var lstMasks = "";
	var lstValues = "";
	var oUser = "";
	try{
		if( arrayLen(arUser) gt 0 ){
			oUser = arUser[1];
			lstMasks = ("[username],[password],[firstname],[lastname],[email],[siteurl]");
			lstValues = ("#oUser.getSUsername()#,#oUser.getSPassword()#,#oUser.getSFirstName()#,#oUser.getSLastName()#,#oUser.getSEmail()#,#request.sProductionURL#" );
		}
	} catch (any e){
		registerError("Error trying to apply the email mask", e);
	}
	return replaceList(arguments.sMessage, lstMasks, lstValues);
}

public void function updateLastLogin( Required Numeric nUserID ){
	// get the user
	var oUser = variables.userGateway.get(arguments.nUserID);
	oUser.setDLastLogin(dateFormat(now(), 'yyyy-mm-dd') & " " & timeFormat(now(), 'HH:mm'));
	variables.userGateway.save(oUser);
}

public Array function getAllWithSubscriptions( Required Numeric nSeasonID ){
	// get all of the users
	var arSeasonUsers = variables.userGateway.getBySeason(arguments.nSeasonID);
	var arUsers = [];
	var itm = 1;
	var arSubscription = [];
	// loop through users and add fee data
	for( itm; itm lte arrayLen(arSeasonUsers); itm++ ){
		// add this user into the user array
		arrayAppend(arUsers, variables.userGateway.get(arSeasonUsers[itm].getNUserID()));
		// get the fees paid by this user for this season
		arSubscription = variables.subscriptionGateway.getByUserAndSeason(arUsers[itm].getNUserID(), arguments.nSeasonID);
		if( arrayLen(arSubscription) gt 0 ){
			arUsers[itm].nSubscriptionID = arSubscription[1].getNSubscriptionID();
			arUsers[itm].nSubscriptionAmount = arSubscription[1].getNAmount();
		} else {
			arUsers[itm].nSubscriptionID = 0;
			arUsers[itm].nSubscriptionAmount = 0;
		}
		
	}
	return arUsers;
}

public void function sendNewUserEmail( Required String sEmail, Required String sPassword, Required model.beans.league oCurrentLeague){
	// send out e-mail
	var sMessage = "Welcome to #arguments.oCurrentLeague.getSName()#. We have created the following temporary password for you: #arguments.sPassword#

Use the above password in combination with your e-mail address to get started with the site.

Good Luck!

#request.stLeagueSettings[arguments.oCurrentLeague.getSKey()].sProductionURL#";

	variables.commonService.sendEmail(sEmail, "Welcome to #arguments.oCurrentLeague.getSName()#!", sMessage);
}

public model.beans.user function handleSave( Required model.beans.user oUser, Required struct stFormData, boolean bIsAdmin = false, boolean bIsNewUser = false ){
	param name="arguments.stFormData.sNickname" default="";
	param name="arguments.stFormData.bActive" default="1";
	// set user data
	var stUserData = {
		"sFirstName" = arguments.stFormData.sFirstName,
		"sLastName" = arguments.stFormData.sLastName,
		"sNickname" = arguments.stFormData.sNickname,
		"bActive" = arguments.stFormData.bActive
	};
	try {
		// if this is data from an admin save more data
		if( arguments.bIsAdmin and structKeyExists(arguments.stFormData, "sEmail") ){
			
			stUserData.sEmail = arguments.stFormData.sEmail;
			stUserData.sUserName = arguments.stFormData.sEmail;
			// if this is a new user generate a new password
			if( arguments.bIsNewUser ){
				arguments.stFormData.sPassword = generatePassword();
			}
			// if the admin is changing the password or generating a new one
			if( structKeyExists(arguments.stFormData, "sPassword") ){
				stUserData.sPassword = arguments.stFormData.sPassword;
			}
		}
		// save the main user
		arguments.oUser = variables.userGateway.update(arguments.oUser, stUserData);
		// reset session value for the user so they don't need a profile anymore
		session.bSetProfile = 0;
		// send out email if its new
		if( bIsNewUser and structKeyExists(arguments.stFormData, "sEmail") and structKeyExists(arguments.stFormData, "sPassword") and len(arguments.stFormData.sPassword) ){
			sendNewUserEmail(arguments.stFormData.sEmail, arguments.stFormData.sPassword);
		}
		// save username and password if it is passed
		if( structKeyExists(arguments.stFormData, "sUsername") ){
			// save the username
			arguments.oUser = userGateway.saveUsername(arguments.oUser.getNUserID(), arguments.stFormData.sUsername);
			// save password
			arguments.oUser = userGateway.savePassword(arguments.oUser.getNUserID(), arguments.stFormData.sPassword);
		}
	} catch ( any e ){
		registerError("Error handling actual user save", e);
	}
	return arguments.oUser;
}

}
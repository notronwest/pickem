component accessors="true" extends="model.services.baseService" {

property name="userGateway";

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
			lstValues = ("#oUser.getSUsername()#,#oUser.getSPassword()#,#oUser.getSFirstName()#,#oUser.getSLastName()#,#oUser.getSEmail()#,#request.sSiteURL#" );
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

}
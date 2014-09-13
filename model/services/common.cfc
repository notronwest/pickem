component accessors="true" extends="model.services.baseService" {

public boolean function isMobileView(){
	var bIsMobile = false;
	if( reFindNoCase("(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino",CGI.HTTP_USER_AGENT) GT 0 OR reFindNoCase("1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-",Left(CGI.HTTP_USER_AGENT,4)) GT 0){
		bIsMobile = true;
	}
	return bIsMobile;
}

public void function sendEmail( Required String sTo, Required String sSubject, Required String sMessage, String sFrom = request.sAdminEmail){
	// Create an instance of the mail object
	  var mail=new mail();
	 
	  // Set it's properties
	  mail.setSubject( arguments.sSubject );
	  mail.setTo( arguments.sTo );
	  mail.setFrom( arguments.sFrom );
	  //mail.setCC( "cc@example.com" );
	  //mail.setBCC( "bcc@example.com" );
	 
	  // Add an attachment
	  //mail.addParam( file="C:\foo.txt" );
	 
	  // Add email body content in text and HTML formats
	  mail.addPart( type="text", charset="utf-8", wraptext="72", body=arguments.sMessage );
	  //mail.addPart( type="html", charset="utf-8", body="<p>This is a test message.</p>" );
	 
	  // Send the email
	  mail.send();
}

/*
Author: 	
	Ron West
Name:
	$dateTimeFormat
Summary:
	Returns the date/time in a nice view
Returns:
	String dtFormatted
Arguments:
	String dtDate
History:
	2013-05-12 - RLW - Created
*/
public String function dateTimeFormat( String dtToFormat = now() ){
	var dtFormatted = dateFormat(arguments.dtToFormat, 'mm/dd/yyyy');
	if( listFirst(timeFormat(arguments.dtToFormat, 'HH:mm'), ":") gte 12 ){
		dtFormatted = dtFormatted & " " & timeFormat(arguments.dtToFormat, 'h:mm') & " PM EDT";
	} else {
		dtFormatted = dtFormatted & " " & timeFormat(arguments.dtToFormat, 'h:mm') & " AM EDT";
	}
	return dtFormatted;
}

/*
Author: 	
	Ron West
Name:
	$getURL
Summary:
	Acts a wrapper for cfhttp so you can call from within a script tag
Returns:
	Struct stResult
Arguments:
	String sURL
	String sUsername
	String sPassword
History:
	2014-09-12 - RLW - Created
*/
public Struct function getURL( Required String sURL, Numeric nTimeout=5, Struct stParams={}, String sUsername = "api", String sPassword = "api" ){
	var sResults = "";
	var stResult = { "statusCode" = 404, "fileContent" = "" };
	var httpService = new http();
	var sKey = "";
	try{
		// check to see if the URL has protocol
		if( !findNoCase("http://", arguments.sURL) or !findNoCase("https://", arguments.sURL) ){
			if( compareNoCase(left(arguments.sURL, 1), "/") eq 0 ){
				arguments.sURL = request.sSiteURL & right(arguments.sURL, len(arguments.sURL - 1));
			}
			
		}
		httpService.setUrl(arguments.sURL);
	    httpService.setTimeOut(arguments.nTimeout);
		// set username and password
	    httpService.setAttributes(username = arguments.sUsername);
	    httpService.setAttributes(password = arguments.sPassword);
	   	/* add additional params */
	   	for(sKey in arguments.stParams){
	   		httpService.addParam(type = "url",name = sKey,value = arguments.stParams[sKey]);
	   	}
	   	// add user agent
	   	httpService.addParam(type="header", name="user-agent", value="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/38.0.2125.44 Safari/537.36");
	    /* make the http call to the URL using send() */
	    stResult = httpService.send().getPrefix();
	} catch ( any e ){
		// TODO Error logging
		writeDump(e);
	}
	return stResult;
}

/*
Author: 	
	Ron West
Name:
	$parseToFindString
Summary:
	Parses a set string to extract content
Returns:
	String sResult
Arguments:
	String sContent
	String sBegin
	String sEnd
History:
	2014-09-12 - RLW - Created
*/
public String function parseToFindString( Required String sContent, Required String sBegin, Required String sEnd){
	var nStart = 0;
	var nEnd = 0;
	var sResult = "";
	nStart = findNoCase(arguments.sBegin, arguments.sContent);
	if( nStart gt 0 ){
		nStart = nStart + len(arguments.sBegin);
		nEnd = findNoCase(arguments.sEnd, arguments.sContent, nStart);
		if( nEnd gt 0){
			sResult = mid(arguments.sContent, nStart, nEnd - nStart);
		}
	}
	return sResult;
}

}
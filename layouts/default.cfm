<cfparam name="rc.bIsDialog" default="false">
<cfparam name="rc.sNav" default="">
<cfparam name="rc.sSideBar" default="">
<cfparam name="rc.sPageTitle" default="Pickem">
<cfparam name="rc.bShowDebug" default="false">
<cfif not rc.bIsDialog><!DOCTYPE html>
<html>
<head>
	<title></title>
  <meta name="google-site-verification" content="63amUBorjOqgr1ak6LIQtZT6qaqPec7cCm844FIKuog" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=0">
    <meta name="description" content="">
    <meta name="author" content="">
    <meta name="keywords" content="Football">
    <link href="/assets/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="/assets/css/jquery.dataTables.min.css" rel="stylesheet"/>
    <link href="/assets/css/font-awesome.min.css" rel="stylesheet"/>
    <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
      <script src="../assets/js/html5shiv.js"></script>
    <![endif]-->
    <!-- Fav and touch icons -->
    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="/assets/ico/apple-touch-icon-144-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="/assets/ico/apple-touch-icon-114-precomposed.png">
      <link rel="apple-touch-icon-precomposed" sizes="72x72" href="/assets/ico/apple-touch-icon-72-precomposed.png">
                    <link rel="apple-touch-icon-precomposed" href="/assets/ico/apple-touch-icon-57-precomposed.png">
                                   <link rel="shortcut icon" href="/assets/ico/favicon.png">
  	<link href="/assets/css/jquery.jgrowl.css" rel="stylesheet"/>
  	<link href="/assets/css/jquery-ui-1.10.3.custom.min.css" rel="stylesheet"/>
  	<link href="/assets/css/default.css" rel="stylesheet"/>
	  <script src="/assets/js/jquery.js"></script>
    <!--- // <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.10.1/jquery.min.js"></script> --->
    <script src="/assets/js/modernizr.custom.js"></script>
    
</head>
<body>
<cfoutput>
#view('nav/main')#
	<div class="container">
		<div id="main" class="row">
			<div class="col-md-12 content">
        <!--- if the current user is not the current user --->
        <cfif rc.stUser.nUserID neq rc.nCurrentUser>
          <div id="impersonating" class="alert alert-info">
            You are currently impersonating #rc.oCurrentUser.getSFirstName()# #rc.oCurrentUser.getSLastName()#
            <a class="close" data-dismiss="alert" href="##" aria-hidden="true">&times;</a>
          </div>
        </cfif>#body#</div>
        <script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
        <!-- Pickem - Mobile -->
        <cfif rc.bIsMobile>
          <ins class="adsbygoogle"
               style="display:inline-block;width:320px;height:50px"
               data-ad-client="ca-pub-1027916687663589"
               data-ad-slot="9762063481"></ins>
        <cfelse>
          <!-- Pickem -->
          <ins class="adsbygoogle"
               style="display:inline-block;width:728px;height:90px"
               data-ad-client="ca-pub-1027916687663589"
               data-ad-slot="4134332285"></ins>
        </cfif>
        <script>
          (adsbygoogle = window.adsbygoogle || []).push({});
        </script>
		</div>
	</div>
</cfoutput>
<!--- // <script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.10.3/jquery-ui.min.js"></script> --->
<script src="/assets/js/jquery-ui-1.10.3.js"></script>
<script src="/assets/js/jquery.offcanvasmenu.js"></script>
<script src="/assets/js/fastclick.js"></script>
<script src="/assets/js/jquery.csswatch.js"></script>
<script src="/assets/js/bootstrap.min.js"></script>
<script src="/assets/js/jquery.dataTables.min.js"></script>
<script src="/assets/js/jquery.jgrowl.min.js"></script>
<script src="/assets/js/jquery.json-2.3.min.js"></script>
<script src="/assets/js/global.js"></script>
<!--- // only do this if we are in production --->
<cfif not request.bIsDevelopment>
  <script>
    (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
    (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
    m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
    })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

    ga('create', 'UA-42929896-1', 'inquisibee.com');
    ga('send', 'pageview');

  </script>
</cfif>
</body>
</html>
<!--- // send back just the raw data --->
<cfelse><cfoutput>#body#</cfoutput></cfif>
<!--- // determine whether or not to show debug --->
<cfif not rc.bShowDebug><cfsetting showDebugOutput="No"></cfif>
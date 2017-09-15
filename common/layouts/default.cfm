<cfparam name="rc.bIsDialog" default="false">
<cfparam name="rc.sNav" default="">
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

  <!-- Fav and touch icons -->
  <link rel="apple-touch-icon-precomposed" sizes="144x144" href="/assets/ico/apple-touch-icon-144-precomposed.png">
  <link rel="apple-touch-icon-precomposed" sizes="114x114" href="/assets/ico/apple-touch-icon-114-precomposed.png">
  <link rel="apple-touch-icon-precomposed" sizes="72x72" href="/assets/ico/apple-touch-icon-72-precomposed.png">
  <link rel="apple-touch-icon-precomposed" href="/assets/ico/apple-touch-icon-57-precomposed.png">

  <!--- // CSS Assets --->
  <link href="/assets/css/styles.min.css" rel="stylesheet"/>

  <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
  <!--[if lt IE 9]>
    <script src="../assets/js/html5shiv.min.js"></script>
  <![endif]-->

  <script src="/assets/js/modernizr.custom.min.js"></script>
  <script>
    (function(funcName, baseObj) {
        // The public function name defaults to window.docReady
        // but you can pass in your own object and own function name and those will be used
        // if you want to put them in a different namespace
        funcName = funcName || "docReady";
        baseObj = baseObj || window;
        var readyList = [];
        var readyFired = false;
        var readyEventHandlersInstalled = false;

        // call this when the document is ready
        // this function protects itself against being called more than once
        function ready() {
            if (!readyFired) {
                // this must be set to true before we start calling callbacks
                readyFired = true;
                for (var i = 0; i < readyList.length; i++) {
                    // if a callback here happens to add new ready handlers,
                    // the docReady() function will see that it already fired
                    // and will schedule the callback to run right after
                    // this event loop finishes so all handlers will still execute
                    // in order and no new ones will be added to the readyList
                    // while we are processing the list
                    readyList[i].fn.call(window, readyList[i].ctx);
                }
                // allow any closures held by these functions to free
                readyList = [];
            }
        }

        function readyStateChange() {
            if ( document.readyState === "complete" ) {
                ready();
            }
        }

        // This is the one public interface
        // docReady(fn, context);
        // the context argument is optional - if present, it will be passed
        // as an argument to the callback
        baseObj[funcName] = function(callback, context) {
            // if ready has already fired, then just schedule the callback
            // to fire asynchronously, but right away
            if (readyFired) {
                setTimeout(function() {callback(context);}, 1);
                return;
            } else {
                // add the function and context to the list
                readyList.push({fn: callback, ctx: context});
            }
            // if document already ready to go, schedule the ready function to run
            if (document.readyState === "complete") {
                setTimeout(ready, 1);
            } else if (!readyEventHandlersInstalled) {
                // otherwise if we don't have event handlers installed, install them
                if (document.addEventListener) {
                    // first choice is DOMContentLoaded event
                    document.addEventListener("DOMContentLoaded", ready, false);
                    // backup is window load event
                    window.addEventListener("load", ready, false);
                } else {
                    // must be IE
                    document.attachEvent("onreadystatechange", readyStateChange);
                    window.attachEvent("onload", ready);
                }
                readyEventHandlersInstalled = true;
            }
        }
    })("docReady", window);

    docReady(function(){
      $("#overridePicks").on("click", function(){
        $.get("/?action=security:main.overridePicks", function(bOk){
            if( !bOk ){
              alert("Sorry you are not permitted to override picks at this point");
            } else {
              alert("Ok, you can now override any picks - please be careful");
              location.reload();
            }
          }, "json"
        );
      });
      $("#cancelOverride").on("click", function(){
        $.get("/?action=security:main.cancelOverridePicks", function(bOk){
            if( bOk ){
              alert("Ok, you are no longer overriding picks for this user");
              location.reload();
            } else {
              alert("Something went wrong, please try again");
            }
          }, "json"
        );
      })
    });

    // put total purse available as jquery
    nTotalPurse = <cfoutput>#((!isNull(rc.oCurrentSeason.getNTotalPurse())) ? rc.oCurrentSeason.getNTotalPurse() : 0)#</cfoutput>;
  </script>
  <cfif rc.bShowPageLevelAds>
    <cfoutput>
      <script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
      <script>
        (adsbygoogle = window.adsbygoogle || []).push({
          google_ad_client: "ca-pub-1027916687663589",
          enable_page_level_ads: true
        });
      </script>
   </cfoutput>
  </cfif>
</head>
<body>
<cfoutput>
<cfif request.bIsDevelopment>
  <div class="alert alert-info">Development environment</div>
<cfelseif request.bIsStaging>
  <div class="alert alert-warning">Staging environment</div>
</cfif>
#view('common:nav/main')#
	<div class="container">
		<div id="main" class="row">
			<div class="col-md-12 content">
        <cfif rc.stUser.nUserID gt 0 and arrayLen(rc.arUserSubscription) eq 0 or ( arrayLen(rc.arUserSubscription) gt 0 and rc.arUserSubscription[1].getNAmount() neq rc.oCurrentSeason.getNSubscriptionAmount())>
          <div class="alert alert-warning">The league fee will be $#rc.oCurrentSeason.getNSubscriptionAmount()# this season. #rc.oCurrentSeason.getSPaymentText()#</div>
        </cfif>
        <!--- if the current user is not the current user --->
        <cfif rc.stUser.nUserID neq rc.nCurrentUser>
          <div id="impersonating" class="alert alert-info">
            You are currently impersonating #rc.oCurrentUser.getSFirstName()# #rc.oCurrentUser.getSLastName()#
            <a class="close" data-dismiss="alert" href="##" aria-hidden="true">&times;</a>
            <cfif !rc.bManualOverridePicks><button id="overridePicks">Override Picks</button><cfelse><button id="cancelOverride">Cancel Override Picks</button></cfif>
          </div>
        </cfif><script src="/assets/js/global.min.js"></script>#body#</div>
        <footer>
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
        </footer>
		</div>
	</div>
</cfoutput>

<script src="/assets/js/main.min.js"></script>
<!--- // only do this if we are in production
<cfif not request.bIsDevelopment>
  <script>
    (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
    (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
    m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
    })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

    ga('create', 'UA-42929896-1', 'inquisibee.com');
    ga('send', 'pageview');

  </script>
</cfif> --->
<div id="modal">
    <div id="admin" class="panel panel-default">
      <div class="panel-heading text-right">
        <!-- Add an optional button to close the popup -->
        <button class="modal_close">Close</button>
      </div>
      <div class="content">here i am</div>
      <div class="panel-footer text-right">
        <!-- Add an optional button to close the popup -->
        <button class="modal_close">Close</button>
      </div>
    </div>
  </div>
</body>
</html>
<!--- // send back just the raw data --->
<cfelse><cfoutput>#body#</cfoutput></cfif>
<!--- // determine whether or not to show debug --->
<cfif not rc.bShowDebug><cfsetting showDebugOutput="No"></cfif>

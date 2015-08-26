<nav class="navbar navbar-default">
  <div class="container-fluid container">
      <div id="menu-trigger"><a class="fa fa-bars fa-lg"></a></div>
      <cfoutput><a class="navbar-brand" href="#buildURL('standing.home')#">Pickem</a></cfoutput>

      <ul class="nav navbar-nav" id="menu">
        <cfoutput>
          <li<cfif compareNoCase(listFirst(request.action, "."), "standing") eq 0 and not rc.bIsAdminAction> class="active"</cfif>>
            <a href="#buildURL('standing.home')#"><span class="fa fa-list-ol fa-fw"></span> Standings</a>
          </li>
    			<li<cfif compareNoCase(listFirst(request.action, "."), "pick") eq 0 and not rc.bIsAdminAction> class="active"</cfif>>
            <a href="#buildURL('pick.set')#"><span class="fa fa-crosshairs fa-fw"></span> Picks</a>
          </li>
          <li<cfif compareNoCase(listFirst(request.action, "."), "user") eq 0 and not rc.bIsAdminAction> class="active"</cfif>>
            <a href="#buildURL('user.addEdit')#"><span class="fa fa-user fa-fw"></span>Account</a>
          </li>
          <!--- // <li<cfif compareNoCase(listFirst(request.action, "."), "setting") eq 0 and not rc.bIsAdminAction> class="active"</cfif>>
            <a href="#buildURL('setting.set')#"><span class="fa fa-gear fa-fw"></span>Settings</a>
          </li> --->
    			<cfif rc.stUser.bIsAdmin eq 1>
            <li<cfif compareNoCase(listLast(request.action, "."), "admin") eq 0 or rc.bIsAdminAction> class="active"</cfif>>
              <a href="#buildURL('main.admin')#"><span class="fa fa-cubes fa-fw"></span> Admin</a>
            </li>
          </cfif>
          <li>
            <a href="#buildURL('security.logout')#"><span class="fa fa-unlock-alt fa-fw"></span> Logout</a>
          </li>
          <li>
            <a>#rc.oCurrentSeason.getSName()# Prize pool: #dollarFormat(rc.oCurrentSeason.getNCalculatedPurse())#</a>
          </li>
        </cfoutput>
      </ul>
  </div>
</nav>
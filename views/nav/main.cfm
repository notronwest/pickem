<nav class="navbar navbar-default">
  <div class="container-fluid container">
      <div id="menu-trigger"><a class="fa fa-bars fa-lg"></a></div>
      <cfoutput><a class="navbar-brand" href="#buildURL('standing.home')#">Pickem</a></cfoutput>

      <ul class="nav navbar-nav" id="menu">
        <cfoutput>
          <li<cfif compareNoCase(listFirst(request.action, "."), "standing") eq 0> class="active"</cfif>>
            <a href="#buildURL('standing.home')#"><span class="fa fa-list-ol fa-fw"></span> Standings</a>
          </li>
    			<li<cfif compareNoCase(listFirst(request.action, "."), "pick") eq 0> class="active"</cfif>>
            <a href="#buildURL('pick.set')#"><span class="fa fa-crosshairs fa-fw"></span> Picks</a>
          </li>
          <li<cfif compareNoCase(listFirst(request.action, "."), "user") eq 0> class="active"</cfif>>
            <a href="#buildURL('user.addEdit')#"><span class="fa fa-user fa-fw"></span>Account</a>
          </li>
    			<cfif rc.stUser.bIsAdmin>
            <li<cfif compareNoCase(listLast(request.action, "."), "admin") eq 0> class="active"</cfif>>
              <a href="#buildURL('main.admin')#"><span class="fa fa-cogs fa-fw"></span> Admin</a>
            </li>
          </cfif>
          <li>
            <a href="#buildURL('security.logout')#"><span class="fa fa-unlock-alt fa-fw"></span> Logout</a>
          </li>
        </cfoutput>
      </ul>
  </div>
</nav>
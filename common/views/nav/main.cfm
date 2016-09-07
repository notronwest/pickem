<nav class="navbar navbar-default">
  <div class="container-fluid container">
      <div id="menu-trigger"><a class="fa fa-bars fa-lg"></a></div>
      <cfoutput><a class="navbar-brand" href="#buildURL('manager:standing.home')#">#rc.oCurrentLeague.getSName()#</a></cfoutput>
        <ul class="nav navbar-nav" id="menu">
          <cfoutput>
              <li>
                <a href="#buildURL('manager:main.about')#"><span class="fa fa-bookmark-o fa-fw"></span> About</a>
              </li>
          </cfoutput>
          <cfif rc.stUser.nUserID gt 0>
            <cfoutput>
              <li<cfif compareNoCase(listFirst(request.action, "."), "standing") eq 0 and not rc.bIsAdminAction> class="active"</cfif>>
                <a href="#buildURL('manager:standing.home')#"><span class="fa fa-list-ol fa-fw"></span> Standings</a>
              </li>
        			<li<cfif compareNoCase(listFirst(request.action, "."), "pick") eq 0 and not rc.bIsAdminAction> class="active"</cfif>>
                <a href="#buildURL('manager:pick.set')#"><span class="fa fa-crosshairs fa-fw"></span> Picks</a>
              </li>
              <li<cfif compareNoCase(listFirst(request.action, "."), "user") eq 0 and not rc.bIsAdminAction> class="active"</cfif>>
                <a href="#buildURL('manager:user.addEdit')#"><span class="fa fa-user fa-fw"></span>Account</a>
              </li>
              <cfif request.stLeagueSettings[rc.oCurrentLeague.getSKey()].bShowPayouts>
                <li<cfif compareNoCase(listFirst(request.action, "."), "seasonPayout") eq 0> class="active"</cfif>>
                  <a href="#buildURL('manager:seasonPayout.details')#"><span class="fa fa-dollar fa-fw"></span>Payouts</a>
                </li>
              </cfif>
        			<cfif rc.stUser.bIsAdmin eq 1>
                <li<cfif compareNoCase(listLast(request.action, "."), "admin") eq 0 or rc.bIsAdminAction> class="active"</cfif>>
                  <a href="#buildURL('manager:main.admin')#"><span class="fa fa-cubes fa-fw"></span> Admin</a>
                </li>
              </cfif>
              <li>
                <a href="#buildURL('security:main.logout')#"><span class="fa fa-unlock-alt fa-fw"></span> Logout</a>
              </li>
              <li>
                <a>#rc.oCurrentSeason.getSName()# Prize pool: #dollarFormat(rc.oCurrentSeason.getNCalculatedPurse())#</a>
              </li>
            </cfoutput>
          </cfif>
        </ul>
  </div>
</nav>
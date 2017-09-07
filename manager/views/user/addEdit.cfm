<cfoutput><form id="addEditUser" action="#buildURL('manager:user.save')#" method="post">
<div class="panel panel-default">
	<div class="panel-heading"><cfif rc.oUser.getNUserID() eq 0>Add<cfelse>Edit</cfif> User (#rc.oUser.getSEmail()#)</div>
	<div class="panel-body">
		<div>
			<cfif len(rc.sMessage) gt 0>
				<div class="alert alert-info">
					#rc.sMessage#
				</div>
			</cfif>
			<div class="form-group">
				<label for="sFirstName">First Name: </label>
				<input type="text" id="sFirstName" name="sFirstName" class="form-control" value="#rc.oUser.getSFirstName()#"/>
			</div>
			<div class="form-group">
				<label for="sLastName">Last Name: </label>
				<input type="text" id="sLastName" name="sLastName" class="form-control" value="#rc.oUser.getSLastName()#"/>
			</div>
			<!--- // <div class="form-group">
				<label for="sNickname">Nickname: </label>
				<input type="text" id="sNickname" name="sNickname" class="form-control" value="#rc.oUser.getSNickname()#"/>
				<abbr>Change your "preferences" if you want your nickname to appear instead of your full name</abbr>
			</div> --->
			<cfif rc.stUser.bIsAdmin>
				<div class="form-group">
					<label for="sEmail">E-mail: </label>
					<input type="text" id="sEmail" name="sEmail" class="form-control" value="#rc.oUser.getSEmail()#"/>
				</div>
				<div class="form-group">
					<label for="bActive">Status: </label>
					<select size="1" id="bActive" name="bActive" class="form-control">
						<option value="1"<cfif rc.oUser.getBActive() eq 1> selected="selected"</cfif>>Active</option>
						<option value="0"<cfif rc.oUser.getBActive() eq 0> selected="selected"</cfif>>Inactive</option>
					</select>
				</div>
			<cfelse>
				<input type="hidden" name="bActive" value="#rc.oUser.getBActive()#"/>
			</cfif>
			<cfif (!rc.stUser.bIsAdmin or rc.bAdminIsUser) and !rc.oUser.getNUserID() eq 0>
				<div class="form-group">
					<a href="#buildURL('user.changePassword')#">Change password</a>
				</div>
				<cfif rc.stLeagueSettings.bHasUserPreferences>
					<div class="form-group">
						<a href="#buildURL('setting.set')#">Change preferences</a>
					</div>
				</cfif>
			</cfif>
			<cfif rc.stUser.bIsAdmin>
				<div class="checkbox">
					<label for="bIsAdmin" class="checkbox"><input type="checkbox" id="bIsAdmin" name="bIsAdmin" value="1"<cfif rc.oUser.getBIsAdmin() eq 1> checked="checked"</cfif>/> Admin (*)</label>
				</div>
			</cfif>
			<cfif !rc.bAddNew and arrayLen(rc.arUserSubscription) gt 0 and rc.arUserSubscription[1].getNAmount() eq rc.oCurrentSeason.getNSubscriptionAmount()>
          		<div class="alert alert-warning">Subscription paid for #rc.oCurrentSeason.getSName()# season. Thank you.</div>
        	</cfif>
			<div class="form-group text-right">
				<button type="button" class="save btn btn-default">Save</button><cfif rc.stUser.bIsAdmin><button type="button" class="cancel btn btn-default">Cancel</button></cfif>
			</div>
			<input type="hidden" id="nUserID" name="nUserID" value="#rc.oUser.getNUserID()#"/>
		</div>
	</div>
</div></form>
</cfoutput>

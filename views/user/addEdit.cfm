<cfoutput><form id="addEditUser" action="#buildURL('user.save')#" method="post">
<div class="panel panel-default">
	<div class="panel-heading"><cfif rc.oUser.getNUserID() eq 0>Add<cfelse>Edit</cfif> User</div>
	<div class="panel-body">
		<div class="container">
			<span class="hide error alert alert-warning"></span> 
			<!--- // <cfif structKeyExists(rc, "bShowProfile") and rc.bShowProfile> --->
				<div class="input-group">
					<label for="sFirstName">First Name: </label>
					<input type="text" id="sFirstName" name="sFirstName" class="form-control" value="#rc.oUser.getSFirstName()#"/>
				</div>
				<div class="input-group">
					<label for="sLastName">Last Name: </label>
					<input type="text" id="sLastName" name="sLastName" class="form-control" value="#rc.oUser.getSLastName()#"/>
				</div>
				<div class="input-group">
					<label for="sEmail">E-mail: </label>
					<input type="text" id="sEmail" name="sEmail" class="form-control" value="#rc.oUser.getSEmail()#"/>
				</div>
			<!--- // </cfif>
			<cfif structKeyExists(rc, "bShowCredentials") and rc.bShowCredentials> --->
				<cfif rc.oUser.getNUserID() neq 0>
					<!--- // pass the username in without updating it --->
					<input type="hidden" name="sUsername" id="sUsername" value="#rc.oUser.getSUsername()#"/>
				<cfelse>
					<div class="input-group">
						<label for="sUsername">Username: </label>
						<input type="text" id="sUsername" name="sUsername" class="form-control" value="#rc.oUser.getSUsername()#"/>
					</div>
				</cfif>
				<div class="input-group">
					<label for="sPassword">Password: </label>
					<input type="password" id="sPassword" name="sPassword" class="form-control" value=""/>
				</div>
				<div class="input-group">
					<label for="sConfirm">Confirm: </label>
					<input type="password" id="sConfirm" name="sConfirm" class="form-control" value=""/>
				</div>
			<!--- // </cfif> --->
			<!--- // <cfif structKeyExists(rc, "bShowProfile") and rc.bShowProfile and rc.stUser.bIsAdmin> --->
			<cfif rc.stUser.bIsAdmin>
				<div class="checkbox">
					<label for="bIsAdmin" class="checkbox"><input type="checkbox" id="bIsAdmin" name="bIsAdmin" value="1"<cfif rc.oUser.getBIsAdmin() eq 1> checked="checked"</cfif>/> Admin (*)</label>
				</div>
			</cfif>
			<div class="input-group text-right">
				<button type="button" class="save btn btn-default">Save</button> <button type="button" class="cancel btn btn-default">Cancel</button>
			</div>
			<input type="hidden" id="nUserID" name="nUserID" value="#rc.oUser.getNUserID()#"/>
		</div>
	</div>
</div></form>
<cfif rc.bProfileSaved><script> $(function(){ showError("Profile Saved"); } );</script></cfif>
</cfoutput>
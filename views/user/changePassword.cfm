<cfdump var="#session#">
<cfparam name="rc.sMessageType" default="info">
<cfparam name="rc.sMessage" default="">
<cfoutput>
<h3>Change your password</h3>
<form id="password" action="#buildURL('user.changePassword')#" method="post">
	<div class="panel panel-default">
		<div class="panel-body">
			<cfif len(rc.sMessage) gt 0>
				<div class="alert alert-#rc.sMessageType#">
					#rc.sMessage#
				</div>
			</cfif>
			<div class="form-group">
				<div class="input-group">
					<div class="input-group-addon">
						<span class="fa fa-lock fa-fw fa-lg"></span>
					</div>
					<input type="password" name="sCurrentPassword" id="sCurrentPassword" class="form-control input-sm" placeholder="current password"/>
				</div>
			</div>
			<div class="form-group">
				<div class="input-group">
					<div class="input-group-addon">
						<span class="fa fa-lock fa-fw fa-lg"></span>
					</div>
					<input type="password" name="sPassword" id="sPassword" class="form-control input-sm" placeholder="new password"/>
				</div>
			</div>
			<div class="form-group">
				<div class="input-group">
					<div class="input-group-addon">
						<span class="fa fa-lock fa-fw fa-lg"></span>
					</div>
					<input type="password" id="sConfirm" class="form-control input-sm" placeholder="confirm"/>
				</div>
			</div>
		</div>
		<div class="panel-footer text-right"><button class="save btn btn-primary btn-xs" id="loginUser">Save</button></div>
		<input type="hidden" name="nUserID" value="#rc.oUser.getNUserID()#"/>
		<input type="hidden" name="bProcess" value="true"/>
	</div>
</form>
</section>
</cfoutput>
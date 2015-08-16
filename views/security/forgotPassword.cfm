<cfparam name="rc.sMessageType" default="login">
<cfparam name="rc.sMessage" default="">
<cfoutput>
<form id="login" action="#buildURL('security.forgotPassword')#" method="post">
	<div class="panel panel-default">
		<div class="panel-heading">
			<h3 class="panel-title">Forgot Password</h3>
		</div>
		<div class="panel-body">
			<cfif len(rc.sMessage) gt 0>
				<div class="alert alert-info">
					#rc.sMessage#
				</div>
			</cfif>
			<div class="form-group">
				<div class="input-group">
					<div class="input-group-addon">
						<span class="fa fa-envelope-o fa-fw fa-lg"></span>
					</div>
					<input type="email" name="sEmail" id="sEmail" class="form-control input-sm" placeholder="Enter your e-mail address"/>
				</div>
			</div>
		</div>
		<div class="panel-footer text-right"><button class="save btn btn-primary btn-xs" id="loginUser">Get Password</button></div>
		<input type="hidden" name="bProcess" value="true"/>
	</div>
</form>
</section>
</cfoutput>
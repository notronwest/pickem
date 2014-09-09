<cfparam name="rc.sMessageType" default="info">
<cfparam name="rc.sMessage" default="">
<cfoutput>
<form id="login" action="#buildURL('security.authenticate')#" method="post">
	<div class="panel panel-default">
		<div class="panel-heading">
			<h3 class="panel-title">Login</h3>
		</div>
		<div class="panel-body">
			<cfif len(rc.sMessage) gt 0>
				<div class="alert alert-#rc.sMessageType#">
					#rc.sMessage#
				</div>
			</cfif>
			<div class="input-group">
				<span class="input-group-addon"><span class="fa fa-envelope-o fa-fw fa-lg"></span></span>
				<div class="controls"><input type="email" name="sUsername" id="sUsername" class="form-control input-sm" placeholder="username"/></div>
			</div>
			<div class="input-group">
				<span class="input-group-addon"><span class="fa fa-lock fa-fw fa-lg"></span></span>
				<div class="controls"><input type="password" name="sPassword" id="sPassword" class="form-control input-sm" placeholder="password"/></div>
			</div>
		</div>
		<div class="panel-footer text-right"><button class="save btn btn-primary btn-xs" id="loginUser">Login</button></div>
		<!--- // keep track of the current action --->
		<input type="hidden" name="sActionAfterLogin" value="#rc.sActionAfterLogin#"/>
	</div>
</form>
</section>
</cfoutput>
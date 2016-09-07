<cfparam name="rc.sMessageType" default="login">
<cfparam name="rc.sMessage" default="">
<cfoutput>
<section>
<!--- // show create account message if they haven't logged in --->
<cfif !rc.bHasLoggedIn>
<h3>Welcome</h3>
Interested in being in on the best kept secret on the web? Well then, just fill out this form and you are in!
<form id="register" action="#buildURL('manager:user.register')#" method="post">
	<div class="panel panel-default">
		<div class="panel-heading">
			<h3 class="panel-title" style="float:none;">Join Now!</h3>
		</div>
		<div class="panel-body">
			<cfif len(rc.sMessage) gt 0 and compareNoCase(rc.sMessageType, "register") eq 0>
				<div class="alert alert-info">
					#rc.sMessage#
				</div>
			</cfif>
			<div class="form-group">
				<div class="input-group">
					<div class="input-group-addon">
						<span class="fa fa-envelope-o fa-fw fa-lg"></span>
					</div>
					<input type="email" name="sEmail" id="sEmail" class="form-control input-sm" placeholder="Enter your e-mail address to get started"/>
				</div>
			</div>
		</div>
		<div class="panel-footer text-right"><button class="save btn btn-primary btn-xs" id="loginUser">Join!</button></div>
	</div>
</form>
<h3>Already a member - Login below</h3>
</cfif>
<form id="login" action="#buildURL('security:main.authenticate')#" method="post">
	<div class="panel panel-default">
		<div class="panel-heading">
			<h3 class="panel-title">Login</h3>
		</div>
		<div class="panel-body">
			<cfif len(rc.sMessage) gt 0 and compareNoCase(rc.sMessageType, "login") eq 0>
				<div class="alert alert-info">
					#rc.sMessage#
				</div>
			</cfif>
			<div class="form-group">
				<div class="input-group">
					<div class="input-group-addon">
						<span class="fa fa-envelope-o fa-fw fa-lg"></span>
					</div>
					<input type="email" name="sUsername" id="sUsername" class="form-control input-sm" placeholder="username"/>
				</div>
			</div>
			<div class="form-group">
				<div class="input-group">
					<div class="input-group-addon">
						<span class="fa fa-lock fa-fw fa-lg"></span>
					</div>
					<input type="password" name="sPassword" id="sPassword" class="form-control input-sm" placeholder="password"/>
				</div>
			</div>
			<div class="form-group">
				<a href="#buildURL('security:main.forgotPassword')#">forgot password</a>
			</div>
		</div>
		<div class="panel-footer text-right"><button class="save btn btn-primary btn-xs" id="loginUser">Login</button></div>
		<!--- // keep track of the current action --->
		<input type="hidden" name="sActionAfterLogin" value="#rc.sActionAfterLogin#"/>
	</div>
</form>
</section>
</cfoutput>
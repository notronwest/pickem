<cfoutput>
<form id="login">
	<div class="panel panel-default">
		<div class="panel-heading">
			<h3 class="panel-title">Login</h3>
		</div>
		<div class="panel-body">
			<span class="hide error"></span>
			<div class="input-group">
				<span class="input-group-addon"><span class="fa fa-envelope-o fa-fw fa-lg"></span></span>
				<div class="controls"><input type="email" id="sUsername" class="form-control input-sm" placeholder="username"/></div>
			</div>
			<div class="input-group">
				<span class="input-group-addon"><span class="fa fa-lock fa-fw fa-lg"></span></span>
				<div class="controls"><input type="password" id="sPassword" class="form-control input-sm" placeholder="password"/></div>
			</div>
		</div>
		<div class="panel-footer text-right"><button type="button" class="save btn btn-primary btn-xs" id="loginUser">Login</button></div>
	</div>
</form>
</section>
</cfoutput>
<cfexit>
<cfoutput>
<form id="login">
	<div class="panel panel-default">
		<div class="panel-heading">
			<h3 class="panel-title">Login</h3>
		</div>
		<div class="panel-body">
			<div class="input-group">
				<div class="error alert alert-danger"></div>
			</div>
			<div class="input-group">
			  <label for="sEmail">Email</label>
			  <input type="email" class="form-control input-sm" name="sEmail" id="sEmail" value="#rc.oUser.getSEmail()#"/>
			  <div class="required" title="Please enter a valid e-mail"></div>
			</div>
			<div class="input-group">
			  <label for="sPassword">Password</label>
			  <input type="password" class="form-control input-sm" name="sPassword"/>
			  <div class="required" title="Please enter a valid password"></div>
			</div>
		</div>
		<div class="panel-footer text-right"><button type="button" class="btn btn-primary btn-xs">Go</button></div>
	</div>
</form>
</cfoutput>
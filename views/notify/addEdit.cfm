<cfoutput>
	<form id="addEditForm" class="form" action="#buildURL('notify.save')#" method="post">
	<div class="panel panel-default">
		<div class="panel-heading">
			<h3><cfif rc.oNotification.getNNotifyID() gt 0>Edit<cfelse>Add</cfif> Notification</h3>
		</div>
		<div class="panel-body">
				<div class="form-group">
					<label for="dStartDate">Setting: </label>
					<select name="nOptionID" id="nOptionID" size="1">
						<option value="">--Select--</option>
						<cfloop collection="#rc.stOptions#" item="local.nOptionID">
							<cfif rc.stOptions[local.nOptionID].bCanNotify eq 1>
								<option value="#nOptionID#"<cfif rc.oNotification.getNOptionID() eq nOptionID> selected="selected"</cfif>>#rc.stOptions[local.nOptionID].sShortName#</option>
							</cfif>
						</cfloop>
					</select>	
				</div>
				<div class="form-group">
					<label for="sSubject">Subject</label>
					<input type="text" class="form-control" id="sSubject" name="sSubject" value="#rc.oNotification.getSSubject()#" placeholder="Enter email subject"/>
				</div>
				<div class="form-group">
					<label for="sFrom">From</label>
					<input type="text" class="form-control" id="sFrom" name="sFrom" value="#rc.oNotification.getSFrom()#" placeholder="Enter from address for the notification"/>
				</div>
				<div class="form-group">
					<label for="sMessage">Message Body</label>
					<textarea class="form-control" id="sMessage" name="sMessage" rows="5">#rc.oNotification.getSMessage()#</textarea>
					<span class="help-block">Enter the following codes to make the form dynamic
						<ul>
							<li>[fistname] - the users first name</li>
							<li>[lastname] - the users last name</li>
							<li>[email] - the users email address</li>
							<li>[siteurl] - the url used to get to the site</li>
							<li>[username] - the users email</li>
							<li>[password] - the users password</li>
						</ul>
					</span>
				</div>
				<input type="hidden" name="nNotifyID" id="nNotifyID" value="#rc.oNotification.getNNotifyID()#"/>
			</div>
		</div>
		<div class="panel-footer text-right">
			<button type="button" class="btn btn-danger cancel">Cancel</button> <button type="button" class="btn btn-primary save" id="addEditWeek">Save</button>
		</div>

	</form>
</cfoutput>
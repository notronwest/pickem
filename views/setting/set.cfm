<cfoutput>
	<form id="setting" action="#buildURL('setting.save')#" method="post">
	<div class="panel panel-default">
		<div class="panel-heading">
			<h3>Settings</h3>
		</div>
		<div class="panel-body">
			<cfif len(rc.sMessage) gt 0><div class="alert alert-#rc.sMessageType#">
				#rc.sMessage#
			</div></cfif>
			<cfloop from="1" to="#arrayLen(rc.arOptions)#" index="local.itm">
				<cfscript>
					local.nOptionID = rc.arOptions[local.itm].getNOptionID();
					local.sLabel = rc.arOptions[local.itm].getSLabel();
					local.arOptions = (isJSON(rc.arOptions[local.itm].getSOptions())) ? deserializeJSON(rc.arOptions[local.itm].getSOptions()).options : [];
					local.sCurrentValue = rc.stSettings[local.nOptionID];
				</cfscript>
				<cfswitch expression="#rc.arOptions[itm].getNType()#">
					<!--- // Checkboxes --->
					<cfcase value="1">
						<div class="checkbox">
							<label for="#local.itm#" class="checkbox"><input type="checkbox" id="#local.itm#" name="#local.nOptionID#" value="1"<cfif local.sCurrentValue eq 1> checked="checked"</cfif>/> #local.sLabel#</label>
						</div>
					</cfcase>
					<!--- // selection list --->
					<cfcase value="3">
						<div class="form-group">
							<label for="#local.itm#">#local.sLabel#</label>
							<select id="#local.itm#" size="1" name="#local.nOptionID#">
								<cfloop from="1" to="#arrayLen(local.arOptions)#" index="local.x">
									<option value="#local.arOptions[local.x].sValue#"<cfif compareNoCase(local.sCurrentValue, local.arOptions[local.x].sValue) eq 0> selected="selected"</cfif>>#local.arOptions[local.x].sOption#</option>
								</cfloop>
							</select>
						</div>
					</cfcase>
				</cfswitch>
			</cfloop>
			<input type="hidden" id="nUserID" name="nUserID" value="#rc.oUser.getNUserID()#"/>
		</div>
		<div class="panel-footer text-right">
				<button type="button" class="cancel btn btn-danger">Cancel</button>
				<button class="save btn btn-primary">Save</button>
		</div>
	</form>
</cfoutput>
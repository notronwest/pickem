<cfoutput><form id="addEditSubscription" action="#buildURL('subscription.save')#" method="post">
<div class="panel panel-default">
	<div class="panel-heading"><cfif rc.oUser.getNUserID() eq 0>Add<cfelse>Edit</cfif> Subscription for #rc.oUser.getSFirstName()# #rc.oUser.getSLastName()# for the #rc.oCurrentSeason.getSName()# season</div> 
	<div class="panel-body">
		<div>
			<cfif len(rc.sMessage) gt 0>
				<div class="alert alert-info">
					#rc.sMessage#
				</div>
			</cfif>
			<div class="alert alert-info error hide"></div>
			<div class="form-group">
				<label for="nAmount">Amount: </label>
				<input type="text" id="nAmount" name="nAmount" class="form-control control-md" value="#rc.oSubscription.getNAmount()#"/>
			</div>
			<div class="form-group">
				<label for="dtPaid">Paid: </label>
				<input type="text" id="dtPaid" name="dtPaid" class="form-control date" value="#rc.oSubscription.getDTPaid()#"/>
			</div>
			<div class="form-group">
				<label for="sPaymentType">Payment Type: </label>
				<select id="sPaymentType" name="sPaymentType" class="form-control control-md">
					<option value="">-Select-</option>
					<option value="cash"<cfif rc.oSubscription.getSPaymentType() eq "cash"> selected="selected"</cfif>>Cash</option>
					<option value="check"<cfif rc.oSubscription.getSPaymentType() eq "check"> selected="selected"</cfif>>Check</option>
					<option value="paypal"<cfif rc.oSubscription.getSPaymentType() eq "paypal"> selected="selected"</cfif>>Paypal</option>
					<option value="other"<cfif rc.oSubscription.getSPaymentType() eq "other"> selected="selected"</cfif>>Other</option>
				</select>
			</div>

			<div class="form-group text-right">
				<button type="button" class="save btn btn-default">Save</button><cfif rc.stUser.bIsAdmin><button type="button" class="cancel btn btn-default">Cancel</button></cfif>
			</div>
			<input type="hidden" id="nSubscriptionID" name="nSubscriptionID" value="#rc.oSubscription.getNSubscriptionID()#"/>
			<input type="hidden" id="nUserID" name="nUserID" value="#rc.nUserID#"/>
		</div>
	</div>
</div></form>
<script>
	docReady(function(){
		$(".date").datepicker();
		<cfif rc.nSubscriptionID eq 0>$(".date").datepicker("setDate", new Date());</cfif>
	});
</script>
</cfoutput>
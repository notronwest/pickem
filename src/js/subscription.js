$(function(){	

	// bind for canceling subscription
	$(".container").on("click",".cancel", function(event){
		event.stopPropagation();
		if( confirm("Are you sure you would like to cancel adding this subscription?") ){
			window.location.href = "/?action=user.listing";
		}
	});
	// bind for saving subscription
	$(".container").on("click", ".save", function(){
		// clear error
		showError();
		var stUser = { "nUserID": $("#nUserID").val() };
		// make sure there is a valid amount
		if( $("#nAmount").length > 0 && $("#nAmount").val().length == 0 ){
			showError("Pleae enter a valid subscription amount");
			$("#nAmount").focus();
			return false;
		}
		// make sure there is a valid date
		if( $("#dtPaid").length > 0 && $("#dtPaid").val().length == 0 ){
			showError("Please enter a valid subscription date");
			$("#dtPaid").focus();
			return false;
		}
		// make sure there is a valid payment type
		if( $("#sPaymentType").length > 0 && $("#sPaymentType").val().length == 0 ){
			showError("Please select a valid payment type");
			$("#sPaymentType").focus();
			return false;
		}

		$("#addEditSubscription").submit();
	});
});
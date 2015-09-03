var nTotalPayout,nSubscriptions;
$(function(){
	// get the value of subscriptions
	nSubscriptions = parseInt($('#nSubscriptions').html());

	// bind for opening add/edit payout
	$(".container").on("click", ".add-payout,.edit-payout", function(event){
		event.stopPropagation();
		nPayoutID = 0;
		if( $(this).hasClass("edit-payout") ){
			window.location.href = "/?action=payout.addEdit&nPayoutID=" + $(this).siblings(".nPayoutID").val();
		} else {
			window.location.href = "/?action=payout.addEdit&bAddNew=true";
		}
	});

	// bind onclick for deleting payout
	$(".container").on("click", ".delete-payout", function(event){
		event.stopPropagation();
		if( confirm("Are you sure you would like to delete the payout") ){
			window.location.href = "/index.cfm?action=payout.delete&nPayoutID=" + $(this).siblings(".nPayoutID").val();
		}
	});

	// bind for canceling payout
	$(".container").on("click",".cancel", function(event){
		event.stopPropagation();
		if( confirm("Are you sure you would like to cancel adding this payout?") ){
			window.location.href = "/?action=payout.listing";
		}
	});
	// bind for saving payout
	$(".container").on("click", ".save", function(){
		// clear error
		showError();


		$("#addEditPayout").submit();
	});
	// set payouts for the current season
	$(".set-payouts").on("click", function(){
		window.location.href = "/?action=seasonPayout.listing";
	});

});
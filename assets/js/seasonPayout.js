var nTotalPayout,nSubscriptions;
$(function(){
	// get the value of subscriptions
	nSubscriptions = parseInt($('#nSubscriptions').html());

	// bind for opening add/edit seasonPayout
	$(".container").on("click", ".add-seasonPayout,.edit-seasonPayout", function(event){
		event.stopPropagation();
		nPayoutID = 0;
		if( $(this).hasClass("edit-seasonPayout") ){
			window.location.href = "/?action=seasonPayout.addEdit&nSeasonPayoutID=" + $(this).siblings(".nSeasonPayoutID").val();
		} else {
			window.location.href = "/?action=seasonPayout.addEdit&bAddNew=true";
		}
	});

	// bind onclick for deleting seasonPayout
	$(".container").on("click", ".delete-seasonPayout", function(event){
		event.stopPropagation();
		if( confirm("Are you sure you would like to delete the seasonPayout") ){
			window.location.href = "/index.cfm?action=seasonPayout.delete&nSeasonPayoutID=" + $(this).siblings(".nSeasonPayoutID").val();
		}
	});

	// bind for canceling seasonPayout
	$(".container").on("click",".cancel", function(event){
		event.stopPropagation();
		if( confirm("Are you sure you would like to cancel adding this season payout?") ){
			window.location.href = "/?action=seasonPayout.listing";
		}
	});
	// bind for saving seasonPayout
	$(".container").on("click", ".save", function(){
		// clear error
		showError();


		$("#addEditPayout").submit();
	});
	
	// handle creating default amount (based on the default percent)
	$("#nPayoutID").on("change", function(){
		$("#nAmount").val(getAmount($(this).find(":selected").data("percent")));
	});
});

// determines the amount of a payout based on the given percentage
function getAmount(nPercent){
	return Math.round((nTotalPurse * parseInt(nPercent))/100);
}

var nTotalPayout = 0, nSubscriptions, nAvailable;
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

	// determine whats available
	determineAvailable();

	// allow buttons to move money in and out of fields
	$(".increase,.decrease").on("click", function(){
		var nNewPayout = 0;
		var nPayout = parseInt($(this).closest("tr").find(".payout").val());
		nNewPayout = nPayout + parseInt(($(this).hasClass("increase") ) ? 5 : -5);
		// set the new payout into the field
		$(this).closest("tr").find(".payout").val(nNewPayout).addClass("updated");
		// redetermine whats available
		determineAvailable();
		// remind to save
		remindToSave();
	});

	// when the amounts are changed in the fields readjust
	$(".payout").on("focusout", function(){
		// make sure this gets marked as needing to be saved
		$(this).addClass("updated");
		determineAvailable();
		remindToSave();
	});

	// save the new payout amounts
	$(".save-all").on("click", function(){
		$(this).prop("disabled",true).html("Saving...");
		// loop through the fields that have been changed
		$(".payout.updated").each(function(){
			// post the save
			$.post("/index.cfm?action=seasonPayout.save",
				{	
					nSeasonPayoutID: $(this).data("id"),
					nAmount: $(this).val(),
					bRedirect: false
				}
			);
		});
		$(this).prop("disabled", false).html("Save All");
		// hide remeinders
		$(".save-all,.remind-to-save").addClass("hide");
		// show message for saved
		$(".saved").removeClass("hide");
		// hide it in a few seconds
		setTimeout(function(){ $(".saved").addClass("hide")}, 5000);
		// remove all of the updated fields
		$(".payout.updated").removeClass("updated");
	});
});

// determines the amount of a payout based on the given percentage
function getAmount(nPercent){
	return Math.round((nTotalPurse * parseInt(nPercent))/100);
}

function determineAvailable(){
	nTotalPayout = 0;
	// loop through all of the amounts
	$(".payout").each(function(){
		if( $(this).data("type") == "season" || $(this).data("type") == "finalWeek" ){
			nTotalPayout = nTotalPayout + parseInt($(this).val());
		} else if( $(this).data("type") == "weekly" ){
			nTotalPayout = nTotalPayout + (parseInt($(this).val() * 18));
		} 
	});

	// set payout available
	nAvailable = parseInt($("#nPurse").val()) - nTotalPayout;
	$("#available").html(nAvailable);

	// make sure available amount is greater than 0
	if(nAvailable < 0){
		$(".allocated-too-much").removeClass("hide");
	} else {
		$(".allocated-too-much").addClass("hide");
	}
}

function remindToSave(){
	$(".remind-to-save").removeClass("hide");
	// show save all button
	$(".save-all").removeClass("hide");
}
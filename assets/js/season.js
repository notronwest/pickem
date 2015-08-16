$(function(){
	// bind for opening add/edit season
	$(".container").on("click", ".add-season,.edit-season", function(event){
		event.stopPropagation();
		nSeasonID = 0;
		if( $(this).hasClass("edit-season") ){
			window.location.href = "/?action=season.addEdit&nSeasonID=" + $(this).siblings(".nSeasonID").val();
		} else {
			window.location.href = "/?action=season.addEdit&bAddNew=true";
		}
	});
	// bind for canceling season
	$(".container").on("click",".cancel", function(event){
		event.stopPropagation();
		if( confirm("Are you sure you would like to cancel adding this season?") ){
			window.location.href = "/?action=season.listing";
		}
	});
	// bind for saving season
	$(".container").on("click", ".save", function(){
		// clear error
		showError();
		var stSeason = { "nSeasonID": $("#nSeasonID").val() };
		// make sure there is a valid name
		if( $("#sName").length > 0 && $("#sName").val().length == 0 ){
			showError("Pleae enter a valid name");
			$("#sName").focus();
			return false;
		}
		// make sure there is a start date
		if( $("#dtStart").length > 0 && $("#dtStart").val().length == 0 ){
			showError("Please enter a valid start date");
			$("#dtStart").focus();
			return false;
		}
		// make sure there is a end date
		if( $("#dtEnd").length > 0 && $("#dtEnd").val().length == 0 ){
			showError("Please enter a valid end date");
			$("#dtEnd").focus();
			return false;
		}

		$("#addEditSeason").submit();
	});
	// bind onclick for deleting season
	$(".container").on("click", ".delete-season", function(event){
		event.stopPropagation();
		if( confirm("Are you sure you would like to delete the season: " + $(this).data("sName")) ){
			window.location.href = "/index.cfm?action=season.delete&nSeasonID=" + $(this).siblings(".nSeasonID").val();
		}
	});

	// load date/time fields
	setTimeout(function(){
		// add date picker
		$(".date").datepicker();
		// add time picker
		$(".time").ptTimeSelect();
	}, 1000);
});
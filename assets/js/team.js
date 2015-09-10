$(function(){
	// bind for opening add/edit team
	$(".container").on("click", ".add-team,.edit-team", function(event){
		event.stopPropagation();
		nTeamID = 0;
		if( $(this).hasClass("edit-team") ){
			window.location.href = "/?action=team.addEdit&nTeamID=" + $(this).siblings(".nTeamID").val();
		} else {
			window.location.href = "/?action=team.addEdit&bAddNew=true";
		}
	});

	// bind for canceling team
	$(".container").on("click",".cancel", function(event){
		event.stopPropagation();
		if( confirm("Are you sure you would like to cancel adding this team?") ){
			window.location.href = "/?action=team.listing";
		}
	});
	// bind for saving team
	$(".container").on("click", ".save", function(){
		// clear error
		showError();
		var stTeam = { "nTeamID": $("#nTeamID").val() };
		// make sure there is a valid name
		if( $("#sName").length > 0 && $("#sName").val().length == 0 ){
			showError("Pleae enter a valid name");
			$("#sName").focus();
			return false;
		}

		$("#addEditTeam").submit();
	});
	// bind onclick for deleting team
	$(".container").on("click", ".delete-team", function(event){
		event.stopPropagation();
		if( confirm("Are you sure you would like to delete the team - this will REALLY mess shit up") ){
			window.location.href = "/index.cfm?action=team.delete&nTeamID=" + $(this).siblings(".nTeamID").val();
		}
	});
});
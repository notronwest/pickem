$(function(){
	// bind edit notify
	$(".container").on("click", ".edit", function(){
		window.location.href = "/?action=notify.addEdit&nNotifyID=" + $(this).closest("tr").data("id")
	});
	// bind add notify
	$(".container").on("click", ".add-notify", function(){
		window.location.href = "/?action=notify.addEdit&bAdd=true";
	});
	// bind delete notify
	$(".notify-actions").on("click", ".delete", function(){
		if( confirm("Are you sure you want to delete this notify?") ){
			window.location.href = "/?action=notify.delete&nNotifyID=" + $(this).closest("tr").data("id");
		}
	});
	// bind cancel add/edit notify
	$("#addEditForm").on("click", ".cancel", function(){
		if( confirm("Are you sure you want to cancel updating the notification? All changes will be lost") ){
			window.location.href = "/?action=notify.listing";
		}
	});
	// bind save for add/edit form
	$("#addEditForm").on("click", ".save", function(){
		// validate that we have an option
		if($("#nOptionID").val().length == 0){
			alert("Please select a setting for this notification");
			$("#nOptionID").focus();
			return false;
		}
		// validate that we have a subject
		if($("#sSubject").val().length == 0){
			alert("Please enter a valid subject for this notification");
			$("#sSubject").focus();
			return false;
		}
		// validate that we have a from
		if($("#sFrom").val().length == 0){
			alert("Please enter a valid from for this notification");
			$("#sFrom").focus();
			return false;
		}
		// validate that we have a message
		if($("#sMessage").val().length == 0){
			alert("Please enter a valid message for this notification");
			$("#sMessage").focus();
			return false;
		}
		// if we get here then we are good to go
		$("#addEditForm").submit();
		return true;
	})
});
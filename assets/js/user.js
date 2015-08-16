$(function(){
	// bind for opening add/edit user
	$(".container").on("click", ".add-user,.edit-user,.edit-credentials", function(event){
		event.stopPropagation();
		nUserID = 0;
		if( $(this).hasClass("edit-user") ){
			window.location.href = "/?action=user.addEdit&nUserID=" + $(this).siblings(".nUserID").val() + "&bShowProfile=true";
		} else if ( $(this).hasClass("edit-credentials") ) {
			window.location.href = "/?action=user.addEdit&nUserID=" + $(this).siblings(".nUserID").val() + "&bShowCredentials=true";
		} else {
			window.location.href = "/?action=user.addEdit&bAddNew=true";
		}
	});
	// bind for canceling user
	$(".container").on("click",".cancel", function(event){
		event.stopPropagation();
		if( confirm("Are you sure you would like to cancel adding this user?") ){
			window.location.href = "/?action=user.listing";
		}
	});
	// bind for saving user
	$(".container").on("click", ".save", function(){
		// clear error
		showError();
		var stUser = { "nUserID": $("#nUserID").val() };
		// make sure there is a valid e-mail address
		if( $("#sEmail").length > 0 && $("#sEmail").val().length == 0 ){
			showError("Pleae enter a valid e-mail address");
			$("#sEmail").focus();
			return false;
		}
		// make sure there is a username
		if( $("#sUsername").length > 0 && $("#sUsername").val().length == 0 ){
			showError("Please enter a valid username");
			$("#sUsername").focus();
			return false;
		}
		// make sure there is a password
		if( $("#sPassword").length > 0 && $("#sPassword").val().length == 0 ){
			showError("Please enter a valid password");
			$("#sPassword").focus();
			return false;
		}
		// make sure that the passwords are the same
		if( $("#sPassword").length > 0 && $("#sPassword").val() != $("#sConfirm").val() ){
			showError("Passwords don't match");
			$("#sPassword").val("");
			$("#sConfirm").val("");
			$("#sPassword").focus();
			return false;
		}

		$("#addEditUser").submit();
	});
	// bind onclick for deleting user
	$(".container").on("click", ".delete-user", function(event){
		event.stopPropagation();
		if( confirm("Are you sure you would like to delete the user with e-mail: " + $(this).data("email")) ){
			window.location.href = "/index.cfm?action=user.delete&nUserID=" + $(this).siblings(".nUserID").val();
		}
	});
	// bind for impersonating a user
	$(".container").on("click", ".impersonate", function(){
		$.post("/?action=user.impersonate",
			{
				nImpersonateUser: $(this).siblings(".nUserID").val(),
			}, function(sResults){
				setMessage(sResults);
			}
		);
	});
	// bind for selecting/unselecting emails
	$("#selectUnselect").on("click", function(){
		if( $(this).is(":checked") ){
			$("#emailList .col-md-3 input[type='checkbox']").prop("checked", "checked");
		} else {
			$("#emailList .col-md-3 input[type='checkbox']").prop("checked", "");
		}
	})
});
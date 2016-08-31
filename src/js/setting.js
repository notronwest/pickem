$(function(){
	// bind cancel add/edit setting
	$("#setting").on("click", ".cancel", function(){
		if( confirm("Are you sure you want to cancel updating your preferences? All changes will be lost") ){
			window.location.href = "/?action=user.addEdit&sMessage=User preferences were NOT saved";
		}
	});
});
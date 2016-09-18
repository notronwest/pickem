docReady(function(){
	// do some dirty work
	$("#picks th").addClass("hidden");

	// build action for turning "make changes" on
	$(".page-controls").on("click", ".make-changes",function(){
		// hide the current pick
		$("#userPick").addClass("hidden");
		// show the headers
		$("th").removeClass("hidden");
		// turn off the button
		$(".make-changes").addClass("hidden");
		// turn on the controls
		$(".page-controls .cancel, .page-controls .save").removeClass("hidden");
		// hide the picks
		$(".game:not('.locked')").children(".picks").addClass("hidden");
		// show the controls
		$(".game:not('.locked')").removeClass("hidden");
		// remove the disabled class
		$(".game:not('.locked')").children(".picks .disabled").removeClass("disabled");
	});
	// build action for cancelling changes
	$(".page-controls").on("click", ".cancel", function(){
		if( confirm("Are you sure you want to cancel changes?") ){
			window.location.href = "/?action=pick.set&nWeekID=" + $("#picks").data("id");
		}
	});
	// build actions for marking picks
	$(".game").on("click", "button", function(){
		if( !$(this).hasClass("disabled") ){
			// clear any other picks
			$(".pick").removeClass("pick btn-success").addClass("btn-default");
			// enable the save button
			$(".page-controls .save").removeClass("disabled");
			// remove any alerts
			$(this).closest("tr").removeClass("btn-danger");
			// remove the pick and primary from anyone in this row
			$(this).closest("tr").find(".pick").removeClass("pick btn-success").addClass("btn-default");
			// add the success pick class
			$(this).removeClass("btn-default").addClass("pick btn-success");
		}
	});
	// bind for saving picks
	$(".page-controls").on("click", ".save:not('.disabled')", function(){
		var stPicks = {};
		var bSendPicks = true;
		// make sure there is only one pick saved
		if( $(".pick").length == 0 ){
			alert("Please select your pick");
			return false;
		} else if( $(".pick").length > 1 ){
			alert("Only one pick is allowed");
			return false;
		}
		// append this pick to the list of picks
		stPicks[$(".pick").closest("tr").data("id")] = $(".pick").data("id");
		// send the picks
		if( bSendPicks ){
			$.post("/index.cfm?action=pick.save",
				{
					"nWeekID": $("#picks").data("id"),
					"stPicks": $.toJSON(stPicks)
				}, function(sResults){
					//setMessage(sResults);
					window.location.href = "/?action=pick.set&bSaved=true&nWeekID=" + $("#picks").data("id");
				}
			);
		}
	});
	// bind click for bulk saving games
	$("#bulk").on("click", "button", function(){
		var reNewLines=/[\n\r]/g;
		var lstPicks = $("#sPicks").val().replace(reNewLines, ",");
		// if the last character is a comma
		if( lstPicks.substr(lstPicks.length - 1) == "," ){
			lstPicks = lstPicks.substring(0, lstPicks.length - 1);
		}
		// send post
		$.post("/?action=pick.bulk",
			{
				"bDoSave": true,
				"lstPicks": lstPicks,
				"nWeekID": $("#nWeekID").val(),
				"nUserID": $("#nUserID").val()
			}, function(sMessage){
				setMessage(sMessage);
				checkPicks();
				// reset the fields
				$("#sPicks").val("");
				$("#nUserID").val("");
			}
		);
	});
	// bind for checking if user has picks this week
	$("#bulk").on("change", "#nWeekID", function(){
		checkPicks();
	});
	// bind action for comparing picks
	$("#compare").on("click", function(){
		window.location.href = "/?action=pick.compare&nWeekID=" + $("h3").data("id") + "&nViewUserID=" + $("#nUserID").val();
	});
	// bind click for gameinfo
	$(".game-info").on("click", function(){
		window.location.href = "/?action=pick.gameInfo&nWeekID=" + $(this).closest("tr").data("nweekid") + "&nGameID=" + $(this).closest("tr").data("id");
	});
	$("#seeAllPicks").on("click", function(){
		window.location.href = "/?action=pick.allWeekPicks&nWeekID=" + $("#picks").data("id");
	});
	$("#backToMyPicks").on("click", function(){
		window.location.href = "/?action=pick.set&nWeekID=" + $("#allPicks").data("id");
	});
});
// checks to see if the users have picks
function checkPicks(){
	var nWeekID = $("#nWeekID").val();
	var stData = {};
	// remove the "has-picks" class
	$("#nUserID option").removeClass("alert alert-success alert-danger");
	// loop through each user and reset their data
	$("#nUserID").children("option").each(function(){
		stData[$(this).data("id")] = 0
	});
	$.post("/?action=pick.hasPicks",
		{
			"stData": $.toJSON(stData),
			"nCheckWeekID": $("#nWeekID").val()
		}, function(stPicks){
			// loop through the results and update each user
			$("#nUserID").children("option").each(function(){
				if( stPicks[$(this).data("id")] ){
					$(this).addClass("alert alert-success");
				} else {
					$(this).addClass("alert alert-danger");
				}
			});
		}, "json"
	);
}
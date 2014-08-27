$(function(){
	// bind save scores
	$(".container").on("click", ".save-scores", function(event){
		var arGames = [];
		var stGame = {};
		event.stopPropagation();
		// loop through the games and retrieve their scores
 		$(".game").each(function(){
			stGame = {
				"nGameID": $(this).data("id"),
				"nHomeScore": $(this).find(".home.score").val(),
				"nAwayScore": $(this).find(".away.score").val()
			}
			arGames.push(stGame);
		});
		// send results
		$.post("/index.cfm?action=game.saveScores",
			{
				arGames: $.toJSON(arGames)
			}, function(sResult){
				setMessage(sResult);
				softReload();
			}
		);
	});

	// calculate scores for the week
	$(".container").on("click", ".calculate", function(){
		// open calculate dialog
		opendialog("game.calculate");
		// do calculate
		$.post("/index.cfm?action=standing.calculate",
			{
				"nWeekID": $("#nWeekID").val(),
				"doCalculate": true
			}, function(sResults){
				// close the modal
				closedialog();
				// show the message
				setMessage(sResults);
				if( sResults.indexOf("success") ){
					// refresh to standings for this week
					//setTimeout( function(){ window.location.href = "/index.cfm?action=main.standings&nWeekID=" + $("#nWeekID").val();}, 1000);
				}
			}
		)
	});
});
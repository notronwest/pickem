docReady(function(){
	// hide all of the tiebreak fields
	$(".tiebreak").closest("td").addClass("hide");
	$("th:contains('Tiebreak')").addClass("hide");
	// bind change week
	$(".container").on("click", ".change-week", function(){
		window.location.href = $(this).closest("form").find("#sWeekURL").val();
	});
	// make the games sortable
	$("#activeGames tbody").sortable().on("sortstart", function(){
		// turn off the binding event
		$(".games").off("sortstart");
		makeActive();
	});
	// bind move of games into active
	$("#availableGames").on("click", ".add", function(){
		$(this).closest("tr").appendTo("#activeGames tbody").find(".add").removeClass("add").removeClass("glyphicon-open").addClass("move").addClass("glyphicon-sort");
		// turn the save button on
		makeActive();
	});
	// bind edit week
	$(".container").on("click", ".edit", function(){
		window.location.href = "/?action=week.addEdit&nWeekID=" + $(this).closest("tr").data("id")
	});
	// bind add week
	$(".container").on("click", ".add-week", function(){
		window.location.href = "/?action=week.addEdit&bAdd=true";
	});
	// bind delete week
	$(".week-actions").on("click", ".delete", function(){
		if( confirm("Are you sure you want to delete this week?") ){
			window.location.href = "/?action=week.delete&nWeekID=" + $(this).closest("tr").data("id");
		}
	});
	// bind cancel add/edit week
	$("#addEditForm").on("click", ".cancel", function(){
		if( confirm("Are you sure you want to cancel updating the week? All changes will be lost") ){
			window.location.href = "/?action=week.manage";
		}
	});
	// bind add for new game
	$(".container").on("click", ".game-actions .add-game", function(){
		var stGame = {
			"sHomeTeam": "",
			"sHomeTeamURL": "",
			"sAwayTeam": "",
			"sAwayTeamURL": "",
			"nSpread": "",
			"sSpreadOriginal": "",
			"sSpreadFavor": "",
			"nTiebreak": "",
			"sGameDateTime": "",
			"bIsNew": true
		};
		makeActive();
		// append this new game
		addGame(stGame, "#activeGames", true);
	});
	// bind for setting favor on new games
	$(".container").on("change", ".spread-favor", function(){
		if( $(this).val() == "home" ){
			sFavoriteClass = "home";
			sUnderdogClass = "away";
		} else {
			sFavoriteClass = "away";
			sUnderdogClass = "home";
		}
		// set the classes
		$(this).closest("tr").find(".favorite").removeClass("home").removeClass("away").addClass(sFavoriteClass);
		$(this).closest("tr").find(".underdog").removeClass("home").removeClass("away").addClass(sUnderdogClass);
	});
	// bind for deleting this game
	$(".container").on("click", ".game .delete", function(){
		if( confirm("Are you sure you would like to remove the game between " + $(this).closest("tr").find(".favorite").val() + " and " + $(this).closest("tr").find(".underdog").val() + "?") ){
			// if there are available games, move this back
			if( $("#source").is(":visible") ){
				$(this).closest("tr").appendTo("#availableGames").find(".move").removeClass("move").removeClass("glyphicon-sort").addClass("add").addClass("glyphicon-open");;	
			} else {
				$(this).closest("tr").remove();
			}
			
		}
		makeActive();
	});
	// bind for swapping home and away teams
	$(".swap-home").on("click", function(){
		$(this).closest("tr").find(".home").addClass("next-away").removeClass("home");
		$(this).closest("tr").find(".away").addClass("home").removeClass("away");
		$(this).closest("tr").find(".next-away").addClass("away").removeClass("next-away");
		oSpreadFavor = $(this).closest("tr").find(".spread-favor")
		$(oSpreadFavor).val(($(oSpreadFavor).val() == "away") ? "home" : "away");
		makeActive();
	});
	// bind for swapping the favorites
	$(".swap-spread").on("click", function(){
		// get two objects
		oFavorite = $(this).closest("tr").find("[name='favorite']");
		oUnderdog = $(this).closest("tr").find("[name='underdog']");
		sFavoriteTeam = $(oFavorite).val();
		nFavoriteTeam = $(oFavorite).data("id");
		oFavorite.val(oUnderdog.val()).data("id", oUnderdog.data("id"));
		oUnderdog.val(sFavoriteTeam).data("id", nFavoriteTeam);
		makeActive();
	});
	// binding to make save games not disabled when someone changes the spread
	$(".container").on("keyup", ".spread,.tiebreak", function(){
		makeActive();
		$(".container").off("keyup", ".spread,.tiebreak");
	});
	// bind to make games active if the time/date is changed
	$(".container").on("focus", ".date,.time", function(){
		makeActive();
	})
	// bind to make save games not disabled when someone clicks x to remove a game
	$(".container").on("click", ".move", function(){
		makeActive();
		$(".container").off("click", ".move");
	});
	// bind for showing/hiding lock dates/times for games
	$("#showLock").on("click", function(){
		if($(this).is(":checked") ){
			$(".lock-control").removeClass("hide");
		} else {
			$(".lock-control").addClass("hide");
		}
	});
	// binding for saving games
	$(".container").on("click", ".save-games:not(.disabled)", function(event){
		event.stopPropagation();
		var bDoSave = true;
		var dtGame = "";
		var dtLock = "";
		var arTiebreaks = [];
		// clear the arGames to build the now active games
		arGames = [];
		// loop through all of the active games
		$("#activeGames .game").each(function(){
			// if there isn't a spread favor selected for a new game
			if( $(this).find(".spread-favor").val() == "" ){
				alert("Please set a spread favor for this game");
				$(this).find(".spread-favor").focus();
				bDoSave = false;
			}
			// store the game dates/times
			dtGame = $(this).find(".game-date").val().trim() + " " + fixTime($(this).find(".game-time").val().trim());
			dtLock = $(this).find(".lock-date").val().trim() + " " + fixTime($(this).find(".lock-time").val().trim());
			// check the game date/time
			if( dtGame.length == 19 ){
				$.get("/?action=game.isDateValid&dtToCheck=" + dtGame,
					function(sValidDate){
						if( sValidDate.length > 0 ){
							dtGame = sValidDate;
						} else {
							alert("Please check your game date and time. Doesn't appear to be valid");
							$(this).focus();
							bDoSave = false;
						}
					}, "json"
				);
			}
			// check the lock date/time
			if( dtLock.length == 19 ){
				$.get("/?action=game.isDateValid&dtToCheck=" + dtLock,
					function(sValidDate){
						if( sValidDate.length > 0 ){
							dtLock = sValidDate;
						} else {
							alert("Please check your game lock date and time. Doesn't appear to be valid");
							$(this).focus();
							bDoSave = false;
						}
					}, "json"
				);
			}
			// reset the array of games
			stGame = {
				"nGameID": $(this).closest("tr").data("game-id"),
				"sHomeTeam": $(this).find(".home").val(),
				"nHomeTeamID": $(this).find(".home").data("id"),
				"sHomeTeamURL": $(this).find(".home").data("url"),
				"sAwayTeam": $(this).find(".away").val(),
				"nAwayTeamID": $(this).find(".away").data("id"),
				"sAwayTeamURL": $(this).find(".away").data("url"),
				"nSpread": toDecimal($(this).find(".spread").val()),
				"sSpreadFavor": $(this).find(".spread-favor").val(),
				"sGameDateTime": ( dtGame.length > 0 ) ? dtGame : "",
				"dtLock": ( dtLock.length > 0 ) ? dtLock : "",
				"nTiebreak": $(this).find(".tiebreak").val()
			};
			arGames.push(stGame);
		});
		if( bDoSave ){
			// send the call to save this week
			$.post("/index.cfm?action=game.saveWeek",
				{
					nWeekID: $("#setWeek").data("id"),
					arGames: $.toJSON(arGames)
				}, function(sResult){
					$.jGrowl(sResult);
					softReload();
				}
			);
		}
	});
});

// parses and builds all of the games
function parseTeams(){
	$("#results").children(".bd").children("h4").each(function(){
		// append the contents of the date
		dGameDate = new Date($(this).text());
		// find all of the games
		$(this).next(".pointspread").children("tbody").children("tr").each(function(){
			stGame = {};
			// get the teams
			$(this).children(".teams").children(".team").each(function(index){
				// get the home team
				if(index == 1){
					 stGame.sHomeTeam = $(this).children("a").text();
					 stGame.sHomeTeamURL = $(this).children("a").prop("href");
				} else {
					stGame.sAwayTeam = $(this).children("a").text();
					stGame.sAwayTeamURL = $(this).children("a").prop("href");
				}
			});
			sGameDate = dGameDate.getFullYear() + '-' + convertMonthDay(dGameDate.getMonth() + 1) + '-' + convertMonthDay(dGameDate.getDate());
			arGameTimeFull = $(this).children(".teams").children("div").text().trim().split(" ");
			arGameTimeHoursMinutes = arGameTimeFull[0].split(":");
			stGame.sGameDateTime = sGameDate.toString() + " " + ((arGameTimeFull[1].toLowerCase() == "pm" && parseInt(arGameTimeHoursMinutes[0]) < 12) ? (parseInt(arGameTimeHoursMinutes[0]) + 12).toString() + ":" + arGameTimeHoursMinutes[1] : arGameTimeHoursMinutes[0].toString() + ":" + arGameTimeHoursMinutes[1]).toString();
			// get the spread from the second td
			sSpreadNode = $(this).children("td:nth-child(2)").children("div:nth-child(1)").children("span");
			if( $(sSpreadNode).hasClass("bottom-line") ){
				stGame.sSpreadFavor = "home";
			} else {
				stGame.sSpreadFavor = "away";
			}
			// add spread
			nSpread = $(sSpreadNode).text().replace("-", "");
			stGame.nSpread = (parseFloat(nSpread).toString() == nSpread.toString()) ? parseFloat(nSpread) : parseFloat(nSpread) + 0.5 ;
			stGame.sSpreadOriginal = stGame.nSpread;
			stGame.bShow = true;
			stGame.nTiebreak = "";
			stGame.dtLock = stGame.sGameDateTime;
			arGames.push(stGame);
		});
	});
}
// construct the HTML from the array of games
function buildForm(arGames, oNode){
	var sGameNode = "";
	// default node to available games
	if( typeof oNode != "string"){
		oNode = "#availableGames";
		// show the source
		$("#source").show().removeClass("hide");
	}
	// loop through the data in the hidden table tag
	for( itm=0; itm < arGames.length; itm++ ){
		addGame(arGames[itm], oNode);
	}
	// hide loading
	$(".loading").addClass("hide");
	// show games
	$("#games").removeClass("hide");
}

// add the game into the UI
function addGame(stGame, oNode, bIsNew){
	if( typeof bIsNew != "boolean" ){
		bIsNew = false;
	}
	var sFavorite = "";
	var sUnderdog = "";
	var oDupe = "";
	// make a copy of the game node (prepend new ones)
	if( bIsNew ){
		oDupe = $("#defaultGame tr").clone(true).prependTo(oNode + " tbody").removeClass("hide").data("game-id", stGame.nGameID);
	} else {
		oDupe = $("#defaultGame tr").clone(true).appendTo(oNode + " tbody").removeClass("hide").data("game-id", stGame.nGameID);
	}
	// if this is the active games node then add in autocomplete
	if( typeof stGame.bIsNew == "boolean" ){
		// add auto complete
		$(oDupe).find(".favorite,.underdog").autocomplete({ source: "/?action=team.searchForTeam" });
		// add date picker
		$(oDupe).find(".date").datepicker();
		// add time picker
		$(oDupe).find(".time").ptTimeSelect();
		// replace spread favor with select
		$(oDupe).find(".spread-favor").remove();
		$(oDupe).find(".move").closest("td").append('<select class="spread-favor"><option value="">Spread Favor</option><option value="home">Home</option><option value="away">Away</select>');
	} else {
		// replace move with add
		$(oDupe).find(".move").removeClass("move").removeClass("glyphicon-sort").addClass("add").addClass("glyphicon-open");
		// set the data for each node
		if( stGame.sSpreadFavor == "home"){
			$(oDupe).find(".favorite").val(stGame.sHomeTeam).addClass("home");
			$(oDupe).find(".underdog").val(stGame.sAwayTeam).addClass("away");
		} else {
			$(oDupe).find(".favorite").val(stGame.sAwayTeam).addClass("away");
			$(oDupe).find(".underdog").val(stGame.sHomeTeam).addClass("home");
		}
		$(oDupe).find(".game-date").val(stGame.sGameDateTime.split(" ")[0]);
		$(oDupe).find(".game-time").val(stGame.sGameDateTime.split(" ")[1]);
		$(oDupe).find(".lock-date").val(stGame.dtLock.split(" ")[0]);
		$(oDupe).find(".lock-time").val(stGame.dtLock.split(" ")[1]);
		$(oDupe).find(".spread").val(stGame.nSpread);
		$(oDupe).find(".spread-favor").val(stGame.sSpreadFavor);
		$(oDupe).find(".tiebreak").val(stGame.nTiebreak);
	}
}
// retrieve available games for this week
function getGames(){
	// get source
	$.get("/index.cfm?action=week.getGames&" + new Date().getTime(),
		{
			nWeekID: $("#setWeek").data("id")
		}, function(stGames){
			if (typeof stGames == "object") { // this is an edit -- load the games
				// if there are games load them into active
				if( stGames.bGamesAreSelected ){
					buildForm(stGames.arGames, "#activeGames");
				} else {
					buildForm(stGames.arGames);
				}
			} else {
				alert("error getting games, please try again");
				// hide loading
				$(".loading").addClass("hide");
			}
		}, "json"
	);
}

// make it active for saving
function makeActive(){
	$(".save-games").removeClass("disabled");
}
// convert fraction characters to actual numbers
function toDecimal(nNumber) {
	// loop through the characters
	for(var itm = 0; itm < nNumber.length; itm++ ){
		if( parseInt(nNumber.charCodeAt(itm)) == 189 ){
			nNumber = nNumber.replaceAt(itm, ".5");
		}
	}
	return nNumber;
}
// converts a time string to an actual time
function fixTime(sTime){
	var arTime = [];
	var sHours = "";
	var sMins = "";
	var dtFixed = sTime;
	// if its already the correct format
	if(sTime.length == 5 && sTime.indexOf(":") > 0 ){
		return dtFixed;
	} else if(sTime.length > 0 && sTime.indexOf(":") > 0 && sTime.indexOf(" ") > 0 ){
		// get the AM PM
		arTime = sTime.split(":");
		sHours = arTime[0];
		arTime = arTime[1].split(" ");
		sMins = arTime[0];
		if( arTime[1] == "PM"){
			sHours = parseInt(sHours) + 12;
		} else if (sHours.length == 1){
			sHours = "0" + sHours;
		}
		dtFixed = sHours + ":" + sMins + ":00";
	}
	if( dtFixed.length != 8){
		dtFixed = "";
	}
	return dtFixed;
}

// returns a factorial of a number
function fact(x) {
   if(x==0) {
      return 1;
   }
   return x * fact(x-1);
}
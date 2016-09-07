var arGames = [];
$(function(){
	// bind override lock
	$(".container").on("click", "#overrideLock", function(){
		window.location.href = $(this).data("url");
	});
	// define modal
	$("#modal").dialog( { width: 600, autoOpen: false, draggable: false });
	// default handler for add buttons
	$("body").on("click", "#add", function(){
		$("#modal").dialog("open");
	});
	// prevent ajax caching
	$.ajaxSetup( { cache: false } );

	$(".container").on("keypress", "#sPassword", function(e){
		if( e.which == 13 ){
			$(this).closest("form").submit();
		} 
	});
	// bind change week
	$(".container").on("click", ".change-week", function(){
		window.location.href = $(this).closest("form").find("#sWeekURL").val();
	});
	// expand collapse help section
	$(".container").on("click", "a.help", function(){
		if( $(this).next(".help").hasClass("hide") ){
			$(this).next(".help").removeClass("hide");
		} else {
			$(this).next(".help").addClass("hide");
		}
	});
	// define the dialog defaults
	$("#modal").dialog( { width: 500, modal: true, autoOpen: false } );
	// add binding to close window with cancel
	$("#modal").on("click", ".cancel", function(){
		closedialog();
	});
	// handle cancelling the impersonation of a user
	$("#impersonating").bind("close.bs.alert", function(){
		$.post("/?action=user.impersonate",
			function(sResults){
				setMessage(sResults);
			}
		);
	});
});

(function() {
  jQuery(function() {
    var $, configureMenus, menu, menuTrigger;
    $ = jQuery;
    menuTrigger = $('#menu-trigger');
    menu = $.offCanvasMenu({
      direction: 'left',
      coverage: '70%'
    });
    (configureMenus = function(display) {
      switch (display) {
        case 'block':
          menu.on();
          break;
        case 'none':
          menu.off();
          break;
        default:
          return;
      }
    })(menuTrigger.css('display'));
    menuTrigger.csswatch({
      props: 'display'
    }).on('css-change', function(event, change) {
      return configureMenus(change.display);
    });
    return FastClick.attach(document.body);
  });

}).call(this);


function opendialog(sTitle){
	if( typeof sTitle == "String" ){
		$("#modal").dialog("option", "title", sTitle);
	}
	$("#modal").dialog("open").addClass("dialog");
}

function closedialog(){
	$("#modal").html();
	$("#modal").dialog("close");
}

function setMessage(sMessage){
	$.jGrowl(sMessage);
}

// reload the window after a second
function softReload(){
	// reload the window
	setTimeout(function(){window.location.href = window.location.href}, 1500);
}

// shows saving message in dialog
function savingdialog(){
	$("#modal").block( { message: "Saving"} );
}

// convert time to Pacific time
function convertTimeToPD(tEastern){
	// get the time
	tHoursMinutes = tEastern.split(" ")[0];
	// get the hours
	tHours = parseInt(tHoursMinutes.split(":")[0]);
	// convert hours to 24 hour and pt
	tHours = ((tEastern.split(" ")[1] == "pm" && tHours != 12)?tHours + 12:tHours) - 3;
	// combine them back
	tGameTime = ((tHours.toString().length == 1)? "0" + tHours.toString():tHours.toString()) + ":" + tHoursMinutes.split(":")[1];
	return tGameTime;
}

// convert the month day
function convertMonthDay(sDatePart){
	return((sDatePart.toString().length == 1)? "0" + sDatePart.toString(): sDatePart.toString());
}

// retrieves a dialog with properties
function getdialog(action, stParams){
	if( typeof stParams != "object" ){
		stParams = {};
	}
	$.get("/index.cfm?action=" + action,
		stParams, function(sResults){
			$("#modal").html(sResults);
			opendialog();
		}
	)
}

// turns the actionalable buttons on
function actions(sAction){
	if( sAction == "on" ){
		$(".page-actions").removeClass("hide");
		$("#games").removeClass("hide");

	}
}

// show error
function showError(sError){
	if( typeof sError != "string" ){
		$(".error").html();
		$(".error").css( { display: "none" } );
	} else {
		$(".error").html(sError);
		$(".error").removeClass("hide");
		$(".error").css( { display: "block" } );
	}
}

String.prototype.replaceAt=function(index, character) {
    return this.substr(0, index) + character + this.substr(index+character.length);
}

// move indexes in an array
function moveArrayIndex (arToUpdate, nOldIndex, nNewIndex) {
    while (nOldIndex < 0) {
        nOldIndex += arToUpdate.length;
    }
    while (nNewIndex < 0) {
        nNewIndex += arToUpdate.length;
    }
    if (nNewIndex >= arToUpdate.length) {
        var k = nNewIndex - arToUpdate.length;
        while ((k--) + 1) {
            arToUpdate.push(undefined);
        }
    }
    arToUpdate.splice(nNewIndex, 0, arToUpdate.splice(nOldIndex, 1)[0]);
    return arToUpdate; // for testing purposes
};
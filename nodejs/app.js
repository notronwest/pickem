/**
 * Module dependencies.
 */ 
var express = require('express');
var jsdom = require('jsdom')
var request = require('request')
var url = require('url')
var path = require('path');
var logger = require('morgan');
var bodyParser = require('body-parser');
var app = express();
// make jQuery available to all functions
var $ = "";
var sSearchURL = "";
var stResults = {};
var arDebugMessage = [];
// view engine setup
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(express.static(path.join(__dirname, 'public')));

app.get('/get-scores', function(req, res){
    // some global variables that will be used in various functions
    var sScoreBlock = "";
    // handle URL to search for
    //sSearchURL = "https://search.yahoo.com/search;_ylt=AwrBT_xXmexV7TcAle9XNyoA;_ylc=X1MDMjc2NjY3OQRfcgMyBGZyA3lmcC10LTkwMQRncHJpZAN4NlB2dGV0NFJ0MnN4aVoyUmhkMGZBBG5fcnNsdAMwBG5fc3VnZwMxMARvcmlnaW4Dc2VhcmNoLnlhaG9vLmNvbQRwb3MDMARwcXN0cgMEcHFzdHJsAwRxc3RybAMxOQRxdWVyeQNwdXJkdWUgYm9pbGVybWFrZXJzBHRfc3RtcAMxNDQxNTY5MTQ1?fr2=sb-top-search&fr=yfp-t-901&fp=1";
    sSearchURL = "https://search.yahoo.com/search?fr2=sb-top-search&fr=yfp-t-901&fp=1";
    // setup the default response
    stResults = {
      "sStatus": 200,
      "stGameData": {},
      "sMessage": "",
      "sSearchURL": sSearchURL,
      "arDebugMessage": arDebugMessage
    }
    // tell the response to be json
    res.set({
      'Content-Type': 'application/json'
    })
    // setup user agent so Yahoo produces score box
    var stHeaders = {
      'User-Agent': "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2227.1 Safari/537.36"
    }
    // get the query params sent to the page
    var arHomeTeam = req.query.lstHomeTeam.split("|"); // will come in with team names separated by |
    var arAwayTeam = req.query.lstAwayTeam.split("|"); // will come in with team names separated by |
    var dtGame = req.query.dtGame;
    var stOptions = {
      uri: sSearchURL,
      method: 'GET',
      headers: stHeaders,
      qs: { "p": arHomeTeam[1] + " Football Results" } // using the second index gives the mascot
    }
    //get the score data from the API and handle parsing
    request(stOptions, function(err, response, body){

        // send the body of the response to jsdom and load jquery
        jsdom.env({
            html: body,
            scripts: ['http://code.jquery.com/jquery-1.6.min.js'],
            done: function (err, window) {
                // setup jQuery scope
                $ = window.jQuery;

                // get the main score block
                sScoreBlock = $('.compScoreCard .score-card[data-key="' + dtGame + '"]');

                if( $(sScoreBlock).length > 0 ){
        arDebugMessage.push('Trying to match home team: ' + arHomeTeam.toString() + ' against t0: ' + $(sScoreBlock).find(".team.t0 .team-name").text() + " or away team:" + arAwayTeam.toString() +  " against t1: " +  $(sScoreBlock).find(".team.t1 .team-name").text());
                  // determine which team id is home and which is away
                  nHomeTeamID = getHomeTeamID(sScoreBlock, arHomeTeam, arAwayTeam);
                  nAwayTeamID = (nHomeTeamID == 0) ? 1 : 0;
        arDebugMessage.push("Home team ID: " + nHomeTeamID);
        arDebugMessage.push("Away team ID: " + nAwayTeamID.toString());
                  // if we have a valid id for the home team
                  if( typeof nHomeTeamID == "number" ){
                    // update the return data with the score data
                    stResults.stGameData = {
                      stGameStatus: getGameStatus($(sScoreBlock)),
                      nAwayScore: getTeamScore($(sScoreBlock).find(".team.t" + nAwayTeamID.toString())),
                      nHomeScore: getTeamScore($(sScoreBlock).find(".team.t" + nHomeTeamID))
                    }
                  } else {
                    // reset response
                    errorOccurred("Got score block but couldn't match the teams provided." + arDebugMessage.toString());
                  }
                } else {
                  // need to do some error work here 
                  errorOccurred("Did not get score block from API call. " + body);
                }
                
                // return the game data as JSON
                res.json({ "stResults": stResults });
            }
        });
    });
});

app.get('/get-record', function(req, res){
    // some global variables that will be used in various functions
    var sRecordBlock = "";
    // handle URL to search for
    sSearchURL = "https://search.yahoo.com/search?fr2=sb-top-search&fr=yfp-t-901&fp=1";
    // setup the default response
    stResults = {
      "sStatus": 200,
      "sRanking": "",
      "sMessage": "",
      "sSearchURL": sSearchURL,
      "arDebugMessage": arDebugMessage
    }
    // tell the response to be json
    res.set({
      'Content-Type': 'application/json'
    })
    // setup user agent so Yahoo produces score box
    var stHeaders = {
      'User-Agent': "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2227.1 Safari/537.36"
    }
    // get the query params sent to the page
    var sTeam = req.query.sTeam
    var stOptions = {
      uri: sSearchURL,
      method: 'GET',
      headers: stHeaders,
      qs: { "p": sTeam + " Football" }
    }
    //get the score data from the API and handle parsing
    request(stOptions, function(err, response, body){

        // send the body of the response to jsdom and load jquery
        jsdom.env({
            html: body,
            scripts: ['http://code.jquery.com/jquery-1.6.min.js'],
            done: function (err, window) {
                // setup jQuery scope
                $ = window.jQuery;

                // get the main score block
                sRecordBlock = $('.compInfo');
                if( $(sRecordBlock).length > 0 ){
                  stResults.sRecord = $(".compInfo li:nth-child(1)").children("a").text().split(",")[0];
                } else {
                  // need to do some error work here 
                  errorOccurred("Did not get standing block from API call. " + body);
                }
                
                // return the game data as JSON
                res.json({ "stResults": stResults });
            }
        });
    });
});

// gets the current standings for this week
app.get('/get-standings', function(req, res){
    // some global variables that will be used in various functions
    var sStandingBlock = "";
    // handle URL to search for
    sSearchURL = "http://sports.yahoo.com/ncaa/football/polls?poll=1";
    // setup the default response
    stResults = {
      "sStatus": 200,
      "stStandingsData": {},
      "sMessage": "",
      "sSearchURL": sSearchURL,
      "arDebugMessage": arDebugMessage
    }
    // tell the response to be json
    res.set({
      'Content-Type': 'application/json'
    })
    // setup user agent so Yahoo produces score box
    var stHeaders = {
      'User-Agent': "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2227.1 Safari/537.36"
    }
    // build parameters for HTTP call
    var stOptions = {
      uri: sSearchURL,
      method: 'GET',
      headers: stHeaders
    }
    //get the score data from the API and handle parsing
    request(stOptions, function(err, response, body){

        // send the body of the response to jsdom and load jquery
        jsdom.env({
            html: body,
            scripts: ['http://code.jquery.com/jquery-1.6.min.js'],
            done: function (err, window) {
                // setup jQuery scope
                $ = window.jQuery;
                // variable to store results
                var arStandings = [];

                // get the main score block
                sStandingBlock = $('#ysprankings-results-table');

                if( $(sStandingBlock).length > 0 ){
                  // loop through all of rows to get the teams and their place
                  $("#ysprankings-results-table tr").each(function(){
                    // make sure this is an actual team
                    if( $(this).find(".first").length > 0 ){
                      arStandings.push($(this).find(".first").next().text().split("(")[0].trim());
                    }
                  });
                  stResults.arStandings = arStandings;
                } else {
                  // need to do some error work here 
                  errorOccurred("Did not get standing block from API call. " + body);
                }
                // return the game data as JSON
                res.json({ "stResults": stResults });
            }
        });
    });
});

app.get('/get-results', function(req, res){
    // some global variables that will be used in various functions
    var sScoreBlock = "";
    var arGames = [];
    var arGameStats = [];
    var stTeamData = {};
    // handle URL to search for
    //sSearchURL = "https://search.yahoo.com/search;_ylt=AwrBT_xXmexV7TcAle9XNyoA;_ylc=X1MDMjc2NjY3OQRfcgMyBGZyA3lmcC10LTkwMQRncHJpZAN4NlB2dGV0NFJ0MnN4aVoyUmhkMGZBBG5fcnNsdAMwBG5fc3VnZwMxMARvcmlnaW4Dc2VhcmNoLnlhaG9vLmNvbQRwb3MDMARwcXN0cgMEcHFzdHJsAwRxc3RybAMxOQRxdWVyeQNwdXJkdWUgYm9pbGVybWFrZXJzBHRfc3RtcAMxNDQxNTY5MTQ1?fr2=sb-top-search&fr=yfp-t-901&fp=1";
    sSearchURL = "https://search.yahoo.com/search?fr2=sb-top-search&fr=yfp-t-901&fp=1";
    // setup the default response
    stResults = {
      "sStatus": 200,
      "arGames": [],
      "sMessage": "",
      "sSearchURL": sSearchURL,
      "arDebugMessage": arDebugMessage
    }
    // tell the response to be json
    res.set({
      'Content-Type': 'application/json'
    })
    // setup user agent so Yahoo produces score box
    var stHeaders = {
      'User-Agent': "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2227.1 Safari/537.36"
    }
    // get the query params sent to the page
    var stOptions = {
      uri: sSearchURL,
      method: 'GET',
      headers: stHeaders,
      qs: { "p": req.query.sTeam + " Football Results" }
    }
    //get the score data from the API and handle parsing
    request(stOptions, function(err, response, body){

        // send the body of the response to jsdom and load jquery
        jsdom.env({
            html: body,
            scripts: ['http://code.jquery.com/jquery-1.6.min.js'],
            done: function (err, window) {
                // setup jQuery scope
                $ = window.jQuery;

                // get the main score block
                sScoreBlock = $('.card-container .score-card');

                if( $(sScoreBlock).length > 0 ){
                  // loop through each score block
                  $(sScoreBlock).each(function(){
                    arGameStats = [];
                    // loop through the two team blocks to get team names
                    $(this).find(".team").each(function(){
                      stTeamData = {};
                      // add the details for this team into the array
                      if( $(this).find(".total.score").text().length > 0 ){
                        arGameStats.push({
                          sTeamName: $(this).find(".team-name").text(),
                          nScore: $(this).find(".total.score").text()
                        });
                      }
                    });
                    if( arGameStats.length > 0 ){
                      stResults.arGames.push(arGameStats);
                    }
                  });
                } else {
                  // need to do some error work here 
                  errorOccurred("Did not get score block from API call. " + body);
                }
                
                // return the game data as JSON
                res.json({ "stResults": stResults });
            }
        });
    });
});

app.get('/get-games', function(req, res){
    var stWeekData = {};
    var stGameData = {};
    // get the query params sent to the page
    var sScheduleURL = req.query.sScheduleURL;
    //var sScheduleURL = "http://www.vegasinsider.com/nfl/matchups/";
    // setup the default response
    stResults = {
      "sStatus": 200,
      "arGameData": [],
      "sMessage": "",
      "sScheduleURL": sScheduleURL,
      "arDebugMessage": arDebugMessage
    }
    // tell the response to be json
    res.set({
      'Content-Type': 'application/json'
    })
    // setup user agent
    var stHeaders = {
      'User-Agent': "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2227.1 Safari/537.36"
    }
    var stOptions = {
      uri: sScheduleURL,
      method: 'GET',
      headers: stHeaders,
      qs: ''
    }
    //get the score data from the API and handle parsing
    request(stOptions, function(err, response, body){

        // send the body of the response to jsdom and load jquery
        jsdom.env({
            html: body,
            scripts: ['http://code.jquery.com/jquery-1.6.min.js'],
            done: function (err, window) {
                // setup jQuery scope
                $ = window.jQuery;

                // block of games
                $(".SLTables4 > table > tbody > tr").each(function(){
                  // if this is a table tag it contains the date
                  if( $(this).children("td[valign='middle']").length > 0 ){
                    sCurrentGameDate = fixDate($(this).children("td").find("strong").text());
                  } else {
                    // each TD with a vertical align of top represents a different game
                    $(this).children("td[valign='top']").each(function(){
                      // skip blank game divs
                      if( $(this).text().length > 10 ){

                        // reset the game data
                        stGameData = {};
                        // get game details
                        $(this).children("table").find(".sportPicksBorder > table").find("tr").each(function(tr_index){
                          switch(tr_index){
                            // first row is teams
                            case 0:
                              // for college games there is an extra blank td
                              if( $(this).children("td").first().text().length == 1 ){
                                $(this).children("td").first().remove();
                              }
                              stGameData.sAwayTeam = $(this).children("td").first().text().split("@")[0].trim();
                              stGameData.sHomeTeam = $(this).children("td").first().text().split("@")[1].trim();
                            break;
                            // second row is game time
                            case 1:
                              // for college games there is an extra blank td
                              if( $(this).children("td").first().text().length == 1 ){
                                $(this).children("td").first().remove();
                              }
                              sTime = $(this).children("td").first().text();
                              
                              stGameData.rawTime = sTime;
                              if( sTime.indexOf("Final") < 0 ){
                                stGameData.sGameDateTime = sCurrentGameDate + " " + fixTime(sTime);
                              } else {
                                stGameData.sGameDateTime = sCurrentGameDate;
                              }
                            break;
                            // fourth row is Away Team
                            case 3:
                              if( $(this).children("td").first().text().length == 1 ){
                                $(this).children("td").first().remove();
                              }
                              $(this).children("td").each(function(td_index){
                                switch(td_index){
                                  // first column is team name
                                  case 0:
                                    stTeam = extractTeamDetails($(this).text());
                                    stGameData.stAwayTeam = stTeam;
                                    stGameData.rawAwayTeamString = $(this).text();
                                    stGameData.nAwayTeamSiteID = stTeam.nID;
                                  break;
                                  // second column is spread
                                  case 1:
                                    stGameData.rawAwaySpread = $(this).text();
                                    if( isFavored($(this).text()) ){
                                      stGameData.sSpreadFavor = "away";
                                      stGameData.nSpread = Math.abs(parseFloat($(this).text()));
                                    } else if( isDraw($(this).text()) ){
                                      stGameData.sSpreadFavor = "home";
                                      stGameData.nSpread = 0;
                                    }
                                  break;
                                  // third column is record
                                  case 2:
                                    stGameData.sAwayTeamRecord = $(this).text();
                                  break;
                                }
                              });
                            break;
                            // fifth column is Home Team
                            case 4:
                              if( $(this).children("td").first().text().length == 1 ){
                                $(this).children("td").first().remove();
                              }
                              $(this).children("td").each(function(td_index){
                                switch(td_index){
                                  // first column is team name
                                  case 0:
                                    stTeam = extractTeamDetails($(this).text());
                                    stGameData.stHomeTeam = stTeam;
                                    stGameData.nHomeTeamSiteID = stTeam.nID;
                                  break;
                                  // second column is spread
                                  case 1:
                                    stGameData.rawHomeSpread = $(this).text();
                                    if( !stGameData.nSpread ){
                                      if( isFavored($(this).text()) ){
                                        stGameData.sSpreadFavor = "home";
                                        stGameData.nSpread = Math.abs(parseFloat($(this).text()));
                                      } else if( isDraw($(this).text()) ){
                                        stGameData.sSpreadFavor = "home";
                                        stGameData.nSpread = 0;
                                      }
                                    }
                                  break;
                                  // third column is record
                                  case 1:
                                    stGameData.sHomeTeamRecord = $(this).text();
                                  break;
                                }
                              });
                            break;
                          }
                        });
                      }
                      // add this game into the array
                      stResults.arGameData.push(stGameData);             
                    });
                  }
                });
              // return the game data as JSON
              res.json({ "stResults": stResults });
            }
        });
    });
});

// determine the home team id
var getHomeTeamID = function(sScoreBlock, arHomeTeam, arAwayTeam){
  var nHomeTeamID = "";
  var itm = 0;
  // check the home team names first
  for(itm; itm < arHomeTeam.length; itm++ ){
    if( doTeamsMatch(arHomeTeam[itm], $(sScoreBlock).find(".team.t0 .team-name").text()) ){
      nHomeTeamID = 0;
      break;
    } else if(doTeamsMatch(arHomeTeam[itm], $(sScoreBlock).find(".team.t1 .team-name").text())){
      nHomeTeamID = 1;
      break;
    }
  }
  // check the away team names next
  if( typeof nHomeTeamID != "number" ){
    for(itm=0; itm < arAwayTeam.length; itm++ ){
      if( doTeamsMatch(arAwayTeam[itm], $(sScoreBlock).find(".team.t0 .team-name").text()) ){
        nHomeTeamID = 1;
        break;
      } else if(doTeamsMatch(arAwayTeam[itm], $(sScoreBlock).find(".team.t1 .team-name").text())){
        nHomeTeamID = 0;
        break;
      }
    }
  }
  return nHomeTeamID;
}

// loop through spaces in team name and compare against the team name provided
var doTeamsMatch = function(sTeamNameIn, sTeamNameToCheck){
  var itm = 0;
  var sTeam = ""
  // loop through the spaces in the home team to see if this is the home team
  for(itm; itm < sTeamNameIn.split(" ").length; itm++ ){
    if( itm == 0 ){
      sTeam = sTeamNameIn.split(" ")[itm];
    } else {
      sTeam = sTeam + " " + sTeamNameIn.split(" ")[itm];
    }
    // compare the the home team name with name we got from site
    if( sTeam.toLowerCase() == sTeamNameToCheck.toLowerCase() ){
      return true;
    }
  }
  return false;
}

// get the teams score
var getTeamScore = function(sTeamBlock){
  return $(sTeamBlock).find("td:last-child .score").text()
}

// convert time
var convertTime = function(sTime){
  var hours = Number(sTime.match(/^(\d+)/)[1]);
  var minutes = Number(sTime.match(/:(\d+)/)[1]);
  var AMPM = sTime.match(/\s(.*)$/)[1];
  if(AMPM == "PM" && hours<12) hours = hours+12;
  if(AMPM == "AM" && hours==12) hours = hours-12;
  var sHours = hours.toString();
  var sMinutes = minutes.toString();
  if(hours<10) sHours = "0" + sHours;
  if(minutes<10) sMinutes = "0" + sMinutes;
  return sHours + ":" + sMinutes;
}

// get the status of the game
var getGameStatus = function(sScoreBlock){
  var nQuarter = 0;
  var sGameTime = "";
  var bGameIsFinal = 0;
  // loop through the children of the status block to see what the game status is
  $(sScoreBlock).find(".period").each(function(itm){
    // stop when we find the timeleft class
    if( $(this).hasClass("timeleft") ){
      // set the game time
      sGameTime = $(this).text();
      // if its half time
      if( $(this).hasClass("half") ){
        nQuarter = "";
        return;
      }
      // if we have no value then its in between quarters
      if( sGameTime.length == 0 ){
        nQuarter = itm + 2;
        sGameTime = "15:00";
      } else {
        nQuarter = itm + 1;
      }
      // stop looping we are done
      return;
    } else if ( $(this).hasClass("total") ){
      sGameTime = "Final";
      bGameIsFinal = 1;
      return;
    }
  });

  // if we are in the "fifth" quarter then the game is over
  if( nQuarter == 5 ){
    bGameIsFinal = 1;
  }

arDebugMessage.push("Quarter: " + nQuarter);

  return {
    "sGameTime": sGameTime,
    "nGameQuarter": (nQuarter != "" || nQuarter != 0) ? ordinal_suffix_of(nQuarter) : nQuarter,
    "bGameIsFinal": bGameIsFinal
  }
}

var fixDate = function(sDate){
  
  var arDate = [];
  if( sDate.indexOf(" ") >= 0 ){
    // turn date into an array
    arDate = sDate.trim().split(" ");
    // if we got back the expected size array
    if( arDate.length == 7 ){
      // rebuild date
      sDate = arDate[4] + " " + arDate[5] + " " + arDate[6];
    }
  }
  return sDate.trim();
  
}

var fixTime = function(sTime){
  var arTime = [];
  if( sTime.indexOf(" ") >= 0 ){
    // turn time into array
    arTime = sTime.trim().split(" ");
    if( arTime.length == 4){
      // rebuild time
      sTime = convertTime(arTime[0] + " " + arTime[1]);
    }
  }
  return sTime;
}

var extractTeamDetails = function(sTeam){
  var stDetails = {};
  var arDataPart = [];
  var sTeamName = "";
  var i = 1;

  if( sTeam.indexOf(" ") >= 0 ){
    // team string will be delimited by space
    arDataPart = sTeam.trim().split(" ");
    
    if( arDataPart.length > 1 ){
      // first part of the team will be the number
      stDetails.nID = arDataPart[0];
      // rest of the details will be the team name
      for(i; i < arDataPart.length; i++){
        sTeamName = sTeamName + " " + arDataPart[i];
      }
      stDetails.sTeamName = sTeamName.trim();
    }
  }
  return stDetails;
}

var isFavored = function(sSpread){
  if( sSpread.trim().indexOf("-") >= 0){
    return true;
  } else {
    return false;
  }
}

var isDraw = function(sSpread){
  if( sSpread.trim().indexOf("PK") >= 0 ){
    return true;
  } else {
    return false;
  }
}

var ordinal_suffix_of = function(i) {
    var j = i % 10,
        k = i % 100;
    if (j == 1 && k != 11) {
        return i + "st";
    }
    if (j == 2 && k != 12) {
        return i + "nd";
    }
    if (j == 3 && k != 13) {
        return i + "rd";
    }
    return i + "th";
}

var errorOccurred = function(sMessage){
  // reset the results structure
  stResults = {
    "sStatus": 500,
    "stGameData": {},
    "sMessage": sMessage,
    "sSearchURL": sSearchURL
}
}

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err);
});

// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
  app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    // reset response data
    stResults.sStatus = res.statusCode;
    stResults.sMessage = "Error getting score data - dev" + new Date();
    res.json({ "stResults": stResults });
  });
}

// production error handler
// no stacktraces leaked to user
app.use(function(err, req, res, next) {
  res.status(err.status || 500);
  // reset response data
  stResults.sStatus = res.statusCode;
  stResults.sMessage = "Error getting score data - prod";
  res.json({ "stResults": stResults });
});


module.exports = app;

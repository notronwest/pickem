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
      qs: { "p": arHomeTeam[0] + " Football Results" }
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
      // if we have no value then its in between quarters
      if( sGameTime.length == 0 ){
        nQuarter = itm + 2;
        sGameTime = "15:00";
      } else {
        nQuarter = itm + 1;
      }
      // stop looping we are done
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
    "nGameQuarter": nQuarter,
    "bGameIsFinal": bGameIsFinal
  }
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

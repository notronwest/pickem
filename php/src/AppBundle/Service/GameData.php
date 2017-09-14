<?php

namespace AppBundle\Service;

use GuzzleHttp\Client;
use Symfony\Component\DomCrawler\Crawler;


class GameData
{
	public $arGames = array();

	public $gameDate;

	public $arGameData;

	public function getGames($league = 'nfl-football'){

		// create http client instance
		$client = new Client();

		// create a request
		$response = $client->get('https://www.sportsbookreview.com/betting-odds/' . $league . '/');

		// this is the response body from the requested page (usually html)
		$result = $response->getBody();

		// pass the HTML to the crawler
		$crawler = new Crawler((string)$result);

		// loop through all of the games for this week
		$nodeValues = $crawler->filter(".dateGroup")->each(function (Crawler $gamesOnDate, $i) {
			// for each loop we will have a new date
			$this->gameDate = $gamesOnDate->filter(".date")->text();
			// now loop through each game on this date
			$gamesOnDate->filter(".event-holder")->each(function( Crawler $game, $i){
					// reset the game data
					$this->arGameData = array();
					// set the date
					$this->arGameData['sGameDate'] = $this->gameDate;
					// game time
					$this->arGameData['sGameTime'] = $this->fixTime($game->filter(".eventLine-time > div")->text());
					// game date and time
					$this->arGameData['sGameDateTime'] = date_format(
						date_create($this->arGameData["sGameDate"] . ' ' . $this->arGameData["sGameTime"]),
						'Y-m-d H:i:s');
					// first instance of .team-name is away team
					$this->arGameData['sAwayTeam'] = $this->removeNationalRanking($game->filter(".team-name")->eq(0)->text());
					// second instance of .team-name is home team
					$this->arGameData['sHomeTeam'] = $this->removeNationalRanking($game->filter(".team-name")->eq(1)->text());
					// get the current bovado full line for away team (will contain more than we need )
					$fullLine = $game->filter("[rel='999996'] > div > b")->text();
					// if the first character is 43 then line favors home team
					if( ord(substr($fullLine, 0, 1)) === 43 ){
						$this->arGameData['sSpreadFavor'] = "home";
					} else {
						$this->arGameData['sSpreadFavor'] = "away";
					}
					// start collecting the actual spread
					$sLine = "";
					for($i = 0; $i <= strLen($fullLine); $i++ ){
						if( $i > 0 && ord(substr($fullLine, $i, 1)) != 194){
							$sLine = $sLine . substr($fullLine, $i, 1);
						} else if( $i > 0 ) {
							break;
						}
					}
					// if we have a half character add it
					if( ord(substr($fullLine, $i + 1, 1)) === 189 ){
						$sLine = $sLine . ".5";
					}
					$this->arGameData['nSpread'] = (float)$sLine;
					// add this game to the game array
					array_push($this->arGames, $this->arGameData);
			});
		});
		return $this->arGames;
	}
	public function fixTime( $sTime ){
		// strip off the am/pm
		$sDayTime = substr($sTime, -1);
		$sTime = substr_replace($sTime, "", -1);
		// fix up the time of day
		if( $sDayTime == "p" ){
			$sDayTime = "pm";
		} else {
			$sDayTime = "am";
		}
		return $sTime . " " . $sDayTime;
	}

	public function removeNationalRanking( $sTeam ){
		if( strpos($sTeam, ")") > 0 ){
			// locate the ending ) and return the end content
			return trim(substr($sTeam, strpos($sTeam, ")") + 3));
		} else {
			return $sTeam;
		}
	}
}

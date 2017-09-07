<?php

namespace AppBundle\Service;

use GuzzleHttp\Client;
use Symfony\Component\DomCrawler\Crawler;


class GameData
{

	public function getGames($league = 'nfl-football'){

		// create http client instance
		$client = new Client();

		// create a request
		$response = $client->get('https://www.sportsbookreview.com/betting-odds/' . $league . '/');

		// this is the response body from the requested page (usually html)
		$result = $response->getBody();

		// pass the HTML to the crawler
		$crawler = new Crawler((string)$result);

		$arGames = array();
		global $arGameData,$gameDate;

		// loop through all of the games for this week
		$nodeValues = $crawler->filter(".dateGroup")->each(function (Crawler $gamesOnDate, $i) {
			// for each loop we will have a new date
			$gameDate = $gamesOnDate->filter(".date")->text();
			// now loop through each game on this date
			$gamesOnDate->filter(".event-holder")->each(function( Crawler $game, $i){
					// reset the game data
					$arGameData = array();
					// set the date
					$arGameData['sGameDate'] = $gameDate;
					// game time
					$arGameData['sGameTime'] = $game->filter(".eventLine-time > div")->text();
					// first instance of .team-name is away team
					$arGameData['sAwayTeam'] = $game->filter(".team-name")->eq(0)->text();
					// second instance of .team-name is home team
					$arGameData['sHomeTeam'] = $game->filter(".team-name")->eq(1)->text();
					// get the current bovado full line for away team (will contain more than we need )
					$fullLine = $game->filter("[rel='999996'] > div > b")->text();
					// if the first character is 43 then line favors home team
					if( ord(substr($fullLine, 0, 1)) === 43 ){
						$arGameData['sSpreadFavor'] = "home";
					} else {
						$arGameData['sSpreadFavor'] = "away";
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
					$arGameData['sSpread'] = (float)$sLine;
			});
			array_push($arGames, $arGameData);
		});
		return $arGames;
	}
}

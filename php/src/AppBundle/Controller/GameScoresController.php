<?php

// src/AppBundle/Controller/GameScoresController.php
namespace AppBundle\Controller;

use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Response;
use AppBundle\Service\GameData as GameData;

class GameScoresController extends Controller
{
	protected $gameDataService;

	public function __construct(GameData $gameDataService)
	{
		$this->gameDataService = $gameDataService;
	}

	/**
	* @Route("/get-games/{league}")
	*/
	public function games($league)
	{
		return $this->json(array('arGameData' => $this->gameDataService->getGames($league)));
	}

	/**
	* @Route("/get-score/{awayTeam}")
	*/
	public function score($awayTeam)
	{
		return $this->json(array('arGameData' => $this->gameDataService->getScores($awayTeam)));
	}
}

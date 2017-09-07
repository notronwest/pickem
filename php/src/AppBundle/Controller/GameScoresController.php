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
	* @Route("/get-scores")
	*/
	public function scores()
	{
		return $this->json(array('lucky-number' => $this->gameDataService->getGames()));
	}
}

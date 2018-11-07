<?php

namespace AppBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\Request;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;

class JSONOddsController extends Controller
{
    /**
     * @Route("/odds/{sport}/{debug}", name="odds", defaults = { "debug" = "false" })
     */
    public function oddsAction(Request $request, String $sport, String $debug)
    {

      $appKey = "99d937ac-82bb-47b3-96bd-2036aab7fb30";
      $ch = curl_init();
      curl_setopt($ch, CURLOPT_URL, "https://jsonodds.com/api/odds/" . $sport);
      curl_setopt($ch, CURLOPT_HTTPGET, 1);
      curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
      curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
      curl_setopt($ch, CURLOPT_HTTPHEADER, array(
          'x-api-key:' . $appKey
      ));
      $res = curl_exec($ch);

      if( $debug == 'true' ){
        // replace this example code with whatever you need
        return $this->render('JSONOdds/json.html.twig', [
            'results'     => $res,
            'JSONResults' => json_decode($res),
            'debug'       => $debug,
        ]);
      } else {
          return new Response($res);
      }
    }

    /**
     * @Route("/results/{sport}/{debug}", name="results", defaults = { "debug" = "false" })
     */
    public function resultsAction(Request $request, String $sport, String $debug)
    {

      $appKey = "bef1a897-b119-11e8-9bbb-0a704e36c1ea";
      $ch = curl_init();
      curl_setopt($ch, CURLOPT_URL, "https://jsonodds.com/api/results/" . $sport);
      curl_setopt($ch, CURLOPT_HTTPGET, 1);
      curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
      curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
      curl_setopt($ch, CURLOPT_HTTPHEADER, array(
          'x-api-key:' . $appKey
      ));
      $res = curl_exec($ch);

      if( $debug == 'true' ){
        // replace this example code with whatever you need
        return $this->render('JSONOdds/json.html.twig', [
            'results'     => $res,
            'JSONResults' => json_decode($res),
            'debug'       => $debug,
        ]);
      } else {
        return new Response($res);
      }
    }


    /**
     * @Route("/game_score/{gameid}/{debug}", name="gameScore", defaults = { "debug" = "false" })
     */
    public function gameScoreAction(Request $request, String $gameid, String $debug)
    {

      $appKey = "bef1a897-b119-11e8-9bbb-0a704e36c1ea";
      $ch = curl_init();
      curl_setopt($ch, CURLOPT_URL, "https://jsonodds.com/api/results/getbyeventid/" . $gameid);
      curl_setopt($ch, CURLOPT_HTTPGET, 1);
      curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
      curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
      curl_setopt($ch, CURLOPT_HTTPHEADER, array(
          'x-api-key:' . $appKey
      ));
      $res = curl_exec($ch);

      // replace this example code with whatever you need
      return $this->render('JSONOdds/json.html.twig', [
          'results'     => $res,
          'JSONResults' => json_decode($res),
          'debug'       => $debug,
      ]);
    }
}

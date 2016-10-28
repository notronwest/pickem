DROP PROCEDURE IF EXISTS `nflPerfection_updateStandings`;

DELIMITER $$

CREATE DEFINER=`inqsports`@`%` PROCEDURE `nflPerfection_updateStandings`(nInWeekID int(4), nInSeason int(4))
    DETERMINISTIC

doUpdate:BEGIN

DECLARE dtPicksDue int;
DECLARE nStandingRecordCount int;
DECLARE nLeastWins int;
DECLARE nFirstPlace int;

DECLARE EXIT HANDLER FOR SQLEXCEPTION
 BEGIN
  ROLLBACK;
  SELECT 'SQLException invoked';
 END;

IF nInWeekID = 0 THEN
    LEAVE doUpdate;
END IF;


    
UPDATE game
SET nWinner = fn_calculateStraightUpWinner(nHomeTeamID,nHomeScore,nAwayTeamID,nAwayScore)
WHERE nWeekID = nInWeekID
AND bGameIsFinal = 1;

UPDATE pick set nWin = fn_isPickWin(nGameID, nTeamID)
WHERE nWeekID = nInWeekID;


INSERT INTO standing  (nUserID, nWeekID, nSeasonID, nWins, nPoints, bHasPicks)
SELECT DISTINCT nUserID, nInWeekID, nInSeason, IF(pick.nWin = 1, 1, 0), IF(pick.nWin = 1, (SELECT ABS(nSpread) FROM game WHERE pick.nGameID = game.nGameID), 0), 1 as bHasPicks
FROM pick
WHERE nWeekID = nInWeekID
AND nUserID not in (select nUserID from standing where nWeekID = nInWeekID)
AND nUserID in (select nUserID from userSeason where nSeasonID = nInSeason)
GROUP BY nUserID;

UPDATE standing
SET bHasPicks = 1
WHERE nUserID in (SELECT nUserID FROM pick where nWeekID = nInWeekID)
AND nWeekID = nInWeekID;
    
UPDATE standing
SET nWins = (SELECT SUM(nWin) FROM pick WHERE nWeekID = nInWeekID AND pick.nUserID = standing.nUserID)
WHERE nWeekID = nInWeekID
AND bHasPicks = 1;

UPDATE standing
SET nPoints = 0
WHERE nPoints is null;

INSERT INTO standing (nUserID, nWeekID, nSeasonID, nWins, nPoints, bHasPicks)
SELECT nUserID, nInWeekID, nInSeason, 0 as nWins, 0 as nPoints, 0 as bHasPicks
FROM user
WHERE nUserID not in (select nUserID from standing where nWeekID = nInWeekID)
AND nUserID in (select nUserID from userSeason where nSeasonID = nInSeason);

DELETE FROM standing
WHERE nUserID IN (SELECT nUserID FROM user WHERE bActive <> 1)
AND nSeasonID = nInSeason;

UPDATE standing
SET nWins = 0
WHERE nUserID in ( SELECT nUserID FROM pick WHERE nWin = 0 AND nWeekID = nInWeekID)
AND nWeekID = nInWeekID;

UPDATE standing
         JOIN (

SELECT nStandingID, rank_calculated 
  from (
    SELECT    nStandingID, @curRank := @curRank + 1 AS rank_calculated
    FROM      standing s, (SELECT @curRank := 0) st
    WHERE nWeekID = nInWeekID
    ORDER BY  nWins DESC
  ) rt
ORDER BY rank_calculated
         ) AS r
         ON r.nStandingID = standing.nStandingID
SET standing.nPlace = r.rank_calculated
WHERE nWeekID = nInWeekID;


UPDATE standing
SET nWins = 0,
nPoints = 0
WHERE nWeekID = nInWeekID
AND bHasPicks <> 1;


END $$

DELIMITER ;
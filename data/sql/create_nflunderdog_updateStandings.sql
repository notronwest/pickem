DROP PROCEDURE IF EXISTS `nflUnderdog_updateStandings`;

DELIMITER $$

CREATE DEFINER=`inqsports`@`%` PROCEDURE `nflUnderdog_updateStandings`(nInWeekID int(4), nInSeason int(4))
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

-- if we have a 0 week id exit
IF nInWeekID = 0 THEN
    LEAVE doUpdate;
END IF;

-- Get the difference between now and the time when picks are due
-- SET dtPicksDue = (SELECT TIMESTAMPDIFF(
--    SECOND,
--    STR_TO_DATE(CONCAT(dPicksDue, ' ', tPicksDue, ':00'), '%Y-%m-%d %H:%i:%s'),
--    NOW())
-- FROM week
-- WHERE nWeekID = nInWeekID);

-- determine if the picks are locked for this week
-- IF dtPicksDue <= 0 THEN
    -- exit the procedure if picks aren't locked
--     LEAVE doUpdate;
-- END IF;

-- Determine which team won the game
UPDATE game
SET nWinner = fn_calculateStraightUpWinner(nHomeTeamID,nHomeScore,nAwayTeamID,nAwayScore)
WHERE nWeekID = nInWeekID
AND bGameIsFinal = 1;

-- Update all of the wins for indivdidual picks this week
UPDATE pick set nWin = fn_isPickWin(nGameID, nTeamID)
WHERE nWeekID = nInWeekID;

-- Update all of the auto pick users
-- UPDATE standing
-- SET bHasPicks = 1
-- WHERE nWeekID = nInWeekID
-- AND nUserID in ( SELECT DISTINCT nUserID FROM pick where nWeekID = nInWeekID and bAuto = 1 );

-- Insert all of the wins per user
INSERT INTO standing  (nUserID, nWeekID, nSeasonID, nWins, nPoints, bHasPicks)
SELECT DISTINCT nUserID, nInWeekID, nInSeason, IF(pick.nWin = 1, 1, 0), IF(pick.nWin = 1, (SELECT ABS(nSpread) FROM game WHERE pick.nGameID = game.nGameID), 0), 1 as bHasPicks
FROM pick
WHERE nWeekID = nInWeekID
AND nUserID not in (select nUserID from standing where nWeekID = nInWeekID)
AND nUserID in (select nUserID from userSeason where nSeasonID = nInSeason)
GROUP BY nUserID;
    
-- Update the records that already exist for this week
UPDATE standing
SET nWins = (SELECT SUM(nWin) FROM pick WHERE nWeekID = nInWeekID AND pick.nUserID = standing.nUserID),
nPoints = ( SELECT ABS(nSpread) FROM game join pick on pick.nGameID = game.nGameID WHERE game.nWeekID = nInWeekID AND pick.nWin = 1 AND pick.nUserID = standing.nUserID )
WHERE nWeekID = nInWeekID
AND bHasPicks = 1;

-- Insert a record for users that don't have picks
INSERT INTO standing (nUserID, nWeekID, nSeasonID, nWins, nPoints, bHasPicks)
SELECT nUserID, nInWeekID, nInSeason, 0 as nWins, 0 as nPoints, 0 as bHasPicks
FROM user
WHERE nUserID not in (select nUserID from standing where nWeekID = nInWeekID)
AND nUserID in (select nUserID from userSeason where nSeasonID = nInSeason);

-- remove any records for users who are inactive
DELETE FROM standing
WHERE nUserID IN (SELECT nUserID FROM user WHERE bActive <> 1)
AND nSeasonID = nInSeason;

-- Update the standings place for this week
UPDATE standing
         JOIN (
--          SELECT nStandingID, rank_calculated 
--          from ( 
--            SELECT nStandingID, nWins, nHighestTiebreak, @winrank := @winrank + 1 AS rank_calculated
--            from standing, (SELECT @winrank := 0) r
--            where nWeekID = nInWeekID
--            ORDER BY nWins DESC, if( nHighestTiebreak=0, nTiebreak2, nHighestTiebreak), nTiebreak2, nTiebreak3, nTiebreak4, nTiebreak5, nTiebreak6, nTiebreak7, nTiebreak8, nTiebreak9, nTiebreak10 ) rt
--          ORDER BY rank_calculated

SELECT nStandingID, rank_calculated 
  from (
    SELECT    nStandingID, @curRank := @curRank + 1 AS rank_calculated
    FROM      standing s, (SELECT @curRank := 0) st
    WHERE nWeekID = nInWeekID
    ORDER BY  nPoints DESC
  ) rt
ORDER BY rank_calculated
--          SELECT nStandingID
--                , @rownum:=@rownum+1 AS rank_calculated
--           FROM standing
--              , (SELECT @rownum:=0) AS st
--           WHERE nWeekID = nInWeekID
--           ORDER BY nWins DESC, if( nHighestTiebreak=0, nTiebreak2, nHighestTiebreak), nTiebreak2 ASC, nTiebreak3 ASC, nTiebreak4 ASC, nTiebreak5 ASC, nTiebreak6 ASC, nTiebreak7 ASC, nTiebreak8 ASC, nTiebreak9 ASC, nTiebreak10 ASC
         ) AS r
         ON r.nStandingID = standing.nStandingID
SET standing.nPlace = r.rank_calculated
WHERE nWeekID = nInWeekID;

-- get the least wins
-- SET nLeastWins = (SELECT nWins
-- FROM standing
-- WHERE nWeekID = nInWeekID
-- AND bHasPicks = 1
-- ORDER BY nWins
-- LIMIT 1);

-- update users who did not make picks
UPDATE standing
SET nWins = 0,
nPoints = 0
WHERE nWeekID = nInWeekID
AND bHasPicks <> 1;



END $$

DELIMITER ;
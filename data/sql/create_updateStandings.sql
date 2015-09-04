DROP PROCEDURE `updateStandings`//
CREATE DEFINER=`pickem`@`%` PROCEDURE `updateStandings`(nInWeekID int(4), nInSeason int(4))
    DETERMINISTIC
doUpdate:BEGIN

DECLARE dtPicksDue int;
DECLARE nStandingRecordCount int;
DECLARE nLeastWins int;

-- if we have a 0 week id exit
IF nInWeekID = 0 THEN
    LEAVE doUpdate;
END IF;

-- Get the difference between now and the time when picks are due
SET dtPicksDue = (SELECT TIMESTAMPDIFF(
    SECOND,
    STR_TO_DATE(CONCAT(dPicksDue, ' ', tPicksDue, ':00'), '%Y-%m-%d %H:%i:%s'),
    NOW())
FROM week
WHERE nWeekID = nInWeekID);

-- determine if the picks are locked for this week
IF dtPicksDue <= 0 THEN
    -- exit the procedure if picks aren't locked
    LEAVE doUpdate;
END IF;

-- Determine which team won the game
UPDATE game
SET nWinner = calculateWinner(nHomeTeamID,nHomeScore,nAwayTeamID,nAwayScore,nSpread,sSpreadFavor)
WHERE nWeekID = nInWeekID
AND bGameIsFinal = 1;

-- Update all of the wins for indivdidual picks this week
UPDATE pick set nWin = isPickWin(nGameID, nTeamID)
WHERE nWeekID = nInWeekID;

-- Insert all of the wins per user
INSERT INTO standing  (nUserID, nWeekID, nSeasonID, nWins, nLosses, bHasPicks)
SELECT DISTINCT nUserID, nInWeekID, nInSeason, SUM(nWin), 20 - SUM(nWin), 1 as bHasPicks
FROM pick
WHERE nWeekID = nInWeekID
AND nUserID not in (select nUserID from standing where nWeekID = nInWeekID)
GROUP BY nUserID;
    
-- Update the records that already exist for this week
UPDATE standing
SET nWins = (SELECT SUM(nWin) FROM pick WHERE nWeekID = nInWeekID AND pick.nUserID = standing.nUserID),
nLosses = (20 - nWins)
WHERE nWeekID = nInWeekID
AND bHasPicks = 1;

-- Insert a record for users that don't have picks
INSERT INTO standing (nUserID, nWeekID, nSeasonID, nWins, nLosses, nHighestTiebreak, bHasPicks)
SELECT nUserID, nInWeekID, nInSeason, 0 as nWins, 20 as nLosses, 0 as nHighestTiebreak, 0 as bHasPicks
FROM user
WHERE nUserID not in (select nUserID from standing where nWeekID = nInWeekID);

-- Update number of nTiebreaks
UPDATE standing
SET nHighestTiebreak = getHighestTiebreak(nWeekID, nUserID)
WHERE nWeekID = nInWeekID;

-- Update the standings place for this week
UPDATE standing
         JOIN
         ( SELECT nStandingID
                , @rownum:=@rownum+1 AS rank_calculated
           FROM standing
              , (SELECT @rownum:=0) AS st
           WHERE nWeekID = nInWeekID
           ORDER BY nWins DESC, nHighestTiebreak DESC
         ) AS r
         ON r.nStandingID = standing.nStandingID
SET standing.nPlace = r.rank_calculated
WHERE nWeekID = nInWeekID;

-- get the least wins
SET nLeastWins = (SELECT nWins
FROM standing
WHERE nWeekID = nInWeekID
AND bHasPicks = 1
ORDER BY nWins
LIMIT 1);

-- update users who did not make picks
UPDATE standing
SET nWins = nLeastWins,
nLosses = (select (count(*) - nLeastWins) as nLoses from game where nWeekID = nInWeekID)
WHERE nWeekID = nInWeekID
AND bHasPicks <> 1;


END

DROP PROCEDURE `updateStandings`//
CREATE DEFINER=`pickem`@`%` PROCEDURE `updateStandings`(nInWeekID int(4), nInSeason int(4))
    DETERMINISTIC
doUpdate:BEGIN

DECLARE dtPicksDue int;
DECLARE nStandingRecordCount int;
DECLARE nLeastWins int;
DECLARE nTiebreak1 int;
DECLARE nTiebreak2 int;
DECLARE nTiebreak3 int;
DECLARE nTiebreak4 int;
DECLARE nTiebreak5 int;
DECLARE nTiebreak6 int;
DECLARE nTiebreak7 int;
DECLARE nTiebreak8 int;
DECLARE nTiebreak9 int;
DECLARE nTiebreak10 int;

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

-- Get all of the tiebreaks
SET nTiebreak1 = getHighestTiebreak(nWeekID, nUserID)
SET nTiebreak2 = getNextTiebreak(nWeekID, nUserID, nTiebreak1)
SET nTiebreak3 = getNextTiebreak(nWeekID, nUserID, nTiebreak2)
SET nTiebreak4 = getNextTiebreak(nWeekID, nUserID, nTiebreak3)
SET nTiebreak5 = getNextTiebreak(nWeekID, nUserID, nTiebreak4)
SET nTiebreak6 = getNextTiebreak(nWeekID, nUserID, nTiebreak5)
SET nTiebreak7 = getNextTiebreak(nWeekID, nUserID, nTiebreak6)
SET nTiebreak8 = getNextTiebreak(nWeekID, nUserID, nTiebreak7)
SET nTiebreak9 = getNextTiebreak(nWeekID, nUserID, nTiebreak8)
SET nTiebreak10 = getNextTiebreak(nWeekID, nUserID, nTiebreak9)

-- Update all of the tiebreak info
UPDATE standing
SET nHighestTiebreak = nTiebreak1,
SET nTiebreak2 = nTnTiebreak2,
SET nTiebreak3 = nTnTiebreak3,
SET nTiebreak4 = nTnTiebreak4,
SET nTiebreak5 = nTnTiebreak5,
SET nTiebreak6 = nTnTiebreak6,
SET nTiebreak7 = nTnTiebreak7,
SET nTiebreak8 = nTnTiebreak8,
SET nTiebreak9 = nTnTiebreak9,
SET nTiebreak10 = nTnTiebreak10,
WHERE nWeekID = nInWeekID
AND nUserID = nUserID;

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

-- remove any records for users who are inactive
DELETE FROM standing
WHERE nUserID IN (SELECT nUserID FROM user WHERE bActive <> 1)
AND nSeasonID = nInSeason;


END

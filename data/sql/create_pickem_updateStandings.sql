DROP PROCEDURE IF EXISTS `pickem_updateStandings`;

DELIMITER $$

-- CREATE PROCEDURE `pickem_updateStandings`(IN nInWeekID int(4), IN nInSeason int(4), OUT errorCodeMessage TEXT)
CREATE PROCEDURE `pickem_updateStandings`(IN nInWeekID int(4), IN nInSeason int(4))
    DETERMINISTIC
doUpdate:BEGIN

-- exit handler variables
DECLARE errorCode CHAR(5) DEFAULT '00000';
DECLARE errorMessage TEXT;
DECLARE debugInfo TEXT;
DECLARE errorNo VARCHAR(10); -- ' MYSQL ERRORNO: ', COALESCE(errorNo, ''), we can use this if needed below in the errorCodeMessage for debugging

DECLARE dtPicksDue int;
DECLARE nStandingRecordCount int;
DECLARE nLeastWins int;
DECLARE nFirstPlace int;

-- exit handler for rollback if we hit an exception (roll it all back!!!!)
DECLARE EXIT HANDLER FOR SQLWARNING, SQLEXCEPTION
BEGIN
GET STACKED DIAGNOSTICS CONDITION 1
    errorCode = RETURNED_SQLSTATE, errorMessage = MESSAGE_TEXT, errorNo = MYSQL_ERRNO;
        -- SET errorCodeMessage = CONCAT('CODE: ', COALESCE(errorCode, ''), ' MESSAGE: ', COALESCE(errorMessage, ''), ' LAST POINT: ', COALESCE(debugInfo, ''));
    ROLLBACK;
END;

-- if we have a 0 week id exit
IF nInWeekID = 0 THEN
    LEAVE doUpdate;
END IF;

-- If this
SET dtPicksDue = (SELECT TIMESTAMPDIFF(
    SECOND,
    STR_TO_DATE(CONCAT(dPicksDue, ' ', tPicksDue, ':00'), '%Y-%m-%d %H:%i:%s'),
    NOW())
FROM week
WHERE nWeekID = nInWeekID);

-- Determine which team won the game
UPDATE game
SET nWinner = fn_calculateWinner(nHomeTeamID,nHomeScore,nAwayTeamID,nAwayScore,nSpread,sSpreadFavor)
WHERE nWeekID = nInWeekID
AND bGameIsFinal = 1;

-- Update all of the wins for indivdidual picks this week
UPDATE pick set nWin = fn_isPickWin(nGameID, nTeamID)
WHERE nWeekID = nInWeekID;

-- Insert all of the wins per user
INSERT INTO standing  (nUserID, nWeekID, nSeasonID, nWins, nLosses, bHasPicks)
SELECT DISTINCT nUserID, nInWeekID, nInSeason, SUM(nWin), 20 - SUM(nWin), 1 as bHasPicks
FROM pick
WHERE nWeekID = nInWeekID
AND nUserID not in (select nUserID from standing where nWeekID = nInWeekID)
AND nUserID in (select nUserID from userSeason where nSeasonID = nInSeason)
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
WHERE nUserID not in (select nUserID from standing where nWeekID = nInWeekID)
AND nUserID in (select nUserID from userSeason where nSeasonID = nInSeason);

-- Update all of the auto pick users
UPDATE standing
SET bAutoPick = 1
WHERE nWeekID = nInWeekID
AND nUserID in ( SELECT DISTINCT nUserID FROM pick where nWeekID = nInWeekID and bAuto = 1 );

-- Update number of nTiebreaks
UPDATE standing
SET nHighestTiebreak = fn_getHighestTiebreak(nWeekID, nUserID),
nTiebreak2 = fn_getNextTiebreak(nWeekID, nUserID, nHighestTiebreak),
nTiebreak3 = fn_getNextTiebreak(nWeekID, nUserID, nTiebreak2),
nTiebreak4 = fn_getNextTiebreak(nWeekID, nUserID, nTiebreak3),
nTiebreak5 = fn_getNextTiebreak(nWeekID, nUserID, nTiebreak4),
nTiebreak6 = fn_getNextTiebreak(nWeekID, nUserID, nTiebreak5),
nTiebreak7 = fn_getNextTiebreak(nWeekID, nUserID, nTiebreak6),
nTiebreak8 = fn_getNextTiebreak(nWeekID, nUserID, nTiebreak7),
nTiebreak9 = fn_getNextTiebreak(nWeekID, nUserID, nTiebreak8),
nTiebreak10 = fn_getNextTiebreak(nWeekID, nUserID, nTiebreak9)
WHERE nWeekID = nInWeekID;

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
    ORDER BY  nWins DESC, nHighestTiebreak DESC, nTiebreak2, nTiebreak3, nTiebreak4, nTiebreak5, nTiebreak6, nTiebreak7, nTiebreak8, nTiebreak9, nTiebreak10
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

-- do fix for first place being off one
SET nFirstPlace = (SELECT count(*) as nFirstPlace
FROM standing
WHERE nPlace = 1
AND nWeekID = nInWeekID);

IF nFirstPlace < 1 THEN
  UPDATE standing
  SET nPlace = (nPlace - 1)
  WHERE nWeekID = nInWeekID;
END IF;


END $$

DELIMITER ;

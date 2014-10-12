CREATE PROCEDURE updateStandings(nInWeekID int(4), sInSeason varchar(9))
DETERMINISTIC
CONTAINS SQL
doUpdate:BEGIN

DECLARE dtPicksDue int;
DECLARE nStandingRecordCount int(4);

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

-- Determine if we are doing an insert or update
--SELECT count(nUserID) into nStandingRecordCount
--FROM standing
--WHERE nWeekID = nInWeekID;

-- Should make sure that there is a record here for every user
--IF nStandingRecordCount = 0 THEN BEGIN

        -- Insert all of the wins per user
        INSERT INTO standing  (nUserID, nWeekID, sSeason, nWins, nLosses, bHasPicks)
        SELECT DISTINCT nUserID, nInWeekID, sInSeason, SUM(nWin), 20 - SUM(nWin), 1 as bHasPicks
        FROM pick
        WHERE nWeekID = nInWeekID
        AND nUserID not in (select nUserID from standing where nWeekID = nInWeekID)
        GROUP BY nUserID;

  --  END;

--ELSE BEGIN
    
        -- Update the records that already exist for this week
        UPDATE standing
        SET nWins = (SELECT SUM(nWin) FROM pick WHERE nWeekID = nInWeekID AND pick.nUserID = standing.nUserID),
        nLosses = (20 - nWins)
        WHERE nWeekID = nInWeekID
        AND bHasPicks = 1;

        -- Insert a record for users that don't have picks
        INSERT INTO standing (nUserID, nWeekID, sSeason, nWins, nLosses, nHighestTiebreak, bHasPicks)
        SELECT nUserID, nInWeekID, sInSeason, 0 as nWins, 20 as nLosses, 0 as nHighestTiebreak, 0 as bHasPicks
        FROM user
        WHERE nUserID not in (select nUserID from standing where nWeekID = nInWeekID);

--    END;

--END IF;

-- Update number of nTiebreaks
UPDATE standing s
SET nHighestTiebreak = ( SELECT MIN(nTiebreak)
    FROM game g
    LEFT JOIN pick p
    ON g.nGameID = p.nGameID
    WHERE nWin = 0 
    AND p.nUserID = s.nUserID
    AND p.nWeekID = nInWeekID )
WHERE bHasPicks = 1;

-- Update the standings place for this week
UPDATE standing  
    JOIN (SELECT s.nUserID,  
                 IF(@lastPoint <> s.nWins,  
                    @curRank := @curRank + @nextrank,  
                    @curRank)  AS rank,  
                 IF(@lastPoint = s.nWins,  
                    @nextrank := @nextrank + 1,  
                    @nextrank := 1),  
                 @lastPoint := s.nWins  
            FROM standing s 
            JOIN (SELECT @curRank := 0, @lastPoint := 0, @nextrank := 1) r
            WHERE s.nWeekID = nInWeekID
            ORDER BY  s.nWins DESC  
          ) ranks ON (ranks.nUserID = standing.nUserID)
SET standing.nPlace = ranks.rank
WHERE standing.nWeekID = nInWeekID;

END;


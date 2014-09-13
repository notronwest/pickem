CREATE PROCEDURE updateStandings(nInWeekID int(4), sInSeason varchar(9))
DETERMINISTIC
CONTAINS SQL
BEGIN

DECLARE nStandingRecordCount int(4);

-- Determine which team won the game
UPDATE game
SET nWinner = calculateWinner(nHomeTeamID,nHomeScore,nAwayTeamID,nAwayScore,nSpread,sSpreadFavor)
WHERE nWeekID = nInWeekID
AND bGameIsFinal = 1;

-- Update all of the wins for indivdidual picks this week
UPDATE pick set nWin = isPickWin(nGameID, nTeamID)
WHERE nWeekID = nInWeekID;

-- Determine if we are doing an insert or update
SELECT count(nUserID) into nStandingRecordCount
FROM standing
WHERE nWeekID = nInWeekID;

-- Should make sure that there is a record here for every user
IF nStandingRecordCount = 0 THEN BEGIN

        -- Insert all of the wins per user
        INSERT INTO standing  (nUserID, nWeekID, sSeason, nWins, nLosses)
        SELECT DISTINCT nUserID, nInWeekID, sInSeason, SUM(nWin), 20 - SUM(nWin)
        FROM pick
        WHERE nWeekID = nInWeekID
        GROUP BY nUserID;

    END;

ELSE BEGIN
    
        -- Update the records that already exist for this week
        UPDATE standing
        SET nWins = (SELECT SUM(nWin) FROM pick WHERE nWeekID = nInWeekID AND pick.nUserID = standing.nUserID),
        nLosses = (20 - nWins)
        WHERE nWeekID = nInWeekID;

    END;

END IF;

-- Update number of nTiebreaks
UPDATE standing s
SET nHighestTiebreak = ( SELECT MIN(nTiebreak)
    FROM game g
    LEFT JOIN pick p
    ON g.nGameID = p.nGameID
    WHERE nWin = 0 
    AND p.nUserID = s.nUserID
    AND p.nWeekID = nInWeekID );

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


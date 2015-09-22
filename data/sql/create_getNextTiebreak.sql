DROP FUNCTION `getNextTiebreak`//
CREATE DEFINER=`pickem`@`%` FUNCTION `getNextTiebreak`(nInWeekID int, nInUserID int, nInTiebreakStart int) RETURNS int(11)
BEGIN

DECLARE nNextTiebreak int;

SET nNextTiebreak = (SELECT nTiebreak
    FROM game g
    LEFT JOIN pick p
    USING (nGameID)
    WHERE p.nWin = 1
    AND p.nUserID = nInUserID
    AND p.nWeekID = nInWeekID
    AND g.nTiebreak > nInTiebreakStart
    ORDER BY g.nTiebreak
    LIMIT 1
);

IF (nNextTiebreak IS NULL) THEN
    SET nNextTiebreak = nInTiebreakStart;
END IF;

RETURN nNextTiebreak;

END

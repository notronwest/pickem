DROP FUNCTION `getHighestTiebreak`//
CREATE DEFINER=`pickem`@`%` FUNCTION `getHighestTiebreak`(nInWeekID int, nInUserID int, nInFromTiebreak int) RETURNS int(11)
BEGIN

IF nInFromTiebreak is null SET @nInFromTiebreak = 0;
DECLARE nHighestTiebreak int;

SET nHighestTiebreak = (SELECT (nTiebreak - 1)
    FROM game g
    LEFT JOIN pick p
    USING (nGameID)
    WHERE p.nWin <> 1
    AND p.nUserID = nInUserID
    AND p.nWeekID = nInWeekID
    AND p.nTiebreak > nInFromTebreak
    ORDER BY g.nTiebreak
    LIMIT 1
);

RETURN nHighestTiebreak;

END

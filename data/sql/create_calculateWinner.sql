
DROP FUNCTION IF EXISTS fn_calculateWinner;

Delimiter $$

CREATE DEFINER=`inqsports`@`%` FUNCTION fn_calculateWinner (nHomeTeamID int, nHomeScore int, nAwayTeamID int, nAwayScore int, nSpread double(8,2), sSpreadFavor varchar(5)) RETURNS int
NOT DETERMINISTIC
CONTAINS SQL
BEGIN

DECLARE nWinner int;
DECLARE nFavoriteScore int;
DECLARE nUnderdogScore int;

IF sSpreadFavor = 'home' THEN
    SET nFavoriteScore = nHomeScore;

    SET nUnderdogScore = nAwayScore;
    IF nFavoriteScore > (nUnderdogScore + nSpread) THEN
        SET nWinner = nHomeTeamID;
    ELSE
        SET nWinner = nAwayTeamID;
    END IF;

ELSE
    SET nFavoriteScore = nAwayScore;
    SET nUnderdogScore = nHomeScore;
    IF nFavoriteScore > (nUnderdogScore + nSpread) THEN
        SET nWinner = nAwayTeamID;
    ELSE
        SET nWinner = nHomeTeamID;
    END IF;
END IF;

RETURN nWinner;

END$$
DELIMITER ;

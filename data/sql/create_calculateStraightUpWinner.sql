
DROP FUNCTION IF EXISTS fn_calculateStraightUpWinner;

Delimiter $$

CREATE DEFINER=`inqsports`@`%` FUNCTION fn_calculateStraightUpWinner (nHomeTeamID int, nHomeScore int, nAwayTeamID int, nAwayScore int) RETURNS int
NOT DETERMINISTIC
CONTAINS SQL
BEGIN

DECLARE nWinner int;

IF nHomeScore > nAwayScore THEN
    SET nWinner = nHomeTeamID;
ELSE
    SET nWinner = nAwayTeamID;
END IF;

RETURN nWinner;

END$$
DELIMITER ;

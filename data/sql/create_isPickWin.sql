DROP FUNCTION IF EXISTS fn_isPickWin;

DELIMITER $$

CREATE DEFINER=`inqsports`@`%` FUNCTION fn_isPickWin(nInGameID int, nInPick int) RETURNS int
NOT DETERMINISTIC
CONTAINS SQL
BEGIN

DECLARE nWin int;

SET nWin = (SELECT count(nWinner)
FROM game
WHERE nGameID = nInGameID
AND nWinner = nInPick
);


RETURN nWin;

END $$

DELIMITER ;
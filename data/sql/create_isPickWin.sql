CREATE FUNCTION isPickWin(nInGameID int(4), nInPick int(4)) RETURNS int(4)
NOT DETERMINISTIC
CONTAINS SQL
BEGIN

DECLARE nWin int(4);

SET nWin = (SELECT count(nWinner)
FROM game
WHERE nGameID = nInGameID
AND nWinner = nInPick
);


RETURN nWin;

END
Go
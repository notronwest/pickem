
CREATE FUNCTION calculateWinner (nHomeTeamID int(11), nHomeScore int(11), nAwayTeamID int(11), nAwayScore int(11), nSpread double(8,2), sSpreadFavor varchar(5)) RETURNS int(11)
NOT DETERMINISTIC
CONTAINS SQL
BEGIN

DECLARE nWinner int(11);
DECLARE nFavoriteScore int(11);
DECLARE nUnderdogScore int(11);

IF sSpreadFavor = 'home' THEN
    SET nFavoriteScore = @nHomeScore;

    SET nUnderdogScore = @nAwayScore;
    IF nFavoriteScore > (nUnderdogScore + @nSpread) THEN
        SET nWinner = @nHomeTeamID;
    ELSE
        SET nWinner = @nAwayTeamID;
    END IF;

ELSE
    SET nFavoriteScore = @nAwayScore;
    SET nUnderdogScore = @nHomeScore;
    IF nFavoriteScore > (nUnderdogScore + @nSpread) THEN
        SET nWinner = @nAwayTeamID;
    ELSE
        SET nWinner = @nHomeTeamID;
    END IF;
END IF;

RETURN nWinner;

END
GO

CREATE TRIGGER LateRating
INSTEAD OF UPDATE OF mID, stars, title ON LateRating
FOR EACH ROW BEGIN
    UPDATE
        Movie
    SET
        title = NEW.title
    WHERE
        mID = OLD.mID
        AND OLD.ratingDate = NEW.ratingDate;
    UPDATE
        Rating
    SET
        stars = NEW.stars
    WHERE
        mID = OLD.mID
        AND ratingDate = OLD.ratingDate AND OLD.ratingDate = NEW.ratingDate;
    UPDATE
        Rating
    SET
        mID = NEW.mID
    WHERE
        mID = OLD.mID
        AND OLD.ratingDate = NEW.ratingDate;
    UPDATE
        Movie
    SET
        mID = NEW.mID
    WHERE
        mID = OLD.mID
        AND OLD.ratingDate = NEW.ratingDate;
END;

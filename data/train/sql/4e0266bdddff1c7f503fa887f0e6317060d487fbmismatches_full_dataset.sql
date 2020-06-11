-- This script will produce a list of records with not matching doorcounts.
-- It only works on the records that exist in both tables. That means records that only exist in one table won't be considered.

SELECT 
    new.kommuneid AS 'new kommuneid',
    new.roadid AS 'new roadid',
    new.HOUSEID AS 'new HOUSEID',
    new.doorcount AS 'new doorcount',
    old.kommuneid AS 'old kommuneid',
    old.roadid AS 'old roadid',
    old.houseid AS 'old houseid',
    old.doorcount AS 'old doorcount'
FROM
    SAMMY_NEW.SAM_HOUSEUNITS AS new
        INNER JOIN SAMMY.SAM_HOUSEUNITS AS old 
        ON old.kommuneid = new.kommuneid AND new.roadid = old.roadid AND new.HOUSEID = old.houseid
WHERE
    new.doorcount != old.doorcount;

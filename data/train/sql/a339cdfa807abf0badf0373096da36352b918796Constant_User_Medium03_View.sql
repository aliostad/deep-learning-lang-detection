-- View: Constant_User_Medium03_View

-- DROP VIEW IF EXISTS Constant_User_Medium03_View CASCADE;

CREATE OR REPLACE VIEW Constant_User_Medium03_View
AS
  SELECT * FROM Constant_User_LevelHigh02_View
  ;

ALTER TABLE Constant_User_Medium03_View OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.   Ìàíüêî Ä.
 04.04.15                                        *
*/

-- òåñò
-- SELECT * FROM Constant_User_Medium03_View LEFT JOIN Object ON Object.Id = Constant_User_Medium03_View.UserId ORDER BY 1

-- View: view_itn_gradeseparation
-- DROP VIEW view_itn_gradeseparation;
CREATE OR REPLACE VIEW view_itn_gradeseparation AS 
  SELECT rl.fid,
  rl.ogc_fid,
  rl.directednode_gradeseparation[1] AS gradeseparation_s,
  rl.directednode_gradeseparation[2] AS gradeseparation_e,
  COALESCE(((rl.roadname::text || ' ('::text) || rl.dftname::text) || ')'::text, COALESCE(rl.dftname::text, rl.descriptiveterm::text)) AS roadname,
  rl.wkb_geometry
FROM roadlink rl
WHERE rl.directednode_gradeseparation = '{0,1}'::integer[] OR rl.directednode_gradeseparation = '{1,1}'::integer[] OR rl.directednode_gradeseparation = '{1,0}'::integer[];
ALTER TABLE view_itn_gradeseparation
  OWNER TO postgres;
COMMENT ON VIEW view_itn_gradeseparation
  IS 'ITN links with grade separation';

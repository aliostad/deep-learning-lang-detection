

DROP FUNCTION IF EXISTS delete_mpoint_seg();

DROP FUNCTION IF EXISTS insert_trigger();

DROP FUNCTION IF EXISTS getBox2D(tpoint[]);

DROP FUNCTION IF EXISTS AddTrajectoryColumn(character varying, character varying, character varying, integer, character varying, integer);

DROP FUNCTION IF EXISTS AddTrajectoryColumn(character varying, character varying, character varying, integer, character varying, integer, integer);

DROP FUNCTION IF EXISTS tpoint(geometry, timestamp);

DROP FUNCTION IF EXISTS getTimeStamp(integer);

DROP FUNCTION IF EXISTS append(trajectory, geometry, timestamp);

DROP FUNCTION IF EXISTS append(trajectory, tpoint[]);

DROP FUNCTION IF EXISTS append(trajectory, tpoint);

DROP FUNCTION IF EXISTS remove(trajectory, timestamp, integer);

DROP FUNCTION IF EXISTS remove(trajectory, timestamp, timestamp);

DROP FUNCTION IF EXISTS modify(trajectory, tpoint);

DROP FUNCTION IF EXISTS modify(trajectory, tpoint[]);

DROP FUNCTION IF EXISTS modify(trajectory, timestamp, timestamp, tpoint[]);

DROP FUNCTION IF EXISTS trajectory_select(trajectory, timestamp, timestamp);

DROP FUNCTION IF EXISTS getrectintrajectory_record(double precision, double precision, double precision, double precision, trajectory);

DROP FUNCTION IF EXISTS getEndTime(trajectory);

DROP FUNCTION IF EXISTS getIntersectTpoint(trajectory, geometry);

DROP FUNCTION IF EXISTS getPointArray(tpoint[]);

DROP FUNCTION IF EXISTS getRect_trajectory(trajectory);

DROP FUNCTION IF EXISTS getStartTime(trajectory);

DROP FUNCTION IF EXISTS getTpointArrayInfo(tpoint[]);

DROP FUNCTION IF EXISTS getTrajectoryarrayinfo(tpoint[],  OUT tpoint text, OUT ptime_timestamp timestamp without time zone);

DROP FUNCTION IF EXISTS tpoint_to_linestring(tpoint[]);



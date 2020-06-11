/*
 * (c) 2014 MGRID B.V.
 * All rights reserved
 *
 * Clean append_id.
 * Delete records not deleted by entity resolution.
 *
 */

/*
 * Delete only the types of tables that are not deleted by the entity
 * resolution procedure. If we would delete all append_id's, we'd require
 * running in serializable isolation mode to prevent deleting newly
 * arrived records due to a nonrepeatable read.
 */

DELETE FROM stream.append_id
WHERE schema_name = 'rim2011'
AND   table_name IN ('ActRelationship','Act','Observation','ControlAct','Participation','Document');

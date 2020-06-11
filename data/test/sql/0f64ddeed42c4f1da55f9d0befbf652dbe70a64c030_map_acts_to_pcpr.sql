/*
 * (c) 2014 Portavita B.V.
 * All rights reserved
 *
 * Post processing on the lake.
 *
 * Creates direct links between an Act row (or any specialized table of Act),
 * the care provision it relates to and the corresponding patient (Record
 * Target). These three fields are added to the table LinkActPcpr.
 */

WITH RECURSIVE start_row AS (
	SELECT a._id, patient.id as "patientId"
        FROM ONLY "Document" a
        JOIN    stream.append_id                i
        ON      i.schema_name    = 'rim2011'
        AND     i.table_name     = 'Document'
        AND     i.id             = a._id
	JOIN   "Participation" part
    ON     part.act=a._id
    AND    part."typeCode"->>'code' =  'RCT'
    JOIN   "Patient" patient
    ON     patient._id = part.role
	WHERE  a."classCode"->>'code' = 'DOCCLIN'
),
actdown(document_id, term) AS (
	SELECT _id, _id as term from start_row
	UNION  ALL
	SELECT rec.document_id, rel.target
	FROM   "ActRelationship" rel
	join   actdown           rec
	ON     rel.source = rec.term
),
pcpr(document_id, code, ptnt_id) AS (
	SELECT sr._id, pcpr_act.code, sr."patientId"
	FROM   start_row sr
	JOIN   "ActRelationship" se_ar
	ON     se_ar.source = sr._id
	AND    se_ar."typeCode"->>'code' = 'DOC'
	JOIN   "Act" se
	ON     se._id = se_ar.target
	JOIN   "Act" pcpr_act
	ON     pcpr_act.id = se.id -- TODO: id is an array, so you should check whether an element in se is an element in pcpr_act
	AND    pcpr_act."classCode"->>'code' = 'PCPR'
	AND    pcpr_act."moodCode"->>'code'  = 'EVN'
)
INSERT INTO "LinkActPcpr" ("actId", "careProvision", "patientId") 
SELECT ad.term, p.code, p.ptnt_id
FROM actdown ad
JOIN pcpr p
ON p.document_id = ad.document_id;

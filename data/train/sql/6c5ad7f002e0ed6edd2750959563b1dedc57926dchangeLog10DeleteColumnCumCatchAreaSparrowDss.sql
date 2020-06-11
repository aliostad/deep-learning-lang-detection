--liquibase formatted sql

--This is for the sparrow_dss schema

    
--logicalFilePath: changeLog10DeleteColumnCumCatchAreaSparrowDss.sql


--changeset lmurphy:deletecolumna
CREATE OR REPLACE FORCE VIEW SPARROW_DSS.MODEL_ATTRIB_VW
(
   SPARROW_MODEL_ID,
   MODEL_REACH_ID,
   IDENTIFIER,
   FULL_IDENTIFIER,
   HYDSEQ,
   FNODE,
   TNODE,
   IFTRAN,
   FRAC,
   REACH_NAME,
   OPEN_WATER_NAME,
   MEANQ,
   MEANV,
   CATCH_AREA,
   TOT_CONTRIB_AREA,
   TOT_UPSTREAM_AREA,
   REACH_LENGTH,
   HUC2,
   HUC4,
   HUC6,
   HUC8,
   HEAD_REACH,
   SHORE_REACH,
   TERM_TRANS,
   TERM_ESTUARY,
   TERM_NONCONNECT,
   EDANAME,
   EDACODE,
   SOURCE,
   HUC2_NAME,
   HUC4_NAME,
   HUC6_NAME,
   HUC8_NAME
)
AS
   (SELECT model.SPARROW_MODEL_ID SPARROW_MODEL_ID,
           model.MODEL_REACH_ID MODEL_REACH_ID,
           model.IDENTIFIER IDENTIFIER,
           model.FULL_IDENTIFIER FULL_IDENTIFIER,
           model.HYDSEQ HYDSEQ,
           model.FNODE FNODE,
           model.TNODE TNODE,
           model.IFTRAN,
           model.FRAC FRAC,
           attrib.REACH_NAME REACH_NAME,
           attrib.OPEN_WATER_NAME OPEN_WATER_NAME,
           attrib.MEANQ MEANQ,
           attrib.MEANV MEANV,
           attrib.CATCH_AREA CATCH_AREA,
           attrib.TOT_CONTRIB_AREA TOT_CONTRIB_AREA,
           attrib.TOT_UPSTREAM_AREA TOT_UPSTREAM_AREA,
           attrib.REACH_LENGTH REACH_LENGTH,
           attrib.HUC2 HUC2,
           attrib.HUC4 HUC4,
           attrib.HUC6 HUC6,
           attrib.HUC8 HUC8,
           attrib.HEAD_REACH HEAD_REACH,
           attrib.SHORE_REACH SHORE_REACH,
           attrib.TERM_TRANS TERM_TRANS,
           attrib.TERM_ESTUARY TERM_ESTUARY,
           attrib.TERM_NONCONNECT TERM_NONCONNECT,
           attrib.EDANAME EDANAME,
           attrib.EDACODE EDACODE,
           'model' source,
           attrib.HUC2_NAME HUC2_NAME,
           attrib.HUC4_NAME HUC4_NAME,
           attrib.HUC6_NAME HUC6_NAME,
           attrib.HUC8_NAME HUC8_NAME
      FROM    MODEL_REACH model
           INNER JOIN
              MODEL_REACH_ATTRIB attrib
           ON (model.MODEL_REACH_ID = attrib.MODEL_REACH_ID)
    UNION ALL
    SELECT model.SPARROW_MODEL_ID SPARROW_MODEL_ID,
           model.MODEL_REACH_ID MODEL_REACH_ID,
           model.IDENTIFIER IDENTIFIER,
           model.FULL_IDENTIFIER FULL_IDENTIFIER,
           model.HYDSEQ HYDSEQ,
           model.FNODE FNODE,
           model.TNODE TNODE,
           model.IFTRAN,
           model.FRAC FRAC,
           attrib.REACH_NAME REACH_NAME,
           attrib.OPEN_WATER_NAME OPEN_WATER_NAME,
           attrib.MEANQ MEANQ,
           attrib.MEANV MEANV,
           attrib.CATCH_AREA CATCH_AREA,
           NULL TOT_CONTRIB_AREA,
           attrib.CUM_CATCH_AREA TOT_UPSTREAM_AREA,
           attrib.REACH_LENGTH REACH_LENGTH,
           attrib.HUC2 HUC2,
           attrib.HUC4 HUC4,
           attrib.HUC6 HUC6,
           attrib.HUC8 HUC8,
           attrib.HEAD_REACH HEAD_REACH,
           attrib.SHORE_REACH SHORE_REACH,
           attrib.TERM_TRANS TERM_TRANS,
           attrib.TERM_ESTUARY TERM_ESTUARY,
           attrib.TERM_NONCONNECT TERM_NONCONNECT,
           attrib.EDANAME EDANAME,
           attrib.EDACDA EDACODE,
           'enhanced' source,
           attrib.HUC2_NAME HUC2_NAME,
           attrib.HUC4_NAME HUC4_NAME,
           attrib.HUC6_NAME HUC6_NAME,
           attrib.HUC8_NAME HUC8_NAME
      FROM    MODEL_REACH model
           INNER JOIN
              STREAM_NETWORK.ENH_ATTRIB_VW attrib
           ON (model.ENH_REACH_ID = attrib.ENH_REACH_ID)
     WHERE NOT EXISTS
              (SELECT MODEL_REACH_ID
                 FROM MODEL_REACH_ATTRIB modattrib
                WHERE modattrib.MODEL_REACH_ID = model.MODEL_REACH_ID)
    UNION ALL
    SELECT model.SPARROW_MODEL_ID SPARROW_MODEL_ID,
           model.MODEL_REACH_ID MODEL_REACH_ID,
           model.IDENTIFIER IDENTIFIER,
           model.FULL_IDENTIFIER FULL_IDENTIFIER,
           model.HYDSEQ HYDSEQ,
           model.FNODE FNODE,
           model.TNODE TNODE,
           model.IFTRAN,
           model.FRAC FRAC,
           NULL REACH_NAME,
           NULL OPEN_WATER_NAME,
           NULL MEANQ,
           NULL MEANV,
           NULL CATCH_AREA,
           NULL TOT_CONTRIB_AREA,
           NULL TOT_UPSTREAM_AREA,
           NULL REACH_LENGTH,
           NULL HUC2,
           NULL HUC4,
           NULL HUC6,
           NULL HUC8,
           NULL HEAD_REACH,
           NULL SHORE_REACH,
           NULL TERM_TRANS,
           NULL TERM_ESTUARY,
           NULL TERM_NONCONNECT,
           NULL EDANAME,
           NULL EDACODE,
           'model_no_attrib' source,
           NULL HUC2_NAME,
           NULL HUC4_NAME,
           NULL HUC6_NAME,
           NULL HUC8_NAME
      FROM MODEL_REACH model
     WHERE     NOT EXISTS
                  (SELECT ENH_REACH_ID
                     FROM STREAM_NETWORK.ENH_ATTRIB_VW enhvw
                    WHERE enhvw.ENH_REACH_ID = model.ENH_REACH_ID)
           AND NOT EXISTS
                  (SELECT MODEL_REACH_ID
                     FROM MODEL_REACH_ATTRIB modattrib
                    WHERE modattrib.MODEL_REACH_ID = model.MODEL_REACH_ID));
--rollback drop view model_attrib_vw;


--changeset lmurphy:deletecolumnb
ALTER TABLE MODEL_REACH_ATTRIB DROP COLUMN CUM_CATCH_AREA;
--rollback alter table model_reach_attrib add (CUM_CATCH_AREA NUMBER(16,6));

--changeset lmurphy:deletecolumnc
ALTER TABLE MODEL_REACH_ATTRIB_SWAP DROP COLUMN CUM_CATCH_AREA;
--rollback alter table model_reach_attrib add (CUM_CATCH_AREA NUMBER(16,6));



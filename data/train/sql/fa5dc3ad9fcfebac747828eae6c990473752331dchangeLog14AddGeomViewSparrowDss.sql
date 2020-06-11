--liquibase formatted sql

--This is for the sparrow_dss schema

--logicalFilePath: changeLog14AddGeomViewSparrowDss.sql

--changeset lmurphy:addviewa
CREATE OR REPLACE FORCE VIEW SPARROW_DSS.MODEL_GEOM_25_VW
(
   SPARROW_MODEL_ID,
   MODEL_REACH_ID,
   IDENTIFIER,
   REACH_GEOM,
   CATCH_GEOM,
   WATERSHED_GEOM,
   REACH_SIZE,
   SOURCE
)
AS
   SELECT /*
             Note:  In this View, reaches which contain no geometry and are not related to a nominal reach are not returned.
             .
             The first query returns reaches which have no geometry at the model level (no entry in MODEL_REACH_GEOM),
             but do inherit geometry from the enhanced level (entry in STREAM_NETWORK.ENH_GEOM_VW).  It is possible, however, that the
             geometry in ENH_GEOM_VW or MODEL_REACH_GEOM may be null.
             */
         model.SPARROW_MODEL_ID AS SPARROW_MODEL_ID,
          model.MODEL_REACH_ID AS MODEL_REACH_ID,
          model.IDENTIFIER AS IDENTIFIER,
          enh.REACH_GEOM AS REACH_GEOM,
          enh.CATCH_GEOM AS CATCH_GEOM,
          enh.WATERSHED_GEOM AS WATERSHED_GEOM,
          model.REACH_SIZE AS REACH_SIZE,
          'enhanced' source
     FROM    MODEL_REACH model
          INNER JOIN
             STREAM_NETWORK.ENH_GEOM_VW enh
          ON (model.ENH_REACH_ID = enh.ENH_REACH_ID)
    WHERE     model.MODEL_REACH_ID NOT IN
                 (SELECT MODEL_REACH_ID FROM MODEL_REACH_GEOM)
          AND model.sparrow_model_id = 25
   UNION ALL
   SELECT /*
          The second query returns reaches which have geometry at the model level (an entry in MODEL_REACH_GEOM)
          */
         model.SPARROW_MODEL_ID AS SPARROW_MODEL_ID,
          model.MODEL_REACH_ID AS MODEL_REACH_ID,
          model.IDENTIFIER AS IDENTIFIER,
          geo.REACH_GEOM AS REACH_GEOM,
          geo.CATCH_GEOM AS CATCH_GEOM,
          geo.WATERSHED_GEOM AS WATERSHED_GEOM,
          model.REACH_SIZE AS REACH_SIZE,
          'model' source
     FROM    MODEL_REACH model
          INNER JOIN
             MODEL_REACH_GEOM geo
          ON (model.MODEL_REACH_ID = geo.MODEL_REACH_ID)
    WHERE model.sparrow_model_id = 25;
--rollback drop view model_geom_25_vw;



--changeset lmurphy:addviewb
CREATE OR REPLACE FORCE VIEW SPARROW_DSS.NATIONAL_MRB_E2RF1_VW
(
   IDENTIFIER,
   REACH_GEOM,
   CATCH_GEOM,
   WATERSHED_GEOM,
   REACH_SIZE,
   SOURCE
)
AS
   SELECT IDENTIFIER,
          REACH_GEOM,
          CATCH_GEOM,
          WATERSHED_GEOM,
          REACH_SIZE,
          SOURCE
     FROM MODEL_GEOM_25_VW;
--rollback drop view national_mrb_e2rf1_vw;

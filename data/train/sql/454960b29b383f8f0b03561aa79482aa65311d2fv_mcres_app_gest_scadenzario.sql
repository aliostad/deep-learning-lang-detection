/* Formatted on 21/07/2014 18:42:14 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_GEST_SCADENZARIO
(
   COD_TIPO_SCADENZA,
   DESC_TIPO_SCADENZA,
   VAL_GG_SUCC,
   VAL_GG_PREC,
   VAL_LIMITE_SCADENZA,
   VAL_GG_SUCC_NEW,
   VAL_GG_PREC_NEW,
   VAL_LIMITE_SCADENZA_NEW,
   FLG_VARIATO
)
AS
   SELECT                                    -- 20130218 AG  Created this view
         cod_tipo_scadenza,
          desc_tipo_scadenza,
          val_gg_succ,
          val_gg_prec,
          val_limite_scadenza,
          val_gg_succ_new,
          val_gg_prec_new,
          val_limite_scadenza_new,
          --
          CASE
             WHEN     val_gg_succ = val_gg_succ_new
                  AND val_gg_prec = val_gg_prec_new
                  AND val_limite_scadenza = val_limite_scadenza_new
             THEN
                0
             ELSE
                1
          END
             flg_variato
     FROM t_mcres_app_scadenzario;

/* Formatted on 21/07/2014 18:41:49 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_CONFERIMENTO_POS
(
   COD_ABI_OLD,
   COD_ABI_NEW,
   COD_NDG_OLD,
   COD_NDG_NEW
)
AS
   SELECT DISTINCT cod_abi_old,
                   cod_abi_new,
                   COD_NDG_OLD,
                   cod_ndg_new
     FROM t_MCRE0_APP_MIG_RECODE_NDG
   UNION
   SELECT DISTINCT cod_abi_old,
                   cod_abi_new,
                   COD_NDG_OLD,
                   cod_ndg_new
     FROM T_MCRE0_APP_MIG_RECODE_RAPP;

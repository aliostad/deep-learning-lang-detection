
SELECT 
    port
    , (SELECT prto_codigo FROM tbl_puerto_prto WHERE prto_pk = port) AS port_prmt
    , TIPO_NAV
    , (SELECT prmt_parametro FROM tbl_parametro_prmt WHERE prmt_pk = TIPO_NAV) AS TIPO_NAV_prmt
    , TIPO_NAV_2
    , (SELECT prmt_parametro FROM tbl_parametro_prmt WHERE prmt_pk = TIPO_NAV_2) AS TIPO_NAV_2_prmt
    , SERV_TRAF
    , (SELECT prmt_parametro FROM tbl_parametro_prmt WHERE prmt_pk = SERV_TRAF) AS SERV_TRAF_prmt
    , ACUERDO
    , (SELECT prmt_parametro FROM tbl_parametro_prmt WHERE prmt_pk = ACUERDO) AS ACUERDO_prmt
    , ORGA_3 AS ORGA
    , (SELECT prmt_parametro FROM tbl_parametro_prmt WHERE prmt_pk = ORGA_3) AS ORGA_prmt
    , TIPO_ESTAN_ESC
    , TIPO_ACT
    , (SELECT prmt_parametro FROM tbl_parametro_prmt WHERE prmt_pk = TIPO_ACT) AS TIPO_ACT_prmt
    , BUQUE
    , (SELECT prmt_parametro FROM tbl_parametro_prmt WHERE prmt_pk = BUQUE) AS BUQUE_prmt
    , TIPO_BUQUE
    , (SELECT prmt_parametro FROM tbl_parametro_prmt WHERE prmt_pk = TIPO_BUQUE) AS TIPO_BUQUE_prmt
    , PAIS
    , (SELECT prmt_parametro FROM tbl_parametro_prmt WHERE prmt_pk = PAIS) AS PAIS_prmt
    , TIPO_BUQUE_GT
    , (SELECT prmt_parametro FROM tbl_parametro_prmt WHERE prmt_pk = TIPO_BUQUE_GT) AS TIPO_BUQUE_GT_prmt
    
    , COUNT(1) AS ENTERO_01
    , SUM(gt) AS ENTERO_02
FROM (
    SELECT 
        port 
        , (
            SELECT srdt_prmt_pk
            FROM tbl_servicio_dato_srdt
            WHERE
                srdt_tpdt_pk = portico.getTipoDato('TIPO_NAV')
                AND srdt_srvc_pk = srvc_pk
        ) AS TIPO_NAV
        , (
            SELECT srdt_prmt_pk
            FROM tbl_servicio_dato_srdt
            WHERE
                srdt_tpdt_pk = portico.getTipoDato('TIPO_NAV_2')
                AND srdt_srvc_pk = srvc_pk
        ) AS TIPO_NAV_2
        , (
            SELECT srdt_prmt_pk
            FROM tbl_servicio_dato_srdt
            WHERE
                srdt_tpdt_pk = portico.getTipoDato('SERV_TRAF')
                AND srdt_srvc_pk = srvc_pk
        ) AS SERV_TRAF
        , (
            SELECT srdt_prmt_pk
            FROM tbl_servicio_dato_srdt
            WHERE
                srdt_tpdt_pk = portico.getTipoDato('ACUERDO')
                AND srdt_srvc_pk = srvc_pk
        ) AS ACUERDO
        , (
            SELECT srdt_prmt_pk
            FROM tbl_servicio_dato_srdt
            WHERE
                srdt_tpdt_pk = portico.getTipoDato('ORGA_3')
                AND srdt_srvc_pk = srvc_pk
        ) AS ORGA_3
        , (
            SELECT srdt_cadena
            FROM tbl_servicio_dato_srdt
            WHERE
                srdt_tpdt_pk = portico.getTipoDato('TIPO_ESTAN_ESC')
                AND srdt_srvc_pk = srvc_pk
        ) AS TIPO_ESTAN_ESC
        , (
            SELECT ssdt_prmt_pk
            FROM tbl_subservicio_dato_ssdt
            WHERE
                ssdt_tpdt_pk = portico.getTipoDato('TIPO_ACT')
                AND ssdt_ssrv_pk = atraque_primero_pk
        ) AS TIPO_ACT
        , buque_pk AS BUQUE
        , (
            SELECT prdt_prmt_pk
            FROM tbl_parametro_dato_prdt
            WHERE
                prdt_tpdt_pk = portico.getTipoDato('TIPO_BUQUE')
                AND prdt_prvr_pk = (
                    SELECT prvr_pk
                    FROM
                        tbl_parametro_version_prvr
                    WHERE
                        prvr_fini <= srvc_fref
                        AND (prvr_ffin IS NULL OR prvr_ffin > srvc_fref)
                        AND prvr_prmt_pk = buque_pk
                ) 
        ) AS TIPO_BUQUE
        , (
            SELECT prdt_prmt_pk
            FROM tbl_parametro_dato_prdt
            WHERE
                prdt_tpdt_pk = portico.getTipoDato('PAIS')
                AND prdt_prvr_pk = (
                    SELECT prvr_pk
                    FROM
                        tbl_parametro_version_prvr
                    WHERE
                        prvr_fini <= srvc_fref
                        AND (prvr_ffin IS NULL OR prvr_ffin > srvc_fref)
                        AND prvr_prmt_pk = buque_pk
                ) 
        ) AS PAIS
        , (
            SELECT prmt_pk
            FROM tbl_parametro_prmt
            WHERE 
                prmt_tppr_pk = portico.getEntidad('TIPO_BUQUE_GT')
                AND EXISTS (
                    SELECT 1
                    FROM tbl_parametro_version_prvr
                    WHERE 
                        prvr_prmt_pk = prmt_pk
                        AND prvr_fini <= srvc_fref
                        AND (prvr_ffin IS NULL OR prvr_ffin > srvc_fref)
                        AND EXISTS (
                            SELECT 1
                            FROM 
                                tbl_parametro_dato_prdt
                            WHERE 
                                prdt_prvr_pk = prvr_pk
                                AND prdt_tpdt_pk = portico.getTipoDato('ENTERO_01')
                                AND prdt_nentero = (
                                    SELECT MIN(prdt_nentero)
                                    FROM 
                                        tbl_parametro_dato_prdt
                                    WHERE 
                                        prdt_tpdt_pk = portico.getTipoDato('ENTERO_01')
                                        AND EXISTS (
                                            SELECT 1
                                            FROM tbl_parametro_version_prvr
                                            WHERE 
                                                prvr_pk = prdt_prvr_pk
                                                AND prvr_fini <= srvc_fref
                                                AND (prvr_ffin IS NULL OR prvr_ffin > srvc_fref)
                                                AND  EXISTS (
                                                    SELECT 1
                                                    FROM tbl_parametro_prmt
                                                    WHERE 
                                                        prmt_pk = prvr_prmt_pk
                                                        AND prmt_tppr_pk = portico.getEntidad('TIPO_BUQUE_GT')
                                                )
                                        )
                                        
                                        AND prdt_nentero >= (
                                            SELECT prdt_nentero
                                            FROM tbl_parametro_dato_prdt
                                            WHERE
                                                prdt_tpdt_pk = portico.getTipoDato('ENTERO_01')
                                                AND prdt_prvr_pk = (
                                                    SELECT prvr_pk
                                                    FROM tbl_parametro_version_prvr
                                                    WHERE
                                                        prvr_fini <= srvc_fref
                                                        AND (prvr_ffin IS NULL OR prvr_ffin > srvc_fref)
                                                        AND prvr_prmt_pk = buque_pk
                                                )
                                        )
            
            
                                
                                )
                        )
                )
        ) AS TIPO_BUQUE_GT
        , (
            SELECT prdt_nentero
            FROM tbl_parametro_dato_prdt
            WHERE
                prdt_tpdt_pk = portico.getTipoDato('ENTERO_01')
                AND prdt_prvr_pk = (
                    SELECT prvr_pk
                    FROM
                        tbl_parametro_version_prvr
                    WHERE
                        prvr_fini <= srvc_fref
                        AND (prvr_ffin IS NULL OR prvr_ffin > srvc_fref)
                        AND prvr_prmt_pk = buque_pk
                ) 
        ) AS gt
    FROM (
        SELECT srvc_subp_pk AS port
            , srvc_pk
            , srvc_fref
            , (
                SELECT srdt_prmt_pk
                FROM tbl_servicio_dato_srdt
                WHERE 
                    srdt_tpdt_pk = portico.getTipoDato('BUQUE')
                    AND srdt_srvc_pk = srvc_pk
            ) AS buque_pk
            , (
                SELECT MIN(ssrv_pk)
                FROM tbl_subservicio_ssrv
                WHERE 
                    ssrv_tpss_pk = portico.getEntidad('ATRAQUE')
                    AND ssrv_srvc_pk = srvc_pk
                    AND ssrv_estado = 'F'
            ) AS atraque_primero_pk
        FROM 
            tbl_servicio_srvc
        WHERE
            srvc_tpsr_pk = portico.getEntidad('ESCALA')
            AND srvc_ffin >= to_date('01022015', 'DDMMYYYY')
            AND srvc_ffin < to_date('01032015', 'DDMMYYYY')
        
            AND EXISTS (
                SELECT 1 FROM tbl_servicio_dato_srdt
                WHERE srdt_srvc_pk = srvc_pk
                    AND srdt_tpdt_pk = portico.gettipodato('COD_EXEN')
                    AND srdt_cadena IN ('0', '2')
            )
    ) sql
) sql
GROUP BY
    port
    , TIPO_NAV
    , TIPO_NAV_2
    , SERV_TRAF
    , ACUERDO
    , ORGA_3
    , TIPO_ESTAN_ESC
    , TIPO_ACT
    , BUQUE
    , TIPO_BUQUE
    , PAIS
    , TIPO_BUQUE_GT
;    





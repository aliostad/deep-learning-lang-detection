CREATE TABLE co_to_new_clu
(
  CO_ID VARCHAR2(255),
  NEWCLU_ID VARCHAR2(255)
)
/

INSERT INTO co_to_new_clu (CO_ID, NEWCLU_ID)
          SELECT
                  co.ID CO_ID,
                  newC.id newClu_ID
  FROM
          KSLU_CLU oldC,
                  KSLU_CLU newC,
                  KSEN_LUI co,
                  KSEN_ATP coAtp,
                  KSEN_ATP newCStartTerm,
                  KSEN_ATP newCEndTerm
  WHERE
          co.CLU_ID = oldC.ID
                  AND co.ATP_ID = coAtp.ID
                  AND oldC.VER_IND_ID = newC.VER_IND_ID
                  AND newC.EXP_FIRST_ATP = newCStartTerm.ID
                  AND newC.LAST_ATP = newCEndTerm.ID(+)
                  AND coAtp.START_DT >= newCStartTerm.START_DT
                  AND
                  (
                          newCEndTerm.END_DT IS NULL
                                  OR newCEndTerm.END_DT>coAtp.START_DT
                          )
                  AND oldC.ID!=newC.ID
/

--Fix formats to point to correct version
UPDATE KSEN_LUI updatef SET CLU_ID=
(SELECT
    newMatch.fid newformatId
FROM
    (
        SELECT
            CO_ID,
            newCLU_ID,
            fid,
            stragg(atype) atype
        FROM
            (
                SELECT
                    CO_ID,
                    newCLU_ID,
                    f.id fid,
                    a.LUTYPE_ID atype
                FROM
                    KSLU_CLU f,
                    KSLU_CLU a,
                    KSLU_CLUCLU_RELTN cfr,
                    KSLU_CLUCLU_RELTN far,
                    co_to_new_clu newmap
                WHERE
                    newCLU_ID = cfr.CLU_ID
                AND F.ID = cfr.RELATED_CLU_ID
                AND F.ID = far.CLU_ID
                AND A.ID = far.RELATED_CLU_ID
                ORDER BY
                    CO_ID,
                    newCLU_ID,
                    fid,
                    atype
            )
        GROUP BY
            CO_ID,
            newCLU_ID,
            fid
    )
    newMatch,
    (
        SELECT
            CO_ID,
            foid,
            fid,
            stragg(atype) atype
        FROM
            (
                SELECT
                    CO_ID,
                    fo.id foid,
                    f.id fid,
                    a.LUTYPE_ID atype
                FROM
                    KSEN_LUI fo,
                    KSEN_LUILUI_RELTN cofor,
                    KSLU_CLU f,
                    KSLU_CLU a,
                    KSLU_CLUCLU_RELTN far,
                    co_to_new_clu newmap
                WHERE
                    newmap.CO_ID = cofor.LUI_ID
                AND fo.ID = cofor.RELATED_LUI_ID
                AND F.ID = fo.CLU_ID
                AND F.ID = far.CLU_ID
                AND A.ID = far.RELATED_CLU_ID
                ORDER BY
                    CO_ID,
                    FOID,
                    FID,
                    ATYPE
            )
        GROUP BY
            CO_ID,
            FOID,
            FID
    )
    oldMatch
WHERE
    newmatch.CO_ID(+)=oldmatch.co_ID
AND newmatch.atype(+)=oldmatch.atype
and oldmatch.foid=updatef.id)
where
updatef.id in
(SELECT
    oldMatch.foid
FROM
    (
        SELECT
            CO_ID,
            newCLU_ID,
            fid,
            stragg(atype) atype
        FROM
            (
                SELECT
                    CO_ID,
                    newCLU_ID,
                    f.id fid,
                    a.LUTYPE_ID atype
                FROM
                    KSLU_CLU f,
                    KSLU_CLU a,
                    KSLU_CLUCLU_RELTN cfr,
                    KSLU_CLUCLU_RELTN far,
                    co_to_new_clu newmap
                WHERE
                    newCLU_ID = cfr.CLU_ID
                AND F.ID = cfr.RELATED_CLU_ID
                AND F.ID = far.CLU_ID
                AND A.ID = far.RELATED_CLU_ID
                ORDER BY
                    CO_ID,
                    newCLU_ID,
                    fid,
                    atype
            )
        GROUP BY
            CO_ID,
            newCLU_ID,
            fid
    )
    newMatch,
    (
        SELECT
            CO_ID,
            foid,
            fid,
            stragg(atype) atype
        FROM
            (
                SELECT
                    CO_ID,
                    fo.id foid,
                    f.id fid,
                    a.LUTYPE_ID atype
                FROM
                    KSEN_LUI fo,
                    KSEN_LUILUI_RELTN cofor,
                    KSLU_CLU f,
                    KSLU_CLU a,
                    KSLU_CLUCLU_RELTN far,
                    co_to_new_clu newmap
                WHERE
                    newmap.CO_ID = cofor.LUI_ID
                AND fo.ID = cofor.RELATED_LUI_ID
                AND F.ID = fo.CLU_ID
                AND F.ID = far.CLU_ID
                AND A.ID = far.RELATED_CLU_ID
                ORDER BY
                    CO_ID,
                    FOID,
                    FID,
                    ATYPE
            )
        GROUP BY
            CO_ID,
            FOID,
            FID
    )
    oldMatch
WHERE
    newmatch.CO_ID(+)=oldmatch.co_ID
AND newmatch.atype(+)=oldmatch.atype)
/

--This script updates COs to point to courses with
UPDATE KSEN_LUI l set CLU_ID=(
SELECT
    newC.id
FROM
    KSLU_CLU oldC,
    KSLU_CLU newC,
    KSEN_LUI co,
    KSEN_ATP coAtp,
    KSEN_ATP newCStartTerm,
    KSEN_ATP newCEndTerm
WHERE
    l.id=co.id
AND co.CLU_ID = oldC.ID
AND co.ATP_ID = coAtp.ID
AND oldC.VER_IND_ID = newC.VER_IND_ID
AND newC.EXP_FIRST_ATP = newCStartTerm.ID
AND newC.LAST_ATP = newCEndTerm.ID(+)
AND coAtp.START_DT >= newCStartTerm.START_DT
AND
    (
        newCEndTerm.END_DT IS NULL
     OR newCEndTerm.END_DT>coAtp.START_DT
    )
and oldC.ID!=newC.ID)
WHERE
l.LUI_TYPE='kuali.lui.type.course.offering' and
 EXISTS(
SELECT
    co.ID CO_ID, oldC.ID oldClu, newC.id newClu_ID, co.LUI_TYPE, co.ATP_ID LUI_ATP, newCStartTerm.ID,newCEndTerm.ID
FROM
    KSLU_CLU oldC,
    KSLU_CLU newC,
    KSEN_LUI co,
    KSEN_ATP coAtp,
    KSEN_ATP newCStartTerm,
    KSEN_ATP newCEndTerm
WHERE
    l.id=co.id
AND co.CLU_ID = oldC.ID
AND co.ATP_ID = coAtp.ID
AND oldC.VER_IND_ID = newC.VER_IND_ID
AND newC.EXP_FIRST_ATP = newCStartTerm.ID
AND newC.LAST_ATP = newCEndTerm.ID(+)
AND coAtp.START_DT >= newCStartTerm.START_DT
AND
    (
        newCEndTerm.END_DT IS NULL
     OR newCEndTerm.END_DT>coAtp.START_DT
    )
and oldC.ID!=newC.ID)
/

drop table co_to_new_clu
/
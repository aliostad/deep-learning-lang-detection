-- OK for CH, UK, PT
-- Get all "current" positions and their associated reference position
SELECT s.securityseedid AS security_id, -- Security ID
s.extid AS intranet_id, -- Intranet ID
s.name AS security_name, -- Security name
s.currency_ AS security_currency, -- Security currency
pos.local_amount AS local_amount, -- Local amount
pos.nav_value, -- NAV
pos.equalization_factor_amount AS equalization_factor_amount, -- Equalization factor
ref_pos.position_exists AS ref_position_exists, -- Position exists
ref_pos.local_amount AS ref_local_amount, -- Reference evaluation local amount
ref_pos.spot_rate AS ref_spot_rate, -- Reference evaluation spot rate
ref_pos.nav_value AS ref_nav_value, -- Reference NAV
ref_pos.equalization_factor_amount AS ref_equalization_factor_amount -- Equalization factor
FROM (
    -- Get positions with their equalization factor
    SELECT posa.security AS security_id, -- Security ID
    SUM(posa.localvalue) AS local_amount, -- Local amount
    MAX(posa.lastnav) AS nav_value, -- NAV
    ef.equalization_factor_amount -- Equalization factor amount
    FROM accountarrest acca,
    positionarrest posa,
    (
        SELECT oa.security AS security_id, -- Security ID
        SUM(oa.basepaid) AS equalization_factor_amount -- Equalization factor amount
        FROM operationarrest oa
        WHERE oa.portfolioarrest = ?
        AND oa.type_ = 'PENDINGEC'
        GROUP BY oa.security
    ) ef
    -- Joins
    WHERE acca.portfolioarrest = ?
    AND posa.accountarrest = acca.aaseedid
    AND ef.security_id(+) = posa.security
    -- Account type = securities
    AND acca.accounttype = 2
    GROUP BY posa.security, ef.equalization_factor_amount
) pos,
(
    -- Get positions with their equalization factor
    SELECT 1 AS position_exists, -- Position exists
    posa.security AS security_id, -- Security ID
    SUM(posa.localvalue) AS local_amount, -- Local amount
    MAX(posa.lastspot) AS spot_rate, -- Spot rate
    MAX(posa.lastnav) AS nav_value, -- NAV
    ef.equalization_factor_amount -- Equalization factor amount
    FROM accountarrest acca,
    positionarrest posa,
    (
        SELECT oa.security AS security_id, -- Security ID
        SUM(oa.basepaid) AS equalization_factor_amount -- Equalization factor amount
        FROM operationarrest oa
        WHERE oa.portfolioarrest = ?
        AND oa.type_ = 'PENDINGEC'
        GROUP BY oa.security
    ) ef
    -- Joins
    WHERE acca.portfolioarrest = ?
    AND posa.accountarrest = acca.aaseedid
    AND ef.security_id(+) = posa.security
    -- Account type = securities
    AND acca.accounttype = 2
    GROUP BY posa.security, ef.equalization_factor_amount
) ref_pos,
security s
WHERE s.securityseedid = pos.security_id
AND  s.securityseedid = ref_pos.security_id(+)
--ORDER BY s.name
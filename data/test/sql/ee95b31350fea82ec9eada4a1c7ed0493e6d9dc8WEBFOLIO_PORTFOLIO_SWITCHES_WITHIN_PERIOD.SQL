-- OK for CH, UK, PT
-- Get switches for a given portfolio and time period
SELECT red.security AS redemption_security_id, -- Redemption security ID
--red.operationseedid AS redemption_id, -- Redemption ID
red.finalamt AS redemption_amount, -- Redemption amount
red.finalqty AS redemption_quantity, -- Redemption quantity
red.finalprice AS redemption_nav, -- Redemption NAV
sub.security AS subscription_security_id, -- Subscription security ID
--sub.operationseedid AS subscription_id, -- Subscription ID
sub.finalqty AS subscription_quantity, -- Subscription quantity
sub.finalprice AS subscription_nav -- Subscription NAV
FROM (
    -- Get operations for positions (switch)
    SELECT opg.groupseedid, -- Group ID
    op.security, -- Security ID
    op.operationseedid, -- Operation ID
    op.type_ AS operation_type, -- Operation type
    op.finalamt, -- Operation amount
    op.finalqty, -- Operation quantity
    op.finalprice -- NAV
    FROM operation op,
    opgroup opg,
    opgroupline opgl
    WHERE opgl.opgroup = opg.groupseedid
    AND opgl.operation = op.operationseedid
    -- Switch
    AND opg.type_ = 'S'
    AND op.portfolio = ?
    -- Given time period
--    AND op.effectivedate > ?
--    AND op.effectivedate <= ?
    AND (
        -- Effective date is between reference evaluation date and current evaluation date
        (
            op.effectivedate > ?
            AND op.effectivedate <= ?
        )
        -- Or effective date is before reference evaluation date and operation creation date is between reference evaluation date and current evaluation date
        OR
        (
            op.effectivedate <= ?
            AND op.creationdate > ?
            AND op.creationdate <= ?
        )
    )
    -- Subscription or redemption
    AND op.type_ = 'RED'
    -- Normal or no capital
--    AND op.subtype = 'NC'
    -- Not cancelled
    AND op.status != 'CAN'
) red,
(
    -- Get operations for positions (switch)
    SELECT opg.groupseedid, -- Group ID
    op.security, -- Security ID
    op.operationseedid, -- Operation ID
    op.type_ AS operation_type, -- Operation type
    op.finalqty, -- Operation quantity
    op.finalprice -- NAV
    FROM operation op,
    opgroup opg,
    opgroupline opgl
    WHERE opgl.opgroup = opg.groupseedid
    AND opgl.operation = op.operationseedid
    -- Switch
    AND opg.type_ = 'S'
    AND op.portfolio = ?
    -- Given time period
--    AND op.effectivedate > ?
--    AND op.effectivedate <= ?
    AND (
        -- Effective date is between reference evaluation date and current evaluation date
        (
            op.effectivedate > ?
            AND op.effectivedate <= ?
        )
        -- Or effective date is before reference evaluation date and operation creation date is between reference evaluation date and current evaluation date
        OR
        (
            op.effectivedate <= ?
            AND op.creationdate > ?
            AND op.creationdate <= ?
        )
    )
    -- Subscription or redemption
    AND op.type_ = 'SUB'
    -- Normal or no capital
--    AND op.subtype = 'NC'
    -- Not cancelled
    AND op.status != 'CAN'
) sub
WHERE red.groupseedid = sub.groupseedid

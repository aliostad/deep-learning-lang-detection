DROP VIEW IF EXISTS transactions.receipt_view;

CREATE VIEW transactions.receipt_view
AS
SELECT
    transactions.transaction_master.transaction_master_id as tran_id,
    transactions.transaction_master.office_id,
    office.offices.office_code,
    transactions.transaction_master.transaction_master_id,
    transactions.transaction_master.transaction_code,
    transactions.transaction_master.transaction_ts,
    transactions.transaction_master.value_date,
    office.users.user_name AS entered_by,
    transactions.transaction_master.reference_number,
    transactions.transaction_master.statement_reference,
    core.verification_statuses.verification_status_name AS status,
    transactions.transaction_master.verification_reason,
    verified_by_user.user_name AS verified_by,
    transactions.customer_receipts.party_id AS customer_id,
    core.parties.party_code AS customer_code,
    core.parties.party_name AS customer_name,
    core.append_if_not_null(core.parties.address_line_1, '&lt;br /&gt;') || core.append_if_not_null(core.parties.address_line_2, '&lt;br /&gt;') || core.append_if_not_null(core.parties.street, '&lt;br /&gt;') || core.append_if_not_null(core.parties.city, '') || '&lt;br /&gt;' || core.get_state_name_by_state_id(core.parties.state_id) || '&lt;br /&gt;' || core.get_country_name_by_country_id(core.parties.country_id) AS address,
    core.parties.pan_number,
    core.parties.sst_number,
    core.parties.cst_number,
    core.parties.email,
    transactions.customer_receipts.currency_code,
    transactions.customer_receipts.amount,
    transactions.customer_receipts.er_debit,
    office.offices.currency_code AS home_currency_code,
    transactions.customer_receipts.amount * transactions.customer_receipts.er_debit AS amount_in_home_currency,
    transactions.customer_receipts.er_credit,
    core.parties.currency_code AS base_currency_code,
    transactions.customer_receipts.amount * transactions.customer_receipts.er_debit * transactions.customer_receipts.er_credit AS amount_in_base_currency
FROM transactions.customer_receipts
INNER JOIN transactions.transaction_master
ON transactions.transaction_master.transaction_master_id = transactions.customer_receipts.transaction_master_id
INNER JOIN core.parties
ON core.parties.party_id = transactions.customer_receipts.party_id
INNER JOIN core.verification_statuses
ON transactions.transaction_master.verification_status_id = core.verification_statuses.verification_status_id
INNER JOIN office.users
ON transactions.transaction_master.user_id = office.users.user_id
INNER JOIN office.offices
ON transactions.transaction_master.office_id = office.offices.office_id
LEFT JOIN office.users AS verified_by_user
ON transactions.transaction_master.verified_by_user_id = verified_by_user.user_id        
WHERE transactions.transaction_master.book = 'Sales.Receipt'
AND transactions.transaction_master.verification_status_id > 0;

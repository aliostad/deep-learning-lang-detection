-- Drop objects

\echo Drop v1.3 views

DROP VIEW IF EXISTS cc_agent_calls3_v;
DROP VIEW IF EXISTS cc_agent_calls_v CASCADE;
DROP VIEW IF EXISTS cc_agent_daycalls_v;
DROP VIEW IF EXISTS cc_agent_invoices_v;
DROP VIEW IF EXISTS cc_agent_money_v;
DROP VIEW IF EXISTS cc_agent_money_vi;
DROP VIEW IF EXISTS cc_agentcard_debt_v;
DROP VIEW IF EXISTS cc_booth_v;
DROP VIEW IF EXISTS cc_card_agent_v;
DROP VIEW IF EXISTS cc_charge_av;
DROP VIEW IF EXISTS cc_session_problems;
DROP VIEW IF EXISTS cc_closed_sessions;
DROP VIEW IF EXISTS cc_session_usage_v;
DROP VIEW IF EXISTS cc_session_calls;
DROP VIEW IF EXISTS cc_session_invoice;
DROP VIEW IF EXISTS cc_tariffrates2_v CASCADE;
DROP VIEW IF EXISTS cc_tariffrates3_v CASCADE;
DROP VIEW IF EXISTS cc_tariffrates_v CASCADE;

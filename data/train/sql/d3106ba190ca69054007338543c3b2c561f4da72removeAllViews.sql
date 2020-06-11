use finance;


drop view if exists p_commentcounts;
drop view if exists p_comparison;
drop view if exists p_endofmonthbalances;
drop view if exists p_monthlytotals;
drop view if exists p_potentialduplicates;
drop view if exists p_transactions;
drop view if exists p_transactionspermonth;
drop view if exists p_transactiontypecounts;
drop view if exists p_runningtotals;
drop view if exists p_recenttransactions;

drop view if exists v_earliestbalances;
drop view if exists v_earliestdates;
drop view if exists v_potentialduplicates;
drop view if exists v_step1;
drop view if exists v_step2;
drop view if exists v_step3;
drop view if exists v_step4;
drop view if exists v_step5;

drop view if exists v_groupedtrans;
drop view if exists v_firstbalance;
drop view if exists v_idamounts;
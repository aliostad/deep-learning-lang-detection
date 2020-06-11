SELECT   a.Budgetacct,
         a.primaryGroupDesc,
         a.SecondaryGroup,
         bsec.secondaryGroupdesc,
         OVRID_DESC,
         b.PROJ_BUD_YR_1  as BudgetAmount,
         NEW_YR_POST_mon_1 + b.ENCUMB_NWYR_MON_1 + NEW_YR_POST_mon_2 + b.ENCUMB_NWYR_MON_2 + NEW_YR_POST_mon_3 + b.ENCUMB_NWYR_MON_3 + NEW_YR_POST_mon_4 + b.ENCUMB_NWYR_MON_4 + NEW_YR_POST_mon_5 + b.ENCUMB_NWYR_MON_5 + NEW_YR_POST_mon_6 + b.ENCUMB_NWYR_MON_6    as 
YTD_Actual, 
         case 
              when b.proj_bud_YR_1 <> 0 then cast(Round((((NEW_YR_POST_mon_1 + b.ENCUMB_NWYR_MON_1  + NEW_YR_POST_mon_2 + b.ENCUMB_NWYR_MON_2 + NEW_YR_POST_mon_3 + b.ENCUMB_NWYR_MON_3 + NEW_YR_POST_mon_4 + b.ENCUMB_NWYR_MON_4  + b.ENCUMB_NWYR_MON_4 + NEW_YR_POST_mon_5 + b.ENCUMB_NWYR_MON_5 + NEW_YR_POST_mon_6 + b.ENCUMB_NWYR_MON_6 ) / b.proj_bud_YR_1) * 100),2) as 

Decimal(9,2)) 
              when b.proj_bud_YR_1 = 0 and (NEW_YR_POST_mon_1 + b.ENCUMB_NWYR_MON_1   + NEW_YR_POST_mon_2 + b.ENCUMB_NWYR_MON_2 + NEW_YR_POST_mon_3 + b.ENCUMB_NWYR_MON_3 + NEW_YR_POST_mon_4 + b.ENCUMB_NWYR_MON_4 + b.ENCUMB_NWYR_MON_4 + NEW_YR_POST_mon_5 + b.ENCUMB_NWYR_MON_5 + NEW_YR_POST_mon_6 + b.ENCUMB_NWYR_MON_6  )=0 then 0 
              else 1000.00 
         end as PercentUsed,
         b.PROJ_BUD_YR_1-(NEW_YR_POST_mon_1 + b.ENCUMB_NWYR_MON_1   + NEW_YR_POST_mon_2 + b.ENCUMB_NWYR_MON_2 + NEW_YR_POST_mon_3 + b.ENCUMB_NWYR_MON_3 + NEW_YR_POST_mon_4 + b.ENCUMB_NWYR_MON_4 + b.ENCUMB_NWYR_MON_4 + NEW_YR_POST_mon_5 + b.ENCUMB_NWYR_MON_5 + NEW_YR_POST_mon_6 + b.ENCUMB_NWYR_MON_6 ) as RemainingBudget,
         case 
              when b.proj_bud_YR_1 - (NEW_YR_POST_mon_1 + b.ENCUMB_NWYR_MON_1  + NEW_YR_POST_mon_2 + b.ENCUMB_NWYR_MON_2 + NEW_YR_POST_mon_3 + b.ENCUMB_NWYR_MON_3  + NEW_YR_POST_mon_4 + b.ENCUMB_NWYR_MON_4 + b.ENCUMB_NWYR_MON_4 + NEW_YR_POST_mon_5 + b.ENCUMB_NWYR_MON_5 + NEW_YR_POST_mon_6 + b.ENCUMB_NWYR_MON_6 ) < 0 Then 'OverBudget' 
              when b.proj_bud_YR_1 - (NEW_YR_POST_mon_1 + b.ENCUMB_NWYR_MON_1 + NEW_YR_POST_mon_2 + b.ENCUMB_NWYR_MON_2 + NEW_YR_POST_mon_3 + b.ENCUMB_NWYR_MON_3 + NEW_YR_POST_mon_4 + b.ENCUMB_NWYR_MON_4 + b.ENCUMB_NWYR_MON_4 + NEW_YR_POST_mon_5 + b.ENCUMB_NWYR_MON_5  + NEW_YR_POST_mon_6 + b.ENCUMB_NWYR_MON_6 )= 0 and b.proj_bud_YR_1 <> 0 Then 'Zero Available' 
              else 'OK' 
         end as BudgetStatus,
         POST_BAL_mon_1 + b.ENCUMB_mon_1 + POST_BAL_mon_2 + b.ENCUMB_mon_2 + POST_BAL_mon_3 + b.ENCUMB_mon_3  + POST_BAL_mon_4 + b.ENCUMB_mon_4 + POST_BAL_mon_5 + b.ENCUMB_mon_5 + POST_BAL_mon_6 + b.ENCUMB_mon_6  + POST_BAL_mon_7 + b.ENCUMB_mon_7 + POST_BAL_mon_8 + b.ENCUMB_mon_8 + POST_BAL_mon_9 + b.ENCUMB_mon_9  + POST_BAL_mon_10 + b.ENCUMB_mon_10  + POST_BAL_mon_11 + b.ENCUMB_mon_11 + POST_BAL_mon_12 + b.ENCUMB_mon_12 as PreviousActual,
         NEW_YR_POST_mon_1  + NEW_YR_POST_mon_2 + NEW_YR_POST_mon_3 + NEW_YR_POST_mon_4 + NEW_YR_POST_mon_5 + NEW_YR_POST_mon_6 as 
MonthlyActual,
         b.ENCUMB_NWYR_MON_1  + b.ENCUMB_NWYR_MON_2 + b.ENCUMB_NWYR_MON_3 + b.ENCUMB_NWYR_MON_4  + b.ENCUMB_NWYR_MON_5 + b.ENCUMB_NWYR_MON_6 as MonthlyEncumberance
FROM     dbo.NC_BudgetActuals_Ctl a 
         left join GL_master b on BudgetAcct=acct_cde 
         left join dbo.NC_Budget_Secondary bsec on a.secondarygroup = bsec.secondaryGroup
WHERE    BudgetAcct not in (select BudgetAcct from dbo.NC_BudgetActuals_Ctl where SecondaryGroup='SAL')
AND      a.BudgetAcct in(select distinct budgetacct from dbo.NC_Budget_STD_OWN_ID )
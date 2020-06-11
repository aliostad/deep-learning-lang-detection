--------------------------------------------------------
--  File created - Wednesday-May-28-2014   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure HP_DIVIDEND_CURSOR
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE HP_DIVIDEND_CURSOR 
AS
  v_nav_scheme      VARCHAR2(500) ;
  v_nav_schemeclass VARCHAR2(500);
  v_nav_date DATE;
  v_unreal_amount         NUMBER;
  v_nav_units             NUMBER ;
  v_prevday_units         NUMBER;
  v_unit_movement         NUMBER;
  v_opening_scheme_upload VARCHAR2(500);
  v_scheme_value_date_upload DATE;
  v_opening_scheme_amount NUMBER;
  V_OPENING_SCHEME_UNIT   NUMBER;
  v_opening_scheme_plan   VARCHAR2(500);
  v_opening_scheme_upload_date DATE;
  v_daily_upr_entry          NUMBER;
  v_prev_opening_amount      NUMBER;
  v_opening_scheme_amount_ND NUMBER;
  CURSOR c1
  IS
    SELECT h.nav_scheme ,
      h.nav_schemeclass ,
      h.nav_wkend_dt,
      CASE
        WHEN h.unreal_amount < 0
        THEN 0
        ELSE h.unreal_amount
      END AS unreal_amount,
      h.nav_units,
      h.unit_movement,
      h.prev_nav_units
    from hi_dividend h
    where h.nav_wkend_dt between '03 APR 2013' and '08 Jan 2014'
    and h.nav_scheme = 'HDFCMS'
    and h.nav_schemeclass = 'DDDP';
    
  /* cursor c2
  is
  select scheme,value_date,amount,unit_capital,plan,upload_dt, lag(amount,1) over (order by scheme,value_date,plan)perv_amount from hupd_opening_balance h;
  --where h.value_date='31 MAR 2013';
  */
BEGIN
  FOR c_rec IN c1
  LOOP
    SELECT scheme,
      value_date,
      amount,
      unit_capital,
      plan,
      upload_dt
    INTO v_opening_scheme_upload,
      v_scheme_value_date_upload,
      v_opening_scheme_amount,
      v_opening_scheme_unit,
      v_opening_scheme_plan,
      v_opening_scheme_upload_date
    from hupd_opening_balance h
    where h.value_date = c_rec.nav_wkend_dt - 1
    and h.scheme       = c_rec.nav_scheme
    AND h.plan         = c_rec.nav_schemeclass
    order by h.value_date desc;
    
    -- Formula to calculate daily UPR balance
    v_daily_upr_entry := (v_opening_scheme_amount + c_rec.unreal_amount)/c_rec.prev_nav_units * c_rec.unit_movement;
   
    /*dbms_output.put_line('Previous Upr Balance : ' || v_opening_scheme_amount);
    dbms_output.put_line('Unreliased Amount : ' || c_rec.unreal_amount);
    dbms_output.put_line('Total unit Outstanding : ' || c_rec.prev_nav_units);
    dbms_output.put_line('Unit Movement : '|| c_rec.unit_movement);
    dbms_output.put_line('Daily Upr Entry : ' || v_daily_upr_entry);*/
    -- opening scheme amount
    v_opening_scheme_amount_ND := v_daily_upr_entry + v_opening_scheme_amount;
  /* dbms_output.put_line('Upr Balance : ' || v_opening_scheme_amount_ND);*/
    -- insert  v_daily_upr_entry into a table HI_DAILY_BALANCE
    INSERT
    INTO HI_DAILY_BALANCE
      (
        SCHEME ,
        VALUE_DATE ,
        PLAN ,
        daily_upr_balance,
        upload_dt,
        UNIT_CAPITAL
      )
      VALUES
      (
        c_rec.nav_scheme,
        c_rec.nav_wkend_dt,
        c_rec.nav_schemeclass,
        v_daily_upr_entry,
        c_rec.nav_wkend_dt,
        c_rec.nav_units
      ) ;
    COMMIT;
    -- insert  opening values amount and unit capital into a table HUPD_OPENING_BALANCE
    INSERT
    INTO HUPD_OPENING_BALANCE
      (
        SCHEME ,
        VALUE_DATE ,
        plan ,
        AMOUNT,
        upload_dt,
        UNIT_CAPITAL
      )
      VALUES
      (
         c_rec.nav_scheme,
        c_rec.nav_wkend_dt,
        c_rec.nav_schemeclass,
        v_opening_scheme_amount_ND,
        c_rec.nav_wkend_dt,
        0
      ) ;
    COMMIT;
  END LOOP;
  --exit when c1%notfound;
  --end loop;
  CLOSE c1;
END;

/

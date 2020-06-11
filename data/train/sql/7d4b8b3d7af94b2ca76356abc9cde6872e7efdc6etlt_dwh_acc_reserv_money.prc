create or replace procedure u1.ETLT_DWH_ACC_RESERV_MONEY is
  v_date date;
begin
  select trunc(max(t.rsvmny_create_date)) - 30
    into v_date
    from u1.T_DWH_ACC_RESERV_MONEY t;

  delete from u1.T_DWH_ACC_RESERV_MONEY t
   where t.rsvmny_create_date >= v_date;
  commit;

  insert /*+ append */
  into u1.T_DWH_ACC_RESERV_MONEY
    select /*+ driving_site*/
     rsvmny_gid,
     rsvmny$change_date,
     rsvmny$row_status,
     rsvmny$audit_id,
     rsvmny$hash,
     rsvmny$source,
     rsvmny$provider,
     rsvmny$source_pk,
     rsvmny_reserv_date,
     rsvmny_create_date,
     rsvmny_clnt_gid,
     rsvmny_empl_gid,
     rsvmny_cntc_empl_gid,
     rsvmny_number,
     rsvmny_amount,
     rsvmny_crnc_gid,
     rsvmny_city,
     rrsvmny_city_name,
     rsvmny_dept_gid,
     rsvmny_clnt_cont_status_cd
      from DWH_MAIN.ACC_RESERV_MONEY@RDWH_EXD
     where rsvmny_create_date >= v_date;
  commit;

end ETLT_DWH_ACC_RESERV_MONEY;
/


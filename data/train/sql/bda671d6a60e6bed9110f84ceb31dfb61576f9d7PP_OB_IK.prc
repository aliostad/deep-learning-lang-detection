create or replace procedure PP_OB_IK
-- Èíâåíòàðíàÿ êàðòî÷êà ïî îáîðîòêå
(nIDENT in number) is
  cursor a(nIDENT in number) is
    select AG.AGNFAMILYNAME || ' ' || AG.AGNFIRSTNAME || ' ' || AG.AGNLASTNAME sAGNNAME, --
           DN.NOMEN_NAME,
           DN.NOMEN_CODE,
           DA.ACC_NUMBER,
           V.DATE_TO,
           V.ACNT_RES_QUANT,
           V.ACNT_RES_SUM,
           V.ACNT_RES_SUM / V.ACNT_RES_QUANT ACNT_RES_PRICE
      from VALTURNS   V, --
           AGNLIST    AG,
           DICNOMNS   DN,
           DICACCS    DA,
           SELECTLIST S
     where V.RN = S.DOCUMENT
       and S.IDENT = nIDENT
       and AG.RN = V.AGENT
       and DN.RN = V.NOMENCLATURE
       and DA.RN = V.ACCOUNT
       and V.ACNT_RES_QUANT <> 0
     order by NOMEN_NAME;

  r1 number;
  r2 number;
  n number;

  --
  procedure excel_init is
  begin
    prsg_excel.PREPARE;
    prsg_excel.SHEET_SELECT('ÈÊ ãðóïïîâîãî ó÷åòà ÎÑ');
    prsg_excel.CELL_DESCRIBE('Äåíü');
    prsg_excel.CELL_DESCRIBE('Ìåñÿö');
    prsg_excel.CELL_DESCRIBE('Ãîä');
    prsg_excel.CELL_DESCRIBE('Äàòà');
    prsg_excel.CELL_DESCRIBE('Íàèìåíîâàíèå');
    prsg_excel.CELL_DESCRIBE('ÌÎË');
    prsg_excel.CELL_DESCRIBE('Ñ÷åò');
    prsg_excel.LINE_DESCRIBE('Ñòðîêà1');
    prsg_excel.LINE_DESCRIBE('Ñòðîêà2');
    prsg_excel.LINE_CELL_DESCRIBE('Ñòðîêà1', 'Íà÷àëüíàÿÑòîèìîñòüÅä');
    prsg_excel.LINE_CELL_DESCRIBE('Ñòðîêà2', 'ÈíâÍîìåð');
    prsg_excel.LINE_CELL_DESCRIBE('Ñòðîêà2', 'ÏîñòóïèëîÊîëè÷');
    prsg_excel.LINE_CELL_DESCRIBE('Ñòðîêà2', 'ÏîñòóïèëîÑóììà');
  end;
  --
  procedure excel_fini is
  begin
    prsg_excel.LINE_DELETE('Ñòðîêà1');
    prsg_excel.LINE_DELETE('Ñòðîêà2');
  end;
begin
  excel_init;
  for c in a(nIDENT) loop
    r1 := prsg_excel.LINE_APPEND('Ñòðîêà1');
    r2 := prsg_excel.LINE_APPEND('Ñòðîêà2');
    if n is null then
      prsg_excel.CELL_VALUE_WRITE('Íàèìåíîâàíèå', c.nomen_name);
      prsg_excel.CELL_VALUE_WRITE('ÌÎË', c.sagnname);
      prsg_excel.CELL_VALUE_WRITE('Ñ÷åò', c.acc_number);
      prsg_excel.CELL_VALUE_WRITE('Äàòà', to_char(c.date_to, 'dd.mm.yyyy'));
      prsg_excel.CELL_VALUE_WRITE('Äåíü', to_char(c.date_to, 'dd'));
      prsg_excel.CELL_VALUE_WRITE('Ìåñÿö', lower(f_smonth_base(to_char(c.date_to, 'mm'), 1)));
      prsg_excel.CELL_VALUE_WRITE('Ãîä', to_char(c.date_to, 'yyyy'));
      n := 1;
    end if;
    prsg_excel.CELL_VALUE_WRITE('Íà÷àëüíàÿÑòîèìîñòüÅä', 0, r1, c.acnt_res_price);
    prsg_excel.CELL_VALUE_WRITE('ÈíâÍîìåð', 0, r2, c.nomen_code);
    prsg_excel.CELL_VALUE_WRITE('ÏîñòóïèëîÊîëè÷', 0, r2, c.acnt_res_quant);
    prsg_excel.CELL_VALUE_WRITE('ÏîñòóïèëîÑóììà', 0, r2, c.acnt_res_sum);
  end loop;
  excel_fini;
end PP_OB_IK;
/

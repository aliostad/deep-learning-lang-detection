CREATE
    /*[ALGORITHM = {UNDEFINED | MERGE | TEMPTABLE}]
    [DEFINER = { user | CURRENT_USER }]
    [SQL SECURITY { DEFINER | INVOKER }]*/
    VIEW `histudb`.`view_vienphi`
    AS
(SELECT
  `view_dv`.`bill_item_encounter_nr` AS `bill_item_encounter_nr`,
  SUM(`view_dv`.`xet_nghiem`)        AS `xetnghiem`,
  SUM(`view_dv`.`cdha`)              AS `cdha`,
  SUM(`view_dv`.`sieu_am`)           AS `sieuam`,
  SUM(`view_dv`.`tt_pt`)             AS `ttpt`,
  SUM(`view_dv`.`ddt`)               AS `ddt`,
  SUM(`view_dv`.`mau`)               AS `mau`,
  SUM(`view_dv`.`giuong`)            AS `giuong`,
  SUM(`view_dv`.`thuoc`)             AS `thuoc`,
  SUM(`view_dv`.`vtyt`)              AS `vtyt`,
  SUM(`view_dv`.`hoachat`)           AS `hoachat`,
  SUM(`view_dv`.`chuyenvien`)        AS `chuyenvien`,
  SUM(`view_dv`.`khamchuabenh`)      AS `khamchuabenh`
FROM `view_dv`
GROUP BY `view_dv`.`bill_item_encounter_nr`);
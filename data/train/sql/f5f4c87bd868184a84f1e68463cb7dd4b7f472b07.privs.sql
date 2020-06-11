insert into privilege(id, name, description, pos)
values('calcMenu', 'Главное меню - калькулятор', '', 3);
insert into privilege_action(privilege, action)
values('calcMenu', 'READ');

insert into privilege(id, name, description, pos)
values('TNCAdd', 'ТМЦ - добавить', '', 10000);
insert into privilege_action(privilege, action)
values('TNCAdd', 'READ');
insert into privilege_action(privilege, action)
values('TNCAdd', 'EXECUTE');

insert into privilege(id, name, description, pos)
values('TNCEdit', 'ТМЦ - редактировать', '', 10001);
insert into privilege_action(privilege, action)
values('TNCEdit', 'READ');
insert into privilege_action(privilege, action)
values('TNCEdit', 'EXECUTE');

insert into privilege(id, name, description, pos)
values('TNCDelete', 'ТМЦ - удалить', '', 10002);
insert into privilege_action(privilege, action)
values('TNCDelete', 'READ');
insert into privilege_action(privilege, action)
values('TNCDelete', 'EXECUTE');
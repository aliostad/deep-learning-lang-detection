insert into auth
(id, login, hash, salt)
values
(1, 'jdoe', 'a3af848c1a2a86d09bb39453c08c928f', '5gth987hc6'),
(2, 'jrow',
'8f265141d92bff83e6ca9052da9717206d971de4aa0a321eae4f98fe51b02eec',
'd97e188ba5a2094195729a665f9d60a5e7cbc1d68d9e186041ee32947e0e5716');

insert into autorise
(id, login, resource, role)
values
(1, 'jdoe', 'a', 'READ'),
(2,'jdoe', 'a.b','WRITE'),
(3,'jrow', 'a.b.c','EXEC'),
(4,'jdoe', 'a.bc','EXEC');

insert into roles
(id, role)
values
(1, 'READ');

insert into roles
(id, role)
values
(2, 'WRITE');

insert into roles
(id, role)
values
(3, 'EXEC');
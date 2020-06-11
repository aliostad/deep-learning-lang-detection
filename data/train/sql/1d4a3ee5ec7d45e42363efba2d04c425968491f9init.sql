-- admin
INSERT INTO admin (id,name,password,true_name,state,create_time,version) VALUES (1,'root','$2a$10$lKjlSxG9E3QDUmJNcQHUceYe6JtjfGc46vqbg9UYgnqMEcSRgYz4C','Root',0,'2012-01-01 01:00:00',0);

-- admin_role
insert into role(id,name,permissions,create_time,version) values (1,'ROOT','admin:read,admin:change,role:read,role:change,user:read,user:change,contract:read,contract:change,house:read,house:change','2012-01-01 01:00:00',0);


-- admin_x_role
insert into admin_x_role(admin_id, role_id) values (1, 1);

-- admin_permission
insert into permission(id,name,permit) values (1,'管理员访问','admin:read');
insert into permission(id,name,permit) values (2,'管理员修改','admin:change');
insert into permission(id,name,permit) values (3,'管理员权限访问','role:read');
insert into permission(id,name,permit) values (4,'管理员权限修改','role:change');
insert into permission(id,name,permit) values (5,'用户访问','user:read');
insert into permission(id,name,permit) values (6,'用户修改','user:change');
insert into permission(id,name,permit) values (7,'房产交易访问','contract:read');
insert into permission(id,name,permit) values (8,'房产交易修改','contract:change');
insert into permission(id,name,permit) values (9,'户型访问','house:read');
insert into permission(id,name,permit) values (10,'户型修改','house:change');

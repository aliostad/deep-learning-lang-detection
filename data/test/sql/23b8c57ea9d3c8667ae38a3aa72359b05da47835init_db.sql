CREATE TABLE sector_users (
     did    SERIAL PRIMARY KEY,
     name   varchar(40) UNIQUE NOT NULL CHECK (name <> ''),
     passwd varchar(20),
     quota  integer CHECK (quota > 0),
     acl    inet[],
     read_permission  text[],
     write_permission text[],
     exec_permission  boolean
);

INSERT INTO sector_users (did, name, acl, read_permission)
     VALUES (DEFAULT, 'anonymous', '{"0.0.0.0/0"}', '{"/pub"}');
     
INSERT INTO sector_users (did, name, passwd, acl, read_permission, write_permission, exec_permission)
     VALUES (DEFAULT, 'root', 'abc123', '{"0.0.0.0/0"}', '{"/"}', '{"/"}', TRUE);
     
INSERT INTO sector_users (did, name, passwd, quota, acl, read_permission, write_permission, exec_permission)
     VALUES (DEFAULT, 'test', 'xxx', 1000000, '{"0.0.0.0/0"}', '{"/"}', '{"/"}', TRUE);

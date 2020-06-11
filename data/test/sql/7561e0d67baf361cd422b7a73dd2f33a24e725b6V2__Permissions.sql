INSERT INTO Permission(id, scope, operation)
VALUES (101, 'studiorum.domain.Role', 'READ_LIST'),
       (102, 'studiorum.domain.Role', 'READ'),
       (103, 'studiorum.domain.Role', 'CREATE'),
       (104, 'studiorum.domain.Role', 'UPDATE'),
       (105, 'studiorum.domain.Role', 'DELETE'),
       (201, 'studiorum.domain.Permission', 'READ_LIST');

INSERT INTO SUser_Role(User_id, Role_id)
VALUES (1, 1);

INSERT INTO Role_Permission(Role_id, Permission_id)
VALUES (1, 101),
       (1, 102),
       (1, 103),
       (1, 104),
       (1, 105),
       (1, 201);

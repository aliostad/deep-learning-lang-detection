INSERT INTO bugs (title, description, status) VALUES('Test Bug 1', 'This is test bug 1', 'New');
INSERT INTO bugs (title, description, status) VALUES('Test Bug 2', 'This is test bug 2', 'New');
INSERT INTO bugs (title, description, status) VALUES('Test Bug 3', 'This is test bug 3', 'New');

INSERT INTO change_log (bug_id, from_status, to_status) VALUES(1, NULL, 'New');
INSERT INTO change_log (bug_id, from_status, to_status) VALUES(2, NULL, 'New');
INSERT INTO change_log (bug_id, from_status, to_status) VALUES(3, NULL, 'New');

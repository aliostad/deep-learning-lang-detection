SET FOREIGN_KEY_CHECKS = 0;

DELETE FROM `#__redcore_oauth_scopes` WHERE `scope` IN ('create', 'read', 'update', 'delete', 'documentation', 'task');

INSERT INTO `#__redcore_oauth_scopes` (`scope`) VALUES
  ('site.create'),
  ('site.read'),
  ('site.update'),
  ('site.delete'),
  ('site.documentation'),
  ('site.task'),
  ('administrator.create'),
  ('administrator.read'),
  ('administrator.update'),
  ('administrator.delete'),
  ('administrator.documentation'),
  ('administrator.task');

SET FOREIGN_KEY_CHECKS = 1;

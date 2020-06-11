UPDATE `acl_permissions` SET `create`=null, `read`=1, `update`=1, `delete`=1 WHERE `resource_type`='task' AND `entity_value`='faculty:director' AND `assertion`='TaskOwner';
UPDATE `acl_permissions` SET `create`=null, `read`=1, `update`=1, `delete`=1 WHERE `resource_type`='task' AND `entity_value`='pcoordinator' AND `assertion`='TaskOwner';
UPDATE `acl_permissions` SET `create`=1, `read`=null, `update`=null, `delete`=null WHERE `resource_type`='task' AND `entity_value`='faculty:director' AND `assertion`='CourseOwner';
UPDATE `acl_permissions` SET `create`=1, `read`=null, `update`=null, `delete`=null WHERE `resource_type`='task' AND `entity_value`='pcoordinator' AND `assertion`='CourseOwner';

INSERT INTO `acl_permissions` (`resource_type`, `resource_value`, `entity_type`, `entity_value`, `app_id`, `create`, `read`, `update`, `delete`, `assertion`) VALUES
('evaluation', NULL, 'group:role', 'staff:admin', 1, 1, 1, 1, 1, NULL),
('evaluationform', NULL, 'group:role', 'staff:admin', 1, 1, 1, 1, 1, NULL),
('evaluationformquestion', NULL, 'group:role', 'staff:admin', 1, 1, 1, 1, 1, NULL),
('gradebook', NULL, 'group', 'student', NULL, NULL, 1, NULL, NULL, NULL),
('metadata', NULL, 'group:role', 'staff:admin', 1, 1, 1, 1, 1, NULL);

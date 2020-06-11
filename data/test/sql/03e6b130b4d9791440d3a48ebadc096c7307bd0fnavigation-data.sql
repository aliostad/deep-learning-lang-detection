DELETE FROM nav_link_2_nav_link;
DELETE FROM sidebar_2_nav_link;
DELETE FROM sidebar;
DELETE FROM nav_link;

-- Home Sidebar --
INSERT INTO sidebar (id, path) VALUES (1, '/home');

-- Home Sidebar Links --
INSERT INTO nav_link (id, name, url, display_priority) VALUES (101, 'Wall', '/home/wall', 1);
INSERT INTO nav_link (id, name, url, display_priority) VALUES (102, 'Projects', '/home/projects', 2);
INSERT INTO nav_link (id, name, url, display_priority) VALUES (103, 'Achievements', '/home/achievements', 3);
INSERT INTO nav_link (id, name, url, display_priority) VALUES (104, 'Scores', '/home/scores', 4);
INSERT INTO nav_link (id, name, url, display_priority) VALUES (105, 'Discussions', '/home/discussions', 5);
INSERT INTO nav_link (id, name, url, display_priority) VALUES (106, 'Calendar', '/home/calendar', 6);
INSERT INTO nav_link (id, name, url, display_priority) VALUES (107, 'Messages', '/home/messages', 7);

INSERT INTO nav_link (id, name, url, display_priority, parent_id) VALUES (112, 'Programming', '/home/projects/programming', 1, 102);

-- Home sidebar_2_nav_link relations --
INSERT INTO sidebar_2_nav_link (sidebar_id, nav_link_id) VALUES (1, 101);
INSERT INTO sidebar_2_nav_link (sidebar_id, nav_link_id) VALUES (1, 102);
INSERT INTO sidebar_2_nav_link (sidebar_id, nav_link_id) VALUES (1, 103);
INSERT INTO sidebar_2_nav_link (sidebar_id, nav_link_id) VALUES (1, 104);
INSERT INTO sidebar_2_nav_link (sidebar_id, nav_link_id) VALUES (1, 105);
INSERT INTO sidebar_2_nav_link (sidebar_id, nav_link_id) VALUES (1, 106);
INSERT INTO sidebar_2_nav_link (sidebar_id, nav_link_id) VALUES (1, 107);

-- Academics Sidebar --
INSERT INTO sidebar (id, path) VALUES (2, '/academic');

-- Academics Sidebar Links --
INSERT INTO nav_link (id, name, url, display_priority) VALUES (201, 'Courses', '/academic/courses', 1);
INSERT INTO nav_link (id, name, url, display_priority) VALUES (202, 'Exams', '/academic/exams', 2);
INSERT INTO nav_link (id, name, url, display_priority) VALUES (203, 'Staff', '/academic/staffs', 3);
INSERT INTO nav_link (id, name, url, display_priority) VALUES (204, 'Students', '/academic/students', 4);
INSERT INTO nav_link (id, name, url, display_priority) VALUES (205, 'Groups', '/academic/groups', 5);

-- Academics sidebar_2_nav_link relations --
INSERT INTO sidebar_2_nav_link (sidebar_id, nav_link_id) VALUES (2, 201);
INSERT INTO sidebar_2_nav_link (sidebar_id, nav_link_id) VALUES (2, 202);
INSERT INTO sidebar_2_nav_link (sidebar_id, nav_link_id) VALUES (2, 203);
INSERT INTO sidebar_2_nav_link (sidebar_id, nav_link_id) VALUES (2, 204);
INSERT INTO sidebar_2_nav_link (sidebar_id, nav_link_id) VALUES (2, 205);


-- Social Sidebar --
INSERT INTO sidebar (id, path) VALUES (3, '/social');

-- Social Sidebar Links --
INSERT INTO nav_link (id, name, url, display_priority) VALUES (301, 'Chat', '/social/chat', 1);
INSERT INTO nav_link (id, name, url, display_priority) VALUES (302, 'Discussions', '/social/discussions', 2);
INSERT INTO nav_link (id, name, url, display_priority) VALUES (303, 'Events', '/social/events', 3);

-- Social sidebar_2_nav_link relations --
INSERT INTO sidebar_2_nav_link (sidebar_id, nav_link_id) VALUES (3, 301);
INSERT INTO sidebar_2_nav_link (sidebar_id, nav_link_id) VALUES (3, 302);
INSERT INTO sidebar_2_nav_link (sidebar_id, nav_link_id) VALUES (3, 303);

-- Courses Sidebar
INSERT INTO sidebar (id, path) VALUES (21, '/academic/course');

-- Courses Sidebar Links --
INSERT INTO nav_link (id, name, url, display_priority) VALUES (211, 'Materials', '/academic/course/{courseId}/materials', 1);
INSERT INTO nav_link (id, name, url, display_priority) VALUES (212, 'Challenges', '/academic/course/{courseId}/challenges', 2);
INSERT INTO nav_link (id, name, url, display_priority) VALUES (213, 'Students', '/academic/course/{courseId}/students', 3);
INSERT INTO nav_link (id, name, url, display_priority) VALUES (214, 'Staff', '/academic/course/{courseId}/staff', 4);
INSERT INTO nav_link (id, name, url, display_priority) VALUES (215, 'Calendar', '/academic/course/{courseId}/calendar', 5);
INSERT INTO nav_link (id, name, url, display_priority) VALUES (216, 'Discussions', '/academic/course/{courseId}/discussions', 6);

-- Courses sidebar_2_nav_link relations --
INSERT INTO sidebar_2_nav_link (sidebar_id, nav_link_id) VALUES (21, 211);
INSERT INTO sidebar_2_nav_link (sidebar_id, nav_link_id) VALUES (21, 212);
INSERT INTO sidebar_2_nav_link (sidebar_id, nav_link_id) VALUES (21, 213);
INSERT INTO sidebar_2_nav_link (sidebar_id, nav_link_id) VALUES (21, 214);
INSERT INTO sidebar_2_nav_link (sidebar_id, nav_link_id) VALUES (21, 215);
INSERT INTO sidebar_2_nav_link (sidebar_id, nav_link_id) VALUES (21, 216);

-- Exams Sidebar
INSERT INTO sidebar (id, path) VALUES (22, '/academic/exam');

-- Exams Sidebar Links --
INSERT INTO nav_link (id, name, url, display_priority) VALUES (221, 'Results', '/academic/exam/{examId}/results', 1);
INSERT INTO nav_link (id, name, url, display_priority) VALUES (222, 'Statistics', '/academic/exam/{examId}/statistics', 2);
INSERT INTO nav_link (id, name, url, display_priority) VALUES (223, 'Requirements', '/academic/exam/{examId}/requirements', 3);
INSERT INTO nav_link (id, name, url, display_priority) VALUES (224, 'Discussions', '/academic/exam/{examId}/discussions', 4);

-- Exams sidebar_2_nav_link relations --
INSERT INTO sidebar_2_nav_link (sidebar_id, nav_link_id) VALUES (22, 221);
INSERT INTO sidebar_2_nav_link (sidebar_id, nav_link_id) VALUES (22, 222);
INSERT INTO sidebar_2_nav_link (sidebar_id, nav_link_id) VALUES (22, 223);
INSERT INTO sidebar_2_nav_link (sidebar_id, nav_link_id) VALUES (22, 224);

-- Staff Sidebar
INSERT INTO sidebar (id, path) VALUES (23, '/academic/staff');

-- Staff Sidebar Links --
INSERT INTO nav_link (id, name, url, display_priority) VALUES (231, 'Scores', '/academic/staff/{staffId}/scores', 1);
INSERT INTO nav_link (id, name, url, display_priority) VALUES (232, 'Achievements', '/academic/staff/{staffId}/achievements', 2);
INSERT INTO nav_link (id, name, url, display_priority) VALUES (233, 'Projects', '/academic/staff/{staffId}/projects', 3);
INSERT INTO nav_link (id, name, url, display_priority) VALUES (234, 'Discussions', '/academic/staff/{staffId}/discussions', 4);

-- Staff sidebar_2_nav_link relations --
INSERT INTO sidebar_2_nav_link (sidebar_id, nav_link_id) VALUES (23, 231);
INSERT INTO sidebar_2_nav_link (sidebar_id, nav_link_id) VALUES (23, 232);
INSERT INTO sidebar_2_nav_link (sidebar_id, nav_link_id) VALUES (23, 233);
INSERT INTO sidebar_2_nav_link (sidebar_id, nav_link_id) VALUES (23, 234);

-- Student Sidebar
INSERT INTO sidebar (id, path) VALUES (24, '/academic/student');

-- Student Sidebar Links --
INSERT INTO nav_link (id, name, url, display_priority) VALUES (241, 'Scores', '/academic/student/{studentId}/scores', 1);
INSERT INTO nav_link (id, name, url, display_priority) VALUES (242, 'Achievements', '/academic/student/{studentId}/achievements', 2);
INSERT INTO nav_link (id, name, url, display_priority) VALUES (243, 'Projects', '/academic/student/{studentId}/projects', 3);
INSERT INTO nav_link (id, name, url, display_priority) VALUES (244, 'Discussions', '/academic/student/{studentId}/discussions', 4);

-- Student sidebar_2_nav_link relations --
INSERT INTO sidebar_2_nav_link (sidebar_id, nav_link_id) VALUES (24, 241);
INSERT INTO sidebar_2_nav_link (sidebar_id, nav_link_id) VALUES (24, 242);
INSERT INTO sidebar_2_nav_link (sidebar_id, nav_link_id) VALUES (24, 243);
INSERT INTO sidebar_2_nav_link (sidebar_id, nav_link_id) VALUES (24, 244);

-- Group Sidebar
INSERT INTO sidebar (id, path) VALUES (25, '/academic/group');

-- Group Sidebar Links --
INSERT INTO nav_link (id, name, url, display_priority) VALUES (251, 'Courses', '/academic/group/{groupId}/courses', 1);
INSERT INTO nav_link (id, name, url, display_priority) VALUES (252, 'Students', '/academic/group/{groupId}/students', 2);
INSERT INTO nav_link (id, name, url, display_priority) VALUES (253, 'Staff', '/academic/group/{groupId}/staff', 2);
INSERT INTO nav_link (id, name, url, display_priority) VALUES (254, 'Discussions', '/academic/group/{groupId}/discussions', 3);

-- Group sidebar_2_nav_link relations --
INSERT INTO sidebar_2_nav_link (sidebar_id, nav_link_id) VALUES (25, 251);
INSERT INTO sidebar_2_nav_link (sidebar_id, nav_link_id) VALUES (25, 252);
INSERT INTO sidebar_2_nav_link (sidebar_id, nav_link_id) VALUES (25, 253);
INSERT INTO sidebar_2_nav_link (sidebar_id, nav_link_id) VALUES (25, 254);

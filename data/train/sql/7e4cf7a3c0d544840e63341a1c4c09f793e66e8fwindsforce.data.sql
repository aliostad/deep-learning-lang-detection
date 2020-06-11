-- WINDSFORCE 群組數據庫數據(Zh-tw - 台湾繁体中文)
-- version 1.1.1
-- http://www.windsforce.com
--
-- 開發: Windsforce TEAM
-- 網站: http://www.windsforce.com

--
-- 數據庫: 群組初始化數據
--

-- --------------------------------------------------------

--
-- 轉存表中的數據 `windsforce_app`
--

INSERT INTO `#@__app` (`app_id`, `app_identifier`, `app_name`, `app_version`, `app_description`, `app_url`, `app_email`, `app_author`, `app_authorurl`, `app_isadmin`, `app_isinstall`, `app_isuninstall`, `app_issystem`, `app_isappnav`, `app_status`) VALUES
(3,'group', '小組', '1.0', '群組應用', 'http://doyouhaobaby.net', 'admin@doyouhaobaby.net', 'WindsForce Team', 'http://doyouhaobaby.net', 1, 1, 1, 1, 1, 1);

-- --------------------------------------------------------

--
-- 轉存表中的數據 `windsforce_creditrule`
--

INSERT INTO `#@__creditrule` (`creditrule_id`, `creditrule_name`, `creditrule_action`, `creditrule_cycletype`, `creditrule_cycletime`, `creditrule_rewardnum`, `creditrule_extendcredit1`, `creditrule_extendcredit2`, `creditrule_extendcredit3`, `creditrule_extendcredit4`, `creditrule_extendcredit5`, `creditrule_extendcredit6`, `creditrule_extendcredit7`, `creditrule_extendcredit8`) VALUES
(10, '發布主題', 'group_addtopic', 4, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0),
(11, '發布回帖', 'group_addcomment', 4, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0),
(12, '帖子被設置精華1', 'group_topicdigest1', 4, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0),
(13, '帖子被設置精華2', 'group_topicdigest2', 4, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0),
(14, '帖子被設置精華3', 'group_topicdigest3', 4, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0),
(15, '帖子被設置精華4', 'group_topicdigest4', 4, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0),
(16, '帖子被組長推薦', 'group_trecommend1', 4, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0),
(17, '帖子被系統推薦', 'group_trecommend2', 4, 0, 0, 10, 0, 0, 0, 0, 0, 0, 0),
(18, '帖子被小組置頂1', 'group_topicstick1', 4, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0),
(19, '帖子被小組置頂2', 'group_topicstick2', 4, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0),
(20, '帖子被全局置頂', 'group_topicstick3', 4, 0, 0, 10, 0, 0, 0, 0, 0, 0, 0),
(21, '帖子被回复', 'group_topicreply', 1, 0, 30, 2, 0, 0, 0, 0, 0, 0, 0),
(22, '管理主題', 'group_topicadmin', 4, 0, 0, 10, 0, 0, 0, 0, 0, 0, 0),
(23, '管理回帖', 'group_commentadmin', 4, 0, 0, 10, 0, 0, 0, 0, 0, 0, 0),
(24, '主題被刪除', 'group_topicdelete', 4, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0),
(25, '回帖被刪除', 'group_commentdelete', 4, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0),
(26, '回帖被置頂', 'group_stickreply', 4, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0),
(27, '帖子被提升', 'group_uptopic', 4, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- 轉存表中的數據 `windsforce_cron`
--

INSERT INTO `#@__cron` (`cron_id`, `cron_status`, `cron_type`, `cron_name`, `cron_filename`, `cron_lastrun`, `cron_nextrun`, `cron_weekday`, `cron_day`, `cron_hour`, `cron_minute`) VALUES
(5, 1, 'app', '清空今日發帖數', 'group@Todaytopic_Daily_.php', 1365910913, 1365955200, -1, -1, 0, '0');

-- --------------------------------------------------------

--
-- 轉存表中的數據 `windsforce_groupoption`
--

INSERT INTO `#@__groupoption` (`groupoption_name`, `groupoption_value`) VALUES
('group_isaudit', '0'),
('group_icon_uploadfile_maxsize', '102400'),
('group_indextopicnum', '10'),
('group_listtopicnum', '10'),
('group_hottopic_date', '604800'),
('group_hottopic_num', '10'),
('group_thumbtopic_num', '5'),
('groupshow_newuser_num', '6'),
('group_listusernum', '15'),
('group_grouptopicside', '1'),
('group_grouptopicstyle', '1'),
('grouptopic_listcommentnum', '10'),
('grouptopic_hotnum', '10'),
('grouptopic_newnum', '10'),
('group_homepagestyle', '1'),
('index_recommendgroupnum', '10'),
('index_newgroupnum', '10'),
('index_hotgroupnum', '10'),
('index_groupleadernum', '6'),
('newtopic_hottagnum', '10'),
('group_grouplistnum', '24'),
('grouptopiccomment_edit_limittime', '86400'),
('grouptopic_edit_limittime', '86400'),
('index_groupadminretopic_num', '10'),
('index_systemrecommendtopic_num', '10'),
('group_headbg_uploadfile_maxsize', '409600'),
('group_space_listtopicnum', '20'),
('group_space_listcommentnum', '15'),
('group_homepagestyle_on', '1'),
('group_grouptopicstyle_on', '1'),
('group_grouptopicside_on', '1'),
('group_hottag_num', '10'),
('group_hottag_date', '86400'),
('group_tag_listtopicnum', '15'),
('group_tag_listnum', '50'),
('group_tag_hotnum', '15'),
('group_deletetopic_recyclebin', '1'),
('group_deletecomment_recyclebin', '1'),
('group_thumbtopic_date', '86400'),
('onegroup_thumbtopic_num', '5'),
('group_reason_support', '我很贊同\r\n精品文章\r\n原創內容\r\n眼前一亮\r\n必須得支持'),
('group_reason_opposition', '廣告/SPAM\r\n惡意灌水\r\n違規內容\r\n文不對題\r\n重複發帖\r\n影響組容'),
('group_hottopic1_comments', '30'),
('group_hottopic2_comments', '50'),
('group_hottopic3_comments', '100'),
('group_hottopic1_views', '200'),
('group_hottopic2_views', '500'),
('group_hottopic3_views', '1000'),
('group_indexgroupmaxnum', '6'),
('group_topictodaynum', '0'),
('group_topiccommenttodaynum', '0'),
('group_totaltodaynum', '0'),
('comment_max_len', '20000'),
('comment_spam_content_size', '10000'),
('newtopic_default', '1'),
('allowed_creategroup', '0'),
('grouptopic_lovenum', '10'),
('group_ucenter_listtopicnum', '20');

-- --------------------------------------------------------

--
-- 轉存表中的數據 `windsforce_group`
--

INSERT INTO `#@__group` (`group_id`, `user_id`, `group_name`, `group_nikename`, `group_sort`, `group_description`, `group_listdescription`, `group_path`, `group_icon`, `group_totaltodaynum`, `group_topicnum`, `group_topictodaynum`, `group_usernum`, `group_topiccomment`, `group_topiccommenttodaynum`, `group_joinway`, `group_roleleader`, `group_roleadmin`, `group_roleuser`, `create_dateline`, `group_isrecommend`, `group_isopen`, `group_isaudit`, `group_ispost`, `group_status`, `group_latestcomment`, `update_dateline`, `group_audittopic`, `group_auditcomment`, `group_color`, `group_headerbg`) VALUES
(1, 1, 'default', '默認小組', 0, '這是系統一個默認的小組。', '測試小組，你可以修改', '', NULL, 0, 1, 0, 1, 0, 0, 0, '組長', '管理員', '成員', 1355499162, 1, 1, 1, 0, 1, 'a:5:{s:11:"commenttime";i:1355499282;s:9:"commentid";i:1;s:3:"tid";s:1:"1";s:13:"commentuserid";s:1:"1";s:12:"commenttitle";s:38:"Hello world! 欢迎使用WindsForce！";}', 1355499282, 0, 0, '', '');

-- --------------------------------------------------------

--
-- 轉存表中的數據 `windsforce_groupcategory`
--

INSERT INTO `#@__groupcategory` (`groupcategory_id`, `groupcategory_name`, `groupcategory_parentid`, `groupcategory_count`, `groupcategory_sort`, `update_dateline`, `create_dateline`, `groupcategory_groupmaxnum`, `groupcategory_groupsorttype`, `groupcategory_columns`) VALUES
(1, 'WindsForce', 0, 1, 0, 1355499162, 1355499102, 0, 0 ,0);

-- --------------------------------------------------------

--
-- 轉存表中的數據 `windsforce_groupcategoryindex`
--

INSERT INTO `#@__groupcategoryindex` (`group_id`, `groupcategory_id`) VALUES
(1, 1);

-- --------------------------------------------------------

--
-- 轉存表中的數據 `windsforce_grouptopic`
--

INSERT INTO `#@__grouptopic` (`grouptopic_id`, `grouptopiccategory_id`, `group_id`, `user_id`, `grouptopic_username`, `grouptopic_title`, `grouptopic_content`, `grouptopic_comments`, `grouptopic_views`, `grouptopic_loves`, `grouptopic_sticktopic`, `grouptopic_status`, `grouptopic_isclose`, `grouptopic_color`, `grouptopic_iscomment`, `grouptopic_addtodigest`, `grouptopic_isaudit`, `grouptopic_allownoticeauthor`, `grouptopic_ordertype`, `grouptopic_isanonymous`, `grouptopic_usesign`, `grouptopic_hiddenreplies`, `grouptopic_latestcomment`, `grouptopic_updateusername`, `create_dateline`, `update_dateline`, `grouptopic_thumb`, `grouptopic_isrecommend`, `grouptopic_onlycommentview`, `grouptopic_update`) VALUES
(1, 0, 1, 1, 'admin', 'Hello world! 歡迎使用WindsForce！', '歡迎大家使用我們的產品，祝你愉快！', 1, 1, 0, 0, 1, 0, '', 1, 0, 1, 1, 0, 0, 1, 0, 'a:4:{s:11:"commenttime";i:1355499282;s:9:"commentid";i:1;s:3:"tid";s:1:"1";s:13:"commentuserid";s:1:"1";}', '', 1355499238, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- 轉存表中的數據 `windsforce_grouptopiccomment`
--

INSERT INTO `#@__grouptopiccomment` (`grouptopiccomment_id`, `grouptopic_id`, `user_id`, `grouptopiccomment_status`, `grouptopiccomment_title`, `grouptopiccomment_name`, `grouptopiccomment_content`, `grouptopiccomment_email`, `grouptopiccomment_url`, `grouptopiccomment_ip`, `create_dateline`, `update_dateline`, `grouptopiccomment_parentid`, `grouptopiccomment_ishide`, `grouptopiccomment_auditpass`, `grouptopiccomment_stickreply`) VALUES
(1, 1, 1, 1, '', '', '我希望一切都是一個美好的開始！', 'admin', '', '', 1355499282, 0, 0, 0, 1, 0);

-- --------------------------------------------------------

--
-- 轉存表中的數據 `windsforce_groupuser`
--

INSERT INTO `#@__groupuser` (`user_id`, `group_id`, `groupuser_isadmin`, `create_dateline`) VALUES
(1, 1, 0, 1355499183);

-- --------------------------------------------------------

--
-- 轉存表中的數據 `windsforce_nav`
--

INSERT INTO `#@__nav` (`nav_id`, `nav_parentid`, `nav_name`, `nav_identifier`, `nav_title`, `nav_url`, `nav_target`, `nav_type`, `nav_style`, `nav_location`, `nav_status`, `nav_sort`, `nav_color`, `nav_icon`) VALUES
(10, 0, '小組', 'app_group', 'group', 'group://public/index', 0, 0, 'a:3:{i:0;i:0;i:1;i:0;i:2;i:0;}', 0, 1, 0, 0, '');

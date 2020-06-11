/* 初始化数据 */
insert into cms_model(model_id, channel_template_prefix, content_template_prefix, name, path, has_content, valid_state, delete_flag) 
		values(1, '', '', '栏目和内容默认字段模型', 'path', '0', '0', '1');
insert into cms_model(model_id, channel_template_prefix, content_template_prefix, name, path, has_content, valid_state, delete_flag) 
		values(2, 'index', '', '首页', '/', '0', '1', '0');
insert into cms_model(model_id, channel_template_prefix, content_template_prefix, name, path, has_content, valid_state, delete_flag) 
		values(3, 'channel_news', 'content_news', '新闻', 'news', '1', '1', '0');


/* 栏目模板字段 */
insert into cms_model_item(item_id, model_id, property, sequence, label, data_type, is_display, is_custom, is_channel, is_single, is_must)
		values(1, 1, 'name', 		'1', '栏目名称', 		'varchar', '1', '0', '1', '0', '1');
insert into cms_model_item(item_id, model_id, property, sequence, label, data_type, is_display, is_custom, is_channel, is_single, is_must)
		values(2, 1, 'path', 		'2', '访问路径', 		'varchar', '1', '0', '1', '0', '1');
insert into cms_model_item(item_id, model_id, property, sequence, label, data_type, is_display, is_custom, is_channel, is_single, is_must)
		values(3, 1, 'title', 		'3', 'meta标题', 	'varchar', '1', '0', '1', '0', '0');
insert into cms_model_item(item_id, model_id, property, sequence, label, data_type, is_display, is_custom, is_channel, is_single, is_must)
		values(4, 1, 'keywords', 	'4', 'meta关键字', 	'varchar', '1', '0', '1', '0', '0');
insert into cms_model_item(item_id, model_id, property, sequence, label, data_type, is_display, is_custom, is_channel, is_single, is_must)
		values(5, 1, 'description',	'5', 'meta描述', 	'textarea', '1', '0', '1', '1', '0');
insert into cms_model_item(item_id, model_id, property, sequence, label, data_type, is_display, is_custom, is_channel, is_single, is_must)
		values(6, 1, 'sequence', 	'6', '排列顺序', 		'int', '1', '0', '1', '1', '0');
insert into cms_model_item(item_id, model_id, property, sequence, label, data_type, is_display, is_custom, is_channel, is_single, is_must, code_type)
		values(7, 1, 'isDisplay', 	'7', '是否显示', 		'radio', '1', '0', '1', '1', '0', 'YesOrNo');
insert into cms_model_item(item_id, model_id, property, sequence, label, data_type, is_display, is_custom, is_channel, is_single, is_must)
		values(8, 1, 'finalLevel', 	'8', '终审级别', 		'int', '1', '0', '1', '1', '0');
insert into cms_model_item(item_id, model_id, property, sequence, label, data_type, is_display, is_custom, is_channel, is_single, is_must, code_type)
		values(9, 1, 'afterCheck', 	'9', '审核后', 		'radio', '1', '0', '1', '1', '0', 'ModelItemAfterCheck');
insert into cms_model_item(item_id, model_id, property, sequence, label, data_type, is_display, is_custom, is_channel, is_single, is_must, code_type)
		values(11, 1, 'isStaticChannel','10','是否静态化栏目','radio', '1', '0', '1', '1', '0', 'YesOrNo');
insert into cms_model_item(item_id, model_id, property, sequence, label, data_type, is_display, is_custom, is_channel, is_single, is_must, code_type)
		values(12, 1, 'isStaticContent','11','是否静态化内容','radio', '1', '0', '1', '1', '0', 'YesOrNo');
insert into cms_model_item(item_id, model_id, property, sequence, label, data_type, is_display, is_custom, is_channel, is_single, is_must)
		values(13, 1, 'link', 		'12', '链接', 		'varchar', '1', '0', '1', '1', '0');
insert into cms_model_item(item_id, model_id, property, sequence, label, data_type, is_display, is_custom, is_channel, is_single, is_must)
		values(14, 1, 'channelTemplate','13','栏目模板', 	'userDefined', '1', '0', '1', '1', '0');
insert into cms_model_item(item_id, model_id, property, sequence, label, data_type, is_display, is_custom, is_channel, is_single, is_must)
		values(15, 1, 'channelContentTemplateList','13','内容可选模板集合', 	'userDefined', '1', '0', '1', '1', '0');
insert into cms_model_item(item_id, model_id, property, sequence, label, data_type, is_display, is_custom, is_channel, is_single, is_must, code_type)
		values(16, 1, 'isBlank', 	'14', '是否新标签打开', 	'radio', '1', '0', '1', '1', '0', 'YesOrNo');
insert into cms_model_item(item_id, model_id, property, sequence, label, data_type, is_display, is_custom, is_channel, is_single, is_must)
		values(17, 1, 'channelTxt.txt', 		'15', '内容', 		'content', '1', '0', '1', '1', '0');
insert into cms_model_item(item_id, model_id, property, sequence, label, data_type, is_display, is_custom, is_channel, is_single, is_must)
		values(18, 1, 'channelTxt.txt1', 		'16', '内容1', 		'content', '1', '0', '1', '1', '0');
insert into cms_model_item(item_id, model_id, property, sequence, label, data_type, is_display, is_custom, is_channel, is_single, is_must)
		values(19, 1, 'channelTxt.txt2', 		'17', '内容2', 		'content', '1', '0', '1', '1', '0');
insert into cms_model_item(item_id, model_id, property, sequence, label, data_type, is_display, is_custom, is_channel, is_single, is_must)
		values(20, 1, 'channelTxt.txt3', 		'18', '内容3', 		'content', '1', '0', '1', '1', '0');
insert into cms_model_item(item_id, model_id, property, sequence, label, data_type, is_display, is_custom, is_channel, is_single, is_must)
		values(21, 1, 'identity', 		'0', '唯一标识', 		'varchar', '1', '0', '1', '1', '0');



/* 内容模板字段 */
insert into cms_model_item(item_id, model_id, property, sequence, label, data_type, is_display, is_custom, is_channel, is_single, is_must)
		values(31, 1, 'title', 		'1', 'meta标题', 		'varchar', '1', '0', '0', '1', '1');
insert into cms_model_item(item_id, model_id, property, sequence, label, data_type, is_display, is_custom, is_channel, is_single, is_must)
		values(32, 1, 'keywords', 	'1', 'meta关键字', 		'textarea', '1', '0', '0', '1', '0');
insert into cms_model_item(item_id, model_id, property, sequence, label, data_type, is_display, is_custom, is_channel, is_single, is_must)
		values(33, 1, 'description', '1', 'meta描述', 		'textarea', '1', '0', '0', '1', '0');
insert into cms_model_item(item_id, model_id, property, sequence, label, data_type, is_display, is_custom, is_channel, is_single, is_must)
		values(34, 1, 'shortTitle', '1', '简短标题', 			'varchar', '1', '0', '0', '1', '0');
insert into cms_model_item(item_id, model_id, property, sequence, label, data_type, is_display, is_custom, is_channel, is_single, is_must)
		values(35, 1, 'author', 		'1', '作者', 		'varchar', '1', '0', '0', '1', '0');
insert into cms_model_item(item_id, model_id, property, sequence, label, data_type, is_display, is_custom, is_channel, is_single, is_must)
		values(36, 1, 'origin', 		'1', '来源', 		'varchar', '1', '0', '0', '1', '0');
insert into cms_model_item(item_id, model_id, property, sequence, label, data_type, is_display, is_custom, is_channel, is_single, is_must)
		values(37, 1, 'originUrl', 		'1', '来源url', 		'varchar', '1', '0', '0', '1', '0');
insert into cms_model_item(item_id, model_id, property, sequence, label, data_type, is_display, is_custom, is_channel, is_single, is_must)
		values(38, 1, 'link', 		'1', '链接', 			'varchar', '1', '0', '0', '1', '0');
insert into cms_model_item(item_id, model_id, property, sequence, label, data_type, is_display, is_custom, is_channel, is_single, is_must)
		values(39, 1, 'contentTemplate', '1', '内容模板', 	'varchar', '1', '0', '0', '1', '0');
insert into cms_model_item(item_id, model_id, property, sequence, label, data_type, is_display, is_custom, is_channel, is_single, is_must)
		values(40, 1, 'contentTxt.txt','1', '内容','content', '1', '0', '0', '1', '0');
insert into cms_model_item(item_id, model_id, property, sequence, label, data_type, is_display, is_custom, is_channel, is_single, is_must)
		values(41, 1, 'contentTxt.txt1','1', '内容1','content', '1', '0', '0', '1', '0');
insert into cms_model_item(item_id, model_id, property, sequence, label, data_type, is_display, is_custom, is_channel, is_single, is_must)
		values(42, 1, 'contentTxt.txt2','1', '内容2','content', '1', '0', '0', '1', '0');
insert into cms_model_item(item_id, model_id, property, sequence, label, data_type, is_display, is_custom, is_channel, is_single, is_must)
		values(43, 1, 'contentTxt.txt3','1', '内容3','content', '1', '0', '0', '1', '0');
insert into cms_model_item(item_id, model_id, property, sequence, label, data_type, is_display, is_custom, is_channel, is_single, is_must)
		values(44, 1, 'attachmentList', '1', '附件','userDefined', '1', '0', '0', '1', '0');
insert into cms_model_item(item_id, model_id, property, sequence, label, data_type, is_display, is_custom, is_channel, is_single, is_must)
		values(45, 1, 'pictureList',	'1', '图片集','userDefined', '1', '0', '0', '1', '0');
insert into cms_model_item(item_id, model_id, property, sequence, label, data_type, is_display, is_custom, is_channel, is_single, is_must, date_format)
		values(46, 1, 'releaseDate', 	'1', '发布时间', 		'date', '1', '0', '0', '1', '0', 'yyyy-MM-dd HH:mm:ss');
insert into cms_model_item(item_id, model_id, property, sequence, label, data_type, is_display, is_custom, is_channel, is_single, is_must)
		values(30, 1, 'identity', 		'0', '唯一标识', 		'varchar', '1', '0', '0', '1', '0');


/* 栏目 */
insert into cms_channel(channel_id, name, mark, delete_flag, parent_id, model_id, user_id, site_id) 
		values(1, '跟栏目', '1', '1', 1, 2, 1, 1);
insert into cms_channel(channel_id, name, mark, delete_flag, parent_id, model_id, user_id, site_id) 
		values(2, '首页', '1001', '0', 1, 2, 1, 1);
insert into cms_channel(channel_id, name, mark, delete_flag, parent_id, model_id, user_id, site_id) 
		values(3, '新闻', '1002', '0', 1, 3, 1, 1);
insert into cms_channel(channel_id, name, mark, delete_flag, parent_id, model_id, user_id, site_id)
		values(4, '国内新闻', '1002001', '0', 3, 3, 1, 1);
insert into  cms_channel_txt(channel_id) values(2);
insert into  cms_channel_txt(channel_id) values(3);
insert into  cms_channel_txt(channel_id) values(4);
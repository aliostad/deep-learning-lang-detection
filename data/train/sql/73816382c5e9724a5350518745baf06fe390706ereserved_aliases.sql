-- Insert reserved aliases. These are mandatory to make Kunena to work.

INSERT INTO `#__kunena_aliases`
	(`alias`,				`type`,		`item`,			`state`) VALUES

	('announcement',		'view',		'announcement',		1),
	('category',			'view',		'category',			1),
	('common',				'view',		'common',			1),
	('credits',				'view',		'credits',			1),
	('home',				'view',		'home',				1),
	('misc',				'view',		'misc',				1),
	('search',				'view',		'search',			1),
	('statistics',			'view',		'statistics',		1),
	('topic',				'view',		'topic',			1),
	('topics',				'view',		'topics',			1),
	('user',				'view',		'user',				1),
	('category/create',		'layout',	'category.create',	1),
	('create',				'layout',	'category.create',	0),
	('category/default',	'layout',	'category.default',	1),
	('default',				'layout',	'category.default',	0),
	('category/edit',		'layout',	'category.edit',	1),
	('edit',				'layout',	'category.edit',	0),
	('category/manage',		'layout',	'category.manage',	1),
	('manage',				'layout',	'category.manage',	0),
	('category/moderate',	'layout',	'category.moderate',1),
	('moderate',			'layout',	'category.moderate',0),
	('category/user',		'layout',	'category.user',	1);

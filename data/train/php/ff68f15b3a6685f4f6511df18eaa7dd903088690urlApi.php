<?php
return array(
	'api/auth'										=> 'api/user/auth',
	'api/signup'									=> 'api/user/signUp',
	'api/(user/<userId:\d+>|my)'					=> 'api/user/index',
	'api/users_list'								=> 'api/user/list',
	'api/users/search'								=> 'api/user/search',
	'api/my/edit'									=> 'api/user/edit',

	'api/my/invite'									=> 'api/message/invite',
	'api/(user/<userId:\d+>|my)/message'			=> 'api/message/send',
	'api/my/messages'								=> 'api/message/getInbox',
	'api/my/messages/sent'							=> 'api/message/getSent',

	'api/looks'										=> 'api/look/default',
	'api/(user/<userId:\d+>|my)/looks'				=> 'api/look/getByUser',
	'api/look/<lookId:\d+>'							=> 'api/look/index',
	'api/looks/search'								=> 'api/look/search',
	'api/looks/new'									=> 'api/look/new',
	'api/look/<lookId:\d+>/del'						=> 'api/look/del',
	'api/look/<lookId:\d+>/vote/<value:(-1|0|1)>'	=> 'api/look/vote',
	'api/look/<lookId:\d+>/loves'					=> 'api/look/loves',

	'api/(user/<userId:\d+>|my)/comments'			=> 'api/comment/getByUser',
	'api/look/<lookId:\d+>/comments'				=> 'api/comment/getByLook',
	'api/comment/add'								=> 'api/comment/add',
	'api/comment/<commentId:\d+>/del'				=> 'api/comment/del',
	'api/comment/<commentId:\d+>/restore'			=> 'api/comment/restore',

	'api/(user/<userId:\d+>|my)/follows'			=> 'api/follow/userFollows',
	'api/(user/<userId:\d+>|my)/followers'			=> 'api/follow/userFollowers',
	'api/(user/<userId:\d+>|my)/follow'				=> 'api/follow/add',
	'api/(user/<userId:\d+>|my)/follow/del'			=> 'api/follow/del',

	'api/<type:(user|look|comment)>/<objId:\d+>/complain' => 'api/complain/add',

	'api/<request:.+>'								=> 'api/user/missing',
);
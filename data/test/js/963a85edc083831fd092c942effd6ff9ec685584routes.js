module.exports.routes = {

	'/': {
		controller: 'HomeController',
		action: 'index'
	},

	'get /register': {
		controller: 'UserController',
		action: 'register'
	},

	'post /register': {
		controller: 'UserController',
		action: 'create'
	},

	'get /session/destroy': {
		controller: 'SessionController',
		action: 'destroy',
		skipAssets: true
	},

	'get /search/:query': {
		controller: 'SearchController',
		action: 'get',
		skipAssets: true
	},

	'get /login': {
		controller: 'SessionController',
		action: 'process'
	},

	'post /topic/updateViews': {
		controller: 'TopicController',
		action: 'updateViews',
		skipAssets: true
	},

	'post /post/like': {
		controller: 'PostController',
		action: 'like',
		skipAssets: true
	},

	'post /post/report': {
		controller: 'PostController',
		action: 'report',
		skipAssets: true
	},

	'post /post/save': {
		controller: 'PostController',
		action: 'save',
		skipAssets: true
	},

	'post /topic/morePosts': {
		controller: 'TopicController',
		action: 'morePosts',
		skipAssets: true
	},

	'/topic/create': {
		controller: 'TopicController',
		action: 'create',
		skipAssets: true
	},

	'post /element': {
		controller: 'ElementController',
		action: 'render'
	},

	'get /profile/likeComment': {
		controller: 'ProfileController',
		action: 'likeComment',
		skipAssets: true
	},

	'post /profile/deleteComment': {
		controller: 'ProfileController',
		action: 'deleteComment',
		skipAssets: true
	},

	'get /user/subscribe': {
		controller: 'UserController',
		action: 'subscribe',
		skipAssets: true
	},

	'get /user/follow': {
		controller: 'UserController',
		action: 'follow',
		skipAssets: true
	},

	'get /user/unfollow': {
		controller: 'UserController',
		action: 'unfollow',
		skipAssets: true
	},

	'post /user/save/avatar': {
		controller: 'UserController',
		action: 'saveAvatar',
		skipAssets: true
	},

	'post /user/save/dateFormat': {
		controller: 'UserController',
		action: 'saveDateFormat',
		skipAssets: true
	},

	'post /user/save/dob': {
		controller: 'UserController',
		action: 'saveDOB',
		skipAssets: true
	},

	'post /user/save/name': {
		controller: 'UserController',
		action: 'saveName',
		skipAssets: true
	},

	'post /user/save/location': {
		controller: 'UserController',
		action: 'saveLocation',
		skipAssets: true
	},

	'get /session/create': {
		controller: 'SessionController',
		action: 'create',
		skipAssets: true
	},

	'post /user/create': {
		controller: 'UserController',
		action: 'create',
		skipAssets: true
	},

	'post /post/get': {
		controller: 'PostController',
		action: 'get',
		skipAssets: true
	},

	'get /session/list': {
		controller: 'SessionController',
		action: 'list',
		skipAssets: true
	},

	'post /forum/moreTopics': {
		controller: 'ForumController',
		action: 'moreTopics',
		skipAssets: true
	},

	'post /post/create': {
		controller: 'PostController',
		action: 'create',
		skipAssets: true
	},

	'post /profile/loadPostHistory': {
		controller: 'ProfileController',
		action: 'loadPostHistory',
		skipAssets: true
	},

	'post /profile/newComment': {
		controller: 'ProfileController',
		action: 'newComment',
		skipAssets: true
	},

	'post /profile/loadComments': {
		controller: 'ProfileController',
		action: 'loadComments',
		skipAssets: true
	},

	'post /profile/updateViews': {
		controller: 'ProfileController',
		action: 'updateViews',
		skipAssets: true
	},

	'get /user/settings': {
		controller: 'UserController',
		action: 'settings',
		skipAssets: true
	},

	'get /user/:username': {
		controller: 'ProfileController',
		action: 'view',
		skipAssets: true
	},

	'get /:forum/new-topic': {
		controller: 'TopicController',
		action: 'new',
		skipAssets: true
	},

	'/:forum/:topic': {
		controller: 'TopicController',
		action: 'index',
		skipAssets: true
	},

	'get /:forum': {
		controller: 'ForumController',
		action: 'index',
		skipAssets: true
	}
};
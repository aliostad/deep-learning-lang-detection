const UsersApi = require('./app/api/usersapi');
const TweetApi = require('./app/api/tweetapi');
const Assets = require('./app/controllers/assets');

module.exports = [
  { method: 'GET', path: '/api/users', config: UsersApi.find },
  { method: 'GET', path: '/api/users/{id}', config: UsersApi.findOne },
  { method: 'GET', path: '/api/users/{id}/follow', config: UsersApi.findOneWithFollowed },
  { method: 'POST', path: '/api/users/{id}/follow', config: UsersApi.followUser },
  { method: 'POST', path: '/api/users/{id}/unfollow', config: UsersApi.unfollowUser },
  { method: 'POST', path: '/api/users', config: UsersApi.create },
  { method: 'POST', path: '/api/users/{id}', config: UsersApi.updateUser },
  { method: 'POST', path: '/api/users/{id}/password', config: UsersApi.resetUserPassword },
  { method: 'DELETE', path: '/api/users/{id}', config: UsersApi.deleteOne },
  { method: 'DELETE', path: '/api/users', config: UsersApi.deleteAll },

  { method: 'GET', path: '/api/tweets', config: TweetApi.findAllTweets },
  { method: 'GET', path: '/api/users/{id}/tweets', config: TweetApi.findTweets },
  { method: 'GET', path: '/api/tweets/{id}/followed', config: TweetApi.findFollowedTweets },
  { method: 'POST', path: '/api/tweets', config: TweetApi.makeTweet },
  { method: 'DELETE', path: '/api/users/{id}/tweets', config: TweetApi.deleteUsersTweets },
  { method: 'DELETE', path: '/api/tweets/{id}', config: TweetApi.deleteOneTweet },
  { method: 'DELETE', path: '/api/tweets', config: TweetApi.deleteAllTweets },

  { method: 'POST', path: '/api/users/authenticate', config: UsersApi.authenticate },

  {
    method: 'GET',
    path: '/{param*}',
    config: { auth: false },
    handler: Assets.servePublicDirectory,
  },
];

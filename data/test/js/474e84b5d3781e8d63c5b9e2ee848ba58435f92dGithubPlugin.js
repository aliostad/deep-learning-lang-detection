"use strict";

const GithubService = require('../services/GithubService');
const GithubApiService = require('../services/GithubApiService');
const FileCacheService = require('../services/FileCacheService');

exports.register = function(server, options, next) {

	let apiService = new GithubApiService({
	    'username': 'MichielvdVelde'
	});
	let cacheService = new FileCacheService();
	GithubService.createService(apiService, cacheService);

	return next();

};

exports.register.attributes = {
	'name': 'GithubPlugin'
};

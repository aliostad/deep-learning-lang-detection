"use strict";

const NpmDownloadsService = require('../services/NpmDownloadsService');
const NpmDownloadsApiService = require('../services/NpmDownloadsApiService');
const FileCacheService = require('../services/FileCacheService');

exports.register = function(server, options, next) {

	let apiService = new NpmDownloadsApiService();
	let cacheService = new FileCacheService({
		'cacheExpire': 720000 // 12h
	});
	NpmDownloadsService.createService(apiService, cacheService);

	return next();

};

exports.register.attributes = {
	'name': 'NpmDownloadsPlugin'
};

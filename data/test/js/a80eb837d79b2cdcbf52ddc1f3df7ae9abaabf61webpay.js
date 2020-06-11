'use strict';

var Client = require('./client');

var api_base = 'https://api.webpay.jp';
var api_version = '/v1';
var api_key = null;

var client = null;

var webpay = {
	get client() {
		if (!client) {
			client = new Client(api_key, api_base, api_version);
		}
		return client;
	},

	get api_base() {
		return api_base;
	},

	set api_base(val) {
		api_base = val;
		client = null;
	},

	/**
	 * get current api_version
	 * @return {string} api_version
	 */
	get api_version() {
		return api_version;
	},

	/**
	 * set api_version
	 * @param {string} val
	 */
	set api_version(val) {
		api_version = val;
		client = null;
	},

	/**
	 * get current api_key
	 * @return {string} api_key
	 */
	get api_key() {
		return api_key;
	},

	/**
	 * set api_key
	 * @param {string} val
	 */
	set api_key(val) {
		api_key = val;
		client = null;
	}
};


module.exports = webpay;

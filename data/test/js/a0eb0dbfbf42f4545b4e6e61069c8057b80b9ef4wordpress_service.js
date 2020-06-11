// Modules
var util = require('util');

// Parents
var Service = require('hummingbird-service').Service;

// Local
var Stream   = require('./wordpress_stream.js');
var Post     = require('./wordpress_post.js');


/**
 * Provides interaction with the Wordpress API
 * @constructor
 * @extends Service
 */
var WordpressService = function() {
  Service.call(this, Stream, Post);
}

// Try as you might, javascript just can't hang
util.inherits(WordpressService, Service);



/**
 * Configuration
 */
WordpressService.prototype.configuration = {
  SERVICE_NAME: 'wordpress',
  MAX_KEYWORDS: 0,
  MAX_ACCOUNTS: 0
};




/** EXPORT */
module.exports = WordpressService = new WordpressService();
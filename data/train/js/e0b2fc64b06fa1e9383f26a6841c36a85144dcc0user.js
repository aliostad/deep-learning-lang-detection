/**
 * Author: Gabriel Petrovay <gabipetrovay@gmail.com>
 */

var util = require('util');
var AbstractApi = require("./abstract_api").AbstractApi;

/**
 * API wrapper for http://confluence.atlassian.com/display/BBDEV/Users
 */
var UserApi = exports.UserApi = function(api) {
    this.$api = api;
};

util.inherits(UserApi, AbstractApi);

(function() {

    /**
     * Get user data including the repository list
     */
    this.getUserProfile = function(callback) {
        this.$api.get("user", null, null, callback);
    };

}).call(UserApi.prototype);


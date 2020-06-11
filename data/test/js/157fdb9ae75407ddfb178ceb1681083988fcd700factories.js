(function () {
	'use strict';

	define([
		'angular',
		'passio/core',
		'passio/rest',
		'passio/encryption',
		'passio/config'
	], function (angular) {

		var passioFactories = angular.module('passio.factories', [
			'passio.core',
			'passio.rest',
			'passio.encryption',
			'passio.config'
		]);

		passioFactories.factory('PasswordServiceFactory', [
			'$q',
			'PasswordService',
			'RestService',
			'EncryptionService',
			'config',
			function ($q, PasswordService, RestService, EncryptionService, config) {
				return {
					/**
					 * Creates a new password service using the given username and password.
					 *
					 * @param  {String} username  The username to use.
					 * @param  {String} password  The password to use.
					 *
					 * @return {Promise} A promise which is resolved when the password service is created and
					 *     initialized.
					 */
					create: function (username, password) {
						var deferred, encryptionService, persistenceService, passwordService;

						try {
							encryptionService = new EncryptionService({
								password: password,
								authIterations: config.authIterations
							});
						} catch (e) {
							deferred = $q.defer();
							deferred.reject('Cannot create EncryptionService: ' + e.message);
							return deferred.promise;
						}

						persistenceService = new RestService({
							backendUrl: config.backendUrl,
							encryptionService: encryptionService
						});

						passwordService = new PasswordService({
							username: username,
							encryptionService: encryptionService,
							persistenceService: persistenceService
						});

						return passwordService.init();
					}
				};
			}
		]);

	});
}());

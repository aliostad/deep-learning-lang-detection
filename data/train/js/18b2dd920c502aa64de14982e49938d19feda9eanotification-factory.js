'use strict';

omega.factory('notificationFactory', ['$translate', 'enumFactory', function ($translate, enumFactory) {
	return {
		notificationMessage: function (messageKey, messageType) {
			var responseMessage = '';

			var displayErrorMessage = function (responseMessage) {
				if (messageType === '' || messageType === null || messageType === undefined) {
					toastr.success(responseMessage);
				}
				else {
					switch (messageType) {
						case enumFactory.messageTypeEnums.success:
							toastr.success(responseMessage);
							break;
						case enumFactory.messageTypeEnums.error:
							toastr.error(responseMessage);
							break;
						case enumFactory.messageTypeEnums.warning:
							toastr.warning(responseMessage);
							break;
						case enumFactory.messageTypeEnums.info:
							toastr.info(responseMessage);
							break;
						default:
							toastr.warning('Check message type!');
							break;
					}
				}
			};

			if (messageKey !== '' || messageKey !== null || messageKey !== undefined) {
				$translate(messageKey).then(function (message) {
					responseMessage = message;
					displayErrorMessage(responseMessage);
				}, function () {
					responseMessage = messageKey;
					displayErrorMessage(responseMessage);
				});
			}
		}
	};
}]);


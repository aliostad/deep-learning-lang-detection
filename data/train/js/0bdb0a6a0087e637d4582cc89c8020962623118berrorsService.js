/* Serrvice for handling error  */
webchatApp.factory('errorsService', function errorsService($rootScope, ajaxErrorText, baseUrl) {
    function handleError(error) {
        var message = {};
        message.Type = 'danger';

        if (error.Message.indexOf('You\'ve already joined this chatroom.') > -1) {
            message.Text = 'You\'ve already joined this chatroom.';
            $rootScope.$broadcast('alertMessage', message);
        } else if (error.Message.indexOf('Authorization has been denied') > -1) {
            message.Text = 'You are not authorized to perform this type of request!';
            $rootScope.$broadcast('alertMessage', message);
        } else if (error.Message.indexOf('Chatroom with the same name already exists') > -1) {
            message.Text = error.Message;
            $rootScope.$broadcast('alertMessage', message);
        } else {
            message.Text = ajaxErrorText;
            $rootScope.$broadcast('alertMessage', message);
        }
    };

    function handleLogingError(error) {
        var message = {};
        message.Type = 'danger';

        if (error.error_description) {
            message.Text = error.error_description;
            $rootScope.$broadcast('alertMessage', message);
        } else {
            message.Text = ajaxErrorText;
            $rootScope.$broadcast('alertMessage', message);
        }
    };

    function handleRegisterError(errorMessage) {
        var message = {};
        message.Type = 'danger';

        if (errorMessage['']) {
            message.Text = errorMessage[''][0];
            $rootScope.$broadcast('alertMessage', message);
        } else if (errorMessage['model.ConfirmPassword']) {
            message.Text = errorMessage['model.ConfirmPassword'][0];
            $rootScope.$broadcast('alertMessage', message);
        } else if (errorMessage['model.Password']) {
            message.Text = errorMessage['model.Password'][0];
            $rootScope.$broadcast('alertMessage', message);
        } else {
            message.Text = ajaxErrorText;
            $rootScope.$broadcast('alertMessage', message);
        }
    };

    return {
        handleError: handleError,
        handleLogingError: handleLogingError,
        handleRegisterError: handleRegisterError,
    };
});
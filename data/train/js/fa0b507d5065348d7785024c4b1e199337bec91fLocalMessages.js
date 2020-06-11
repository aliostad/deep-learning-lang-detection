define(['logger','jquery', 'backbone', 'underscore',
        'text!templates/messages/standard.tpl'],
function (Logger, $, Backbone, _, AlertTemplate) {
    return {
        LOG: Logger.get('LocalMessages'),
        addMessage: function(container, type, text) {
            var message = _.template(AlertTemplate, {
                type: type, // success, info, warning, danger
                message: text
            });
            message = $(message);

            container.append(message);
        },
        addSuccessMessage: function(container, message) {
            this.addMessage(container, 'success', message);
        },
        addInfoMessage: function(container, message) {
            this.addMessage(container, 'info', message);
        },
        addWarningMessage: function(container, message) {
            this.addMessage(container, 'warning', message);
        },
        addDangerMessage: function(container, message) {
            this.addMessage(container, 'danger', message);
        },
        clearMessages: function(container) {
            container.find('.alert').remove();
        }
    }
});

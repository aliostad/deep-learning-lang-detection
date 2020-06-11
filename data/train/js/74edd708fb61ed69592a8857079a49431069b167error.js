var _ = require('underscore'),
    Handlebars = require('handlebars');


function AppError(message) {
    this.name = "AppError";
    this.code = 500;
    this.message = 'Default message';


    if (_.isString(message)) {
        this.message = message;
    } else if (_.isObject(message)) {

        if (message.code) {
            this.code = message.code;
        }
        if (message.message) {
            this.message = message.message;
        }

        if( message.placeholders ){
            this.message = Handlebars.compile(this.message)(message.placeholders);
        }

        if (message.data) {
            this.data = message.data;
        }

    }
}


AppError.prototype = new Error();
AppError.prototype.constructor = AppError;

module.exports = AppError;
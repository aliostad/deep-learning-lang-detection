var ApiMessages = {};
ApiMessages.EMAIL_NOT_FOUND = 0;
ApiMessages.INVALID_PWD = 1;
ApiMessages.DB_ERROR = 'Sorry. Some errors on server. Please try again later.';
ApiMessages.NOT_FOUND = 3;
ApiMessages.EMAIL_ALREADY_EXISTS = "User already exist.";
ApiMessages.COULD_NOT_CREATE_USER = "Could not create user.";
ApiMessages.PASSWORD_RESET_EXPIRED = 6;
ApiMessages.PASSWORD_RESET_HASH_MISMATCH = 7;
ApiMessages.PASSWORD_RESET_EMAIL_MISMATCH = 8;
ApiMessages.COULD_NOT_RESET_PASSWORD = 9;

ApiMessages.USER_ADDED = "User was created successful";

module.exports = ApiMessages;
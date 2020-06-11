

const userController = require('./user.server.controller');
const rolesController = require('./role.server.controller');
const termController = require('./term.server.controller');
const studentController = require('./student.server.controller');
const paymentsController = require('./payment.server.controller');
const paymenttypeController = require('./payment-type.server.controller');
const authController = require('./auth.server.controller');
const tokenController = require('./token.server.controller');

module.exports = {
  userController: userController,
  rolesController: rolesController,
  termController: termController,
  studentController: studentController,
  paymentsController: paymentsController,
  paymenttypeController: paymenttypeController,
  authController: authController,
  tokenController: tokenController,
};

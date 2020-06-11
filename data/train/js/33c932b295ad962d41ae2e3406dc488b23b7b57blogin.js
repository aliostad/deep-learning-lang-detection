var express = require('express');
var router = express.Router();

var controller = require('.././controllers');

router.get('/', controller.loginController.mostrarLogin);
router.get('/signup', controller.loginController.mostrarSignup);
router.get('/cerrarSesion', controller.loginController.cerrarSesion);
router.post('/', controller.loginController.validarUsuario);
router.post('/signup', controller.loginController.registrarUsuario);
//router.get('/reportes', controller.reporteController.reporteIngresos);

module.exports = router;

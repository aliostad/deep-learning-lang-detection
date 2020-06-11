var express = require('express');
var multer = require('multer');
var router = express.Router();

var quizController = require('../controllers/quiz_controller');
var commentController = require('../controllers/comment_controller');
var sessionController = require('../controllers/session_controller');
var statisticsController = require('../controllers/statistics_controller');
var userController = require('../controllers/user_controller');
var favouritesController = require('../controllers/favourites_controller');

/* GET home page. */
router.get('/', sessionController.autologout, function(req, res) {
                                                  res.render('index', { title: "Quiz Edav", errors: [] });}
          );

// Autoload de comandos con: quizId
router.param('quizId', quizController.load);   // autoload: quizId
router.param('commentId', commentController.load);  // autoload :commentId
router.param('userId', userController.load); //autoload :userId

// Ruta de página de Autores
router.get('/author', sessionController.autologout, function(req, res) {
                                                      res.render('author', { errors: [] });}
          );

// Definición de rutas de /quizes
router.get('/quizes',                               sessionController.autologout, quizController.index);
router.get('/quizes/:quizId(\\d+)',                 sessionController.autologout, quizController.show);
router.get('/quizes/:quizId(\\d+)/answer',          sessionController.autologout, quizController.answer);
router.get('/quizes/new',                           sessionController.autologout, sessionController.loginRequired, quizController.new);
router.post('/quizes/create',                       sessionController.autologout, sessionController.loginRequired, multer({dest:'./public/media/'}), quizController.create);
router.get('/quizes/:quizId(\\d+)/edit',            sessionController.autologout, sessionController.loginRequired, quizController.ownershipRequired, quizController.edit);
router.put('/quizes/:quizId(\\d+)',                 sessionController.autologout, sessionController.loginRequired, quizController.ownershipRequired, multer({dest:'./public/media/'}), quizController.update);
router.delete('/quizes/:quizId(\\d+)',              sessionController.autologout, sessionController.loginRequired, quizController.ownershipRequired, quizController.destroy);
router.get('/quizes/play',                          sessionController.autologout, sessionController.loginRequired, quizController.play);

//definicion de rutas de comentarios
router.get('/quizes/:quizId(\\d+)/comments/new',    sessionController.autologout, commentController.new);
router.post('/quizes/:quizId(\\d+)/comments',       sessionController.autologout, commentController.create);
router.get('/quizes/:quizId(\\d+)/comments/:commentId(\\d+)/publish', sessionController.autologout, sessionController.loginRequired, quizController.ownershipRequired, commentController.publish);

// Definición de rutas de sesion
router.get('/login',                                sessionController.autologout, sessionController.new);     // formulario login
router.post('/login',                               sessionController.autologout, sessionController.create);  // crear sesión
router.get('/logout',                               sessionController.destroy); // destruir sesión

//definicion de la ruta de estadísticas
router.get('/quizes/statistics',                    sessionController.autologout, statisticsController.load);

//definición de las rutas de administración de cuentas
router.get('/adminusers',                           sessionController.autologout, sessionController.loginRequired, userController.adminRequired, userController.show);
router.get('/adminusers/kill',                      sessionController.autologout, sessionController.loginRequired, userController.adminRequired, userController.kill);
router.get('/adminusers/new',                       sessionController.autologout, sessionController.loginRequired, userController.adminRequired, userController.newFromAdmin);
router.post('/adminusers/new',                      sessionController.autologout, sessionController.loginRequired, userController.adminRequired, userController.createFromAdmin);
router.get('/adminusers/power',                     sessionController.autologout, sessionController.loginRequired, userController.adminRequired, userController.adminPower);

//definición de las rutas de cuentas
router.get('/user',                                 sessionController.autologout, userController.new); //formulario sign up
router.post('/user',                                sessionController.autologout, userController.create); //registrar usuario
router.get('/user/:userId(\\d+)/edit',              sessionController.autologout, sessionController.loginRequired, userController.ownershipRequired, userController.edit);
router.put('/user/:userId(\\d+)',                   sessionController.autologout, sessionController.loginRequired, userController.ownershipRequired, userController.update);
router.delete('/user/:userId(\\d+)',                sessionController.autologout, sessionController.loginRequired, userController.ownershipRequired, userController.destroy);
router.get('/user/:userId(\\d+)/quizes',            sessionController.autologout, quizController.myQuestions); //ver las preguntas de un usuario

//definición de las rutas de los favoritos
router.get('/user/:userId(\\d+)/favourites',                   sessionController.autologout, sessionController.loginRequired, favouritesController.show);
router.put('/user/:userId(\\d+)/favourites/:quizId(\\d+)',     sessionController.autologout, sessionController.loginRequired, favouritesController.fav);
router.delete('/user/:userId(\\d+)/favourites/:quizId(\\d+)',  sessionController.autologout, sessionController.loginRequired, favouritesController.unfav);

module.exports = router;

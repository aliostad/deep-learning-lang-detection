/* eslint-disable */

/**
  * @module Educatify
  */

var configuration = require('./configuration'),
  UserController = require('./Controllers/UserController'),
  DocumentController = require('./Controllers/DocumentController'),
  PersonController = require('./Controllers/PersonController'),
  StudentController = require('./Controllers/StudentController'),
  CourseController = require('./Controllers/CourseController'),
  BatchController = require('./Controllers/BatchController'),
  InstitutionController = require('./Controllers/InstitutionController'),
  NetworkController = require('./Controllers/NetworkController'),
  AuthController = require('./Controllers/AuthController');


function initializer() {

}

// Main functional components of Educatify
initializer.configuration = configuration;
initializer.UserController = UserController;
initializer.DocumentController = DocumentController;
initializer.PersonController = PersonController;
initializer.StudentController = StudentController;
initializer.CourseController = CourseController;
initializer.BatchController = BatchController;
initializer.InstitutionController = InstitutionController;
initializer.NetworkController = NetworkController;
initializer.AuthController = AuthController;

module.exports = initializer;

'use strict';

var datasource = require('./../../datasource').getDataSource();
var Pet = datasource.Pet;
var serenityControllerHelper = require('serenity-controller-helper');
var config = require('config');
var controllerHelper = new serenityControllerHelper(config);

// build controller
var petController = controllerHelper.buildController(Pet, [], {filtering: true});

module.exports = {
  findPets: petController.all,
  addPet: petController.create,
  findPetById: petController.get,
  updatePet: petController.update,
  deletePet: petController.delete
};
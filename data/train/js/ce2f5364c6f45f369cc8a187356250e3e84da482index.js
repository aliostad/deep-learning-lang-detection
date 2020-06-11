var usersController = require('./UsersController');
var countriesController = require('./CountriesController');
var townsController = require('./TownsController');
var pagesController = require('./PagesController');
var tripsController = require('./TripsController');
var messagesController = require('./MessagesController');
var commentsController = require('./CommentsController');
var photosController = require('./PhotosController');

module.exports = {
    users: usersController,
    countries: countriesController,
    towns: townsController,
    pages: pagesController,
    trips: tripsController,
	messages: messagesController,
    comments: commentsController,
    photos: photosController
};
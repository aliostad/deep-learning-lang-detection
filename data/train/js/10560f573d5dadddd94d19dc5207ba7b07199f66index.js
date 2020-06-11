var usersController = require('../controllers/usersController');
var hotelsController = require('../controllers/hotelsController');
var reservationsController = require('../controllers/ReservationsController');
var roomsController = require('../controllers/roomsController');
var statisticsController = require('../controllers/StatisticsController');
var ratingController = require('../controllers/RatingController');


module.exports = {
    users: usersController,
    hotels: hotelsController,
    reservations: reservationsController,
    rooms: roomsController,
    statistics : statisticsController,
    rating : ratingController
};
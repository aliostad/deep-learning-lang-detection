'use strict';

var app = require('angular').module('movieApp');

app.controller('AppController', require('./appController'));
app.controller('BookingController', require('./bookingController'));
app.controller('CancellationController', require('./cancellationController'));
app.controller('HomeController', require('./homeController'));
app.controller('AdminController', require('./adminController'));
app.controller('MoviesController', require('./moviesController'));
app.controller('AssignShowController', require('./assignShowController'));


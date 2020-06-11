'use strict';

var app = require('angular').module('movieApp');


app.controller('HomeController', require('./homeController'));
app.controller('BookingController', require('./bookingController'));
app.controller('AdminController', require('./adminController'));
app.controller('TrailerController', require('./trailerController'));
app.controller('CancelController', require('./cancelController'));
app.controller('PaymentController', require('./paymentController'));
app.controller('RatingController', require('./ratingController'));
app.controller('MainController', require('./main'));
app.controller('LoginController', require('./loginController'));
app.controller('LogoutController', require('./logoutController'));
app.controller('RegisterController', require('./registerController'));

var db = require('../models'),
    _  = require('underscore');

// latitude 40.7150728 longitude -73.9363004

var users = [
  {username: 'walfly',
   password: 'supersecret',
   email: 'walker.d.flynn@gmail.com'},
   {username: 'Moose',
   password: 'supersecret',
   email: 'moose@gmail.com'},
   {username: 'Cow',
   password: 'supersecret',
   email: 'cow@gmail.com'},
   {username: 'Pigeon',
   password: 'supersecret',
   email: 'Pigeon@gmail.com'},
   {username: 'Fox',
   password: 'supersecret',
   email: 'Fox@gmail.com'},
   {username: 'Carrot',
   password: 'supersecret',
   email: 'Carrot@gmail.com'},
   {username: 'Dog',
   password: 'supersecret',
   email: 'Dog@gmail.com'}
];

var myMessages = [{
  latitude: 40.111,
  longitude: -73.9,
  message: "MESSAGE MESSAGE MESSAGE MESSAGE MESSAGE MESSAGE"
  },
  {
  latitude: 40.9,
  longitude: -74.1,
  message: "MESSAGE MESSAGE MESSAGE MESSAGE MESSAGE MESSAGE"
  },
  {
  latitude: 41.111,
  longitude: -73.00001,
  message: "MESSAGE MESSAGE MESSAGE MESSAGE MESSAGE MESSAGE"
  },
  {
    latitude: 40.7150868,
    longitude: -73.9363024,
    message: 'developing here'
  }
];


var dogMessages = [{
  latitude: 46.111,
  longitude: -73.9,
  message: "MESSAGE MESSAGE MESSAGE MESSAGE MESSAGE MESSAGE"
  },
  {
  latitude: 39.9,
  longitude: -74.1,
  message: "MESSAGE MESSAGE MESSAGE MESSAGE MESSAGE MESSAGE"
  },
  {
  latitude: 41.111,
  longitude: -73.00001,
  message: "MESSAGE MESSAGE MESSAGE MESSAGE MESSAGE MESSAGE"
  }
];

var carrotMessages = [{
  latitude: 45,
  longitude: -73.9,
  message: "MESSAGE MESSAGE MESSAGE MESSAGE MESSAGE MESSAGE"
  },
  {
  latitude: 43.9,
  longitude: -74.1,
  message: "MESSAGE MESSAGE MESSAGE MESSAGE MESSAGE MESSAGE"
  },
  {
  latitude: 41.111,
  longitude: -74.00001,
  message: "MESSAGE MESSAGE MESSAGE MESSAGE MESSAGE MESSAGE"
  }
];

var foxMessages = [{
  latitude: 41.111,
  longitude: -73.9,
  message: "MESSAGE MESSAGE MESSAGE MESSAGE MESSAGE MESSAGE"
  },
  {
  latitude: 39.9,
  longitude: -74.1,
  message: "MESSAGE MESSAGE MESSAGE MESSAGE MESSAGE MESSAGE"
  },
  {
  latitude: 43.111,
  longitude: -73.00001,
  message: "MESSAGE MESSAGE MESSAGE MESSAGE MESSAGE MESSAGE"
  }
];

var cowMessages = [{
  latitude: 40,
  longitude: -73.9666,
  message: "MESSAGE MESSAGE MESSAGE MESSAGE MESSAGE MESSAGE"
  },
  {
  latitude: 43,
  longitude: -74.3,
  message: "MESSAGE MESSAGE MESSAGE MESSAGE MESSAGE MESSAGE"
  },
  {
  latitude: 42.111,
  longitude: -73.5000,
  message: "MESSAGE MESSAGE MESSAGE MESSAGE MESSAGE MESSAGE"
  }
];

var mooseMessages = [{
  latitude: 43,
  longitude: -72.9666,
  message: "MESSAGE MESSAGE MESSAGE MESSAGE MESSAGE MESSAGE"
  },
  {
  latitude: 43.5,
  longitude: -74.2222,
  message: "MESSAGE MESSAGE MESSAGE MESSAGE MESSAGE MESSAGE"
  },
  {
  latitude: 42.109,
  longitude: -73.7500,
  message: "MESSAGE MESSAGE MESSAGE MESSAGE MESSAGE MESSAGE"
  }
];

var pigeonMessages = [{
    latitude: 40.7021868,
    longitude: -73.8903426,
    message: '1 lot of pigeons in NYC'
  },
  {
    latitude: 40.7270265,
    longitude: -73.9663034,
    message: '2 lot of pigeons in NYC'
  },
  {
    latitude: 40.6955968,
    longitude: -73.8933124,
    message: '3 lot of pigeons in NYC'
  },
  {
    latitude: 40.7351068,
    longitude: -73.9533020,
    message: '4 lot of pigeons in NYC'
  },
  {
    latitude: 40.7474958,
    longitude: -73.9763044,
    message: '5 lot of pigeons in NYC'
  },
  {
    latitude: 40.6952966,
    longitude: -73.9463023,
    message: '6 lot of pigeons in NYC'
  },
  {
    latitude: 40.7355968,
    longitude: -73.9873018,
    message: '7 lot of pigeons in NYC'
  },
  {
    latitude: 40.7192968,
    longitude: -73.9199010,
    message: '8 lot of pigeons in NYC'
  },
  {
    latitude: 40.7181973,
    longitude: -73.9462010,
    message: '9 lot of pigeons in NYC'
  }
];

var createAndAssociate = function (username, messageArr) {
  db.User.find({where: {username: username}})
    .success(function (user){
      _.each(messageArr, function (message){
        db.Message.create({
          latitude: message.latitude,
          longitude: message.longitude,
          message: message.message,
          username: user.username
        }).success(function(message){
          message.setAuthor(user);
          user.addMessage(message);
        });
      });
    });
};

module.exports = function(){
  createAndAssociate('walfly', myMessages);
  createAndAssociate('Carrot', carrotMessages);
  createAndAssociate('Cow', cowMessages);
  createAndAssociate('Fox', foxMessages);
  createAndAssociate('Moose', mooseMessages);
  createAndAssociate('Dog', dogMessages);
  createAndAssociate('Pigeon', pigeonMessages);
}
'use strict';

var noe = require('nr-of-episodes');
var notification = require('./notifications');
var list = require('./list');

var checked = [];

list(function(e, data) {
  data = data.filter(function(show) {
    return show.stillWatching;
  });

  data.forEach(checkShow);

  setInterval(function(){
    data.forEach(checkShow);
  }, 30000);

  setInterval(function(){
    checked = [];
  }, 60*60*1000);

});

var checkShow = function(show) {
  if (checked.indexOf(show.title) === -1) {
    noe(show.title, function(e, d) {
      if (d && !e && d > show.episodes) {
        notification(show.title);
        checked.push(show.title);
      }
    });
  }
};

'use strict';

module.exports = function(app, callback) {
  app.post('/', function(req, res, next) {
    if (!req.body || !req.body.payload || !isArray(req.body.payload)) {
      callback(new Error('JSON parsing failed'), req, res, next);
    }
    else {
      var shows = req.body.payload;
      var showsFiltered = shows.filter(function(show){
        if (validShowObject(show))
          return (show.drm==true && show.episodeCount>0)
      }); 
      
      var showsFormatted = [];
      showsFiltered.forEach(function(show) {
        var showOutputFormat = { 
          image: (show.image && show.image.showImage) ? show.image.showImage : '',
          slug: (show.slug) ? show.slug : '',
          title: (show.title) ? show.title: ''
        };
        showsFormatted.push(showOutputFormat)
      });

      res.send({ response: showsFormatted });
    }
  });
}

function validShowObject(show) {
  return show.hasOwnProperty('drm') && show.hasOwnProperty('episodeCount');
}

function isArray(obj) {
  return Object.prototype.toString.call(obj) === '[object Array]'; 
}
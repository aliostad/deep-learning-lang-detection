/**
 * Main application routes
 */

'use strict';

var errors = require('./components/errors');

module.exports = function(app) {

  // Insert routes below
  app.use('/api/productionDesigners', require('./api/productionDesigner'));
  app.use('/api/laserdiscs', require('./api/laserdisc'));
  app.use('/api/literature', require('./api/literature'));
  app.use('/api/quotes', require('./api/quote'));
  app.use('/api/releaseDates', require('./api/releaseDate'));
  app.use('/api/productioncompanies', require('./api/productionCompany'));
  app.use('/api/plots', require('./api/plot'));
  app.use('/api/movieLinks', require('./api/movieLink'));
  app.use('/api/miscellaneous', require('./api/miscellaneous'));
  app.use('/api/soundMixes', require('./api/soundMix'));
  app.use('/api/soundtracks', require('./api/soundtrack'));
  app.use('/api/specialEffectsCompanies', require('./api/specialEffectsCompany'));
  app.use('/api/trivia', require('./api/trivia'));
  app.use('/api/taglines', require('./api/tagline'));
  app.use('/api/italianAkaTitles', require('./api/italianAkaTitle'));
  app.use('/api/isoAkaTitles', require('./api/isoAkaTitle'));
  app.use('/api/germanAkaTitles', require('./api/germanAkaTitle'));
  app.use('/api/goofs', require('./api/goof'));
  app.use('/api/editors', require('./api/editor'));
  app.use('/api/distributors', require('./api/distributor'));
  app.use('/api/crazyCredits', require('./api/crazyCredit'));
  app.use('/api/costumeDesigners', require('./api/costumeDesigner'));
  app.use('/api/composers', require('./api/composer'));
  app.use('/api/completeCrew', require('./api/completeCrew'));
  app.use('/api/completeCast', require('./api/completeCast'));
  app.use('/api/cinematographers', require('./api/cinematographer'));
  app.use('/api/certificates', require('./api/certificate'));
  app.use('/api/alternateVersions', require('./api/alternateVersion'));
  app.use('/api/akaNames', require('./api/akaName'));
  app.use('/api/akaTitles', require('./api/akaTitle'));
  app.use('/api/writers', require('./api/writer'));
  app.use('/api/locations', require('./api/location'));
  app.use('/api/runningTimes', require('./api/runningTime'));
  app.use('/api/technicals', require('./api/technical'));
  app.use('/api/languages', require('./api/language'));
  app.use('/api/colors', require('./api/color'));
  app.use('/api/genres', require('./api/genre'));
  app.use('/api/countries', require('./api/country'));
  app.use('/api/businesses', require('./api/business'));
  app.use('/api/keywords', require('./api/keyword'));
  app.use('/api/producers', require('./api/producer'));
  app.use('/api/ratings', require('./api/rating'));
  app.use('/api/directors', require('./api/director'));
  app.use('/api/actors', require('./api/actor'));
  app.use('/api/actresses', require('./api/actress'));
  app.use('/api/mpaaRatingsReasons', require('./api/mpaaRatingsReason'));
  app.use('/api/movies', require('./api/movie'));
  app.use('/api/things', require('./api/thing'));
  app.use('/api/users', require('./api/user'));

  app.use('/auth', require('./auth'));
  
  // All undefined asset or api routes should return a 404
  app.route('/:url(api|auth|components|app|bower_components|assets)/*')
   .get(errors[404]);

  // All other routes should redirect to the index.html
  app.route('/*')
    .get(function(req, res) {
      res.sendfile(app.get('appPath') + '/index.html');
    });
};

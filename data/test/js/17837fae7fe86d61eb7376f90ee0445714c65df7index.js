'use strict';

/**
 * @module heremaps.map
 * @name HeremapsMap
 * @description Map module - wrapper for H.map
 */

var
  angular = require('angular'),
  map = angular
    .module('heremapsMap', [])
    .directive('locationLabel', require('./directives/locationLabelDirective'))
    .controller('LocationLabelController', require('./controllers/locationLabelController'))
    .service('PlatformService', require('./services/platformService'))
    .service('MapEventsService', require('./services/mapEventsService'))
    .service('MarkersService', require('./services/markersService'))
    .service('GeocodingService', require('./services/geocodingService'))
    .service('MapService', require('./services/mapService'));

module.exports = map;

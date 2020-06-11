/*jslint node: true, vars: true, white: true */
"use strict";

//Load settings
var apiSettings = require('./api-settings');

var apiGroup = require('./api-group');

var apiMasks = require('./api-masks');

var apiUtilities = require('./api-utilities');

//Load route files
var agtApiRoutes = require('./api-routes/agt-api');
var certApiRoutes = require('./api-routes/cert-api');
var chrApiRoutes = require('./api-routes/chr-api');
var crpApiRoutes = require('./api-routes/crp-api');
var dgmApiRoutes = require('./api-routes/dgm-api');
var eveApiRoutes = require('./api-routes/eve-api');
var invApiRoutes = require('./api-routes/inv-api');
var mapApiRoutes = require('./api-routes/map-api');

module.exports = function(db, app) {

	var APIGroup = apiGroup(db, app, apiMasks);

	var agtApiGroup = new APIGroup(apiSettings.apiPrefix, apiSettings.agtApiPrefix);
	var certApiGroup = new APIGroup(apiSettings.apiPrefix, apiSettings.certApiPrefix);
	var chrApiGroup = new APIGroup(apiSettings.apiPrefix, apiSettings.chrApiPrefix);
	var crpApiGroup = new APIGroup(apiSettings.apiPrefix, apiSettings.crpApiPrefix);
	var dgmApiGroup = new APIGroup(apiSettings.apiPrefix, apiSettings.dgmApiPrefix);
	var eveApiGroup = new APIGroup(apiSettings.apiPrefix, apiSettings.eveApiPrefix);
	var invApiGroup = new APIGroup(apiSettings.apiPrefix, apiSettings.invApiPrefix);
	var mapApiGroup = new APIGroup(apiSettings.apiPrefix, apiSettings.mapApiPrefix);

	//Link route files to an API group
	agtApiRoutes(agtApiGroup);
	certApiRoutes(certApiGroup);
	chrApiRoutes(chrApiGroup);
	crpApiRoutes(crpApiGroup);
	dgmApiRoutes(dgmApiGroup);
	eveApiRoutes(eveApiGroup);
	invApiRoutes(invApiGroup, apiUtilities);
	mapApiRoutes(mapApiGroup);
};

'use strict';

const
  express = require('express'),
  app = express(),
  prezisRoutes = require('./prezis.routes'),
  PrezisService = require('./prezis.service'),
  JsonDataService = require('./json-data.service');

module.exports = app;

const PREZIS_FILE = 'data/prezis.json';

const dataService = Object.create(JsonDataService);
dataService.init(PREZIS_FILE);

const prezisService = Object.create(PrezisService);
prezisService.init(dataService);

app.locals.prezisService = prezisService;

app.use(prezisRoutes);

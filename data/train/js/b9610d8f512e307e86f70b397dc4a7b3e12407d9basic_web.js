var framework           = require('./../../framework');

var InternalConnector   = require('./../../lib/connectors/internal');

var HttpService         = require('./services/http');
var RandomService       = require('./services/random');


var container = framework.createContainer();

var internalConnector = new InternalConnector();
container.registerConnector(internalConnector);

var httpService = new HttpService();
var randomService = new RandomService();
container.registerService(httpService);
container.registerService(randomService);

container.start();
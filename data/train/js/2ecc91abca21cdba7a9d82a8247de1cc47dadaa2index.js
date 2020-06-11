import ReferenceDataService from './referenceDataService.js';
import ExecutionService from './executionService.js';
import LimitCheckerService from './limitCheckerService.js';
import PriceService from './priceService.js';
import BlotterService from './blotterService.js';

// TODO Some way to switch from simulators to SignalR
import simulators from './serviceClients/simulators/index.js';

let referenceDataService = new ReferenceDataService(simulators.referenceDataServiceClient);
let limitCheckerService = new LimitCheckerService();
let executionService = new ExecutionService(simulators.executionServiceClient, limitCheckerService);
let priceService = new PriceService(simulators.pricingServiceClient);
let blotterService = new BlotterService(simulators.blotterServiceClient);

export default { referenceDataService, priceService, executionService, blotterService };

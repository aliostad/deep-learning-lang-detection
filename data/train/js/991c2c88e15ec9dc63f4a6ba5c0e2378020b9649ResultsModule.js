import ResultsController from './ResultsController';
import ResultsTableController from './resultsTable/ResultsTableController';
import ScheduleDetailsModalController from './schedule/scheduleDetailsModal/ScheduleDetailsModalController';
import ScheduleController from './schedule/ScheduleController';
import ResultsService from './ResultsService';
import ResultsRoutes from './ResultsRoutes';

var resultsModule = angular.module('results', [])
    .controller('ResultsController', ResultsController)
    .controller('ResultsTableController', ResultsTableController)
    .controller('ScheduleController', ScheduleController)
    .controller('ScheduleDetailsModalController', ScheduleDetailsModalController)
    .service('ResultsService', ResultsService)
    .config(ResultsRoutes);

export default resultsModule;
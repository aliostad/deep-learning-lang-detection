import NewsRoute from './NewsRoute';
import NewsAddController from './controllers/AddController';
import NewsViewController from './controllers/ViewController';
import NewsListController from './controllers/ListController';

export default angular.module('zc.security.news', ['ui.grid', 'ui.grid.selection', 'ui.grid.pagination', 'ui.grid.resizeColumns', 'ui.grid.pinning', 'ui.grid.moveColumns'])
    .config(NewsRoute)
    .controller('NewsAddController', NewsAddController)
    .controller('NewsListController', NewsListController)
    .controller('NewsViewController', NewsViewController)
    ;
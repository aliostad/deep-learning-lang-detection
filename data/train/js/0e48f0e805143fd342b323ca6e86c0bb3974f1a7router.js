var calendarController = require('../controllers/calendar_controller');
var inboxController    = require('../controllers/inbox_controller');
var itemsController    = require('../controllers/items_controller');
var pagesController    = require('../controllers/pages_controller');

module.exports = function(app) {
  app.route('/').get(itemsController.index);

  app.route('/about').get(pagesController.about);
  app.route('/calendar').get(calendarController.index);
  app.route('/inbox').get(inboxController.index);
};

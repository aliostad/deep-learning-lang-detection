var UsersController = require('./users-controller'),
  ZenController = require('./zen-controller'),
  AdminController = require('./admin-controller'),
  AboutController = require('./about-controller'),
  ContactsController = require('./contacts-controller'),
  EventsController = require('./events-controller'),
    BooksController = require('./books-controller');

module.exports = {
  users: UsersController,
  jsexecutor: ZenController,
  admin: AdminController,
  about: AboutController,
  contacts: ContactsController,
  events: EventsController,
  books: BooksController
};

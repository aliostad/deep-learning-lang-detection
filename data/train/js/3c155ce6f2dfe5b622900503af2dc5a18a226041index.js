angular.module('app.contacts', ['ui.router', 'ngAnimate'])

// Config
.config(require('./contacts-routes.js'))

// Controllers
.controller('ContactsCreateController', require('./create/contacts-create-controller.js'))
.controller('ContactsListController', require('./list/contacts-list-controller.js'))
.controller('ContactsInfoController', require('./info/contacts-info-controller.js'))
.controller('ContactsEditController', require('./edit/contacts-edit-controller.js'))

// Services
.service('ContactsRepository', require('./contacts-repository-service.js'))
Router.route('/', {
  controller: 'ApplicationController',
  action: 'index'
});

Router.route('/projects', {
  controller: 'ProjectController',
  action: 'index'
});

Router.route('/clients', {
  controller: 'ClientController',
  action: 'index'
});

Router.route('/project/new', {
  controller: 'ProjectController',
  action: 'new'
});

Router.route('/tasks', {
  controller: 'TaskController',
  action: 'index'
});

Router.route('/task/new', {
  controller: 'TaskController',
  action: 'new'
});

Router.route('/trackers', {
  controller: 'TrackerController',
  action: 'index'
});

Router.route('/tracker/new', {
  controller: 'TrackerController',
  action: 'new'
});

Router.route('/tasklogs', {
  controller: 'TaskController',
  action: 'logs'
});
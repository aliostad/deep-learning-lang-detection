Package.describe({
  summary: 'Controller class for dynamic layouts.',
  version: '1.0.7',
  git: 'https://github.com/eventedmind/iron-controller.git',
  name: 'iron:controller'
});

Package.on_use(function (api) {
  api.versionsFrom('METEOR@0.9.2');

  api.use('underscore');

  // reactivity
  api.use('tracker');

  // reactive state variables
  api.use('reactive-dict');

  api.use('templating');

  api.use('iron:core@1.0.7');
  api.imply('iron:core');

  api.use('iron:layout@1.0.7');
  api.use('iron:dynamic-template@1.0.7');

  api.add_files('lib/wait_list.js', 'client');
  api.add_files('lib/controller.js');
  api.add_files('lib/controller_server.js', 'server');
  api.add_files('lib/controller_client.js', 'client');
});

Package.on_test(function (api) {
  api.use('iron:controller');
  api.use('iron:layout');
  api.use('tinytest');
  api.use('test-helpers');
  api.use('tracker');
  api.use('templating');

  api.add_files('test/controller_test.html', 'client');
  api.add_files('test/wait_list_test.js', 'client');
  api.add_files('test/controller_test.js', 'client');
});

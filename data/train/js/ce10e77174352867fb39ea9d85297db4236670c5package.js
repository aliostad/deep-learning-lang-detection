Package.describe({
  summary: "Debabel Library"
});

Package.on_use(function (api, where) {
  api.use('coffeescript', 'server');

  api.add_files('lib/model.coffee', ['client', 'server']);
  api.add_files('lib/patterns.coffee', ['client', 'server']);
  api.add_files('lib/transforms.coffee', ['client', 'server']);
});


Package.on_test(function (api) {
  //api.use('router', 'client');
  //api.use('test-helpers', 'client');
  //api.use('tinytest', 'client');

  //api.add_files('router_tests.js', 'client');
});

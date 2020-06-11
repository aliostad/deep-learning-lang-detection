Package.describe({
  summary: 'Dynamic templates and data contexts.',
  version: "0.2.1",
  git: "https://github.com/eventedmind/iron-dynamic-template"
});

Package.on_use(function (api) {
  api.use('blaze');
  api.use('underscore');
  api.use('ui');
  api.use('spacebars');
  api.use('jquery')
  api.use('deps');
  api.use('templating');

  api.use('iron-core');
  api.imply('iron-core');

  api.add_files('dynamic_template.js', 'client');
});

Package.on_test(function (api) {
  api.use('iron-dynamic-template');
  api.use('templating');
  api.use('tinytest');
  api.use('test-helpers');
  api.use('ui');
  api.use('deps');

  api.add_files('dynamic_template_test.html', 'client');
  api.add_files('dynamic_template_test.js', 'client');
});

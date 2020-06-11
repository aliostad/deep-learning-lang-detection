Package.describe({
  summary: "A smart package of common trix I use in Meteor apps"
});

Package.on_use(function (api) {
  api.use('environment-hooks', ['client', 'server']);
  api.use('dev-trix', ['client', 'server']);
  api.use('code-demo', ['client', 'server']);
  api.use('simple-secure', 'server');
  api.use('backbone', 'client');
  api.use('bootstrap', 'client');
  api.use('tabs', 'client');
  api.use('jquery', 'client');
  api.use('deploy-config', 'server');
  api.use('fork-me', 'client');

  api.add_files('styles.css', 'client');
  api.add_files('common.js', ['client', 'server']);
});

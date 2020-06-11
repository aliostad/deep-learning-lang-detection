Package.describe({
  summary: "Runkeeper API",
  internal: false
});

Package.on_use(function(api) {
  api.use('oauth2', ['client', 'server']);
  api.use('oauth', ['client', 'server']);
  api.use('http', ['server']);
  api.use('underscore', 'client');
  api.use('templating', 'client');
  api.use('random', 'client');
  api.use('service-configuration', ['client', 'server']);

  api.export('Runkeeper');

  api.add_files(
    ['runkeeper_configure.html', 'runkeeper_configure.js'],
    'client');

  api.add_files('runkeeper_server.js', 'server');
  api.add_files('runkeeper_client.js', 'client');
});
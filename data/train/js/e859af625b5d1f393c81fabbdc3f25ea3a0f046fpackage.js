Package.describe({
  summary: "Provides a Product API. For use with Meteor Belt applications"
});

Package.on_use(function (api, where) {
  api.use('belt-collection');
  api.use('belt-collection-plugins');
  api.use('deps', 'client');
  api.use('session', 'client');

  api.add_files('product_common.js', ['client', 'server']);
  api.add_files('product_client.js', 'client');
  api.add_files('product_server.js', 'server');

  api.export('Products');
});

Package.on_test(function (api) {
  api.use('belt-product');
  api.use('tinytest');

  api.add_files('product_tests.js', 'server');
});

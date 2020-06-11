Package.describe({
  name: 'app-index',
});

Npm.depends({
  "react": "0.14.6",
  "react-mounter": "1.0.0",
});

Package.onUse(function(api) {
  api.versionsFrom('1.3-modules-beta.4');
  api.use('meteor-base');
  api.use('mobile-experience');
  api.use('mongo');
  api.use('blaze-html-templates');
  api.use('session');
  api.use('jquery');
  api.use('tracker');
  api.use('standard-minifiers');
  api.use('es5-shim');
  api.use('ecmascript');
  api.use('kadira:flow-router');

  api.use('app-test');

  api.addFiles('client/routes.jsx', 'client');
});

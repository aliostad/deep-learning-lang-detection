Package.describe({
  name: "robertlowe:autoform-pickadate",
  version: "0.1.3",
  summary: "pickadate.js for autoform",
  git: "https://github.com/robertlowe/autoform-pickadate"
});

Package.onUse(function (api, where) {
  api.versionsFrom('1.0.3.1');

  api.use('templating');
  api.use('underscore');
  api.use('jquery');
  api.use('tracker');
  api.use('coffeescript');
  api.use('mquandalle:jade@0.4.1');
  api.use('aldeed:autoform@4.2.2 || 5.0.0');
  api.use('robertlowe:pickadate@3.5.5');
  api.use('aldeed:template-extension@3.4.1');

  api.addFiles('autoform-pickadate.jade', 'client');
  api.addFiles('autoform-pickadate.coffee', 'client');
});

Package.onTest(function (api) {
});
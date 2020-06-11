define([
  'underscore',
  'backbone.marionette',
  'dashboard/controllers/DashboardController',
  'containers/controllers/ContainersController',
  'containers/controllers/ContainerController',
  'images/controllers/ImagesController',
  'images/controllers/ImageController'
], function(
  _,
  Marionette,
  DashboardController,
  ContainersController,
  ContainerController,
  ImagesController,
  ImageController
) {
  'use strict';
  return Marionette.Controller.extend(_.extend(
    {},
    DashboardController,
    ContainersController,
    ContainerController,
    ImagesController,
    ImageController
  ));
});

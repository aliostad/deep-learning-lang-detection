define([
  'angular',
  'controllers/AchievementsController',
  'controllers/BuildCityController',
  'controllers/CityController',
  'controllers/GameController',
  'controllers/SettingsController',
  'controllers/UpgradesController',
], function () {
  angular.module('EB.Controllers', [
    'EB.Controllers.AchievementsController',
    'EB.Controllers.BuildCityController',
    'EB.Controllers.CityController',
    'EB.Controllers.GameController',
    'EB.Controllers.SettingsController',
    'EB.Controllers.UpgradesController',
    ]);
});

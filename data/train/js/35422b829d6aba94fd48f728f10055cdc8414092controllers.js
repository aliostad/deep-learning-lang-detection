define([
  'controllers/FavoritesController',
  'controllers/AboutController',
  'controllers/ReposController',
  'controllers/ReposIndexController',
  'controllers/SearchController',
  'controllers/RepoController',
  'controllers/BuildController',
  'controllers/BuildsController',
  'controllers/JobController'
], function (FavoritesController, AboutController, ReposController, ReposIndexController, SearchController, RepoController, BuildController, BuildsController, JobController) {
  return {
    FavoritesController  : FavoritesController,
    AboutController      : AboutController,
    ReposController      : ReposController,
    ReposIndexController : ReposIndexController,
    SearchController     : SearchController,
    RepoController       : RepoController,
    BuildController      : BuildController,
    BuildsController     : BuildsController,
    JobController        : JobController
  };
});
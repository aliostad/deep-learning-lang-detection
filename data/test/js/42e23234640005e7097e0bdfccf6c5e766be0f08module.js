/**
 * Created by Zack on 4/18/2015.
 */
(function() {
  'use strict';

  define([
    'angular',
    'relatify.app.playlist/playlist',
    'relatify.app.services/possiblesongsservice',
    'relatify.app.services/previewsongservice',
    'relatify.app.services/relatedartistsservice',
    'relatify.app.services/spotifyuserservice',
    'relatify.app.services/spotifyplaylistservice'
  ], function (
    angular,
    PlaylistController,
    PossibleSongsService,
    PreviewSongService,
    RelatedArtistsService,
    SpotifyUserService,
    SpotifyPlaylistService
  ) {

    return angular.module('relatifyApp.controllers.PlaylistCtrl', ['spotify'])
      .controller('PlaylistCtrl', PlaylistController)
      .service('PossibleSongsService', PossibleSongsService)
      .service('PreviewSongService', PreviewSongService)
      .service('RelatedArtistsService', RelatedArtistsService)
      .service('SpotifyUserService', SpotifyUserService)
      .service('SpotifyPlaylistService', SpotifyPlaylistService);
  });
})();

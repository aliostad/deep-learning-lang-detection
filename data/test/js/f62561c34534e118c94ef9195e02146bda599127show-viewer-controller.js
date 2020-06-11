(function (angular) {
	'use strict';

	angular.module('battlesnake.show-viewer')
		.controller('showViewerController', showViewerController);

	function showViewerController($scope, languageService, showViewerLocale) {
		var scope = $scope;

		scope.strings = languageService(showViewerLocale);

		scope.view = {
			showPlaylist: false
		};

		scope.selectSource = selectSource;

		this.init = initController;

		return;

		function initController() {
			scope.$watch('show', showChanged);
		}

		function showChanged() {
			var show = scope.show;
			if (show && show.media.sources && show.media.sources.length) {
				selectSource(show.media.sources[0], null);
			} else {
				scope.activeSource = null;
			}
		}

		function selectSource(source, title) {
			scope.activeSource = source;
			scope.activeSourceTitle = title;
		}
	}

})(window.angular);

(function() {
    'use strict';

    var app = angular.module('taptap');

    app.factory('outputService', ['playService', 'metService', 'staffService', 'feedbackService',
        function(playService, metService, staffService, feedbackService) {
        var outputService = {
            outputBeat: _outputBeat,
            toStaff: _toStaff,
            start: _start,
            end: _end,
            feedback: {
                leftButton: false,
                rightButton: false,
                length: 0
            }
        };

        function _outputBeat(beat) {
            if (typeof beat !== 'undefined') {
                feedbackService.showFeedback(beat);
                playService.playBeat(beat);
                metService.currentBeat = beat;
                metService.startPlayer();
            }
        }

        function _toStaff(lines) {
            if (Array.isArray(lines)) {
                metService.startComputer(lines);
            } else {
                console.log('Not Array.');
            }
        }

        function _start() {
            staffService.clear();
        }

        function _end() {
            staffService.end();
        }

        return outputService;
    }]);
})();

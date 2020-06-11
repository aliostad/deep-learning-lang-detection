(function() {
    'use strict';
    angular.module('triggerWarningsApp.tvdb')
        .factory('tvdb', [
            'Restangular',
            function(Restangular) {
                var o = {
                    showList: [],
                    show: {},
                    episode: {}
                };

                var andSetEpisode;

                o.findShow = function(name) {
                    return Restangular.all('tvdb')
                        .all('shows').getList({
                            name: name
                        }).then(function(data) {
                            o.showList = data;
                        });
                };

                o.getShow = function(id) {
                    if (o.show.tvShow === undefined || o.show.tvShow.id !== id) {
                        return Restangular.all('tvdb')
                            .one('shows', id).get()
                            .then(function(data) {
                                o.show = data;
                                if (andSetEpisode !== undefined) {
                                    return o.setEpisode(andSetEpisode);
                                }
                            });
                    } else {
                        return true;
                    }
                };

                o.setEpisode = function(id) {
                    if (o.show.tvShow === undefined) {
                        andSetEpisode = id;
                        return true;
                    }

                    var i = 0;
                    while (o.show.episodes[i].id !== id) {
                        i++;
                    }

                    o.episode = o.show.episodes[i];
                    return true;
                };

                return o;
            }
        ]);

    return angular;
})();

angular.module('lub-tmdb-api', ['lub-tmdb-api-movie',
    'lub-tmdb-api-search',
    'lub-tmdb-api-configuration',
    'lub-tmdb-api-collection',
    'lub-tmdb-api-people',
    'lub-tmdb-api-list',
    'lub-tmdb-api-change',
    'lub-tmdb-api-keyword',
    'lub-tmdb-api-genre',
    'lub-tmdb-api-company',
    'lub-tmdb-api-tv'])
    .factory('lubTmdbApi', [
    "lubTmdbApiSearch",
    "lubTmdbApiConfiguration",
    "lubTmdbApiMovie",
    "lubTmdbApiCollection",
    "lubTmdbApiPeople",
    "lubTmdbApiList",
    "lubTmdbApiCompany",
    "lubTmdbApiGenre",
    "lubTmdbApiKeyword",
    "lubTmdbApiChange",
    "lubTmdbApiTv",
    function (lubTmdbApiSearch, lubTmdbApiConfiguration, lubTmdbApiMovie, lubTmdbApiCollection, lubTmdbApiPeople, lubTmdbApiList, lubTmdbApiCompany, lubTmdbApiGenre, lubTmdbApiKeyword, lubTmdbApiChange) {
        return {
            search:lubTmdbApiSearch,
            configuration:lubTmdbApiConfiguration,
            movie:lubTmdbApiMovie,
            collection:lubTmdbApiCollection,
            people:lubTmdbApiPeople,
            list:lubTmdbApiList,
            company:lubTmdbApiCompany,
            genre:lubTmdbApiGenre,
            keyword:lubTmdbApiKeyword,
            change:lubTmdbApiChange
        };
    }]);
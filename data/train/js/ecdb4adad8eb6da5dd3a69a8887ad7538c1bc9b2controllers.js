'use strict';

define(function (require) {
    require('angular');
    var module = angular.module('beerApp.controllers', ['beerApp.services']);

    module.controller('BreweryMapController', require('controller/brewery_map'));
    module.controller('BreweryListController', require('controller/brewery_list'));
    module.controller('BrewerySelectedController', require('controller/brewery_details'));
    module.controller('BreweryBeersController', require('controller/brewery_beers'));
    module.controller('AnswersController', require('controller/answers'));
    module.controller('QuestionController', require('controller/question'));
    module.controller('TweetController', require('controller/tweets'));
    module.controller('UserModelBuilderController', require('controller/usermodeling_builder'));
    module.controller('UserModelResultController', require('controller/usermodeling_result'));
});

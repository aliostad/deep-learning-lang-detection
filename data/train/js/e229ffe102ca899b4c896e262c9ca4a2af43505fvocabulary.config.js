;(function(){
  'use strict';
	angular.module('languagelearningApp')
    .config(function($routeProvider){
	$routeProvider				
	.when('/home', {
		templateUrl : 'views/home.html',
		controller : 'HomeController',
		controllerAs: 'home',
		private: true

	})
	.when('/vocabulary', {
		templateUrl : 'views/vocabulary.html',
		controller : 'VocabularyController',
		controllerAs: 'vocal',
		private: true
	})
	.when('/vocabulary/Days&Months', {
		templateUrl : 'views/DaysMonths.html',
		controller : 'VocabularyController',
		controllerAs: 'vocal',
		private: true
	})
	.when('/vocabulary/animals', {
		templateUrl : 'views/animals.html',
		controller : 'VocabularyController',
		controllerAs: 'vocal',
		private: true
	})
	.when('/vocabulary/colors', {
		templateUrl : 'views/colors.html',
		controller : 'VocabularyController',
		controllerAs: 'vocal',
		private: true
	})
	.when('/vocabulary/fruits', {
		templateUrl : 'views/fruits.html',
		controller : 'VocabularyController',
		controllerAs: 'vocal',
		private: true
	})
	.when('/vocabulary/bodyface', {
		templateUrl : 'views/bodyface.html',
		controller : 'VocabularyController',
		controllerAs: 'vocal',
		private: true
	})
	.when('/vocabulary/VocabularyAnimals', {
		templateUrl : 'views/VocabularyAnimals.html',
		controller : 'VocabularyController',
		controllerAs: 'vocal',
		private: true
	})
	.when('/vocabulary/vocabularydaysmonth', {
		templateUrl : 'views/vocabularydaysmonth.html',
		controller : 'VocabularyController',
		controllerAs: 'vocal',
		private: true
	})
	.when('/vocabulary/vocabularybodyface', {
		templateUrl : 'views/vocabularybodyface.html',
		controller : 'VocabularyController',
		controllerAs: 'vocal',
		private: true
	})
	.when('/vocabulary/vocabularyfruits', {
		templateUrl : 'views/vocabularyfruits.html',
		controller : 'VocabularyController',
		controllerAs: 'vocal',
		private: true
	})
    .when('/greetings', {
        templateUrl : 'views/greetings.html',
        controller : 'GreetingsController',
        controllerAs : 'greetCtrl',
        private: true
	})
	.when('/transiGreetings', {
        templateUrl : 'views/transiGreetings.html',
        controller : 'GreetingsController',
        controllerAs : 'cardCtrl',
        private: true
	})

	.when('/cards', {
        templateUrl : 'views/cards.html',
       // controller : 'CardsController',
        controllerAs : 'cardCtrl',
        private: true
	})
	.when('/cards/flip', {
        templateUrl : 'views/flip.html',
        controller : 'FlipController',
        controllerAs : 'flip',
        private: true
	})

    .when('/quiz', {
		templateUrl: 'views/quiz.html',
		controller: 'QuizController',
		controllerAs: 'quiz',
		private: true
	})
	.when('/quiz/quiz1', {
		templateUrl: 'views/quiz1.html',
		controller: 'QuizController',
		controllerAs: 'quiz',
		private: true
	})
	.when('/quiz/quiz2', {
		templateUrl: 'views/quiz2.html',
		controller: 'QuizController',
		controllerAs: 'quiz',
		private: true
	})
	.when('/quiz/quiz3', {
		templateUrl: 'views/quiz3.html',
		controller: 'QuizController',
		controllerAs: 'quiz',
		private: true
	})
	.when('/search', {
		templateUrl: 'views/search.html',
		controller: 'SearchController',
		controllerAs: 'search',
		private: true
	})

	.when('/flashcards/FruitsCard', {
		templateUrl: 'views/FruitsCard.html',
		controller : 'CardsController',
        controllerAs : 'cardCtrl',
        private: true		
	})
	.when('/flashcards/AnimalsCard', {
		templateUrl: 'views/AnimalsCard.html',
		controller : 'CardsController',
        controllerAs : 'cardCtrl',
        private: true		
	})
	.when('/flashcards/ColorsCard', {
		templateUrl: 'views/ColorsCard.html',
		controller : 'CardsController',
        controllerAs : 'cardCtrl',
        private: true		
	})
	.when('/flashcards/BodyFaceCard', {
		templateUrl: 'views/BodyFaceCard.html',
		controller : 'CardsController',
        controllerAs : 'cardCtrl',
        private: true		
	})
	.when('/flashcards/DaysMonthsCard', {
		templateUrl: 'views/DaysMonthsCard.html',
		controller : 'CardsController',
        controllerAs : 'cardCtrl',
        private: true		
	})

    })				
}());
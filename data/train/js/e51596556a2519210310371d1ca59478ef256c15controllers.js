'use strict';

// Home screen controller
function HomeController($scope) {
	$scope.books = [
		{"title": "My first holiday", "img": "book1.png", "author": "Edward Marriner"},
		{"title": "Graduation", "img": "book1.png", "author": "Edward Marriner"}
	];
}
HomeController.$inject = ['$scope'];

// List all the books contoller
function AllBooksController() {
}
AllBooksController.$inject = [];

// New book controller
function NewBookController() {
}
NewBookController.$inject = [];

// profile controller
function MyProfileController() {
}
MyProfileController.$inject = [];

// freinds controller
function FriendsController() {
}
FriendsController.$inject = [];

// settings controller
function SettingsController() {
}
SettingsController.$inject = [];

// about screen controller
function AboutController() {
}
AboutController.$inject = [];

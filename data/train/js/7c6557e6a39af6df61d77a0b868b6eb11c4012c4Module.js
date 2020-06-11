Zenefits.add('Class','Module', function App(){
    /////////////////
    //MODULE
    /////////////////
    this.module = angular.module('zenefits', ['ngRoute', 'ngSanitize']);

    /////////////////
    //ROUTING
    /////////////////
    this.module.config(['$routeProvider', '$sceDelegateProvider',
        function($routeProvider) {
            $routeProvider
                //All notes view
                .when('/', {
                    'templateUrl': '/zn-notes-template.html',
                    'controller': 'NotesController'
                })
                //Note view
                .when('/note/:id', {
                    'templateUrl': '/zn-note-template.html',
                    'controller': 'NoteController'
                })
                //Edit view
                .when('/note/:id/edit', {
                    'templateUrl': '/zn-edit-template.html',
                    'controller': 'EditController'
                })
                //Create view
                .when('/create', {
                    'templateUrl': '/zn-edit-template.html',
                    'controller': 'CreateController'
                })
                //Fallback
                .otherwise({
                    'redirectTo': '/'
                });
        }]);

    /////////////////
    //CONTROLLERS
    /////////////////
    this.module
        .controller('NotesController', Zenefits.Controller.NotesController.controller)
        .controller('NoteController', Zenefits.Controller.NoteController.controller)
        .controller('EditController', Zenefits.Controller.EditController.controller)
        .controller('CreateController', Zenefits.Controller.CreateController.controller)
});

//Add instance into namespace
Zenefits.angular = new Zenefits.Class.Module;
'use strict';

/**
 * @ngdoc service
 * @name mytodoApp.todoTracker
 * @description
 * # todoTracker
 * Service in the mytodoApp.
 */
angular.module('mytodoApp')
  .service('todoTracker', ['localStorageService', function (localStorageService) {
    // AngularJS will instantiate a singleton by calling "new" on this function
    var service = {};
    var todosInStore = localStorageService.get('todos');

    service.todos = todosInStore || [];

    service.addTodo = function(todo){
		service.todos.push(todo);
        localStorageService.set('todos',service.todos);
    };

    service.removeTodo = function(index){
    	service.todos.splice(index,1);
        localStorageService.set('todos',service.todos);
    };

    return service;
  }]);

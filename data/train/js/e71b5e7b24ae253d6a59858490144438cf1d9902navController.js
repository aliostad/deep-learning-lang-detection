(function(){
    'use strict';

    angular.module('navController', [])
        .controller('navController', navController);

    navController.$inject = ["$filter", "$location", "listService"];

    function navController($filter, $location, listService)
    {
        var nav = this;
        nav.isActive = isActive;
        nav.addList = addList;
        nav.listNames = listService.listNames;

        function isActive(viewLocation) {
            return viewLocation === $location.path();
        }
        function addList(){
            var newName = $filter('capFilter')(nav.listName);
            listService.addList(newName);
            nav.listName = '';
        }
    }

}());
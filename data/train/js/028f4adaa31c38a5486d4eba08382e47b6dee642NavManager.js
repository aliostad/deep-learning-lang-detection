(function() {

    var navActions = {};
  
    var NavManager = function() {

       
  /* Get repo list */
        setNav = function(navScope) {
            //functions
            navActions.openNav = navScope.openNav;
            navActions.addForm = navScope.addForm;
            navActions.editForm = navScope.editForm;
            navActions.updateViewNode = navScope.updateViewNode;
            navActions.errorWindow = navScope.errorWindow;
            //variables
            navActions.activeNav = navScope.activeNav;
            navActions.activeSubMenu = navScope.activeSubMenu;
            navActions.activeList = navScope.activeList;
            navActions.currentNode = navScope.currentNode;
            navActions.previousMenu = navScope.previousMenu;
            navActions.parentAddNode = navScope.parentAddNode;
        };

        var connectNav = function(childScope){
            //functions
            childScope.openNav = navActions.openNav;
            childScope.addForm = navActions.addForm;
            childScope.editForm = navActions.editForm;
            childScope.updateViewNode = navActions.updateViewNode;
            //variables
            childScope.activeNav = navActions.activeNav;
            childScope.activeSubMenu = navActions.activeSubMenu;
            childScope.activeList = navActions.activeList;
            childScope.currentNode = navActions.currentNode;
            childScope.previousMenu = navActions.previousMenu;
            childScope.parentAddNode = navActions.parentAddNode;
        };


        return {
            setNav: setNav,
            connectNav: connectNav
        };
    };

    var module = angular.module("todoApp");
    module.factory("NavManager", NavManager);
}());
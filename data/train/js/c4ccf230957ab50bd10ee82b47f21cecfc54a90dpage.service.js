(function () {
  'use strict';

  angular
    .module('hexangular')
    .factory('page', page);
  
  page.$inject = ['$log', '$mdSidenav', '$mdToast'];
  function page($log, $mdSidenav, $mdToast) {
    var vm = {
      title: '',
      toggleNav: toggleNav,
      openNav: openNav,
      closeNav: closeNav,
      showError: showError,
      showToast: showToast
    };
    
    var mainNavId = 'mainNav';
    
    function toggleNav() {
      $mdSidenav(mainNavId).toggle();
    }
    
    function openNav() {
      $mdSidenav(mainNavId).open();
    }    
    
    function closeNav() {
      $mdSidenav(mainNavId).close();
    }
    
    function showError(error) {
      showToast(error);
    }
    
    function showToast(msg) {
      $log.log(msg);
      $mdToast.show($mdToast.simple().content(msg));
    }
    
    return vm;
  }
})();

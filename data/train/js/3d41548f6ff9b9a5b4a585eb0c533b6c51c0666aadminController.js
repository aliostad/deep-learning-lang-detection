// Administration controller
tsApp
  .controller(
    'AdminCtrl',
    [
      '$scope',
      '$http',
      '$modal',
      '$location',
      '$anchorScroll',
      'gpService',
      'utilService',
      'tabService',
      'securityService',
      'translationService',
      'refsetService',
      'directoryService',
      'adminService',
      function($scope, $http, $modal, $location, $anchorScroll, gpService,
        utilService, tabService, securityService, translationService,
        refsetService, directoryService, adminService) {
        console.debug('configure AdminCtrl');

        // Handle resetting tabs on "back" button
        if (tabService.selectedTab.label != 'Admin') {
          tabService.setSelectedTabByLabel('Admin');
        }

        //
        // Scope Variables
        //

        // Scope variables initialized from services
        $scope.translation = translationService.getModel();
        $scope.user = securityService.getUser();
        $scope.component = directoryService.getModel();
        $scope.pageSizes = directoryService.getPageSizes();

        // Search parameters
        $scope.searchParams = directoryService.getSearchParams();
        $scope.searchResults = directoryService.getSearchResults();

      }
 

    ]);



app.controller('driverController', function($scope, $http) {
    
    
    //-----info_driver_show
    $scope.info_driver_show = function() {
        $http.get('/hsms/public/info-driver-show').then(function(response) {
          $scope.driver_show = response.data;
        });
    };
    $scope.info_driver_show();
    
    
    
    
    //-----service_person_picture_show
    $scope.info_driver_pic_show = function(driver_id) {
        $http.get('/hsms/public/info-driver-pic-show/'+driver_id).then(function(response) {
          $scope.driver_pic = response.data;
        });
    };
    
    
});
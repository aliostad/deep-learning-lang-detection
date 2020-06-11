blog.controller('homeController', function($scope){

});

blog.controller('getArticleController', function($scope){

});

blog.controller('addArticleController', function($scope, $http, $location){
    $scope.save = function(form, article){
        if(form.$valid){
            $http.post('/article', article).success(function(){
                console.log(article);
                $location.path('/');
            });
        }
    };
});

blog.controller('updateController', function($scope){

});

blog.controller('deleteController', function($scope){

});

blog.controller('aboutController', function($scope){

});
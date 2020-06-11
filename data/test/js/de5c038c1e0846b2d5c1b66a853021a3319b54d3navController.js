angular.module('autoControllers')
    .controller('NavCtrl', ['$scope', 'NavServices',
        function($scope, NavServices) {
            $scope.navs = [{
                name: 'קטלוג הרכב',
                img: '......',
                route: '#/articles/carcatalog',
                navId: '1'
            }, {
                name: 'כתבות',
                img: '......',
                route: '#/articles',
                navId: '2'
            }, {
                name: 'מדריך קניה',
                img: '......',
                route: '#',
                navId: '3'
            }, {
                name: 'יייעוץ חינם לקניית רכב',
                img: '......',
                route: '#',
                navId: '4'
            }, {
                name: 'מועדפים',
                img: '......',
                route: '#',
                navId: '5'
            }];
        }
    ]);
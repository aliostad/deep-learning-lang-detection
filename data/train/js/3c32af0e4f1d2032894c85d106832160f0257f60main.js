/**
 * @file 消息展示模块主文件
 * @author conanmy
 */
angular.module('show', ['ui.router', 'showTab', 'showList'])
    .config(function($stateProvider) {
        $stateProvider.state('show', {
            url: '/',
            views: {
                '': {
                    templateUrl: 'app/show/main.html'
                },
                'tab@show': {
                    templateUrl: 'app/show/tab/main.html',
                    controller: 'showTabCtrl'
                },
                'list@show': {
                    templateUrl: 'app/show/list/main.html',
                    controller: 'showListCtrl'
                }
            }
        });
    });

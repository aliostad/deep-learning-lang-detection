// (function () {
//     'use strict';
//
//     angular.module('etl.sendDingConfig').factory('SendDingConfigService', SendDingConfigService);
//
//     SendDingConfigService.$inject = ['TransformServiceRestangular'];
//
//     function SendDingConfigService(TransformServiceRestangular){
//         var service;
//         service = {
//             getAllData: TransformServiceRestangular.all('api/dingTalk'),
//             connectInfoTest:TransformServiceRestangular.all('api/test-device'),
//             getAllDataId:TransformServiceRestangular.all('api/dingTalkId')
//         };
//         return service;
//     }
// })();

/**
 * Created by li_xiaoliang on 2015/3/24.
 */
define(['angular',
    'service/constantsService',
    'service/parsemarkdownService',
    'service/uploadService',
    'service/uploadLocalService',
    'service/utilitiesService',
    'service/haspermissionService'
], function (angular,
             constantsService,
             parsemarkdownService,
             uploadService,
             uploadLocalService,
             utilitiesService,
             haspermissionService) {
    angular.module("app.services", [])
        .constant("constantsService",constantsService)
        .constant('parsemarkdown',parsemarkdownService)
        .factory('uploadService',uploadService)
        .factory('uploadLocalService',uploadLocalService)
        .constant('utilitiesService',utilitiesService)
        .factory('haspermission',haspermissionService)
})

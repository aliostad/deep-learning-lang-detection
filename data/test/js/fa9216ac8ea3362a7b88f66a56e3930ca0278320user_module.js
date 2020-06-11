import {UserService} from './user_service'
// import ApiService from "../../../core/api_service.js"

export default angular
    .module('environment.user', [])
    .service('ctUserService', UserService)
    // .service('ApiService', ApiService)
    .factory('ApiResourcePermissions', function (ApiResource) {
        // debugger;
        // console.log($stateParams);
        var r = ApiResource.getResource('groups/:groupId/permissions'
            // , {
            //     resource : { id : "@ID" }
            // }
        );
        // r.query();
        return r;
        }
    )
    // .run(userInit)
;

// function userInit(ctUserService) {
//     ctUserService.init();
// }
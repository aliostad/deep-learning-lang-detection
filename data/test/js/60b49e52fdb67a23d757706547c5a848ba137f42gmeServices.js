/*globals angular, require*/

'use strict';

var DataStoreServiceClass = require( './DataStoreService.js' ),
    ProjectServiceClass = require( './ProjectService/ProjectService.js' ),
    BranchServiceClass = require( './BranchService.js' ),
    NodeServiceClass = require( './NodeService.js' );

angular.module( 'gme.services', [] )
    .service( 'dataStoreService', DataStoreServiceClass )
    .service( 'projectService', ProjectServiceClass )
    .service( 'branchService', BranchServiceClass )
    .service( 'nodeService', NodeServiceClass );